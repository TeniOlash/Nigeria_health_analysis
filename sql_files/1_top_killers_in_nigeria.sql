-- Top 10 leading causes of death in Nigeria
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
    AND indicator_name LIKE '%mortality%'
GROUP BY cause_name
ORDER BY total_mortality DESC
LIMIT 10;
/*Key Observations Top Cause: Lower Respiratory Infections Highest mortality (1, 942 deaths) suggests significant challenges in healthcare access, air quality, or infectious disease control (e.g., pneumonia, bronchitis).High Burden of Cardiovascular Diseases Second - leading cause (1, 626 deaths), likely tied to hypertension,
 poor diet, and limited preventive care.HIV / AIDS Remains a Major Threat Third place (913 deaths) highlights ongoing struggles with HIV management and education.Injuries & Unintentional Deaths Combined,
 injuries (886) and unintentional incidents (699) point to risks like road accidents,
 violence, or workplace hazards.Stroke & Ischaemic Heart Disease Both in the top 10, reflecting lifestyle factors (high salt intake, smoking, sedentary habits).Digestive & Diarrhoeal Diseases High mortality (727 and 526 deaths) may indicate poor sanitation, contaminated water, or malnutrition.
 */