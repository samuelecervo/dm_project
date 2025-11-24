-- =========================================================
-- RECONCILED LAYER 
-- =========================================================
BEGIN;

DROP SCHEMA IF EXISTS reconciled_layer CASCADE;
CREATE SCHEMA IF NOT EXISTS reconciled_layer;

-- COVID CASES
CREATE TABLE reconciled_layer.covid_cases (
    date DATE,
    region_code TEXT,
    hospitalized INTEGER,
    new_positives INTEGER,
    deceased INTEGER,
    swabs INTEGER
);

-- ITALIAN VACCINATION
CREATE TABLE reconciled_layer.italian_vaccination (
    date DATE,
    supplier TEXT,
    region_code TEXT,
    age_group TEXT,
    males INTEGER,
    females INTEGER,
    first_dose INTEGER,
    second_dose INTEGER,
    additional_booster_dose INTEGER,
    second_booster INTEGER,
    db3 INTEGER
);


-- REGIONS ISTAT
CREATE TABLE reconciled_layer.regions_istat (
    region_code TEXT,
    region_name TEXT,
    region_abbr TEXT
);

-- POPULATION
CREATE TABLE reconciled_layer.population (
    year INTEGER,
    region_code TEXT,
    region_name TEXT,
    age_group TEXT,
    male_count INTEGER,
    female_count INTEGER,
    total_count INTEGER
);


-- VACCINES
CREATE TABLE reconciled_layer.vaccines (
    vaccine_key TEXT,
    vaccine_name TEXT,
    supplier TEXT,
    technology TEXT
);

-- =========================================================
-- DATA LOADING
-- =========================================================

\copy reconciled_layer.covid_cases FROM 'data_staging/dcp_regions_clean.csv' DELIMITER ',' CSV HEADER;
\copy reconciled_layer.italian_vaccination FROM 'data_staging/italian_vaccination_clean.csv' DELIMITER ',' CSV HEADER;
\copy reconciled_layer.regions_istat FROM 'data_staging/istat_regions_clean.csv' DELIMITER ',' CSV HEADER;
\copy reconciled_layer.population FROM 'data_staging/popolazione_istat_clean.csv' DELIMITER ',' CSV HEADER;
\copy reconciled_layer.vaccines FROM 'data_staging/vaccines_clean.csv' DELIMITER ',' CSV HEADER;

COMMIT;
