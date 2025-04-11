-- Leading causes of death in Nigeria
-- SELECT
--     indicator_code,
--     indicator_name,
--     cause_name,
--     year,
--     sex,
--     indicator_value
-- FROM nigeria_health_indicators
-- WHERE 
--     cause_name IS NOT NULL
--     AND cause_name <> 'All Causes'
--     AND indicator_name LIKE '%mortality%'
--     AND cause_name NOT LIKE '%Communicable%'
--     AND cause_name NOT LIKE '%Infectious%'
--     AND cause_name NOT LIKE '%Parasitic%'
--     AND cause_name NOT LIKE '%Respiratory%'
--     AND cause_name NOT LIKE '%Noncommunicable%'
--     AND sex = 'Both sexes'
-- ORDER BY indicator_value DESC
-- LIMIT 25
-- Yearly trends for the overall top 5 causes of mortality
WITH overall_top_causes AS (
    SELECT cause_name,
        SUM(indicator_value) AS total_mortality
    FROM nigeria_health_indicators
    WHERE cause_name IS NOT NULL
        AND cause_name <> 'All Causes'
        AND indicator_name LIKE '%mortality%'
        AND cause_name NOT LIKE '%Communicable%'
        AND cause_name NOT LIKE '%Infectious%'
        AND cause_name NOT LIKE '%Parasitic%'
        AND cause_name NOT LIKE '%Respiratory%'
        AND cause_name NOT LIKE '%Noncommunicable%'
        AND sex = 'Both sexes'
        AND indicator_name LIKE '%mortality%'
    GROUP BY cause_name
    ORDER BY total_mortality DESC
    LIMIT 10
)
SELECT n.year,
    n.cause_name,
    SUM(n.indicator_value) AS yearly_total_mortality
FROM nigeria_health_indicators n
    JOIN overall_top_causes otc ON n.cause_name = otc.cause_name
WHERE n.indicator_name LIKE '%mortality%'
GROUP BY n.year,
    n.cause_name
ORDER BY n.year,
    yearly_total_mortality DESC;