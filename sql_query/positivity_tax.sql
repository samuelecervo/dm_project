
WITH tamponi_giornalieri AS (
    SELECT 
        date_key,
        region_key,
        swabs AS tamponi_cumulativi,
        LAG(swabs) OVER (PARTITION BY region_key ORDER BY date_key) AS tamponi_precedenti,
        COALESCE(swabs - LAG(swabs) OVER (PARTITION BY region_key ORDER BY date_key), swabs) AS tamponi_giornalieri
    FROM dw_layer.fact_covid_cases
)
SELECT 
    dr.region_name,
    dd.year,
    dd.month,
    SUM(fcc.new_positives) AS nuovi_positivi,
    SUM(fcc.hospitalized) AS ospedalizzati,
    SUM(fcc.deceased) AS deceduti,
    SUM(tg.tamponi_giornalieri) AS tamponi_totali,
    ROUND((SUM(fcc.new_positives) * 100.0 / NULLIF(SUM(tg.tamponi_giornalieri), 0)), 2) AS tasso_positivita
FROM dw_layer.fact_covid_cases fcc
JOIN tamponi_giornalieri tg ON fcc.date_key = tg.date_key AND fcc.region_key = tg.region_key
JOIN dw_layer.dimRegion dr ON fcc.region_key = dr.regionKey
JOIN dw_layer.dimDate dd ON fcc.date_key = dd.dateKey
WHERE dd.year BETWEEN 2021 AND 2023
GROUP BY 
    dr.region_name, 
    dd.year, 
    dd.month
ORDER BY 
    year, month, region_name;