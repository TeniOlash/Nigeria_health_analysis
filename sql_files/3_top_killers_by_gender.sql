-- Identifying top 10 causes of deaths in Nigeria for both Males and Females
WITH gender_causes AS (
    SELECT sex,
        cause_name,
        SUM(indicator_value) AS total_mortality,
        RANK() OVER (
            PARTITION BY sex
            ORDER BY SUM(indicator_value) DESC
        ) AS sex_rank
    FROM nigeria_health_indicators
    WHERE cause_name IS NOT NULL
        AND cause_name NOT IN (
            'All Causes',
            'Communicable & other Group I',
            'Noncommunicable diseases',
            'Respiratory infections',
            'Infectious and parasitic diseases'
        )
        AND sex <> 'Both sexes'
        AND indicator_name ILIKE '%mortality%'
    GROUP BY sex,
        cause_name
)
SELECT sex,
    cause_name,
    total_mortality
FROM gender_causes
WHERE sex_rank <= 10
ORDER BY sex,
    sex_rank;