SELECT
    r.region_name,
    v.age_key AS age_group,
    SUM(fv.first_dose) AS total_first_dose,
    SUM(fv.second_dose) AS total_second_dose,
    SUM(fv.booster) AS total_booster,
    fp.total_count AS population_2024,
    ROUND(SUM(fv.first_dose)::numeric / NULLIF(fp.total_count,0) * 100, 2) AS pct_first_dose,
    ROUND(SUM(fv.second_dose)::numeric / NULLIF(fp.total_count,0) * 100, 2) AS pct_second_dose,
    ROUND(SUM(fv.booster)::numeric / NULLIF(fp.total_count,0) * 100, 2) AS pct_booster
FROM dw_layer.fact_vaccination fv
JOIN dw_layer.dimRegion r ON fv.region_key = r.regionKey
JOIN dw_layer.dimAgeRange v ON fv.age_key = v.age_key
LEFT JOIN dw_layer.fact_population fp 
       ON fv.region_key = fp.region_key
      AND fv.age_key = fp.age_key
      AND fp.year = 2024
GROUP BY r.region_name, v.age_key, fp.total_count
ORDER BY r.region_name, v.age_key;
