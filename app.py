from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime, timedelta
import mysql.connector
from mysql.connector import pooling
import os
from typing import Set
import requests
import json
from retention import calculate_retention_multi, debug_retention_data

app = FastAPI(title="运营数据查询系统")

# PostHog 配置（从环境变量读取，如果没有则使用默认值）
POSTHOG_API_KEY = os.getenv('POSTHOG_API_KEY', 'phx_ZslpuGTtRNJ1whReQsoPdG0TM29oknVNRMKqRufszcD1Nf5')
POSTHOG_PROJECT_ID = os.getenv('POSTHOG_PROJECT_ID', '214859')
POSTHOG_INSIGHT_ID = os.getenv('POSTHOG_INSIGHT_ID', 'ySiO61m3')
POSTHOG_BASE_URL = os.getenv('POSTHOG_BASE_URL', 'https://us.posthog.com')

# 配置 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 静态文件服务
app.mount("/static", StaticFiles(directory="public"), name="static")

# 数据库配置
db_config = {
    'host': 'iaas-center.mysql.rds.aliyuncs.com',
    'port': 3306,
    'user': 'iaasdev',
    'password': 'cznynf6Tcdl5pkY',
    'database': 'iaas_wallet',
    'charset': 'utf8mb4',
    'autocommit': True
}

# 创建数据库连接池
pool = pooling.MySQLConnectionPool(
    pool_name="mypool",
    pool_size=10,
    pool_reset_session=True,
    **db_config
)

# 请求模型
class DateRangeRequest(BaseModel):
    startDate: str
    endDate: str

class RetentionRequest(BaseModel):
    retentionType: str  # daily, weekly, monthly
    baseDate: str
    periods: int

class RetentionMultiRequest(BaseModel):
    retentionType: str  # new 或 active
    period: str  # daily, weekly, monthly
    startDate: str
    endDate: str

def detect_fake_users(start_date: str, end_date: str) -> Set[str]:
    """检测刷量用户（2分钟内大量创建的用户）
    
    算法逻辑：
    1. 查询指定日期范围内的所有用户及其创建时间
    2. 按创建时间排序
    3. 滑动窗口检测：如果某个2分钟窗口内注册用户数超过阈值，标记为异常时间段
    4. 返回所有异常时间段内的用户ID集合
    
    参数：
        start_date: 开始日期
        end_date: 结束日期
    
    返回：
        刷量用户的 user_id 集合
    """
    try:
        connection = pool.get_connection()
        try:
            cursor = connection.cursor(dictionary=True)
            
            # 查询指定日期范围内的所有用户及其创建时间
            sql = """
                SELECT user_id, created_at
                FROM iaas_wallet.user_balance
                WHERE created_at >= %s
                AND created_at < DATE_ADD(%s, INTERVAL 1 DAY)
                ORDER BY created_at ASC
            """
            cursor.execute(sql, (start_date, end_date))
            users = cursor.fetchall()
            cursor.close()
            
            if not users:
                return set()
            
            # 将创建时间转换为 datetime 对象
            user_times = []
            for user in users:
                try:
                    if isinstance(user['created_at'], str):
                        dt = datetime.strptime(user['created_at'], '%Y-%m-%d %H:%M:%S')
                    else:
                        dt = user['created_at']
                    user_times.append((user['user_id'], dt))
                except:
                    continue
            
            if not user_times:
                return set()
            
            # 滑动窗口检测刷量用户
            fake_user_ids = set()
            window_minutes = 1  # 2分钟窗口
            threshold = 5  # 阈值：2分钟内超过10个用户注册认为是刷量
            
            # 按时间排序
            user_times.sort(key=lambda x: x[1])
            
            # 滑动窗口检测（优化：使用双指针避免重复计算）
            i = 0
            while i < len(user_times):
                window_start = user_times[i][1]
                window_end = window_start + timedelta(minutes=window_minutes)
                
                # 统计窗口内的用户数（从当前位置开始）
                window_users = []
                j = i
                while j < len(user_times) and user_times[j][1] <= window_end:
                    window_users.append(user_times[j][0])
                    j += 1
                
                # 如果窗口内用户数超过阈值，标记为刷量用户
                if len(window_users) >= threshold:
                    fake_user_ids.update(window_users)
                    print(f"检测到刷量时间段: {window_start} 至 {window_end}, 用户数: {len(window_users)}")
                    # 跳过这个窗口内的所有用户，避免重复检测
                    i = j
                else:
                    # 窗口正常，继续下一个用户
                    i += 1
            
            print(f"共检测到 {len(fake_user_ids)} 个刷量用户")
            return fake_user_ids
            
        finally:
            connection.close()
    except Exception as e:
        print(f"检测刷量用户失败: {e}")
        import traceback
        traceback.print_exc()
        return set()

