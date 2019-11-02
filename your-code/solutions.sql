CREATE temporary table temp as (
SELECT 
    *
FROM
    (SELECT 
        title_id, au_id, author_id, SUM(sales_royalty) AS royalty
    FROM
        (SELECT 
        titles.title_id AS title_id,
            titleauthor.au_id,
            titles.royalty AS author_id,
            ROUND(((titles.price * sales.qty) * (titles.royalty / 100) * (titleauthor.royaltyper / 100)), 3) AS sales_royalty
    FROM
        sales
    INNER JOIN titles ON sales.title_id = titles.title_id
    INNER JOIN titleauthor ON titles.title_id = titleauthor.title_id) summary
    GROUP BY au_id , title_id) summary2
GROUP BY royalty , title_id
);

SELECT 
    *
FROM
    temp;