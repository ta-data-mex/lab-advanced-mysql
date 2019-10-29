--no lo habia subido
-- Step 1 si funciona
use publications;
select titles.title_id, 
titleauthor.au_id, titles.royalty,
(titles.price * sales.qty )*(titles.royalty / 100)*(titleauthor.royaltyper / 100) as  sales_royalty
from sales
inner join titles on sales.title_id = titles.title_id
inner join titleauthor on titles.title_id = titleauthor.title_id;

-- Step 2
use publications;
select Title_ID, Author_ID, sales_royalty as sales
from(
	select titles.title_id as Title_ID,
	titleauthor.au_id as Author_ID, 
	sum((titles.price * sales.qty )*(titles.royalty / 100)*(titleauthor.royaltyper / 100)) as  sales_royalty
	from sales
	inner join titles on sales.title_id = titles.title_id
	inner join titleauthor on titles.title_id = titleauthor.title_id;
) summary;
group by Author_ID, Title_ID;

-- Step 2 bueno
use publications;
select titles.title_id, 
titleauthor.au_id,
sum(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) as  sales_royalty
from sales
inner join titles on sales.title_id = titles.title_id
inner join titleauthor on titles.title_id = titleauthor.title_id
group by au_id, title_id;

-- Step 3 
use publications;
select titles.title_id, 
titleauthor.au_id,
sum((titles.price * sales.qty )*(titles.royalty / 100)*(titleauthor.royaltyper / 100)) + titles.advance as  Profits
from sales
inner join titles on sales.title_id = titles.title_id
inner join titleauthor on titles.title_id = titleauthor.title_id
group by au_id, title_id;
