-- Determining the burdens of neglected tropical diseases in Nigeria.
WITH tropical_disease_burden AS (
    SELECT indicator_name,
        SUM (indicator_value) AS total_burden
    FROM neglected_topical_disease_indicators ntd
    GROUP BY indicator_name
    HAVING SUM(indicator_value) IS NOT NULL
    UNION
    SELECT indicator_name,
        SUM (indicator_value) AS total_burden
    FROM neglected_topical_disease_indicators_2
    GROUP BY indicator_name
    HAVING SUM(indicator_value) IS NOT NULL
)
SELECT *
FROM tropical_disease_burden
WHERE indicator_name NOT LIKE '%requiring%'
    AND indicator_name NOT LIKE '%warrant%'
ORDER BY total_burden DESC
    /*1.Dominant Disease Burden Onchocerciasis (River Blindness) overwhelms all other diseases,
     with 432.3 million treated individuals.Implication: This remains Africa 's most widespread neglected tropical disease (NTD), requiring massive public health efforts.
     
     2. High-Impact Preventable Conditions
     Trachoma (bacterial eye infection) shows significant burden:
     
     52 million received antibiotic treatment
     
     82,414 required surgery for advanced trichiasis
     
     Insight: While treatment is widespread, late-stage cases still lead to blindness.
     
     3. Emerging Concerns
     Dracunculiasis (Guinea Worm) has 1.7 million annual cases despite being near eradication.
     
     Context: This waterborne parasite was targeted for global elimination by 2030—the data suggests ongoing challenges.
     
     4. Rare but Severe Diseases
     Buruli Ulcer (1,204 cases) and Leishmaniasis (240 cutaneous + 60 visceral cases) persist at lower but clinically severe levels.
     
     Pattern: These diseases show focal endemicity rather than widespread transmission.
     
     5. Imported/Controlled Diseases
     Zero reported cases of imported leishmaniasis and yaws suggests:
     
     Effective surveillance at borders, or
     
     Underreporting of these conditions*/