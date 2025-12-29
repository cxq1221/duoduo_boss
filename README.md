# 运营数据查询系统

基于 FastAPI + Python + MySQL 的运营数据查询网页应用。

## 功能特性

- 📊 查询运营核心指标：总充值金额、付费用户数、总用户数、ARPPU、ARPU、付费率
- 📅 支持自定义日期范围查询
- ⚡ 快速日期选择：今天、近7天、近30天
- 🎨 现代化 UI 设计
- 🔒 参数化查询，防止 SQL 注入
- 🚀 基于 FastAPI，自动生成 API 文档

## SQL 查询修正说明

原 SQL 存在以下问题，已修正：

1. **只统计支付成功的订单**：原 SQL 统计了所有订单，修正后只统计 `state = 1` 的支付成功订单
2. **付费率计算错误**：原 SQL 使用整数除法，修正后使用小数除法并乘以 100 显示百分比
3. **日期范围处理**：使用参数化查询，支持灵活的日期范围
4. **NULL 值处理**：使用 `COALESCE` 和 `CASE WHEN` 确保数据准确性

## 安装和运行

### 前置要求

- Python 3.8+

### 安装步骤

1. 安装依赖：
```bash
pip install -r requirements.txt
```

2. 启动服务器：
```bash
python app.py
```

或者使用 uvicorn 直接启动：
```bash
uvicorn app:app --host 0.0.0.0 --port 3000
```

3. 打开浏览器访问：
```
http://localhost:3000
```

4. API 文档（可选）：
```
http://localhost:3000/docs  # Swagger UI
http://localhost:3000/redoc  # ReDoc
```

## 数据库配置

数据库配置在 `app.py` 中，当前使用：
- 主机：iaas-center.mysql.rds.aliyuncs.com:3306
- 数据库：iaas_wallet
- 用户：iaasdev

## API 接口

### POST /api/operational-data

查询运营数据

**请求体：**
```json
{
  "startDate": "2025-01-01",
  "endDate": "2025-01-31"
}
```

**响应：**
```json
{
  "success": true,
  "data": {
    "total_revenue": 1000000,
    "paying_users": 100,
    "total_users": 500,
    "ARPPU": 10000,
    "ARPU": 2000,
    "pay_rate": 20.00
  },
  "dateRange": {
    "startDate": "2025-01-01",
    "endDate": "2025-01-31"
  }
}
```

### GET /api/health

健康检查接口，用于测试数据库连接。

