SELECT 
    d.year,r.region_name,a.age_group,
    MAX(vc.cumulative_first_dose) AS total_vaccinations, 
    fp.total_count AS population,
    ROUND(MAX(vc.cumulative_first_dose)::NUMERIC / fp.total_count * 100, 2) AS vaccination_rate_percent
FROM dw_layer.vw_vaccination_cumulative vc
JOIN dw_layer.dimDate d
    ON vc.date_key = d.date_key
JOIN dw_layer.fact_population fp
    ON vc.region_key = fp.region_key
   AND vc.age_key = fp.age_key
   AND d.year = fp.year
JOIN dw_layer.dimRegion r
    ON vc.region_key = r.regionKey
JOIN dw_layer.dimAgeRange a
    ON vc.age_key = a.age_key
GROUP BY d.year,r.region_name,a.age_group,fp.total_count
ORDER BY d.year,r.region_name,a.age_group;
