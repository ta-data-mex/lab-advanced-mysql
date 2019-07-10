SELECT titles.title_id AS Title_ID, authors.au_id AS Author_ID, (titles.price * sales.qty)*(titles.royalty / 100)*(titleauthor.royaltyper / 100) AS Sales_Royalties
FROM publications.authors
INNER JOIN publications.titleauthor ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales ON titles.title_id = sales.title_id;

SELECT Author_ID, Title_ID, SUM(Sales_Royalties) AS Total_Royalties
FROM (
	SELECT titles.title_id AS Title_ID, authors.au_id AS Author_ID, (titles.price * sales.qty)*(titles.royalty / 100)*(titleauthor.royaltyper / 100) AS Sales_Royalties
	FROM publications.authors
	INNER JOIN publications.titleauthor ON authors.au_id = titleauthor.au_id
	INNER JOIN publications.titles ON titleauthor.title_id = titles.title_id
	INNER JOIN publications.sales ON titles.title_id = sales.title_id
) summary
GROUP BY Author_ID, Title_ID;

SELECT Author_ID, Advance_Total + Total_Royalties AS Profit_Author
FROM (
	SELECT Author_ID, Title_ID, Advance_Total, SUM(Sales_Royalties) AS Total_Royalties
	FROM (
		SELECT titles.title_id AS Title_ID, authors.au_id AS Author_ID, (titles.price * 	sales.qty)*(titles.royalty / 100)*(titleauthor.royaltyper / 100) AS Sales_Royalties, (titles.advance*(titleauthor.royaltyper/100)) AS Advance_Total 
		FROM publications.authors
		INNER JOIN publications.titleauthor ON authors.au_id = titleauthor.au_id
		INNER JOIN publications.titles ON titleauthor.title_id = titles.title_id
		INNER JOIN publications.sales ON titles.title_id = sales.title_id
	) summary
	GROUP BY Author_ID, Title_ID
) summary
ORDER BY Profit_Author DESC
LIMIT 3;

CREATE TEMPORARY TABLE publications.royalties_each_sale_author
SELECT titles.title_id AS Title_ID, authors.au_id AS Author_ID, (titles.price * sales.qty)*(titles.royalty / 100)*(titleauthor.royaltyper / 100) AS Sales_Royalties, (titles.advance*(titleauthor.royaltyper/100)) AS Advance_Total 
FROM publications.authors
INNER JOIN publications.titleauthor ON authors.au_id = titleauthor.au_id
INNER JOIN publications.titles ON titleauthor.title_id = titles.title_id
INNER JOIN publications.sales ON titles.title_id = sales.title_id;

CREATE TEMPORARY TABLE publications.royalties_total_author
SELECT Title_ID, Author_ID, SUM(Sales_Royalties) AS Total_Royalties
FROM publications.royalties_each_sale_author
GROUP BY Author_ID, Title_ID;

SELECT publications.royalties_total_author.Author_ID, Advance_Total + Total_Royalties AS Profit_Author
FROM publications.royalties_each_sale_author
INNER JOIN publications.royalties_total_author ON publications.royalties_total_author.Author_ID = publications.royalties_each_sale_author.Author_ID
ORDER BY Profit_Author DESC
LIMIT 3;

CREATE TABLE Most_Profiting_Authors AS
SELECT Author_ID, Advance_Total + Total_Royalties AS Profit_Author
FROM (
	SELECT Author_ID, Title_ID, Advance_Total, SUM(Sales_Royalties) AS Total_Royalties
	FROM (
		SELECT titles.title_id AS Title_ID, authors.au_id AS Author_ID, (titles.price * 	sales.qty)*(titles.royalty / 100)*(titleauthor.royaltyper / 100) AS Sales_Royalties, (titles.advance*(titleauthor.royaltyper/100)) AS Advance_Total 
		FROM publications.authors
		INNER JOIN publications.titleauthor ON authors.au_id = titleauthor.au_id
		INNER JOIN publications.titles ON titleauthor.title_id = titles.title_id
		INNER JOIN publications.sales ON titles.title_id = sales.title_id
	) summary
	GROUP BY Author_ID, Title_ID
) summary
ORDER BY Profit_Author DESC
LIMIT 3;