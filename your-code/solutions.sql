# CHALLENGE 1
# ---------------------------------------------------------------------------------------------------------------------------------------------
USE publications;
# ---------------------------------------------------------------------------------------------------------------------------------------------
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
# ---------------------------------------------------------------------------------------------------------------------------------------------
# MAIN QUERY
SELECT sub_query_2.author_id AS author_id, sub_query_2.profits AS profits
FROM
# SUBQUERY 2
	(SELECT sub_query_1.title AS title, sub_query_1.author_id AS author_id, SUM(sub_query_1.sales_royalty) AS profits
	FROM
    # SUBQUERY 1
		(SELECT ti_au.title_id AS title, au.au_id AS author_id, 
		(ti.price * sa.qty * ti.royalty / 100 * ti_au.royaltyper / 100) AS sales_royalty
		FROM authors AS au
		LEFT JOIN publications.titleauthor AS ti_au ON au.au_id = ti_au.au_id
		LEFT JOIN publications.titles AS ti ON ti_au.title_id = ti.title_id
		LEFT JOIN publications.sales AS sa ON ti.title_id = sa.title_id
		) AS sub_query_1
	GROUP BY title, author_id
    ) AS sub_query_2
GROUP BY author_id
ORDER BY profits DESC 
LIMIT 3;
# ---------------------------------------------------------------------------------------------------------------------------------------------
# CHALLENGE 2
# ---------------------------------------------------------------------------------------------------------------------------------------------
USE publications;
# ---------------------------------------------------------------------------------------------------------------------------------------------
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
# ---------------------------------------------------------------------------------------------------------------------------------------------
CREATE TEMPORARY TABLE publications.most_profiting_authors_1
SELECT ti_au.title_id AS title, au.au_id AS author_id, 
(ti.price * sa.qty * ti.royalty / 100 * ti_au.royaltyper / 100) AS sales_royalty
FROM publications.authors AS au
LEFT JOIN publications.titleauthor AS ti_au ON au.au_id = ti_au.au_id
LEFT JOIN publications.titles AS ti ON ti_au.title_id = ti.title_id
LEFT JOIN publications.sales AS sa ON ti.title_id = sa.title_id;
# ---------------------------------------------------------------------------------------------------------------------------------------------
CREATE TEMPORARY TABLE publications.most_profiting_authors_2
SELECT title, author_id, SUM(most_profiting_authors_1.sales_royalty) AS profits
FROM publications.most_profiting_authors_1
GROUP BY title, author_id;
# ---------------------------------------------------------------------------------------------------------------------------------------------
CREATE TEMPORARY TABLE publications.most_profiting_authors_3
SELECT author_id, profits
FROM publications.most_profiting_authors_2
GROUP BY author_id
ORDER BY profits DESC 
LIMIT 3;
# ---------------------------------------------------------------------------------------------------------------------------------------------
# CHALLENGE 3
# ---------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE publications.most_profiting_authors
SELECT sub_query_2.author_id AS author_id, sub_query_2.profits AS profits
FROM
# SUBQUERY 2
	(SELECT sub_query_1.title AS title, sub_query_1.author_id AS author_id, SUM(sub_query_1.sales_royalty) AS profits
	FROM
    # SUBQUERY 1
		(SELECT ti_au.title_id AS title, au.au_id AS author_id, 
		(ti.price * sa.qty * ti.royalty / 100 * ti_au.royaltyper / 100) AS sales_royalty
		FROM authors AS au
		LEFT JOIN publications.titleauthor AS ti_au ON au.au_id = ti_au.au_id
		LEFT JOIN publications.titles AS ti ON ti_au.title_id = ti.title_id
		LEFT JOIN publications.sales AS sa ON ti.title_id = sa.title_id
		) AS sub_query_1
	GROUP BY title, author_id
    ) AS sub_query_2
GROUP BY author_id
ORDER BY profits DESC 
LIMIT 3;