
/*Challenge 1*/

/*Step 1*/

SELECT tia.au_id, tia.title_id, tit.price * sls.qty * tit.royalty / 100 * tia.royaltyper / 100 AS "Sales Royalty"
FROM publications.titleauthor tia
LEFT JOIN publications.titles tit
ON tia.title_id = tit.title_id
LEFT JOIN publications.sales sls
ON tit.title_id = sls.title_id
ORDER BY tit.price * sls.qty * tit.royalty / 100 * tia.royaltyper / 100 DESC;

/*Step 2*/

SELECT summary.au_id, summary.title_id, SUM(SalesRoyalty) AS Total
FROM (
	SELECT tia.au_id, tia.title_id, tit.price * sls.qty * tit.royalty / 100 * tia.royaltyper / 100 AS SalesRoyalty
	FROM publications.titleauthor tia
	LEFT JOIN publications.titles tit
	ON tia.title_id = tit.title_id
	LEFT JOIN publications.sales sls
	ON tit.title_id = sls.title_id
	ORDER BY tit.price * sls.qty * tit.royalty / 100 * tia.royaltyper / 100 DESC
) summary
GROUP BY summary.au_id, summary.title_id
ORDER BY Total DESC;

/*Step 3*/


SELECT step2.au_id, SUM(step2.Total + tit2.advance) AS TOTALROY
FROM (
	SELECT summary.au_id, summary.title_id, SUM(SalesRoyalty) AS Total
	FROM (
		SELECT tia.au_id, tia.title_id, tit.price * sls.qty * tit.royalty / 100 * tia.royaltyper / 100 AS SalesRoyalty
		FROM publications.titleauthor tia
		LEFT JOIN publications.titles tit
		ON tia.title_id = tit.title_id
		LEFT JOIN publications.sales sls
		ON tit.title_id = sls.title_id
		ORDER BY tit.price * sls.qty * tit.royalty / 100 * tia.royaltyper / 100 DESC
	) summary
	GROUP BY summary.au_id, summary.title_id
	ORDER BY Total DESC
) step2
INNER JOIN publications.titles tit2
ON step2.title_id = tit2.title_id
GROUP BY step2.au_id
ORDER BY TOTALROY DESC;


/*Challenge 2*/
CREATE TEMPORARY TABLE publications.profits
SELECT tia.au_id, tia.title_id, tit.price * sls.qty * tit.royalty / 100 * tia.royaltyper / 100 AS SalesRoyalty
FROM publications.titleauthor tia
LEFT JOIN publications.titles tit
ON tia.title_id = tit.title_id
LEFT JOIN publications.sales sls
ON tit.title_id = sls.title_id
ORDER BY tit.price * sls.qty * tit.royalty / 100 * tia.royaltyper / 100 DESC;

SELECT * FROM publications.profits;

CREATE TEMPORARY TABLE publications.sumaprofits1
SELECT tia.au_id, tia.title_id, SUM(pro.SalesRoyalty) AS SumROyalty
FROM publications.titleauthor tia
LEFT JOIN publications.profits pro
ON tia.title_id = pro.title_id
GROUP BY tia.au_id, tia.title_id
ORDER BY SumROyalty DESC;

SELECT * FROM publications.sumaprofits1;

CREATE TEMPORARY TABLE publications.TotalRoy
SELECT sup.au_id, sup.title_id, SUM(sup.SumROyalty + tit.advance) AS TotalRoyalty
FROM publications.sumaprofits1 sup
LEFT JOIN publications.titles tit
ON sup.title_id = tit.title_id
GROUP BY sup.au_id, sup.title_id
ORDER BY TotalRoyalty DESC;

SELECT * FROM publications.TotalRoy;


/*Challenge 3*/

CREATE TABLE publications.most_profiting_authors
SELECT TotalRoy.au_id AS Author_ID, TotalRoy.TotalRoyalty AS Profit
FROM publications.TotalRoy
ORDER BY Profit DESC
LIMIT 3;

SELECT * FROM publications.most_profiting_authors;


