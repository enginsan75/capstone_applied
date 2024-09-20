DROP TABLE db_2019_2022.report_segment;
CREATE TABLE db_2019_2022.report_segment AS
SELECT report.SEGMENT,
SUM(CASE WHEN report.YIL='2021' AND report.IHRITH='H' THEN 1
else 0
end) as 2021_IHR_DEGER,
SUM(CASE WHEN report.YIL='2021' AND report.IHRITH='T' THEN 1
else 0
end) as 2021_ITH_DEGER,
SUM(CASE WHEN report.YIL='2022' AND report.IHRITH='H' THEN 1
else 0
end) as 2022_IHR_DEGER,
SUM(CASE WHEN report.YIL='2022' AND report.IHRITH='T' THEN 1
else 0
end) as 2022_ITH_DEGER
FROM(SELECT SEGMENT, YIL, IHRITH, SUM_OF_DOLAR AS "DEĞER" FROM db_2019_2022.dt_maib_son dms  
WHERE YIL IN (2021, 2022)
AND AY BETWEEN 1 AND 7 AND KOD IS NOT NULL) report
GROUP BY SEGMENT;

CREATE TABLE db_2019_2022.report_ulke_ihracat AS
SELECT s.ulke_adi, s.DEĞER AS 2021_DEĞER, p.DEĞER AS 2022_DEĞER
FROM (SELECT ulke_adi, SUM(SUM_OF_DOLAR/1000000) AS "DEĞER" FROM db_2019_2022.dt_maib_son WHERE YIL='2021' 
AND IHRITH ='H' AND AY BETWEEN 1 AND 7 AND KOD IS NOT NULL
GROUP BY ulke_adi 
ORDER BY SUM(SUM_OF_DOLAR) DESC
LIMIT 10) s,
(SELECT ulke_adi AS ulke_adi2, SUM(SUM_OF_DOLAR/1000000) AS "DEĞER" FROM db_2019_2022.dt_maib_son 
WHERE YIL='2022' 
AND IHRITH ='H' AND AY BETWEEN 1 AND 7 AND KOD IS NOT NULL 
GROUP BY ulke_adi
ORDER BY SUM(SUM_OF_DOLAR) DESC
LIMIT 10) p
WHERE s.ulke_adi=p.ulke_adi2;


CREATE TABLE db_2019_2022.report_ulke_ithalat AS
SELECT s.ulke_adi, s.DEĞER AS 2021_DEĞER, p.DEĞER AS 2022_DEĞER
FROM (SELECT ulke_adi, SUM(SUM_OF_DOLAR/1000000) AS "DEĞER" FROM db_2019_2022.dt_maib_son WHERE YIL='2021' 
AND IHRITH ='T' AND AY BETWEEN 1 AND 7 AND KOD IS NOT NULL
GROUP BY ulke_adi 
ORDER BY SUM(SUM_OF_DOLAR) DESC
LIMIT 10) s,
(SELECT ulke_adi AS ulke_adi2, SUM(SUM_OF_DOLAR/1000000) AS "DEĞER" FROM db_2019_2022.dt_maib_son 
WHERE YIL='2022' 
AND IHRITH ='T' AND AY BETWEEN 1 AND 7 AND KOD IS NOT NULL 
GROUP BY ulke_adi
ORDER BY SUM(SUM_OF_DOLAR) DESC
LIMIT 10) p
WHERE s.ulke_adi=p.ulke_adi2;




