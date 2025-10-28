BEGIN;

DROP SCHEMA IF EXISTS dw_layer CASCADE;
CREATE SCHEMA IF NOT EXISTS dw_layer;

-- =========================================================
-- DIMENSION
-- =========================================================

-- dimDate
CREATE TABLE dw_layer.dimDate AS
SELECT DISTINCT 
    date AS dateKey,
    date,
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    EXTRACT(DAY FROM date) AS day
FROM reconciled_layer.italian_vaccination
UNION
SELECT DISTINCT
    date AS dateKey,
    date,
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    EXTRACT(DAY FROM date) AS day
FROM reconciled_layer.covid_cases;

-- dimRegion
CREATE TABLE dw_layer.dimRegion AS
SELECT DISTINCT
    region_code AS regionKey,
    region_name,
    region_abbr
FROM reconciled_layer.regions_istat;

-- dimAgeRange
CREATE TABLE dw_layer.dimAgeRange AS
SELECT DISTINCT
    age_group AS age_key,
    age_group
FROM reconciled_layer.italian_vaccination;

-- dimVaccine
CREATE TABLE dw_layer.dimVaccine AS
SELECT DISTINCT
    vaccine_key,
    vaccine_name,
    supplier,
    technology
FROM reconciled_layer.vaccines;

-- =========================================================
-- FACT
-- =========================================================

-- fact_vaccination
CREATE TABLE dw_layer.fact_vaccination AS
SELECT
    date AS date_key,
    supplier as vaccine_key,
    region_code AS region_key,
    age_group AS age_key,
    SUM(first_dose) AS first_dose,
    SUM(second_dose) AS second_dose,
    SUM(additional_booster_dose) AS booster,
    SUM(males) AS males,
    SUM(females) AS females
FROM reconciled_layer.italian_vaccination
GROUP BY date, supplier, region_code, age_group;

-- fact_covid_cases
CREATE TABLE dw_layer.fact_covid_cases AS
SELECT
    date AS date_key,
    region_code AS region_key,
    SUM(new_positives) AS new_positives,
    SUM(hospitalized) AS hospitalized,
    SUM(deceased) AS deceased,
    MAX(swabs) AS swabs 
FROM reconciled_layer.covid_cases
GROUP BY date, region_code;

-- fact_population
CREATE TABLE dw_layer.fact_population AS
SELECT
    year,
    region_code AS region_key,
    age_group AS age_key,
    SUM(male_count) AS male_count,
    SUM(female_count) AS female_count,
    SUM(total_count) AS total_count
FROM reconciled_layer.population
GROUP BY year, region_code, age_group;


COMMIT;
