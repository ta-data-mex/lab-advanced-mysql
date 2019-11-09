-- Challenge 1

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
;

-- Challenge 2
use publications;
select titles.title_id, 
titleauthor.au_id,
sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as  sales_royalty
from sales
inner join titles on sales.title_id = titles.title_id
inner join titleauthor on titles.title_id = titleauthor.title_id
group by au_id, title_id
;


-- Challenge 3

use publications;
select titles.title_id, titleauthor.au_id, sum((titles.price * sales.qty )(titles.royalty / 100)(titleauthor.royaltyper / 100)) + titles.advance as  Profits
from sales
inner join titles on sales.title_id = titles.title_id
inner join titleauthor on titles.title_id = titleauthor.title_id
group by au_id, title_id;
