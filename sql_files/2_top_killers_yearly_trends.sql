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
), yearly_mortality AS (
    SELECT n.year,
        n.cause_name,
        SUM(n.indicator_value) AS yearly_total_mortality
    FROM nigeria_health_indicators n
        JOIN overall_top_causes otc ON n.cause_name = otc.cause_name
    WHERE n.indicator_name LIKE '%mortality%'
    GROUP BY n.year,
        n.cause_name
),
mortality_trends AS (
    SELECT year,
        cause_name,
        yearly_total_mortality,
        -- Year-over-year absolute change
        yearly_total_mortality - LAG(yearly_total_mortality) OVER (
            PARTITION BY cause_name
            ORDER BY year
        ) AS yoy_change,
        -- Year-over-year percentage change
        ROUND(
            CAST(
                (
                    yearly_total_mortality - LAG(yearly_total_mortality) OVER (
                        PARTITION BY cause_name
                        ORDER BY year
                    )
                ) AS numeric
            ) / NULLIF(
                CAST(
                    LAG(yearly_total_mortality) OVER (
                        PARTITION BY cause_name
                        ORDER BY year
                    ) AS numeric
                ),
                0
            ) * 100,
            2
        ) AS yoy_pct_change,
        -- Rank causes by mortality each year
        RANK() OVER (
            PARTITION BY year
            ORDER BY yearly_total_mortality DESC
        ) AS yearly_rank
    FROM yearly_mortality
)
SELECT year,
    cause_name,
    yearly_total_mortality,
    yoy_change,
    yoy_pct_change,
    yearly_rank,
    -- Calculate percentage of total mortality for that year
    ROUND(
        CAST(yearly_total_mortality AS numeric) / NULLIF(
            CAST(
                SUM(yearly_total_mortality) OVER (PARTITION BY year) AS numeric
            ),
            0
        ) * 100,
        2
    ) AS pct_of_year_total
FROM mortality_trends
ORDER BY year DESC,
    yearly_total_mortality DESC;
/*1.Leading Causes of Death (Consistent) Lower respiratory infections
 and cardiovascular diseases remained the top 2 killers in both years,
 though their burden decreased: Respiratory infections: 1,
 075 (2000) → 868 (2012) ▼ 19.25 % Cardiovascular diseases: 829 → 797 ▼ 3.83 % 2.Most Significant Changes HIV / AIDS Surge: Increased by 26.4 % (403 → 510 deaths),
 jumping
 from #4 to #3 rank.
 Implication: Reflects the peak of Nigeria 's HIV epidemic before widespread ART access.
 
 Diarrhoeal Diseases Collapse:
 
 63.5% decrease (385 → 141 deaths), dropping from #6 to #10.
 
 Likely drivers: Improved water/sanitation and ORS adoption.
 
 3. Mixed Trends in Injuries
 Unintentional injuries remained stable (350 → 349, ▼0.5%).
 
 Intentional injuries decreased slightly (450 → 436, ▼3.1%).
 
 4. Chronic Disease Progress
 Stroke and ischaemic heart disease showed modest declines (▼4% and ▼1.6% respectively).
 
 Cancer (malignant neoplasms) decreased significantly (▼10.4%), possibly due to earlier detection/treatment.
 
 5. Year 2000 Baseline Insights
 Diarrhoeal diseases were the #6 cause (385 deaths), highlighting historical sanitation challenges.
 
 Injuries (both intentional and unintentional) accounted for 16.3% of top-10 mortality.
 
 Priority Implications
 HIV Success Story: The 2012 surge suggests Nigeria' s HIV response needed scaling up (
 later achieved through PEPFAR / Global Fund support
 ).Infection Control Wins: Sharp declines in diarrhoeal
 and respiratory infections show public health interventions worked.Chronic Disease Transition: Non - communicable diseases (stroke, heart disease) remained persistent despite overall declines.Data Limitations Missing intermediate years (2001 -2011) obscures trend trajectories."% of year total" calculations exclude causes beyond the top 10.*/