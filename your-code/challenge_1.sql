SELECT
author_id,
advance+total_royalties AS profits
FROM
(
SELECT 
title_id,
author_id,
advance,
SUM(royalties) AS total_royalties
FROM
(
SELECT
titles.title_id AS title_id,
authors.au_id AS author_id,
titles.advance AS advance,
((titles.price*sales.qty*titles.royalty)/100)*(titleauthor.royaltyper/100) AS royalties
FROM authors
JOIN titleauthor ON authors.au_id = titleauthor.au_id
JOIN titles ON titleauthor.title_id = titles.title_id
JOIN sales ON titles.title_id = sales.title_id
) royalties
GROUP BY author_id, title_id
) per_author
ORDER BY profits DESC
LIMIT 3
;