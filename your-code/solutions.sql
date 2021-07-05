-- Challenge 1
USE publications;
CREATE TEMPORARY TABLE sales_royalty
SELECT 
ti.title_id as 'TITLE_ID',
au.au_ID as 'AUTHOR_ID',
(ti.price * sale.qty * ti.royalty / 100 * ta.royaltyper / 100) AS 'Royalty'
FROM authors as au
LEFT JOIN titleauthor AS ta ON ta.au_id = au.au_id
INNER JOIN titles as ti ON ti.title_id = ta.title_id
INNER JOIN sales as sale ON sale.title_id = ti.title_id
GROUP BY au.au_id
ORDER BY Royalty DESC;


-- Challenge 2
CREATE TEMPORARY TABLE TOTAL
SELECT 
TITLE_ID,
AUTHOR_ID,
SUM(Royalty) AS 'TOTAL_ROYALTY'
FROM sales_royalty
GROUP BY TITLE_ID, AUTHOR_ID
ORDER BY TOTAL_ROYALTY DESC;

-- Challenge 3

SELECT 
au.au_ID as 'AUTHOR_ID',
SUM(ti.price * sale.qty * ti.royalty / 100 * ta.royaltyper / 100)+ti.advance AS 'PROFITS'
FROM authors as au
LEFT JOIN titleauthor AS ta ON ta.au_id = au.au_id
INNER JOIN titles as ti ON ti.title_id = ta.title_id
INNER JOIN sales as sale ON sale.title_id = ti.title_id
GROUP BY au.au_id
ORDER BY Royalty DESC;

CREATE TABLE most_profiting_authors
SELECT TOTAL.AUTHOR_ID,(TOTAL_ROYALTY + ti.advance) AS 'PROFITS'
FROM TOTAL
LEFT JOIN titles as ti ON TOTAL.TITLE_ID = ti.title_id;

SELECT * FROM most_profiting_authors;

DROP TABLE most_profiting_authors;




-- DROP TABLE sales_royalty;