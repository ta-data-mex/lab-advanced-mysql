use publications;

SELECT 
    author, sum(ganancias.Royalty) as profit
FROM
    (SELECT 
        sales.title_id,
            titleauthor.au_id AS author,
            SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty
    FROM
        sales
    JOIN titles ON sales.title_id = titles.title_id
    JOIN titleauthor ON titleauthor.title_id = titles.title_id
    GROUP BY sales.title_id , titleauthor.au_id) ganancias
group by 1
order by 2 desc
limit 3
;
-- Challenge2 y 3
create temporary table temp
SELECT 
        sales.title_id,
            titleauthor.au_id AS author,
            SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalty
    FROM
        sales
    JOIN titles ON sales.title_id = titles.title_id
    JOIN titleauthor ON titleauthor.title_id = titles.title_id
    GROUP BY sales.title_id , titleauthor.au_id;

CREATE TABLE most_profiting_authors SELECT author AS Author_ID, SUM(Royalty) AS profits FROM
    temp
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3
;