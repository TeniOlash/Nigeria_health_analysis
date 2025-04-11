-- Dimension Table
CREATE TABLE indicators_dim (
    id SERIAL PRIMARY KEY,
    indicator_code TEXT UNIQUE,
    indicator_name TEXT
);
-- Fact Tables
CREATE TABLE nigeria_health_indicators (
    id SERIAL PRIMARY KEY,
    indicator_id INT REFERENCES indicators_dim(id),
    indicator_code TEXT,
    indicator_name TEXT,
    year INT,
    age_group TEXT,
    sex TEXT,
    cause_code TEXT,
    cause_name TEXT,
    indicator_value FLOAT
);
CREATE TABLE infectious_disease_indicators (
    id SERIAL PRIMARY KEY,
    indicator_id INT REFERENCES indicators_dim(id),
    indicator_code TEXT,
    indicator_name TEXT,
    year INT,
    indicator_value FLOAT
);
CREATE TABLE neglected_topical_disease_indicators (
    id SERIAL PRIMARY KEY,
    indicator_id INT REFERENCES indicators_dim(id),
    indicator_code TEXT,
    indicator_name TEXT,
    year INT,
    indicator_value FLOAT
);
CREATE TABLE neglected_topical_disease_indicators_2 (
    id SERIAL PRIMARY KEY,
    indicator_id INT REFERENCES indicators_dim(id),
    indicator_code TEXT,
    indicator_name TEXT,
    year INT,
    indicator_value FLOAT
);
CREATE TABLE ncd_mental_health_indicators (
    id SERIAL PRIMARY KEY,
    indicator_id INT REFERENCES indicators_dim(id),
    indicator_code TEXT,
    indicator_name TEXT,
    year INT,
    sex TEXT,
    cause_code TEXT,
    cause_name TEXT,
    indicator_value FLOAT
);
CREATE TABLE ncd_health_indicators_status (
    id SERIAL PRIMARY KEY,
    indicator_id INT REFERENCES indicators_dim(id),
    indicator_code TEXT,
    indicator_name TEXT,
    year INT,
    age_group TEXT,
    sex TEXT,
    indicator_value FLOAT
);
-- Set ownership
ALTER TABLE nigeria_health_indicators OWNER TO postgres;
ALTER TABLE infectious_disease_indicators OWNER TO postgres;
ALTER TABLE neglected_topical_disease_indicators OWNER TO postgres;
ALTER TABLE neglected_topical_disease_indicators_2 OWNER TO postgres;
ALTER TABLE ncd_mental_health_indicators OWNER TO postgres;
ALTER TABLE ncd_health_indicators_status OWNER TO postgres;
ALTER TABLE indicators_dim OWNER TO postgres;
-- Indexes on Foreign Keys
CREATE INDEX idx_nigeria_health_indicators_id ON nigeria_health_indicators(indicator_id);
CREATE INDEX idx_infectious_disease_indicators_id ON infectious_disease_indicators(indicator_id);
CREATE INDEX idx_neglected_topical_disease_indicators_id ON neglected_topical_disease_indicators(indicator_id);
CREATE INDEX idx_neglected_topical_disease_indicators_2_id ON neglected_topical_disease_indicators_2(indicator_id);
CREATE INDEX idx_ncd_mental_health_indicators_id ON ncd_mental_health_indicators(indicator_id);
CREATE INDEX idx_ncd_health_indicators_status_id ON ncd_health_indicators_status(indicator_id);