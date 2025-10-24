-- =========================================================
--  SOURCE LAYER
-- =========================================================
BEGIN;

DROP SCHEMA IF EXISTS source_layer CASCADE;
CREATE SCHEMA IF NOT EXISTS source_layer;

-- COVID CASES
CREATE TABLE source_layer.covid_cases (
  date date,
  country_code text,
  region_code text,
  region_name text,
  latitude double precision,
  longitude double precision,
  hospitalized_with_symptoms int,
  intensive_care int,
  total_hospitalized int,
  home_isolation int,
  total_positive int,
  variation_total_positive int,
  new_positive int,
  recovered int,
  deceased int,
  suspected_cases int,
  screening_cases int,
  total_cases int,
  swabs int,
  tested_cases int,
  notes text,
  intensive_care_admissions int,
  test_notes text,
  case_notes text,
  positive_molecular_test int,
  positive_rapid_antigen_test int,
  molecular_swabs int,
  rapid_antigen_swabs int,
  nuts_1_code text,
  nuts_2_code text
);

-- ITALIAN VACCINATION
CREATE TABLE source_layer.italian_vaccination (
  date date,
  supplier text,
  region_abbr text,
  age_range text,
  males int,
  females int,
  first_dose int,
  second_dose int,
  previous_infection int,
  additional_booster_dose int,
  second_booster int,
  db3 int,
  nuts_1_code text,
  nuts_2_code text,
  region_code text,
  region_name text,
  age_group text
);

-- ISTAT REGIONS
CREATE TABLE source_layer.regions_istat (
  region_code text,
  region_name text,
  region_abbr text
);

-- POPULATION
CREATE TABLE source_layer.population (
  region_code text,
  nuts_1_code text,
  nuts_1_desc text,
  nuts_2_code text,
  region_name text,
  region_abbr text,
  latitude double precision,
  longitude double precision,
  age_range text,
  male_count int,
  female_count int,
  total_count int,
  age_group text
);

-- VACCINES
CREATE TABLE source_layer.vaccines (
  vaccine_key text,
  vaccine_name text,
  supplier text,
  technology text
);

-- =========================================================
-- DATA LOADING
-- =========================================================

\copy source_layer.covid_cases FROM 'data-clean/dcp_regions_clean.csv' DELIMITER ',' CSV HEADER;

\copy source_layer.italian_vaccination FROM 'data-clean/italian_vaccination_clean.csv' DELIMITER ',' CSV HEADER;

\copy source_layer.regions_istat FROM 'data-clean/istat_regions.csv' DELIMITER ',' CSV HEADER;

\copy source_layer.population FROM 'data-clean/popolazione_istat_clean.csv' DELIMITER ',' CSV HEADER;

\copy source_layer.vaccines FROM 'data-clean/vaccines_clean.csv' DELIMITER ',' CSV HEADER;


COMMIT;