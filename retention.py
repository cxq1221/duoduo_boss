"""
留存数据分析模块
负责加载 CSV 数据、计算留存率等功能
"""
from datetime import datetime, timedelta
from collections import defaultdict
from typing import Dict, Set, List, Tuple, Optional
import csv


# 数据缓存
_data_cache = None
_data_loaded = False


def load_data_from_csv(csv_file: str = "user_balance_changes.csv") -> Optional[Dict]:
    """从 CSV 文件加载数据到内存
    
    参数:
        csv_file: CSV 文件路径，默认为 "user_balance_changes.csv"
    
    返回:
        包含以下键的字典：
        - user_consumptions: {user_id: [datetime, ...]} - 每个用户的消费时间列表
        - user_first_consumption: {user_id: datetime} - 每个用户首次消费时间
        - max_date: datetime - 数据的最新时间，用于判断后续周期是否已到来
        如果加载失败返回 None
    """
    global _data_cache, _data_loaded
    
    if _data_loaded:
        return _data_cache
    
    print("正在加载 CSV 数据...")
    
    # 数据结构：
    # user_consumptions: {user_id: [datetime, ...]} - 每个用户的消费时间列表（type=1）
    # user_first_consumption: {user_id: datetime} - 每个用户首次消费时间
    user_consumptions = defaultdict(list)
    user_first_consumption = {}
    max_date = None  # 记录数据的最新时间
    
    try:
        with open(csv_file, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                try:
                    user_id = row['user_id'].strip('"')
                    created_at_str = row['created_at'].strip('"')
                    
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
                    
                    # 记录最新时间
                    if max_date is None or dt > max_date:
                        max_date = dt
                        
                except (ValueError, KeyError) as e:
                    continue
        
        # 对每个用户的消费时间排序
        for user_id in user_consumptions:
            user_consumptions[user_id].sort()
        
        _data_cache = {
            'user_consumptions': dict(user_consumptions),
            'user_first_consumption': user_first_consumption,
            'max_date': max_date  # 添加数据的最新时间
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


def generate_periods(start_date: str, end_date: str, period: str) -> List[Tuple[datetime, datetime]]:
    """生成时间段列表
    
    参数:
        start_date: 开始日期 (YYYY-MM-DD)
        end_date: 结束日期 (YYYY-MM-DD)
        period: 周期类型 ('daily', 'weekly', 'monthly')
    
    返回:
        时间段列表，每个元素为 (period_start, period_end) 元组
    """
    start_dt = datetime.strptime(start_date, '%Y-%m-%d').replace(hour=0, minute=0, second=0, microsecond=0)
    end_dt = datetime.strptime(end_date, '%Y-%m-%d').replace(hour=23, minute=59, second=59, microsecond=999999)
    
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
        # 使用用户选择的开始日期作为第一周的开始，而不是强制对齐到周一
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
    
    return periods


def get_base_users(
    user_consumptions: Dict[str, List[datetime]],
    period_start: datetime,
    period_end: datetime,
    retention_type: str
) -> Set[str]:
    """获取基准用户集合（新用户或活跃用户）
    
    参数:
        user_consumptions: 用户消费记录字典
        period_start: 时间段开始时间
        period_end: 时间段结束时间
        retention_type: 留存类型 ('new' 或 'active')
    
    返回:
        用户ID集合
    """
    base_users = set()
    
    if retention_type == 'new':
        # 新用户留存：该时间段首次有消费记录的用户
        for user_id, consumptions in user_consumptions.items():
            # 检查用户在该时间段是否有消费
            has_consumption_in_period = any(
                period_start <= dt <= period_end for dt in consumptions
            )
            
            if has_consumption_in_period:
                # 检查是否是首次消费（在时间段开始之前没有消费记录）
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
    
    return base_users


def calculate_retention_for_period(
    base_users: Set[str],
    user_consumptions: Dict[str, List[datetime]],
    period_start: datetime,
    period_end: datetime,
    period_type: str,
    max_periods: int = 9,
    max_date: Optional[datetime] = None
) -> List[Dict]:
    """计算单个时间段的留存率
    
    参数:
        base_users: 基准用户集合
        user_consumptions: 用户消费记录字典
        period_start: 基准时间段开始时间
        period_end: 基准时间段结束时间
        period_type: 周期类型 ('daily', 'weekly', 'monthly')
        max_periods: 最多计算多少个后续周期
        max_date: 数据的最新时间，用于判断周期是否已到来
    
    返回:
        留存数据列表，每个元素包含 retained_users 和 retention_rate（如果周期未到来则为 None）
    """
    base_users_count = len(base_users)
    retention_data = []
    
    for i in range(1, max_periods + 1):
        # 计算后续周期的时间范围
        if period_type == 'daily':
            current_period_start = (period_end + timedelta(microseconds=1)).replace(hour=0, minute=0, second=0, microsecond=0)
            current_period_start += timedelta(days=(i-1))
            current_period_end = current_period_start.replace(hour=23, minute=59, second=59, microsecond=999999)
        elif period_type == 'weekly':
            current_period_start = period_end + timedelta(microseconds=1)
            current_period_start += timedelta(weeks=(i-1))
            current_period_end = current_period_start + timedelta(days=6, hours=23, minutes=59, seconds=59, microseconds=999999)
        else:  # monthly
            # 从基准周期的下一个月开始
            if period_end.month == 12:
                next_month_start = period_end.replace(year=period_end.year + 1, month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
            else:
                next_month_start = period_end.replace(month=period_end.month + 1, day=1, hour=0, minute=0, second=0, microsecond=0)
            
            # 计算第 i 个后续月份（基于实际月份，而不是固定天数）
            target_month = next_month_start.month + (i - 1)
            target_year = next_month_start.year
            
            # 处理跨年
            while target_month > 12:
                target_month -= 12
                target_year += 1
            
            current_period_start = datetime(target_year, target_month, 1, 0, 0, 0, 0)
            
            # 计算月末
            if target_month == 12:
                next_month = datetime(target_year + 1, 1, 1, 0, 0, 0, 0)
            else:
                next_month = datetime(target_year, target_month + 1, 1, 0, 0, 0, 0)
            current_period_end = next_month - timedelta(microseconds=1)
        
        # 判断周期是否已经到来（如果后续周期的开始时间在数据最新时间之后，说明周期未到来）
        if max_date is not None and current_period_start > max_date:
            # 周期未到来，返回空值
            retention_data.append({
                'retained_users': None,
                'retention_rate': None
            })
            continue
        
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
    
    return retention_data


def format_period_label(period_start: datetime, period_end: datetime, period_type: str) -> str:
    """格式化时间段标签
    
    参数:
        period_start: 时间段开始时间
        period_end: 时间段结束时间
        period_type: 周期类型 ('daily', 'weekly', 'monthly')
    
    返回:
        格式化的时间段标签字符串
    """
    if period_type == 'daily':
        return period_start.strftime('%Y-%m-%d')
    elif period_type == 'weekly':
        return f"{period_start.strftime('%Y/%m/%d')}~{period_end.strftime('%Y/%m/%d')}"
    else:
        return f"{period_start.strftime('%Y/%m')}"


def calculate_retention_multi(
    retention_type: str,
    period: str,
    start_date: str,
    end_date: str
) -> Dict:
    """计算多时间段留存率
    
    参数:
        retention_type: 留存类型 ('new' 或 'active')
        period: 周期类型 ('daily', 'weekly', 'monthly')
        start_date: 开始日期 (YYYY-MM-DD)
        end_date: 结束日期 (YYYY-MM-DD)
    
    返回:
        包含 success 和 data 字段的字典
    """
    # 加载 CSV 数据
    data_cache = load_data_from_csv()
    if not data_cache:
        raise ValueError("无法加载 CSV 数据，请确保 user_balance_changes.csv 文件存在")
    
    user_consumptions = data_cache['user_consumptions']
    max_date = data_cache.get('max_date')  # 获取数据的最新时间
    
    # 生成时间段列表
    periods = generate_periods(start_date, end_date, period)
    
    results = []
    
    # 对每个时间段计算留存率
    for period_start, period_end in periods:
        # 计算该时间段的新增用户或活跃用户
        base_users = get_base_users(user_consumptions, period_start, period_end, retention_type)
        base_users_count = len(base_users)
        
        # 计算后续周期的留存率
        retention_data = calculate_retention_for_period(
            base_users, user_consumptions, period_start, period_end, period, max_periods=9, max_date=max_date
        )
        
        # 生成时间段标签
        period_label = format_period_label(period_start, period_end, period)
        
        results.append({
            'period_label': period_label,
            'new_users': base_users_count,
            'retention_data': retention_data
        })
    
    return {
        "success": True,
        "data": results
    }


def debug_retention_data(start_date: str, end_date: str) -> Dict:
    """调试接口：返回详细的计算过程
    
    参数:
        start_date: 开始日期 (YYYY-MM-DD)
        end_date: 结束日期 (YYYY-MM-DD)
    
    返回:
        包含详细调试信息的字典
    """
    start_dt = datetime.strptime(start_date, '%Y-%m-%d').replace(hour=0, minute=0, second=0, microsecond=0)
    end_dt = datetime.strptime(end_date, '%Y-%m-%d').replace(hour=23, minute=59, second=59, microsecond=999999)
    
    data_cache = load_data_from_csv()
    if not data_cache:
        raise ValueError("无法加载 CSV 数据")
    
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

