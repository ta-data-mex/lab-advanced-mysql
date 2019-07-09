/*Challenge 1*/

/*STEP 1*/
CREATE TEMPORARY TABLE C1_S1
SELECT titles.title_id AS 'TITLE ID', authors.au_id 'AUTHOR ID', titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS 'PROFIT'
FROM authors INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
JOIN titles ON titles.title_id = titleauthor.title_id
JOIN sales ON titles.title_id = sales.title_id;

/*STEP 2*/
CREATE TEMPORARY TABLE C1_S2
SELECT `TITLE ID`, `AUTHOR ID`, SUM(PROFIT) AS 'PROFIT'
FROM C1_S1
GROUP BY `TITLE ID`, `AUTHOR ID`;

/*STEP 3*/
CREATE TEMPORARY TABLE C1_S3
SELECT `AUTHOR ID`, `PROFIT` + titles.advance*(titleauthor.royaltyper/100) AS 'PROFIT'
FROM C1_S2 INNER JOIN titles ON `TITLE ID` = titles.title_id
JOIN titleauthor ON `TITLE ID` = titleauthor.title_id
ORDER BY `PROFIT` + titles.advance*(titleauthor.royaltyper/100) DESC LIMIT 3;

/*Challenge 2*/

SELECT `AUTHOR ID`, `PROFIT` + titles.advance*(titleauthor.royaltyper/100) AS 'PROFIT'
FROM (
	SELECT `TITLE ID`, `AUTHOR ID`, SUM(PROFIT) AS 'PROFIT'
	FROM (
		SELECT `TITLE ID`, `AUTHOR ID`, `PROFIT`
		FROM (
			SELECT titles.title_id AS 'TITLE ID', authors.au_id 'AUTHOR ID', titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100) AS 'PROFIT'
			FROM authors INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
			JOIN titles ON titles.title_id = titleauthor.title_id
			JOIN sales ON titles.title_id = sales.title_id
		) C2_S1
	) C2_S2
	GROUP BY `TITLE ID`, `AUTHOR ID`
) C2_S3
INNER JOIN titles ON `TITLE ID` = titles.title_id
JOIN titleauthor ON `TITLE ID` = titleauthor.title_id
ORDER BY `PROFIT` + titles.advance*(titleauthor.royaltyper/100) DESC LIMIT 3;

/*Challenge 3*/

CREATE TABLE most_profiting_authors 
SELECT * FROM C1_S3;