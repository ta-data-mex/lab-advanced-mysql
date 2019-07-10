/*Challenge 1*/

SELECT AUTHOR__ID, (ADVANCE_TOTAL + TOTAL_ROYALTIES) AS PROFITS
FROM (
SELECT TITLE_ID, AUTHOR_ID AS AUTHOR__ID, SUM(SALES_ROYALTY) AS TOTAL_ROYALTIES, ADVANCE_TOTAL
FROM (
SELECT titles.title_id AS TITLE_ID, authors.au_id AS AUTHOR_ID, (titles.price * sales.qty*titles.royalty/100*titleauthor.royaltyper/100) AS SALES_ROYALTY, (titles.advance)*(titleauthor.royaltyper/100) AS ADVANCE_TOTAL
FROM publications.authors          
INNER JOIN publications.titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles
ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id
GROUP BY authors.au_id, sales.title_id
) summary
GROUP BY TITLE_ID, AUTHOR_ID
) big_summary
GROUP BY AUTHOR__ID
ORDER BY PROFITS DESC
LIMIT 3;




/*Challenge2*/
DROP TABLE SALES_TABLE;

CREATE TEMPORARY TABLE publications.SALES_TABLE
SELECT titles.title_id AS TITLE_ID, authors.au_id AS AUTHOR_ID, (titles.price * sales.qty*titles.royalty/100*titleauthor.royaltyper/100) AS SALES_ROYALTY, (titles.advance)*(titleauthor.royaltyper/100) AS ADVANCE_TOTAL
FROM publications.authors          
INNER JOIN publications.titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles
ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id
GROUP BY authors.au_id, sales.title_id;

DROP TABLE ROYALTIES_TABLE;

CREATE TEMPORARY TABLE publications.ROYALTIES_TABLE
SELECT TITLE_ID, AUTHOR_ID AS AUTHOR__ID, SUM(SALES_ROYALTY) AS TOTAL_ROYALTIES, ADVANCE_TOTAL
FROM publications.SALES_TABLE
GROUP BY TITLE_ID, AUTHOR_ID;

SELECT AUTHOR__ID, (ADVANCE_TOTAL + TOTAL_ROYALTIES) AS PROFITS
FROM publications.ROYALTIES_TABLE
GROUP BY AUTHOR__ID
ORDER BY PROFITS DESC
LIMIT 3;




/*Challenge3*/
DROP TABLE most_profiting_authors;

CREATE TABLE publications.most_profiting_authors
SELECT au_id, (ADVANCE_TOTAL + TOTAL_ROYALTIES) AS PROFITS
FROM (
SELECT TITLE_ID, AUTHOR_ID AS au_id, SUM(SALES_ROYALTY) AS TOTAL_ROYALTIES, ADVANCE_TOTAL
FROM (
SELECT titles.title_id AS TITLE_ID, authors.au_id AS AUTHOR_ID, (titles.price * sales.qty*titles.royalty/100*titleauthor.royaltyper/100) AS SALES_ROYALTY, (titles.advance)*(titleauthor.royaltyper/100) AS ADVANCE_TOTAL
FROM publications.authors          
INNER JOIN publications.titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles
ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id
GROUP BY authors.au_id, sales.title_id
) summary
GROUP BY TITLE_ID, AUTHOR_ID
) big_summary
GROUP BY au_id
ORDER BY PROFITS DESC
LIMIT 3;

SELECT * FROM publications.most_profiting_authors