WITH vaccination_cumulative AS (
    SELECT
        fv.date_key,
        v.technology AS vaccine_technology,
        SUM(fv.first_dose)
            OVER (PARTITION BY v.technology ORDER BY fv.date_key) AS cumulative_vaccinations
    FROM dw_layer.fact_vaccination fv
    JOIN dw_layer.dimVaccine v
        ON fv.vaccine_key = v.supplier
),
population_per_year AS (
    SELECT
        year,
        SUM(total_count) AS total_population
    FROM dw_layer.fact_population
    GROUP BY year
)
SELECT
    d.year,
    vc.vaccine_technology,
    MAX(vc.cumulative_vaccinations) AS total_vaccinations_cumulative,
    p.total_population,
    ROUND(MAX(vc.cumulative_vaccinations)::numeric / NULLIF(p.total_population,0), 4) * 100 AS pct_vaccinated
FROM vaccination_cumulative vc
JOIN dw_layer.dimDate d
    ON vc.date_key = d.dateKey
JOIN population_per_year p
    ON d.year = p.year
GROUP BY d.year, vc.vaccine_technology, p.total_population
ORDER BY d.year, vc.vaccine_technology;
