SELECT
    EXTRACT(YEAR FROM vc.date_key)::INT AS year,
    EXTRACT(MONTH FROM vc.date_key)::INT AS month,
    r.region_name,
    a.age_group,
    MAX(vc.cumulative_first_dose) AS total_vaccinations_cumulative,
    cm.monthly_new_cases AS total_new_positives,
    cm.monthly_hospitalized AS total_hospitalized,
    fp.total_count AS population,
    ROUND(cm.monthly_new_cases::NUMERIC / NULLIF(fp.total_count,0) * 100000, 2) AS incidence_per_100k,
    ROUND(MAX(vc.cumulative_first_dose)::NUMERIC / NULLIF(fp.total_count,0) * 100, 2) AS pct_vaccinated
FROM dw_layer.vw_vaccination_cumulative vc
JOIN dw_layer.vw_covid_monthly cm
    ON cm.region_key = vc.region_key
   AND cm.year = EXTRACT(YEAR FROM vc.date_key)
   AND cm.month = EXTRACT(MONTH FROM vc.date_key)
JOIN dw_layer.dimRegion r
    ON vc.region_key = r.regionKey
JOIN dw_layer.dimAgeRange a
    ON vc.age_key = a.age_key
JOIN dw_layer.fact_population fp
    ON vc.region_key = fp.region_key
   AND vc.age_key = fp.age_key
   AND EXTRACT(YEAR FROM vc.date_key) = fp.year
WHERE r.region_name IN ('Lombardia', 'Lazio')
  AND EXTRACT(YEAR FROM vc.date_key) BETWEEN 2021 AND 2023
GROUP BY
    EXTRACT(YEAR FROM vc.date_key),
    EXTRACT(MONTH FROM vc.date_key),
    r.region_name,
    a.age_group,
    cm.monthly_new_cases,
    cm.monthly_hospitalized,
    fp.total_count
ORDER BY
    year,
    month,
    r.region_name,
    a.age_group;
