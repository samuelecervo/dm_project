SELECT
    r.region_name,
    d.year,
    d.month,
    AVG(c.new_positives) AS avg_new_positives,
    SUM(v.first_dose + v.second_dose + v.booster) AS total_vaccination
FROM dw_layer.fact_covid_cases c
JOIN dw_layer.fact_vaccination v 
    ON c.region_key = v.region_key AND c.date_key = v.date_key
JOIN dw_layer.dimRegion r ON c.region_key = r.regionKey
JOIN dw_layer.dimDate d ON c.date_key = d.dateKey
GROUP BY r.region_name, d.year, d.month
ORDER BY d.year, d.month, r.region_name;
