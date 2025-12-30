"""
工具函数模块
包含刷量用户检测等工具函数
"""
from datetime import datetime, timedelta
from typing import Set


def detect_fake_users(
    connection_pool,
    start_date: str,
    end_date: str,
    window_minutes: int = 1,
    threshold: int = 5
) -> Set[str]:
    """检测刷量用户（短时间内大量创建的用户）
    
    算法逻辑：
    1. 查询指定日期范围内的所有用户及其创建时间
    2. 按创建时间排序
    3. 滑动窗口检测：如果某个时间窗口内注册用户数超过阈值，标记为异常时间段
    4. 返回所有异常时间段内的用户ID集合
    
    参数：
        connection_pool: MySQL 连接池对象
        start_date: 开始日期 (YYYY-MM-DD)
        end_date: 结束日期 (YYYY-MM-DD)
        window_minutes: 时间窗口大小（分钟），默认1分钟
        threshold: 阈值，窗口内超过此数量的用户注册认为是刷量，默认5个
    
    返回：
        刷量用户的 user_id 集合
    """
    try:
        connection = connection_pool.get_connection()
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