def get_posthog_unique_users(start_date: str, end_date: str) -> int:
    """从 PostHog 获取指定日期范围内的独立用户数（unique users）
    使用 trends API 统计独立访客数，用于计算注册率
    """
    try:
        if not POSTHOG_API_KEY:
            print("警告: POSTHOG_API_KEY 未设置，无法获取浏览数据")
            return 0
        
        # 使用 PostHog Trends API (GET)
        # 参考: https://us.posthog.com/api/projects/{project_id}/insights/trend/
        url = f"{POSTHOG_BASE_URL}/api/projects/{POSTHOG_PROJECT_ID}/insights/trend/"
        
        headers = {
            "Authorization": f"Bearer {POSTHOG_API_KEY}",
            "Content-Type": "application/json"
        }
        
        # events 参数：使用 $pageview 事件和 unique_group 统计独立用户数
        # 需要 JSON 编码后作为 URL 参数
        events_json = json.dumps([{"id": "$pageview", "math": "dau"}])
        
        params = {
            "date_from": start_date,
            "date_to": end_date,
            "interval": "month",
            "filter_test_accounts": "true",
            "period": "month",
            "events": events_json
        }
        
        # 构建完整的请求 URL（包含所有参数）
        from urllib.parse import urlencode
        full_url = f"{url}?{urlencode(params)}"
        # print("=" * 80)
        # # print("PostHog API 请求信息:")
        print(f"完整请求 URL: {full_url}")
        # print(f"请求头: {json.dumps(headers, indent=2)}")
        # print(f"请求参数: {json.dumps(params, indent=2)}")
        # print("=" * 80)
        
        response = requests.get(url, headers=headers, params=params, timeout=10)
        
        print("=" * 80)
        print("PostHog API 响应信息:")
        print(f"状态码: {response.status_code}")
        # print(f"响应头: {json.dumps(dict(response.headers), indent=2)}")
        
        if response.status_code == 200:
            data = response.json()
            # print(f"完整响应数据: {json.dumps(data, indent=2, ensure_ascii=False)}")
            print("=" * 80)
            
            # 解析 PostHog 返回的数据结构
            # 返回格式: {"result": [{"data": [1062], "count": 1062.0, ...}]}
            unique_users = 0
            
            if 'result' in data and isinstance(data['result'], list) and len(data['result']) > 0:
                # result 是一个数组，取第一个元素
                result_item = data['result'][0]
                
                if isinstance(result_item, dict):
                    # 优先使用 count 字段（浮点数）
                    if 'count' in result_item:
                        unique_users = result_item['count']
                    # 如果没有 count，使用 data 数组的第一个值
                    elif 'data' in result_item and isinstance(result_item['data'], list) and len(result_item['data']) > 0:
                        unique_users = result_item['data'][0]
                    # 备用：使用 value 字段
                    elif 'value' in result_item:
                        unique_users = result_item['value']
            
            if unique_users > 0:
                print(f"成功获取独立用户数: {int(unique_users)}")
                return int(unique_users)
            else:
                print("警告: 无法从 PostHog API 响应中解析独立用户数")
                print(f"响应数据: {json.dumps(data, indent=2)}")
                return 0
        else:
            print(f"错误响应内容: {response.text}")
            print("=" * 80)
            return 0
    except Exception as e:
        print(f"获取 PostHog 浏览数据失败: {e}")
        import traceback
        traceback.print_exc()
        return 0
   
