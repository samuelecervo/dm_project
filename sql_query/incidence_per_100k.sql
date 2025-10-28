SELECT
    EXTRACT(YEAR FROM d.date) AS year,
    EXTRACT(MONTH FROM d.date) AS month,
    r.region_name,
    SUM(fc.new_positives) AS monthly_new_cases,
    SUM(fp.total_count) AS population,
    ROUND(SUM(fc.new_positives)::numeric / SUM(fp.total_count) * 100000, 2) AS incidence_per_100k
FROM dw_layer.fact_covid_cases fc
JOIN dw_layer.dimDate d
    ON fc.date_key = d.dateKey
JOIN dw_layer.dimRegion r
    ON fc.region_key = r.regionKey
JOIN dw_layer.fact_population fp
    ON fc.region_key = fp.region_key
    AND EXTRACT(YEAR FROM fc.date_key) = fp.year
GROUP BY EXTRACT(YEAR FROM d.date), EXTRACT(MONTH FROM d.date), r.region_name
ORDER BY EXTRACT(YEAR FROM d.date), EXTRACT(MONTH FROM d.date), r.region_name;
