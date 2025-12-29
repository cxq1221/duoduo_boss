我希望增加一个功能，支持查看日留存率、周留存率、月留存率，在单独的页面，页面的结构参考常用的留存率查询统计产品，可通过左侧菜单切换到该页面
计算原理：根据user_balance_changes 表中有扣费记录代表该用户当天是活跃的

我希望加一个运营数据：激活率，定义是总注册用户数中，至少发生过一次实例扣费的，可以简单化实现，
实现方式：user_balance 这个表中如果创建时间和更新时间不一致，则为发生过实例扣费

phx_ZslpuGTtRNJ1whReQsoPdG0TM29oknVNRMKqRufszcD1Nf5

curl -X POST https://app.posthog.com/api/projects/214859/insights/trends/ \
  -H "Authorization: Bearer phc_bRmZYeUvTYAcXHbOgoNrKaUfSDv9bCD99mH2mcWCeQy" \
  -H "Content-Type: application/json" \
  -d '{
    "events": [
      {
        "id": "$pageview",
        "math": "unique_users"
      }
    ],
    "date_from": "2025-01-01",
    "date_to": "2025-01-31",
    "interval": "month"
  }'

  curl -X POST https://app.posthog.com/api/projects/214859/insights/trends/ \
  -u "phx_ZslpuGTtRNJ1whReQsoPdG0TM29oknVNRMKqRufszcD1Nf5:" \
  -H "Content-Type: application/json" \
  -d '{
    "events": [
      { "id": "$pageview", "math": "unique_users" }
    ],
    "date_from": "2025-01-01",
    "date_to": "2025-01-31",
    "interval": "month"
  }'

curl https://us.posthog.com/api/projects/214859/query/ \
  -X POST \
  -H "Authorization: Bearer phx_ZslpuGTtRNJ1whReQsoPdG0TM29oknVNRMKqRufszcD1Nf5" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "kind": "HogQLQuery",
      "query": "SELECT count(DISTINCT person_id) FROM events WHERE timestamp >= \"2025-12-01\" AND timestamp < \"2025-12-28\""
    }
  }'

curl "https://us.posthog.com/api/projects/214859/insights/trend/?date_from=2025-11-01&date_to=2025-12-29&&period=month&interval=month&events=%5B%7B%22math%22%3A%22unique_group%22%7D%5D" \
  -H "Authorization: Bearer phx_ZslpuGTtRNJ1whReQsoPdG0TM29oknVNRMKqRufszcD1Nf5"

curl "https://us.posthog.com/api/projects/214859/insights/trend/?date_from=2025-11-01&date_to=2025-12-29&interval=month&filter_test_accounts=true&period=month&events=%5B%7B%22id%22%3A%22%24pageview%22%2C%22math%22%3A%22dau%22%7D%5D" \
-H "Authorization: Bearer phx_ZslpuGTtRNJ1whReQsoPdG0TM29oknVNRMKqRufszcD1Nf5"

https://us.posthog.com/api/projects/214859/insights/trend/?date_from=2025-11-01&date_to=2025-12-29&interval=month&filter_test_accounts=true&period=month&events=%5B%7B%22id%22%3A+%22%24pageview%22%2C+%22math%22%3A+%22unique_group%22%7D%5D