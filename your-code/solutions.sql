/* Challenge 1 - Step 1 */
SELECT authors.au_id, titles.title_id, (titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100) as sales_royalty, (titles.advance * titleauthor.royaltyper/100) as AggrAdvance
FROM publications.authors
INNER JOIN publications.titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles
ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id;

/* Challenge 1 - Step 2 */
SELECT AuthorIDs, TitleIDs, SUM(sales_royalty) as AggrRoyalty, AggrAdvance
FROM (SELECT authors.au_id as AuthorIDs, titles.title_id as TitleIDs, (titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100) as sales_royalty, (titles.advance * titleauthor.royaltyper/100) as AggrAdvance
FROM publications.authors
INNER JOIN publications.titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles
ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id) summary
GROUP BY AuthorIDs, TitleIDs;

/* Challenge 1 - Step 3 */
SELECT AuthorIDs, AggrRoyalty + AggrAdvance as TotalRoyalties
FROM (SELECT AuthorIDs, TitleIDs, SUM(sales_royalty) as AggrRoyalty, AggrAdvance
FROM (SELECT authors.au_id as AuthorIDs, titles.title_id as TitleIDs, (titles.price * sales.qty * (titles.royalty/100)* (titleauthor.royaltyper/100)) as sales_royalty, (titles.advance * titleauthor.royaltyper/100) as AggrAdvance
FROM publications.authors
INNER JOIN publications.titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles
ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id) summary
GROUP BY AuthorIDs, TitleIDs) big_summary
ORDER BY TotalRoyalties DESC LIMIT 3;

/* Challenge 2 - Create Temporary Tables*/
DROP TABLE step1;

CREATE TEMPORARY TABLE step1
SELECT authors.au_id as AuthorIDs, titles.title_id as TitleIDs, (titles.price * sales.qty * titles.royalty/100 * titleauthor.royaltyper/100) as sales_royalty, (titles.advance * titleauthor.royaltyper/100) as AggrAdvance
FROM publications.authors
INNER JOIN publications.titleauthor
ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles
ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id;

DROP TABLE step2;

CREATE TEMPORARY TABLE step2
SELECT step1.AuthorIDs, step1.TitleIDs, SUM(step1.sales_royalty) as AggrRoyalty, step1.AggrAdvance
FROM publications.step1
GROUP BY AuthorIDs, TitleIDs, AggrAdvance;

/* Challenge 2 - Run Query based on Temporary Table */
SELECT AuthorIDs, AggrRoyalty + AggrAdvance as TotalRoyalties
FROM publications.step2
GROUP BY AuthorIDs, TotalRoyalties
ORDER BY TotalRoyalties DESC LIMIT 3;

/* Challenge 3 - Create Permanent Table for Author Profits */
DROP TABLE author_profits;
CREATE TABLE author_profits
SELECT AuthorIDs, AggrRoyalty + AggrAdvance as TotalRoyalties
FROM publications.step2
GROUP BY AuthorIDs, TotalRoyalties
ORDER BY TotalRoyalties DESC;