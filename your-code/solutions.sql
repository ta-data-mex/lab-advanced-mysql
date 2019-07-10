/*Challenge 1*/

/*PASO 1*/

SELECT ta.au_id, ta.title_id, titl.price * sls.qty * titl.royalty / 100 * ta.royaltyper / 100 AS "Sales Royalty"
FROM publications.titleauthor ta
LEFT JOIN publications.titles titl
ON ta.title_id = titl.title_id
LEFT JOIN publications.sales sls
ON titl.title_id = sls.title_id
ORDER BY titl.price * sls.qty * titl.royalty / 100 * ta.royaltyper / 100 DESC;

/*Step 2*/

SELECT summary.au_id, summary.title_id, SUM(SalesRoyalty) AS Total
FROM (
	SELECT ta.au_id, ta.title_id, titl.price * sls.qty * titl.royalty / 100 * ta.royaltyper / 100 AS SalesRoyalty
	FROM publications.titleauthor ta
	LEFT JOIN publications.titles titl
	ON ta.title_id = titl.title_id
	LEFT JOIN publications.sales sls
	ON titl.title_id = sls.title_id
	ORDER BY titl.price * sls.qty * titl.royalty / 100 * ta.royaltyper / 100 DESC
) summary
GROUP BY summary.au_id, summary.title_id
ORDER BY Total DESC;

/*Step 3*/


SELECT step2.au_id, SUM(step2.Total + titl2.advance) AS TOTALROY
FROM (
	SELECT summary.au_id, summary.title_id, SUM(SalesRoyalty) AS Total
	FROM (
		SELECT ta.au_id, ta.title_id, titl.price * sls.qty * titl.royalty / 100 * ta.royaltyper / 100 AS SalesRoyalty
		FROM publications.titleauthor ta
		LEFT JOIN publications.titles titl
		ON ta.title_id = titl.title_id
		LEFT JOIN publications.sales sls
		ON titl.title_id = sls.title_id
		ORDER BY titl.price * sls.qty * titl.royalty / 100 * ta.royaltyper / 100 DESC
	) summary
	GROUP BY summary.au_id, summary.title_id
	ORDER BY Total DESC
) step2
INNER JOIN publications.titles titl2
ON step2.title_id = titl2.title_id
GROUP BY step2.au_id
ORDER BY TOTALROY DESC;


/*Challenge 2*/
CREATE TEMPORARY TABLE publications.profits
SELECT ta.au_id, ta.title_id, titl.price * sls.qty * titl.royalty / 100 * ta.royaltyper / 100 AS SalesRoyalty
FROM publications.titleauthor ta
LEFT JOIN publications.titles titl
ON ta.title_id = titl.title_id
LEFT JOIN publications.sales sls
ON titl.title_id = sls.title_id
ORDER BY titl.price * sls.qty * titl.royalty / 100 * ta.royaltyper / 100 DESC;

SELECT * FROM publications.profits;

CREATE TEMPORARY TABLE publications.sumaprofits1
SELECT ta.au_id, ta.title_id, SUM(pro.SalesRoyalty) AS SumRoyal
FROM publications.titleauthor ta
LEFT JOIN publications.profits pro
ON ta.title_id = pro.title_id
GROUP BY ta.au_id, ta.title_id
ORDER BY SumRoyal DESC;

SELECT * FROM publications.sumaprofits1;

CREATE TEMPORARY TABLE publications.TotalRoy
SELECT sup.au_id, sup.title_id, SUM(sup.SumROyalty + tit.advance) AS TotalRoyalty
FROM publications.sumaprofits1 sup
LEFT JOIN publications.titles titl
ON sup.title_id = titl.title_id
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

