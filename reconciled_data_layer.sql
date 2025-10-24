-- =========================================================
-- RECONCILED LAYER - CREATION
-- =========================================================
BEGIN;

DROP SCHEMA IF EXISTS reconciled_layer CASCADE;
CREATE SCHEMA IF NOT EXISTS reconciled_layer;

-- COVID CASES
CREATE TABLE reconciled_layer.covid_cases AS
SELECT
    region_code,
    date,
    new_positive AS new_positives,
    total_hospitalized AS hospedalized,
    deceased,
    swabs
FROM source_layer.covid_cases;

-- ITALIAN VACCINATION
CREATE TABLE reconciled_layer.italian_vaccination AS
SELECT
    date,
    supplier,
    region_code,
    age_group,
    males,
    females,
    first_dose,
    second_dose,
    additional_booster_dose AS booster
FROM source_layer.italian_vaccination;

-- REGIONS ISTAT
CREATE TABLE reconciled_layer.regions_istat AS
SELECT
    region_code,
    region_name,
    region_abbr
FROM source_layer.regions_istat;

-- POPULATION
CREATE TABLE reconciled_layer.population AS
SELECT
  region_code,
  region_name,
  age_group,
  male_count,
  female_count,
  total_count
FROM source_layer.population;

-- VACCINES
CREATE TABLE reconciled_layer.vaccines AS
SELECT
    vaccine_key,
    vaccine_name,
    supplier,
    technology
FROM source_layer.vaccines;

COMMIT;