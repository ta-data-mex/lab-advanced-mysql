SELECT Title, Author, (Royals + Advances) As PROFIT FROM (
	SELECT Title, Author, SUM(Royals) As Royals, SUM(Advances) As Advances
		FROM (
			SELECT ti.title_id as Title, ta.au_id as Author, (ti.price * sales.qty * ti.royalty / 100 * ta.royaltyper / 100) AS Royals, (ti.advance/(ta.royaltyper/100)) AS Advances
			FROM publications.titles ti
			JOIN publications.titleauthor ta
			ON ti.title_id = ta.title_id
			JOIN publications.sales sales
			ON ti.title_id = sales.title_id) summary
		GROUP BY Title) summary
GROUP BY Author
ORDER BY PROFIT DESC
LIMIT 3;


CREATE TEMPORARY TABLE publications.authors_profits_step_1
SELECT ti.title_id as Title, ta.au_id as Author, (ti.price * sales.qty * ti.royalty / 100 * ta.royaltyper / 100) AS Royals, (ti.advance/(ta.royaltyper/100)) AS Advances
FROM publications.titles ti
JOIN publications.titleauthor ta
ON ti.title_id = ta.title_id
JOIN publications.sales sales
ON ti.title_id = sales.title_id;

CREATE TEMPORARY TABLE publications.authors_profits_step_2
SELECT Title, Author, SUM(Royals) As Royals, SUM(Advances) As Advances
FROM publications.authors_profits_step_1
GROUP BY Title;

CREATE TEMPORARY TABLE publications.authors_profits_step_3
SELECT Title, Author, (Royals + Advances) As PROFIT 
FROM publications.authors_profits_step_2
GROUP BY Author
ORDER BY PROFIT DESC
LIMIT 3;

SELECT * FROM publications.authors_profits_step_3;

CREATE TABLE publications.most_profiting_authors
SELECT Author as au_id, PROFIT as profits FROM publications.authors_profits_step_3;