# 运营数据查询接口
@app.post("/api/operational-data")
async def get_operational_data(request: DateRangeRequest):
    try:
        start_date = request.startDate
        end_date = request.endDate
        
        if not start_date or not end_date:
            raise HTTPException(status_code=400, detail="请提供开始日期和结束日期")
        
        # 验证日期格式
        try:
            datetime.strptime(start_date, '%Y-%m-%d')
            datetime.strptime(end_date, '%Y-%m-%d')
        except ValueError:
            raise HTTPException(status_code=400, detail="日期格式错误，请使用 YYYY-MM-DD 格式")
        
        if start_date > end_date:
            raise HTTPException(status_code=400, detail="开始日期不能晚于结束日期")

        # 修正后的 SQL 查询
        # 主要修正：
        # 1. 只统计支付成功的订单（state = 1）
        # 2. 使用参数化查询防止 SQL 注入
        # 3. 付费率使用小数除法
        # 4. 日期范围同时应用到两个表
        sql = """
            SELECT
                -- 总充值金额（只统计支付成功的订单）
                COALESCE(SUM(CASE WHEN r.state = 1 THEN r.amount ELSE 0 END), 0) AS total_revenue,
                
                -- 付费用户数量（只统计支付成功的订单）
                COUNT(DISTINCT CASE WHEN r.state = 1 THEN r.user_id ELSE NULL END) AS paying_users,
                
                -- 总用户数量（在日期范围内注册的用户）
                COUNT(DISTINCT u.user_id) AS total_users,
                
                -- ARPPU = 总充值金额 / 付费用户数
                CASE 
                    WHEN COUNT(DISTINCT CASE WHEN r.state = 1 THEN r.user_id ELSE NULL END) > 0 
                    THEN COALESCE(SUM(CASE WHEN r.state = 1 THEN r.amount ELSE 0 END), 0) / 
                         COUNT(DISTINCT CASE WHEN r.state = 1 THEN r.user_id ELSE NULL END)
                    ELSE 0 
                END AS ARPPU,
                
                -- ARPU = 总充值金额 / 总用户数
                CASE 
                    WHEN COUNT(DISTINCT u.user_id) > 0 
                    THEN COALESCE(SUM(CASE WHEN r.state = 1 THEN r.amount ELSE 0 END), 0) / 
                         COUNT(DISTINCT u.user_id)
                    ELSE 0 
                END AS ARPU,
                
                -- 付费率 = 付费用户数 / 总用户数（使用小数除法）
                CASE 
                    WHEN COUNT(DISTINCT u.user_id) > 0 
                    THEN COUNT(DISTINCT CASE WHEN r.state = 1 THEN r.user_id ELSE NULL END) * 100.0 / 
                         COUNT(DISTINCT u.user_id)
                    ELSE 0 
                END AS pay_rate
            FROM iaas_wallet.user_balance u
            LEFT JOIN iaas_wallet.recharge_order r
                ON r.user_id = u.user_id
                AND r.created_at >= %s
                AND r.created_at < DATE_ADD(%s, INTERVAL 1 DAY)
            WHERE
                u.created_at >= %s
                AND u.created_at < DATE_ADD(%s, INTERVAL 1 DAY)
        """
        
        # 检测刷量用户（2分钟内大量创建的用户）
        fake_user_ids = detect_fake_users(start_date, end_date)
        
        # 构建排除刷量用户的 SQL 条件
        fake_user_ids_list = list(fake_user_ids) if fake_user_ids else []
        exclude_condition = ""
        exclude_params = ()
        
        if fake_user_ids_list:
            placeholders = ','.join(['%s'] * len(fake_user_ids_list))
            exclude_condition = f"u.user_id NOT IN ({placeholders})"
            exclude_params = tuple(fake_user_ids_list)
            print(f"排除 {len(fake_user_ids_list)} 个刷量用户")
        
        # 修改 SQL 查询，添加排除刷量用户的条件
        sql_with_exclude = sql
        if exclude_condition:
            # 在 WHERE 子句的开头添加排除条件
            sql_with_exclude = sql.replace(
                "WHERE\n                u.created_at >= %s",
                f"WHERE\n                {exclude_condition}\n                AND u.created_at >= %s"
            )
        
        # 查询激活率：从 iaas_wallet.user_balance 表统计
        # 活跃用户定义：created_at != updated_at（发生过实例扣费）
        # 排除刷量用户
        active_rate_sql = """
            SELECT
                -- 总注册用户数（在日期范围内注册的用户，排除刷量用户）
                COUNT(DISTINCT user_id) AS total_registered_users,
                
                -- 激活用户数（created_at != updated_at，表示发生过实例扣费，排除刷量用户）
                COUNT(DISTINCT CASE 
                    WHEN created_at != updated_at 
                    THEN user_id 
                    ELSE NULL 
                END) AS active_users,
                
                -- 激活率 = 激活用户数 / 总注册用户数
                CASE 
                    WHEN COUNT(DISTINCT user_id) > 0 
                    THEN COUNT(DISTINCT CASE 
                        WHEN created_at != updated_at 
                        THEN user_id 
                        ELSE NULL 
                    END) * 100.0 / COUNT(DISTINCT user_id)
                    ELSE 0 
                END AS active_rate
            FROM iaas_wallet.user_balance
            WHERE
                created_at >= %s
                AND created_at < DATE_ADD(%s, INTERVAL 1 DAY)
        """
        
        # 如果有刷量用户，添加排除条件到激活率查询
        if fake_user_ids_list:
            placeholders = ','.join(['%s'] * len(fake_user_ids_list))
            active_rate_sql += f" AND user_id NOT IN ({placeholders})"
        
        # 从连接池获取连接
        connection = pool.get_connection()
        try:
            cursor = connection.cursor(dictionary=True)
            
            # 查询运营数据（排除刷量用户）
            # SQL 参数顺序：start_date, end_date (recharge_order), exclude_params (user_balance WHERE), start_date, end_date (user_balance WHERE)
            if fake_user_ids_list:
                # 参数顺序：r.created_at 的 start_date, end_date, exclude_params (u.user_id NOT IN), u.created_at 的 start_date, end_date
                sql_params = (start_date, end_date) + exclude_params + (start_date, end_date)
                cursor.execute(sql_with_exclude, sql_params)
            else:
                cursor.execute(sql_with_exclude, (start_date, end_date, start_date, end_date))
            result = cursor.fetchone()
            
            # 查询激活率数据（排除刷量用户）
            if fake_user_ids_list:
                cursor.execute(active_rate_sql, (start_date, end_date) + exclude_params)
            else:
                cursor.execute(active_rate_sql, (start_date, end_date))
            active_rate_result = cursor.fetchone()
            
            cursor.close()
            
            if not result:
                raise HTTPException(status_code=500, detail="查询结果为空")
            
            # 合并结果
            if active_rate_result:
                result['total_registered_users'] = active_rate_result.get('total_registered_users', 0)
                result['active_users'] = active_rate_result.get('active_users', 0)
                result['active_rate'] = active_rate_result.get('active_rate', 0)
            else:
                result['total_registered_users'] = 0
                result['active_users'] = 0
                result['active_rate'] = 0
            
            # 从 PostHog 获取浏览数据并计算注册率
            pageviews = get_posthog_unique_users(start_date, end_date)
            result['pageviews'] = pageviews
            
            # 注册率 = 注册用户数 / 浏览量 × 100%（排除刷量用户后的注册用户数）
            if pageviews > 0:
                result['registration_rate'] = (result['total_registered_users'] / pageviews) * 100
            else:
                result['registration_rate'] = 0
            
            # 添加刷量用户统计信息
            result['fake_users_count'] = len(fake_user_ids_list)
            
            return {
                "success": True,
                "data": result,
                "dateRange": {
                    "startDate": start_date,
                    "endDate": end_date
                }
            }
        finally:
            connection.close()
            
    except HTTPException:
        raise
    except Exception as e:
        print(f"查询错误: {e}")
        raise HTTPException(status_code=500, detail=f"查询失败: {str(e)}")

