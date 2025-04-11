-- Top 10 leading causes of death in Nigeria
SELECT cause_name,
    SUM(indicator_value) AS ind_val
FROM nigeria_health_indicators
WHERE cause_name IS NOT NULL
    AND cause_name <> 'All Causes'
    AND indicator_name LIKE '%mortality%'
    AND cause_name NOT LIKE '%Communicable%'
    AND cause_name NOT LIKE '%Infectious%'
    AND cause_name NOT LIKE '%Parasitic%'
    AND cause_name NOT LIKE '%Respiratory%'
    AND cause_name NOT LIKE '%Noncommunicable%'
GROUP BY cause_name
ORDER BY ind_val DESC
LIMIT 10