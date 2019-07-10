/*Challenge 1 - Most Profiting Authors*/

/*STEP 1: Calculate the royalties of each sales for each author*/
CREATE TEMPORARY TABLE C1_S1
SELECT titles.title_id AS 'TITLE_ID', authors.au_id AS 'AUTHOR_ID',
titles.price * sales.qty * (titles.royalty / 100) * (titleauthor.royaltyper / 100) AS 'SALES_ROYALTY'
FROM authors INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN sales ON sales.title_id = titles.title_id;

/*STEP 2: Aggregate the total royalties for each title for each author*/
CREATE TEMPORARY TABLE C1_S2
SELECT `TITLE_ID`, `AUTHOR_ID`, SUM(`SALES_ROYALTY`) AS `SALES_ROYALTY`
FROM C1_S1
GROUP BY `TITLE_ID`,`AUTHOR_ID`;

/*STEP 3: Calculate the total profits of each author*/
CREATE TEMPORARY TABLE C1_S3
SELECT `AUTHOR_ID`, `SALES_ROYALTY` + titles.advance * (titleauthor.royaltyper / 100) AS `SALES_ROYALTY`
FROM C1_S2 INNER JOIN titles ON C1_S2.TITLE_ID = titles.title_id
JOIN titleauthor ON C1_S2.TITLE_ID = titleauthor.title_id
ORDER BY `SALES_ROYALTY` + titles.advance * (titleauthor.royaltyper / 100) DESC LIMIT 3;

/*Challenge 2 Alternative Solution: derived tables */
SELECT `AUTHOR_ID`, `SALES_ROYALTY` + titles.advance*(titleauthor.royaltyper/100) AS 'SALES_ROYALTY'
FROM (
	SELECT `TITLEID`, `AUTHOR_ID`, SUM(SALES_ROYALTY) AS 'SALES_ROYALTY'
	FROM (
		SELECT `TITLEID`, `AUTHOR_ID`, `SALES_ROYALTY`
		FROM (
			SELECT titles.title_id AS 'TITLEID', authors.au_id 'AUTHOR_ID', titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS 'SALES_ROYALTY'
			FROM authors INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
			JOIN titles ON titles.title_id = titleauthor.title_id
			JOIN sales ON titles.title_id = sales.title_id
		) C2_S1
	) C2_S2
	GROUP BY `TITLEID`, `AUTHOR_ID`
) C2_S3
INNER JOIN titles ON `TITLEID` = titles.title_id
JOIN titleauthor ON `TITLEID` = titleauthor.title_id
ORDER BY `SALES_ROYALTY` + titles.advance*(titleauthor.royaltyper/100) DESC LIMIT 3;


/*Challenge 3*/
CREATE TABLE most_profiting_authors 
SELECT * FROM C1_S3;

/*para tests*/
SELECT * FROM C1_S2;
DROP TEMPORARY TABLE C1_S2;
DROP TEMPORARY TABLE C1_S1;
DROP TEMPORARY TABLE C1_S3;
DROP TABLE most_profiting_authors; 

/*Para ver Tablas que existen*/
SELECT * FROM authors;
SELECT * FROM titleauthor;
SELECT * FROM titles;
SELECT * FROM publishers;
SELECT * FROM pubinfo;
SELECT * FROM toysched;
SELECT * FROM employee;
SELECT * FROM sales;
