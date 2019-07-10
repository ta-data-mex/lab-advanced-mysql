/* CHALLENGE 1 */

/* STEP 1 */

SELECT 
titleauthor.title_id as "Title_ID",
titleauthor.au_id as "Author_ID",
round(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100),2) as "Sales_royalty"
FROM titleauthor
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN sales on titleauthor.title_id = sales.title_id
ORDER BY Sales_royalty DESC;

/* STEP 2 */

SELECT
Title_ID,
Author_ID,
SUM(Sales_royalty) as Aggregated_royalty
FROM(
SELECT 
titleauthor.title_id as Title_ID,
titleauthor.au_id as Author_ID,
round(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100),2) as Sales_royalty
FROM titleauthor
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN sales on titleauthor.title_id = sales.title_id
)summary
GROUP BY Author_ID,Title_ID ORDER BY Aggregated_royalty DESC;

/* STEP 3 */

SELECT 
Author_ID,
round(SUM(Aggregated_royalty) + titles.advance/COUNT(titles.title_id),2) as Profits
FROM(
SELECT
Title_ID,
Author_ID,
SUM(Sales_royalty) as Aggregated_royalty
FROM(
SELECT 
titleauthor.title_id as Title_ID,
titleauthor.au_id as Author_ID,
round(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100),2) as Sales_royalty
FROM titleauthor
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN sales on titleauthor.title_id = sales.title_id
)summary
GROUP BY Author_ID,Title_ID ORDER BY Aggregated_royalty DESC
)summary2
INNER JOIN titles ON summary2.Title_ID = titles.title_id
GROUP BY Author_ID ORDER BY Profits DESC;

/* CHALLENGE 2 */

/* STEP 1 */

CREATE TEMPORARY TABLE publications.Sales_royalty
SELECT 
titleauthor.title_id as "Title_ID",
titleauthor.au_id as "Author_ID",
round(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100),2) as "Sales_royalty"
FROM titleauthor
INNER JOIN titles on titleauthor.title_id = titles.title_id
INNER JOIN sales on titleauthor.title_id = sales.title_id
ORDER BY Sales_royalty DESC;

/* STEP 2 */

CREATE TEMPORARY TABLE publications.Sales_royalty_perbook
SELECT
Title_ID,
Author_ID,
SUM(Sales_royalty) as Aggregated_royalty
FROM publications.Sales_royalty
GROUP BY Author_ID,Title_ID ORDER BY Aggregated_royalty DESC;	

/* STEP 3 */

CREATE TEMPORARY TABLE publications.profits
SELECT 
Author_ID,
round(SUM(Aggregated_royalty) + titles.advance/COUNT(titles.title_id),2) as Profits
FROM publications.Sales_royalty_perbook
INNER JOIN titles ON Sales_royalty_perbook.Title_ID = titles.title_id
GROUP BY Author_ID ORDER BY Profits DESC;

/* CHALLENGE 3 */

CREATE TABLE most_profiting_authors
SELECT
Author_ID,
Profits
FROM publications.profits;