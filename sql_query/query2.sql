-- roll-up temporale (dal giorno al mese) e un drill-down 
-- per regione, aggregando le misure della fact table.

SELECT
    r.region_name,
    d.year,
    d.month,
    SUM(c.deceased) AS total_deceased,
    SUM(c.new_positives) AS total_new_positives
FROM dw_layer.fact_covid_cases c
JOIN dw_layer.dimRegion r ON c.region_key = r.regionKey
JOIN dw_layer.dimDate d ON c.date_key = d.dateKey
GROUP BY r.region_name, d.year, d.month
ORDER BY d.year, d.month, r.region_name;
