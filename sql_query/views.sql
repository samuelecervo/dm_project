
CREATE OR REPLACE VIEW dw_layer.vw_vaccination_cumulative AS
SELECT
    date_key,
    region_key,
    age_key,
    SUM(first_dose) OVER (PARTITION BY region_key, age_key ORDER BY date_key) AS cumulative_first_dose
FROM dw_layer.fact_vaccination;


CREATE OR REPLACE VIEW dw_layer.vw_covid_monthly AS
SELECT
    d.year,d.month,fc.region_key,
    SUM(fc.new_positives) AS monthly_new_cases,
    SUM(fc.hospitalized) AS monthly_hospitalized
FROM dw_layer.fact_covid_cases fc
JOIN dw_layer.dimDate d
    ON fc.date_key = d.datekey
GROUP BY d.year, d.month, fc.region_key;
