-- identifying the yearly trends for neglected tropical diseases in Nigeria
WITH tropical_disease_burden AS (
    SELECT indicator_name,
        year,
        SUM(indicator_value) AS total_burden
    FROM neglected_topical_disease_indicators
    WHERE indicator_value IS NOT NULL
    GROUP BY indicator_name,
        year
    UNION
    SELECT indicator_name,
        year,
        SUM(indicator_value) AS total_burden
    FROM neglected_topical_disease_indicators_2
    WHERE indicator_value IS NOT NULL
    GROUP BY indicator_name,
        year
),
disease_trends AS (
    SELECT indicator_name,
        year,
        total_burden,
        -- Year-over-year change
        total_burden - LAG(total_burden) OVER (
            PARTITION BY indicator_name
            ORDER BY year
        ) AS yoy_change,
        -- Percent change (using CAST to numeric for proper rounding)
        ROUND(
            CAST(
                (
                    total_burden - LAG(total_burden) OVER (
                        PARTITION BY indicator_name
                        ORDER BY year
                    )
                ) AS numeric
            ) / NULLIF(
                CAST(
                    LAG(total_burden) OVER (
                        PARTITION BY indicator_name
                        ORDER BY year
                    ) AS numeric
                ),
                0
            ) * 100,
            2
        ) AS yoy_pct_change,
        -- Rank diseases by burden each year
        RANK() OVER (
            PARTITION BY year
            ORDER BY total_burden DESC
        ) AS yearly_rank
    FROM tropical_disease_burden
    WHERE indicator_name NOT LIKE '%requiring%'
        AND indicator_name NOT LIKE '%warrant%'
        AND total_burden > 0 -- Exclude zero-burden entries
)
SELECT indicator_name,
    year,
    total_burden,
    yoy_change,
    yoy_pct_change,
    yearly_rank
FROM disease_trends
ORDER BY total_burden DESC,
    year DESC;
/*1. Onchocerciasis (River Blindness) Dominance
 Consistent #1 Ranking: Remained the top-treated NTD across all years (2005-2018)
 
 Treatment Peaks:
 
 2014 saw highest treatment volume (44.4M people, ▲55% YoY)
 
 2015 unexpected 20.6% drop (35.3M), possibly due to program disruptions
 
 2. Trachoma Treatment Volatility
 Antibiotic Treatment Surges:
 
 2016: 18018% spike (7.98M people) after near-zero 2015 (44K)
 
 2018: 11.3M treated (▲87.7% YoY)
 
 Surgical Interventions Growth:
 
 Trichiasis surgeries increased 60% YoY in 2019 (23,717 procedures)
 
 3. Dracunculiasis (Guinea Worm) Near-Eradication
 98.8% Reduction:
 
 1989: 640,008 cases → 2007: 73 cases
 
 Steady annual declines (avg ▼47% YoY 1989-2007)
 
 Recent Progress:
 
 By 2007, cases fell to double digits (73 cases)
 
 4. Emerging Disease Patterns
 Buruli Ulcer:
 
 Cases grew 63.7% (2017-2018) after years of instability
 
 2016 saw 106% YoY increase (235 cases)
 
 Leishmaniasis:
 
 Cutaneous cases fluctuated wildly (95 in 2011 → 5 in 2014)
 
 Visceral leishmaniasis peaked at 57 cases (2012)
 
 5. African Trypanosomiasis Control
 Cases Reduced to Near-Zero:
 
 1990: 24 cases → 2016: 1 case
 
 Intermittent resurgences (e.g., 31 cases in 2003)
 
 Key Public Health Implications
 Onchocerciasis Success: Mass drug administration programs are reaching tens of millions annually, but 2015 drop warrants investigation.
 
 Trachoma Gaps: Extreme treatment fluctuations suggest inconsistent program implementation.
 
 Guinea Worm Victory: The 1989-2007 data shows one of global health's greatest success stories.
 
 Buruli Ulcer Alert: Recent case growth in Nigeria may require targeted surveillance.
 
 Data Anomalies Needing Verification
 Trachoma antibiotic treatments in 2010-2015 show biologically implausible % changes (e.g., 18,018% in 2016)
 
 Some year-to-year case fluctuations may reflect reporting changes rather than true epidemiological shifts*/