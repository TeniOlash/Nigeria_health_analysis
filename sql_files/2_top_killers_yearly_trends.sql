-- Yearly trends for the overall top 10 causes of mortality
WITH overall_top_causes AS (
    SELECT cause_name,
        SUM(indicator_value) AS total_mortality
    FROM nigeria_health_indicators
    WHERE cause_name IS NOT NULL
        AND cause_name NOT IN (
            'All Causes',
            'Communicable & other Group I',
            'Noncommunicable diseases',
            'Respiratory infections',
            'Infectious and parasitic diseases'
        )
        AND indicator_name ILIKE '%mortality%'
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
/*1.Nigeria ’ s Top Killers: Key Trends A.Infectious Diseases (Mixed Progress) Diarrhoeal Diseases: ↓ 63.5 % (385 → 141) Success likely tied to: Improved oral rehydration, rotavirus vaccines, and sanitation campaigns (e.g., UNICEF WASH programs).Lower Respiratory Infections: ↓ 19.3 % (1075 → 868) Possible drivers: Pneumonia vaccines (introduced in 2014) and better primary healthcare access pre -2012.HIV / AIDS: ↑ 26.4 % (403 → 510) Nigeria ’ s context: Despite global progress, Nigeria had low ART coverage (~ 20 % in 2012) and high stigma.B.Non - Communicable Diseases (Growing Threat) Cardiovascular Diseases: ↓ 3.8 % (829 → 797) Still the #2 cause: Reflects rising obesity, hypertension, and urban diets. Stroke: ↓ 4 % (387 → 371) Limited decline: Poor hypertension control (only ~ 10 % of Nigerians had controlled BP in 2012).C.Injuries (Persistent Crisis) Unintentional Injuries: Stable (~ 350 deaths) Likely includes: Road accidents (Nigeria has one of the world ’ s highest road fatality rates).*/