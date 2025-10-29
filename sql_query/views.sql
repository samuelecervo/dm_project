CREATE OR REPLACE VIEW dw_layer.vw_daily_swabs AS
SELECT
    date_key,
    region_key,
    swabs AS swabs_daily
FROM dw_layer.fact_covid_cases;


CREATE OR REPLACE VIEW dw_layer.vw_first_dose_daily AS
SELECT
    date_key,
    region_key,
    age_key,
    first_dose
FROM dw_layer.fact_vaccination;

CREATE OR REPLACE VIEW dw_layer.vw_vaccination_cumulative AS
SELECT
    date_key,
    region_key,
    age_key,
    SUM(first_dose) OVER (PARTITION BY region_key, age_key ORDER BY date_key) AS cumulative_first_dose
FROM dw_layer.fact_vaccination;


CREATE OR REPLACE VIEW dw_layer.vw_covid_monthly AS
SELECT
    EXTRACT(YEAR FROM date_key) AS year,
    EXTRACT(MONTH FROM date_key) AS month,
    region_key,
    SUM(new_positives) AS monthly_new_cases,
    SUM(hospitalized) AS monthly_hospitalized
FROM dw_layer.fact_covid_cases
GROUP BY EXTRACT(YEAR FROM date_key), EXTRACT(MONTH FROM date_key), region_key;
