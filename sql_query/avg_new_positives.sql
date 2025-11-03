SELECT r.region_name,
       d.year,
       d.month, 
       AVG(c.new_positives) AS avg_new_positives,
       MAX(vc.cumulative_first_Dose) AS vaccination
FROM dw_layer.fact_covid_cases c
JOIN dw_layer.vw_vaccination_cumulative vc
    ON c.region_key = vc.region_key AND c.date_key = vc.date_key
JOIN dw_layer.dimRegion r
    ON c.region_key = r.regionKey
JOIN dw_layer.dimDate d
    ON c.date_key = d.dateKey
GROUP BY r.region_name, d.year, d.month
ORDER BY d.year, d.month, r.region_name;