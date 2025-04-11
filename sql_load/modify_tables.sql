\ COPY nigeria_health_indicators(
    indicator_code,
    indicator_name,
    year,
    age_group,
    sex,
    cause_code,
    cause_name,
    indicator_value
)
FROM 'C:/Users/User/Documents/My Stuff/TecN/Nigeria_health_analysis/csv_files/nigeria_health_indicators.csv' DELIMITER ',' CSV HEADER;
\ COPY infectious_disease_indicators (
    indicator_code,
    indicator_name,
    year,
    indicator_value
)
FROM 'C:/Users/User/Documents/My Stuff/TecN/Nigeria_health_analysis/csv_files/infectious_disease_indicators_for_nigeria.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
\ COPY neglected_topical_disease_indicators(
    indicator_code,
    indicator_name,
    year,
    indicator_value
)
FROM 'C:/Users/User/Documents/My Stuff/TecN/Nigeria_health_analysis/csv_files/negelected_tropical_diseases_indicators.csv' DELIMITER ',' CSV HEADER;
\ COPY neglected_topical_disease_indicators_2(
    indicator_code,
    indicator_name,
    year,
    indicator_value
)
FROM 'C:/Users/User/Documents/My Stuff/TecN/Nigeria_health_analysis/csv_files/neglected_tropical_diseases_indicators_2.csv' DELIMITER ',' CSV HEADER;
\ COPY ncd_mental_health_indicators(
    indicator_code,
    indicator_name,
    year,
    sex,
    cause_code,
    cause_name,
    indicator_value
)
FROM 'C:/Users/User/Documents/My Stuff/TecN/Nigeria_health_analysis/csv_files/ncd_and_mental_health_indicators_for_nigeria_1.csv' DELIMITER ',' CSV HEADER;
\ COPY ncd_health_indicators_status(
    indicator_code,
    indicator_name,
    year,
    age_group,
    sex,
    indicator_value
)
FROM 'C:/Users/User/Documents/My Stuff/TecN/Nigeria_health_analysis/csv_files/ncd_indicators_for_nigeria_status.csv' DELIMITER ',' CSV HEADER;
-- extracting unique indicator_code + indicator_name
INSERT INTO indicators_dim (indicator_code, indicator_name)
SELECT DISTINCT indicator_code,
    indicator_name
FROM (
        SELECT indicator_code,
            indicator_name
        FROM nigeria_health_indicators
        UNION
        SELECT indicator_code,
            indicator_name
        FROM infectious_disease_indicators
        UNION
        SELECT indicator_code,
            indicator_name
        FROM ncd_mental_health_indicators
        UNION
        SELECT indicator_code,
            indicator_name
        FROM ncd_health_indicators_status
        UNION
        SELECT indicator_code,
            indicator_name
        FROM neglected_topical_disease_indicators
        UNION
        SELECT indicator_code,
            indicator_name
        FROM neglected_topical_disease_indicators_2
    ) AS all_indicators;
-- assigning the correct indicator_id to all the tables
UPDATE nigeria_health_indicators n
SET indicator_id = i.id
FROM indicators_dim i
WHERE n.indicator_code = i.indicator_code;
UPDATE infectious_disease_indicators t
SET indicator_id = i.id
FROM indicators_dim i
WHERE t.indicator_code = i.indicator_code;
UPDATE neglected_topical_disease_indicators t
SET indicator_id = i.id
FROM indicators_dim i
WHERE t.indicator_code = i.indicator_code;
UPDATE neglected_topical_disease_indicators_2 t
SET indicator_id = i.id
FROM indicators_dim i
WHERE t.indicator_code = i.indicator_code;
UPDATE ncd_mental_health_indicators t
SET indicator_id = i.id
FROM indicators_dim i
WHERE t.indicator_code = i.indicator_code;
UPDATE ncd_health_indicators_status t
SET indicator_id = i.id
FROM indicators_dim i
WHERE t.indicator_code = i.indicator_code;