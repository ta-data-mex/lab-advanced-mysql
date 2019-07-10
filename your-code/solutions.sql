/*Challege1*/
use publications;
SELECT aut.au_id AS "AUTHOR ID", aut.au_lname AS "LAST NAME", aut.au_fname AS "FIRST NAME", titl.title AS "TITLE", pubs.pub_name AS "PUBLISHER"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON taut.au_id = aut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.publishers pubs
ON titl.pub_id = pubs.pub_id;

/*Challege2*/
SELECT taut.au_id AS "AUTHOR ID", aut.au_lname AS "LAST NAME", aut.au_fname AS "FIRST NAME", pubs.pub_name AS "PUBLISHER", COUNT(titl.title_id) AS "TITLES"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON aut.au_id = taut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.publishers pubs
ON titl.pub_id = pubs.pub_id
GROUP BY pubs.pub_name, taut.au_id, aut.au_fname, aut.au_lname, pubs.pub_name
ORDER BY COUNT(titl.title_id) DESC;

/*Challege3*/
SELECT aut.au_id AS "AUTHOR ID", aut.au_lname AS "LAST NAME", aut.au_fname AS "FIRST NAME", SUM(sales.qty) AS "TOTAL"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON aut.au_id = taut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales
ON sales.title_id = titl.title_id
GROUP BY taut.au_id
ORDER BY SUM(sales.qty) DESC
LIMIT 3;

/*Challege4*/
SELECT aut.au_id AS "AUTHOR ID", aut.au_lname AS "LAST NAME", aut.au_fname AS "FIRST NAME", SUM(IFNULL(sales.qty,0)) AS "TOTAL"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON aut.au_id = taut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales
ON sales.title_id = titl.title_id
GROUP BY taut.au_id
ORDER BY SUM(sales.qty) DESC
LIMIT 23;

/*BONUS*/
SELECT aut.au_id AS "AUTHOR ID", aut.au_lname AS "LAST NAME", aut.au_fname AS "FIRST NAME", SUM(((titl.royalty*titl.price*sales.qty*taut.royaltyper)/100) + (titl.advance*taut.royaltyper/ 100)) AS "PROFIT"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON aut.au_id = taut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales
ON sales.title_id = titl.title_id
GROUP BY taut.au_id
ORDER BY PROFIT DESC
LIMIT 3;

/*Lab Advaced MySql - Challenge 1 - STEP1*/
SELECT aut.au_id AS "AUTHORID", titl.title_id as "TITLEID", sales.ord_num, ((titl.royalty*titl.price*sales.qty)/100)*((taut.royaltyper)/100) AS "Royalty"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON aut.au_id = taut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales
ON sales.title_id = titl.title_id
GROUP BY sales.ord_num
ORDER BY Royalty DESC;

/*Lab Advaced MySql - Challenge 1 - STEP2*/
#CREATE TEMPORARY TABLE publications.royalties_title_author (title_id VARCHAR (100), "Author ID" VARCHAR (100), "Royalty" VARCHAR (100))
SELECT AUTHORID, TITLEID, royalty as AGGREGATED_ROYALTY
FROM (
SELECT aut.au_id AS "AUTHORID", titl.title_id AS "TITLEID", SUM(ifnull(((titl.royalty*titl.price*sales.qty)/100)*((taut.royaltyper)/100),0)) AS "ROYALTY"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON aut.au_id = taut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales
ON sales.title_id = titl.title_id
GROUP BY  titl.title_id
ORDER BY ROYALTY DESC
)summary;

/*Lab Advaced MySql - Challenge 1 - STEP3.1*/
SELECT AUTHORID, PROFIT
FROM (
SELECT aut.au_id AS "AUTHORID", SUM(((titl.royalty*titl.price*sales.qty)/100)*(taut.royaltyper/100) + (titl.advance)) AS "PROFIT"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON aut.au_id = taut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales
ON sales.title_id = titl.title_id
GROUP BY aut.au_id
ORDER BY PROFIT DESC
LIMIT 3
)summary;

/*Lab Advaced MySql - Challenge 1 - STEP3.2*/
SELECT aut.au_id AS "AUTHORID", SUM(((titl.royalty*titl.price*sales.qty)/100)*(taut.royaltyper/100) + (titl.advance)) AS "PROFIT"
FROM publications.authors aut
LEFT JOIN publications.titleauthor taut
ON aut.au_id = taut.au_id
LEFT JOIN publications.titles titl
ON titl.title_id = taut.title_id
LEFT JOIN publications.sales
ON sales.title_id = titl.title_id
GROUP BY taut.au_id
ORDER BY PROFIT DESC
LIMIT 3;

