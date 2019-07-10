CREATE TEMPORARY TABLE publications.ro
SELECT ti.title_id as title_id, (ti.price * (ti.royalty/100) * sum(sales.qty)) AS royalty_calc
from publications.titles ti
join publications.sales sales
on ti.title_id = sales.title_id
group by ti.title_id

SELECT Author, (Royals + ADV) AS profits FROM (
SELECT Author, SUM(Royals) as Royals, SUM(Advances) as ADV FROM (
SELECT ti.title_id as Title, ta.au_id as Author, ro.royalty_calc * (ta.royaltyper / 100) AS Royals, ti.advance*(ta.royaltyper/100) AS Advances
FROM publications.titles ti
JOIN publications.titleauthor ta
ON ti.title_id = ta.title_id
JOIN publications.ro ro
ON ti.title_id = ro.title_id) summary
GROUP BY Author) summary
ORDER BY profits DESC
LIMIT 3

