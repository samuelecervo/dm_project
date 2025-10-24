-- aggregation ROLAP per dimensione regione, 
-- misura media dei nuovi positivi.

SELECT
    r.region_name,
    AVG(c.new_positives) AS avg_new_positives
FROM dw_layer.fact_covid_cases c
JOIN dw_layer.dimRegion r ON c.region_key = r.regionKey
GROUP BY r.region_name
ORDER BY avg_new_positives DESC;