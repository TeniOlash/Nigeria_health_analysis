-- Identifying the mortalities caused by non-communicable diseases (Cardiovascular, Neoplasms, Diabetes, COPD) and comparing the prevalence by gender
WITH ncd_sex_trend AS (
    SELECT sex,
        cause_name,
        SUM (indicator_value) AS total_mortality,
        RANK () OVER (
            PARTITION BY sex
            ORDER BY SUM (indicator_value) DESC
        ) AS sex_rank
    FROM ncd_mental_health_indicators
    WHERE sex <> 'Both sexes'
    GROUP BY sex,
        cause_name
    ORDER BY total_mortality DESC
)
SELECT sex,
    cause_name,
    total_mortality
FROM ncd_sex_trend
ORDER BY sex,
    sex_rank;
/*1. Leading Causes by Gender
 Both Genders:
 
 Lower respiratory infections (e.g., pneumonia) are the top killer for both females (598 deaths) and males (697 deaths), but males are ~16% more affected.
 
 Cardiovascular diseases rank #2 for both, but females (555 deaths) have a 5% higher mortality than males (527 deaths).
 
 Female-Specific Trends:
 
 HIV/AIDS is the #3 cause (328 deaths), far surpassing male mortality (281 deaths), suggesting higher vulnerability or testing disparities.
 
 Stroke (#4 for females) and malignant neoplasms (cancer, #5) are more prominent than in males.
 
 Male-Specific Trends:
 
 Injuries (385 deaths) and unintentional injuries (289 deaths) are the #3 and #5 causes for males, likely tied to accidents, violence, or occupational hazards.
 
 Digestive diseases (#4 for males) and malaria (#10) appear only in the male top 10, pointing to behavioral or environmental differences (e.g., diet, outdoor exposure).
 
 2. Notable Disparities
 Injury-Related Deaths: Males die from injuries 88% more often than females (385 vs. 205 deaths).
 
 HIV/AIDS: Female mortality is 16% higher, possibly due to biological susceptibility or social factors (e.g., testing rates).
 
 Stroke & Cancer: More lethal for females, possibly linked to hormonal factors or healthcare access.
 
 3. Actionable Implications
 Targeted Interventions:
 
 Males: Accident prevention programs, workplace safety, and malaria control.
 
 Females: Strengthen HIV/AIDS education, maternal health, and cancer screening.
 
 Shared Priorities:
 
 Combat respiratory infections (vaccination, clean air) and cardiovascular diseases (public awareness on hypertension).*/