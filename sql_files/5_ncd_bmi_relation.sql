-- Identifying the relationship between BMI and cardiovascular diseases and diabetes mellitus from 2000 to 2016
WITH bmi_ncd_mortality AS (
    SELECT RANK () OVER (
            PARTITION BY cause_name
            ORDER BY ncd_stat.indicator_value DESC
        ) AS ranked_cause,
        ncd_stat.indicator_name,
        ncd_stat.indicator_value AS mean_bmi,
        ncd_stat.year,
        ncd.cause_name,
        ncd.indicator_value AS total_mortality
    FROM ncd_health_indicators_status ncd_stat
        JOIN ncd_mental_health_indicators AS ncd ON ncd_stat.year = ncd.year
    WHERE ncd_stat.indicator_value IS NOT NULL
        AND ncd_stat.indicator_name LIKE '%Mean BMI%crude%'
        AND ncd_stat.sex = 'Both sexes'
        AND ncd_stat.age_group LIKE '%18+%'
        AND cause_name IN ('Cardiovascular diseases', 'Diabetes mellitus')
)
SELECT cause_name,
    year,
    AVG(mean_bmi) AS avg_bmi,
    SUM (total_mortality) AS total_burden
FROM bmi_ncd_mortality
GROUP BY bmi_ncd_mortality.year,
    bmi_ncd_mortality.mean_bmi,
    cause_name
ORDER BY mean_bmi DESC
    /*1. BMI Trends Over Time
     Gradual Increase: Average BMI rose consistently from 22.1 (2000) to 23 (2015-2016).
     
     Implication: Population-wide weight gain over 16 years, suggesting lifestyle/diet changes.
     
     2. Disease Burden Growth
     Both conditions showed significant mortality increases:
     
     Cardiovascular Diseases:
     
     +26% increase (344,844 in 2000 → 451,204 in 2016)
     
     Diabetes Mellitus:
     
     +60% increase (32,283 in 2000 → 51,623 in 2016)
     
     Note: Diabetes burden grew at twice the rate of cardiovascular diseases.
     
     3. BMI-Disease Correlation
     Parallel Trends: Rising BMI aligns with increasing disease burden, especially for diabetes.
     
     BMI ↑ 4% (22.1 → 23) vs. Diabetes deaths ↑ 60%.
     
     Interpretation: Diabetes may be more sensitive to BMI changes than cardiovascular diseases.
     
     4. Critical Observations
     2015-2016 Plateau: BMI stabilized at 23, but disease burden continued rising.
     
     Suggests other factors (aging population, healthcare access) may now dominate mortality trends.*/