# 多时间段留存率查询接口（从 CSV 数据计算）
@app.post("/api/retention-multi")
async def get_retention_multi_data(request: RetentionMultiRequest):
    """多时间段留存率查询接口"""
    try:
        retention_type = request.retentionType  # new 或 active
        period = request.period  # daily, weekly, monthly
        start_date = request.startDate
        end_date = request.endDate
        
        if retention_type not in ['new', 'active']:
            raise HTTPException(status_code=400, detail="留存类型必须是 new 或 active")
        
        if period not in ['daily', 'weekly', 'monthly']:
            raise HTTPException(status_code=400, detail="周期类型必须是 daily, weekly 或 monthly")
        
        if not start_date or not end_date:
            raise HTTPException(status_code=400, detail="请提供开始日期和结束日期")
        
        # 验证日期格式
        try:
            datetime.strptime(start_date, '%Y-%m-%d')
            datetime.strptime(end_date, '%Y-%m-%d')
        except ValueError:
            raise HTTPException(status_code=400, detail="日期格式错误，请使用 YYYY-MM-DD 格式")
        
        if start_date > end_date:
            raise HTTPException(status_code=400, detail="开始日期不能晚于结束日期")
        
        # 调用留存计算模块
        result = calculate_retention_multi(retention_type, period, start_date, end_date)
        return result
            
    except HTTPException:
        raise
    except ValueError as e:
        raise HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        print(f"多时间段留存率查询错误: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"查询失败: {str(e)}")

# 调试接口：验证数据加载和查询
@app.post("/api/debug-retention")
async def debug_retention(request: RetentionMultiRequest):
    """调试接口：返回详细的计算过程"""
    try:
        start_date = request.startDate
        end_date = request.endDate
        
        # 验证日期格式
        try:
            datetime.strptime(start_date, '%Y-%m-%d')
            datetime.strptime(end_date, '%Y-%m-%d')
        except ValueError:
            raise HTTPException(status_code=400, detail="日期格式错误，请使用 YYYY-MM-DD 格式")
        
        # 调用留存调试模块
        result = debug_retention_data(start_date, end_date)
        return result
    except ValueError as e:
        raise HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"调试失败: {str(e)}")

# 健康检查接口
@app.get("/api/health")
async def health_check():
    try:
        connection = pool.get_connection()
        try:
            cursor = connection.cursor()
            cursor.execute("SELECT 1")
            cursor.fetchone()
            cursor.close()
            return {"status": "ok", "message": "数据库连接正常"}
        finally:
            connection.close()
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"数据库连接失败: {str(e)}")

# 根路径重定向到前端
@app.get("/")
async def root():
    from fastapi.responses import FileResponse
    return FileResponse("public/index.html")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000)

