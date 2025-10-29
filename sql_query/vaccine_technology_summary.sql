SELECT
    d.year,
    v.technology AS vaccine_technology,
    SUM(fv.first_dose) AS total_vaccinations_cumulative,
    p.total_population,
    ROUND(SUM(fv.first_dose)::numeric / NULLIF(p.total_population,0), 4) * 100 AS pct_vaccinated
FROM dw_layer.fact_vaccination fv
JOIN dw_layer.dimVaccine v
    ON fv.vaccine_key = v.vaccine_name
JOIN dw_layer.dimDate d
    ON fv.date_key = d.dateKey
JOIN (
    SELECT year, SUM(total_count) AS total_population
    FROM dw_layer.fact_population
    GROUP BY year
) p
    ON d.year = p.year
GROUP BY d.year, v.technology, p.total_population
ORDER BY d.year, v.technology;
