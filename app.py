from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime, timedelta
import mysql.connector
from mysql.connector import pooling
import os
import csv
from collections import defaultdict
from typing import Dict, Set, List, Tuple

app = FastAPI(title="运营数据查询系统")

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

# 数据缓存
_data_cache = None
_data_loaded = False

def load_data_from_csv():
    """从 CSV 文件加载数据到内存"""
    global _data_cache, _data_loaded
    
    if _data_loaded:
        return _data_cache
    
    print("正在加载 CSV 数据...")
    csv_file = "user_balance_changes.csv"
    
    # 数据结构：
    # user_consumptions: {user_id: [datetime, ...]} - 每个用户的消费时间列表（type=1）
    # user_first_consumption: {user_id: datetime} - 每个用户首次消费时间
    user_consumptions = defaultdict(list)
    user_first_consumption = {}
    
    try:
        with open(csv_file, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                try:
                    user_id = row['user_id'].strip('"')
                    type_val = int(row['type'].strip('"'))
                    created_at_str = row['created_at'].strip('"')
                    
                    # 只处理消费记录（type=1）
                    if type_val != 1:
                        continue
                    
                    # 解析日期：格式可能是 "14/7/2025 16:59:45" 或 "2025-07-14 16:59:45"
                    try:
                        if '/' in created_at_str and len(created_at_str.split('/')[0]) <= 2:
                            # 格式：14/7/2025 16:59:45
                            dt = datetime.strptime(created_at_str, '%d/%m/%Y %H:%M:%S')
                        else:
                            # 格式：2025-07-14 16:59:45 或 2025-11-03 00:00:00
                            if '.' in created_at_str:
                                dt = datetime.strptime(created_at_str, '%Y-%m-%d %H:%M:%S.%f')
                            else:
                                dt = datetime.strptime(created_at_str, '%Y-%m-%d %H:%M:%S')
                    except ValueError:
                        print(f"无法解析日期: {created_at_str}")
                        continue
                    
                    user_consumptions[user_id].append(dt)
                    
                    # 记录首次消费时间
                    if user_id not in user_first_consumption or dt < user_first_consumption[user_id]:
                        user_first_consumption[user_id] = dt
                        
                except (ValueError, KeyError) as e:
                    continue
        
        # 对每个用户的消费时间排序
        for user_id in user_consumptions:
            user_consumptions[user_id].sort()
        
        _data_cache = {
            'user_consumptions': dict(user_consumptions),
            'user_first_consumption': user_first_consumption
        }
        _data_loaded = True
        
        print(f"数据加载完成，共 {len(user_consumptions)} 个用户，{sum(len(v) for v in user_consumptions.values())} 条消费记录")
        return _data_cache
        
    except FileNotFoundError:
        print(f"CSV 文件 {csv_file} 不存在，将使用数据库查询")
        return None
    except Exception as e:
        print(f"加载 CSV 数据出错: {e}")
        import traceback
        traceback.print_exc()
        return None

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
        
        # 查询激活率：从 iaas_wallet.user_balance 表统计
        # 活跃用户定义：created_at != updated_at（发生过实例扣费）
        active_rate_sql = """
            SELECT
                -- 总注册用户数（在日期范围内注册的用户）
                COUNT(DISTINCT user_id) AS total_registered_users,
                
                -- 激活用户数（created_at != updated_at，表示发生过实例扣费）
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
        
        # 从连接池获取连接
        connection = pool.get_connection()
        try:
            cursor = connection.cursor(dictionary=True)
            
            # 查询运营数据
            cursor.execute(sql, (start_date, end_date, start_date, end_date))
            result = cursor.fetchone()
            
            # 查询激活率数据
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

# 留存率查询接口
@app.post("/api/retention")
async def get_retention_data(request: RetentionRequest):
    try:
        retention_type = request.retentionType
        base_date = request.baseDate
        periods = request.periods
        
        if retention_type not in ['daily', 'weekly', 'monthly']:
            raise HTTPException(status_code=400, detail="留存类型必须是 daily, weekly 或 monthly")
        
        if not base_date:
            raise HTTPException(status_code=400, detail="请提供基准日期")
        
        if periods < 1 or periods > 100:
            raise HTTPException(status_code=400, detail="统计周期数必须在 1-100 之间")
        
        # 验证日期格式
        try:
            base_dt = datetime.strptime(base_date, '%Y-%m-%d')
        except ValueError:
            raise HTTPException(status_code=400, detail="日期格式错误，请使用 YYYY-MM-DD 格式")
        
        # 从连接池获取连接
        connection = pool.get_connection()
        try:
            cursor = connection.cursor(dictionary=True)
            results = []
            
            # 先查询基准期的活跃用户
            if retention_type == 'daily':
                # 日留存：基准日期当天的活跃用户
                base_sql = """
                    SELECT DISTINCT user_id
                    FROM iaas_wallet.user_balance_changes
                    WHERE type = 1
                    AND DATE(created_at) = %s
                """
                cursor.execute(base_sql, (base_date,))
                base_users = {row['user_id'] for row in cursor.fetchall()}
                base_users_count = len(base_users)
                
                if base_users_count == 0:
                    raise HTTPException(status_code=400, detail="基准日期没有活跃用户")
                
                # 查询每个后续日期的留存用户（使用 JOIN 优化性能）
                for i in range(1, periods + 1):
                    current_date = (base_dt + timedelta(days=i)).strftime('%Y-%m-%d')
                    
                    # 使用子查询 JOIN，性能更好
                    retention_sql = """
                        SELECT 
                            COUNT(DISTINCT base.user_id) as retained_count
                        FROM (
                            SELECT DISTINCT user_id
                            FROM iaas_wallet.user_balance_changes
                            WHERE type = 1
                            AND DATE(created_at) = %s
                        ) base
                        INNER JOIN (
                            SELECT DISTINCT user_id
                            FROM iaas_wallet.user_balance_changes
                            WHERE type = 1
                            AND DATE(created_at) = %s
                        ) current ON base.user_id = current.user_id
                    """
                    cursor.execute(retention_sql, (base_date, current_date))
                    retained_count = cursor.fetchone()['retained_count'] or 0
                    
                    # 查询当前日期总激活用户数
                    total_sql = """
                        SELECT COUNT(DISTINCT user_id) as total_count
                        FROM iaas_wallet.user_balance_changes
                        WHERE type = 1
                        AND DATE(created_at) = %s
                    """
                    cursor.execute(total_sql, (current_date,))
                    current_users_count = cursor.fetchone()['total_count'] or 0
                    
                    retention_rate = (retained_count / base_users_count * 100) if base_users_count > 0 else 0
                    
                    results.append({
                        'period': i,
                        'base_users': base_users_count,
                        'current_users': current_users_count,
                        'retained_users': retained_count,
                        'retention_rate': retention_rate
                    })
                    
            elif retention_type == 'weekly':
                # 周留存：基准日期所在周的活跃用户（周一到周日）
                # 计算基准周的周一
                days_since_monday = base_dt.weekday()
                week_start = base_dt - timedelta(days=days_since_monday)
                week_end = week_start + timedelta(days=6)
                
                base_sql = """
                    SELECT DISTINCT user_id
                    FROM iaas_wallet.user_balance_changes
                    WHERE type = 1
                    AND DATE(created_at) >= %s
                    AND DATE(created_at) <= %s
                """
                cursor.execute(base_sql, (week_start.strftime('%Y-%m-%d'), week_end.strftime('%Y-%m-%d')))
                base_users = {row['user_id'] for row in cursor.fetchall()}
                base_users_count = len(base_users)
                
                if base_users_count == 0:
                    raise HTTPException(status_code=400, detail="基准周没有活跃用户")
                
                # 查询每个后续周的留存用户
                for i in range(1, periods + 1):
                    current_week_start = week_start + timedelta(weeks=i)
                    current_week_end = current_week_start + timedelta(days=6)
                    
                    # 使用 JOIN 查询留存用户
                    retention_sql = """
                        SELECT 
                            COUNT(DISTINCT base.user_id) as retained_count
                        FROM (
                            SELECT DISTINCT user_id
                            FROM iaas_wallet.user_balance_changes
                            WHERE type = 1
                            AND DATE(created_at) >= %s
                            AND DATE(created_at) <= %s
                        ) base
                        INNER JOIN (
                            SELECT DISTINCT user_id
                            FROM iaas_wallet.user_balance_changes
                            WHERE type = 1
                            AND DATE(created_at) >= %s
                            AND DATE(created_at) <= %s
                        ) current ON base.user_id = current.user_id
                    """
                    cursor.execute(retention_sql, (
                        week_start.strftime('%Y-%m-%d'),
                        week_end.strftime('%Y-%m-%d'),
                        current_week_start.strftime('%Y-%m-%d'),
                        current_week_end.strftime('%Y-%m-%d')
                    ))
                    retained_count = cursor.fetchone()['retained_count'] or 0
                    
                    # 查询当前周总激活用户数
                    total_sql = """
                        SELECT COUNT(DISTINCT user_id) as total_count
                        FROM iaas_wallet.user_balance_changes
                        WHERE type = 1
                        AND DATE(created_at) >= %s
                        AND DATE(created_at) <= %s
                    """
                    cursor.execute(total_sql, (
                        current_week_start.strftime('%Y-%m-%d'),
                        current_week_end.strftime('%Y-%m-%d')
                    ))
                    current_users_count = cursor.fetchone()['total_count'] or 0
                    
                    retention_rate = (retained_count / base_users_count * 100) if base_users_count > 0 else 0
                    
                    results.append({
                        'period': i,
                        'base_users': base_users_count,
                        'current_users': current_users_count,
                        'retained_users': retained_count,
                        'retention_rate': retention_rate
                    })
                    
            else:  # monthly
                # 月留存：基准日期所在月的活跃用户
                month_start = base_dt.replace(day=1)
                # 计算下个月的第一天，然后减一天得到本月最后一天
                if month_start.month == 12:
                    month_end = month_start.replace(year=month_start.year + 1, month=1) - timedelta(days=1)
                else:
                    month_end = month_start.replace(month=month_start.month + 1) - timedelta(days=1)
                
                base_sql = """
                    SELECT DISTINCT user_id
                    FROM iaas_wallet.user_balance_changes
                    WHERE type = 1
                    AND DATE(created_at) >= %s
                    AND DATE(created_at) <= %s
                """
                cursor.execute(base_sql, (month_start.strftime('%Y-%m-%d'), month_end.strftime('%Y-%m-%d')))
                base_users = {row['user_id'] for row in cursor.fetchall()}
                base_users_count = len(base_users)
                
                if base_users_count == 0:
                    raise HTTPException(status_code=400, detail="基准月没有活跃用户")
                
                # 查询每个后续月的留存用户
                for i in range(1, periods + 1):
                    # 计算第i个月的第一天和最后一天
                    if month_start.month + i > 12:
                        current_month_start = month_start.replace(year=month_start.year + (month_start.month + i - 1) // 12, month=((month_start.month + i - 1) % 12) + 1)
                    else:
                        current_month_start = month_start.replace(month=month_start.month + i)
                    
                    if current_month_start.month == 12:
                        current_month_end = current_month_start.replace(year=current_month_start.year + 1, month=1) - timedelta(days=1)
                    else:
                        current_month_end = current_month_start.replace(month=current_month_start.month + 1) - timedelta(days=1)
                    
                    # 使用 JOIN 查询留存用户
                    retention_sql = """
                        SELECT 
                            COUNT(DISTINCT base.user_id) as retained_count
                        FROM (
                            SELECT DISTINCT user_id
                            FROM iaas_wallet.user_balance_changes
                            WHERE type = 1
                            AND DATE(created_at) >= %s
                            AND DATE(created_at) <= %s
                        ) base
                        INNER JOIN (
                            SELECT DISTINCT user_id
                            FROM iaas_wallet.user_balance_changes
                            WHERE type = 1
                            AND DATE(created_at) >= %s
                            AND DATE(created_at) <= %s
                        ) current ON base.user_id = current.user_id
                    """
                    cursor.execute(retention_sql, (
                        month_start.strftime('%Y-%m-%d'),
                        month_end.strftime('%Y-%m-%d'),
                        current_month_start.strftime('%Y-%m-%d'),
                        current_month_end.strftime('%Y-%m-%d')
                    ))
                    retained_count = cursor.fetchone()['retained_count'] or 0
                    
                    # 查询当前月总激活用户数
                    total_sql = """
                        SELECT COUNT(DISTINCT user_id) as total_count
                        FROM iaas_wallet.user_balance_changes
                        WHERE type = 1
                        AND DATE(created_at) >= %s
                        AND DATE(created_at) <= %s
                    """
                    cursor.execute(total_sql, (
                        current_month_start.strftime('%Y-%m-%d'),
                        current_month_end.strftime('%Y-%m-%d')
                    ))
                    current_users_count = cursor.fetchone()['total_count'] or 0
                    
                    retention_rate = (retained_count / base_users_count * 100) if base_users_count > 0 else 0
                    
                    results.append({
                        'period': i,
                        'base_users': base_users_count,
                        'current_users': current_users_count,
                        'retained_users': retained_count,
                        'retention_rate': retention_rate
                    })
            
            cursor.close()
            
            return {
                "success": True,
                "data": results
            }
        finally:
            connection.close()
            
    except HTTPException:
        raise
    except Exception as e:
        print(f"留存率查询错误: {e}")
        raise HTTPException(status_code=500, detail=f"查询失败: {str(e)}")

# 多时间段留存率查询接口（从 CSV 数据计算）
@app.post("/api/retention-multi")
async def get_retention_multi_data(request: RetentionMultiRequest):
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
            start_dt = datetime.strptime(start_date, '%Y-%m-%d').replace(hour=0, minute=0, second=0, microsecond=0)
            end_dt = datetime.strptime(end_date, '%Y-%m-%d').replace(hour=23, minute=59, second=59, microsecond=999999)
        except ValueError:
            raise HTTPException(status_code=400, detail="日期格式错误，请使用 YYYY-MM-DD 格式")
        
        if start_date > end_date:
            raise HTTPException(status_code=400, detail="开始日期不能晚于结束日期")
        
        # 加载 CSV 数据
        data_cache = load_data_from_csv()
        if not data_cache:
            raise HTTPException(status_code=500, detail="无法加载 CSV 数据，请确保 user_balance_changes.csv 文件存在")
        
        user_consumptions = data_cache['user_consumptions']
        user_first_consumption = data_cache['user_first_consumption']
        
        # 生成时间段列表（修复：不强制对齐到周一，使用用户选择的精确时间范围）
        periods = []
        
        if period == 'daily':
            current = start_dt
            while current.date() <= end_dt.date():
                period_start = current.replace(hour=0, minute=0, second=0, microsecond=0)
                period_end = current.replace(hour=23, minute=59, second=59, microsecond=999999)
                if period_start <= end_dt:
                    periods.append((period_start, period_end))
                current += timedelta(days=1)
        elif period == 'weekly':
            # 修复：使用用户选择的开始日期作为第一周的开始，而不是强制对齐到周一
            current = start_dt.replace(hour=0, minute=0, second=0, microsecond=0)
            while current <= end_dt:
                period_start = current
                period_end = min(current + timedelta(days=6, hours=23, minutes=59, seconds=59, microseconds=999999), end_dt)
                if period_start <= end_dt:
                    periods.append((period_start, period_end))
                current += timedelta(weeks=1)
        else:  # monthly
            current = start_dt.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
            while current <= end_dt:
                period_start = current
                # 计算月末
                if current.month == 12:
                    next_month = current.replace(year=current.year + 1, month=1, day=1)
                else:
                    next_month = current.replace(month=current.month + 1, day=1)
                period_end = min(next_month - timedelta(microseconds=1), end_dt)
                if period_start <= end_dt:
                    periods.append((period_start, period_end))
                current = next_month
        
        # 限制最多查询20个时间段
        if len(periods) > 20:
            periods = periods[-20:]
        
        results = []
        
        # 对每个时间段计算留存率
        for period_start, period_end in periods:
            # 计算该时间段的新增用户或活跃用户（使用精确时间比较）
            base_users = set()
            
            if retention_type == 'new':
                # 新用户留存：该时间段首次有消费记录的用户
                # 修复：使用精确时间比较，检查在时间段开始之前是否有消费记录
                for user_id, consumptions in user_consumptions.items():
                    # 检查用户在该时间段是否有消费
                    has_consumption_in_period = any(
                        period_start <= dt <= period_end for dt in consumptions
                    )
                    
                    if has_consumption_in_period:
                        # 检查是否是首次消费（在时间段开始之前没有消费记录）
                        # 修复：检查时间段开始之前是否有任何消费记录
                        has_consumption_before = any(
                            dt < period_start for dt in consumptions
                        )
                        
                        if not has_consumption_before:
                            # 用户在该时间段首次消费
                            base_users.add(user_id)
            else:
                # 活跃用户留存：该时间段有消费记录的所有用户
                for user_id, consumptions in user_consumptions.items():
                    if any(period_start <= dt <= period_end for dt in consumptions):
                        base_users.add(user_id)
            
            base_users_count = len(base_users)
            
            # 计算后续周期的留存率（最多9个周期）
            retention_data = []
            max_periods = 9
            
            for i in range(1, max_periods + 1):
                if period == 'daily':
                    current_period_start = (period_end + timedelta(microseconds=1)).replace(hour=0, minute=0, second=0, microsecond=0)
                    current_period_start += timedelta(days=(i-1))
                    current_period_end = current_period_start.replace(hour=23, minute=59, second=59, microsecond=999999)
                elif period == 'weekly':
                    # 修复：后续周从当前周结束后开始，不强制对齐到周一
                    current_period_start = period_end + timedelta(microseconds=1)
                    current_period_start += timedelta(weeks=(i-1))
                    current_period_end = current_period_start + timedelta(days=6, hours=23, minutes=59, seconds=59, microseconds=999999)
                else:  # monthly
                    if period_end.month == 12:
                        current_period_start = period_end.replace(year=period_end.year + 1, month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
                    else:
                        current_period_start = period_end.replace(month=period_end.month + 1, day=1, hour=0, minute=0, second=0, microsecond=0)
                    current_period_start += timedelta(days=(i-1)*30)
                    current_period_start = current_period_start.replace(day=1)
                    if current_period_start.month == 12:
                        current_period_end = current_period_start.replace(year=current_period_start.year + 1, month=1, day=1) - timedelta(microseconds=1)
                    else:
                        current_period_end = current_period_start.replace(month=current_period_start.month + 1, day=1) - timedelta(microseconds=1)
                
                # 计算在当前周期也活跃的基准用户
                retained_users = set()
                for user_id in base_users:
                    consumptions = user_consumptions.get(user_id, [])
                    if any(current_period_start <= dt <= current_period_end for dt in consumptions):
                        retained_users.add(user_id)
                
                retained_count = len(retained_users)
                retention_rate = (retained_count / base_users_count * 100) if base_users_count > 0 else 0
                
                retention_data.append({
                    'retained_users': retained_count,
                    'retention_rate': retention_rate
                })
            
            # 生成时间段标签
            if period == 'daily':
                period_label = period_start.strftime('%Y-%m-%d')
            elif period == 'weekly':
                period_label = f"{period_start.strftime('%Y/%m/%d')}~{period_end.strftime('%Y/%m/%d')}"
            else:
                period_label = f"{period_start.strftime('%Y/%m')}"
            
            results.append({
                'period_label': period_label,
                'new_users': base_users_count,
                'retention_data': retention_data
            })
        
        return {
            "success": True,
            "data": results
        }
            
    except HTTPException:
        raise
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
        
        start_dt = datetime.strptime(start_date, '%Y-%m-%d').replace(hour=0, minute=0, second=0, microsecond=0)
        end_dt = datetime.strptime(end_date, '%Y-%m-%d').replace(hour=23, minute=59, second=59, microsecond=999999)
        
        data_cache = load_data_from_csv()
        if not data_cache:
            raise HTTPException(status_code=500, detail="无法加载 CSV 数据")
        
        user_consumptions = data_cache['user_consumptions']
        user_first_consumption = data_cache['user_first_consumption']
        
        # 查找在时间段内有消费的用户（活跃用户）
        active_users = []
        for user_id, consumptions in user_consumptions.items():
            period_consumptions = [dt for dt in consumptions if start_dt <= dt <= end_dt]
            if period_consumptions:
                # 检查是否是新增用户（在时间段开始之前没有消费记录）
                has_consumption_before = any(dt < start_dt for dt in consumptions)
                first_consumption = user_first_consumption.get(user_id)
                
                active_users.append({
                    'user_id': user_id,
                    'consumption_count': len(period_consumptions),
                    'first_consumption_in_period': min(period_consumptions).isoformat(),
                    'last_consumption_in_period': max(period_consumptions).isoformat(),
                    'is_new_user': not has_consumption_before,
                    'first_consumption_ever': first_consumption.isoformat() if first_consumption else None,
                    'total_consumptions': len(consumptions)
                })
        
        # 统计新增用户
        new_users = [u for u in active_users if u['is_new_user']]
        
        return {
            "success": True,
            "period": {
                "start": start_dt.isoformat(),
                "end": end_dt.isoformat()
            },
            "statistics": {
                "total_active_users": len(active_users),
                "new_users": len(new_users),
                "returning_users": len(active_users) - len(new_users)
            },
            "active_users": sorted(active_users, key=lambda x: x['user_id']),
            "new_users_list": sorted([u['user_id'] for u in new_users])
        }
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

