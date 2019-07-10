#CHALLENGE 1
#1.1

SELECT taut.au_id AS "AUTHORID", taut.title_id AS "TITLEID", (titl.price * sls.qty * (titl.royalty / 100) * (taut.royaltyper / 100)) AS "SALES_ROYALTY"
FROM publications.titleauthor taut
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales sls
ON sls.title_id = titl.title_id
ORDER BY SALES_ROYALTY DESC;

#1.2

SELECT AUTHORID, TITLEID, SUM(SALES_ROYALTY) AS AGGREGATED_ROYALTY
FROM(
SELECT taut.au_id AS "AUTHORID", taut.title_id AS "TITLEID", (titl.price * sls.qty * (titl.royalty / 100) * (taut.royaltyper / 100)) AS "SALES_ROYALTY"
FROM publications.titleauthor taut
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales sls
ON sls.title_id = titl.title_id
)summary 
GROUP BY TITLEID , AUTHORID
ORDER BY AGGREGATED_ROYALTY DESC;

#1.3

SELECT AUTHORID, AGGREGATED_ROYALTY + ADVANCE_ROYALTY AS FINAL_ROYALTY
FROM(
SELECT AUTHORID, TITLEID, ADVANCE_ROYALTY, SUM(SALES_ROYALTY) AS AGGREGATED_ROYALTY
FROM(
SELECT taut.au_id AS "AUTHORID", taut.title_id AS "TITLEID", (titl.price * sls.qty * (titl.royalty / 100) * (taut.royaltyper / 100)) AS "SALES_ROYALTY", (titl.advance* (taut.royaltyper / 100)) AS "ADVANCE_ROYALTY"
FROM publications.titleauthor taut
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales sls
ON sls.title_id = titl.title_id
)summary
GROUP BY TITLEID , AUTHORID
)summary 
ORDER BY FINAL_ROYALTY DESC LIMIT 3;

#CHALLENGE 2

CREATE TEMPORARY TABLE publications.royalties_individual_sales
SELECT taut.au_id AS "AUTHORID", taut.title_id AS "TITLEID", (titl.price * sls.qty * (titl.royalty / 100) * (taut.royaltyper / 100)) AS "SALES_ROYALTY", (titl.advance* (taut.royaltyper / 100)) AS "ADVANCE_ROYALTY"
FROM publications.titleauthor taut
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales sls
ON sls.title_id = titl.title_id;

CREATE TEMPORARY TABLE publications.royalties_aggregated_sales
SELECT AUTHORID, TITLEID, ADVANCE_ROYALTY, SUM(SALES_ROYALTY) AS AGGREGATED_ROYALTY
FROM  publications.royalties_individual_sales
GROUP BY TITLEID , AUTHORID, ADVANCE_ROYALTY;

CREATE TEMPORARY TABLE publications.royalties_total_sales
SELECT AUTHORID, AGGREGATED_ROYALTY + ADVANCE_ROYALTY AS FINAL_ROYALTY
FROM publications.royalties_aggregated_sales
GROUP BY AUTHORID, FINAL_ROYALTY;

#CHALLENGE 3

CREATE TABLE publications.most_profiting_author
SELECT AUTHORID, FINAL_ROYALTY
FROM publications.royalties_total_sales
GROUP BY AUTHORID, FINAL_ROYALTY;

SELECT * FROM publications.most_profiting_author
