
-- derived measure, join con population per normalizzazione, 
-- roll-up per regione e fascia d’età.

-- View 
CREATE OR REPLACE VIEW dw_layer.vw_total_vaccination AS
SELECT
    region_code AS region_key,
    age_group AS age_key,
    SUM(first_dose + second_dose + booster) AS total_vaccination
FROM dw_layer.fact_vaccination
GROUP BY region_code, age_group;

-- Query 
SELECT
    r.region_name,
    a.age_group,
    v.total_vaccination::FLOAT / p.total_count AS vaccination_rate
FROM dw_layer.vw_total_vaccination v
JOIN dw_layer.fact_population p 
    ON v.region_key = p.region_key AND v.age_key = p.age_key
JOIN dw_layer.dimRegion r ON v.region_key = r.regionKey
JOIN dw_layer.dimAgeRange a ON v.age_key = a.age_key
ORDER BY vaccination_rate DESC;
