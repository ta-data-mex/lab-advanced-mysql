 -- Challenge 1
SELECT titleauthor.au_id, SUM(titles.price*sales.qty*titles.royalty/100 * titleauthor.royaltyper/100) as sales_royalty
FROM authors
INNER JOIN titleauthor ON authors.au_id = titleauthor.au_id
INNER JOIN titles ON titleauthor.title_id=titles.title_id
INNER JOIN sales ON titles.title_id=sales.title_id
GROUP BY titleauthor.au_id;
 
 -- Challenge 2
 CREATE TEMPORARY TABLE RegaliasAutor
SELECT 
authors.au_id AS IDAutor,
titles.title_id AS IDTitulo, 
((titles.price*sales.qty*titles.royalty)/100)*(titleauthor.royaltyper/100) AS Regalias
FROM authors
JOIN titleauthor ON authors.au_id = titleauthor.au_id
JOIN titles ON titleauthor.title_id = titles.title_id
JOIN sales ON titles.title_id = sales.title_id
GROUP BY IDAutor;

SELECT IDAutor, SUM(Regalias) as Ganancias
FROM RegaliasAutor
GROUP BY IDAutor
ORDER BY Ganancias DESC;

-- Challenge 3
CREATE TABLE Most_Profiting_Author SELECT * FROM RegaliasAutor;
SELECT * FROM Most_Profiting_Author;
INSERT Most_Profiting_Author SELECT IDAutor, Ganancias FROM RegaliasAutor;

