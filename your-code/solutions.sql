
SELECT titles.title_id as titlesIDs, authors.au_id as authorsIDs, (((((titles.price*sales.qty)*titles.royalty/100)*titleauthor.royaltyper))/100) as Sales_royalty, (titles.advance * titleauthor.royaltyper) as aggregate_advance
From publications.authors 
INNER Join publications.titleauthor
on authors.au_id = titleauthor.au_id
inner join publications.titles
on titles.title_id = titleauthor.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id
Group by titlesIDs, authorsIDs, Sales_royalty;

SELECT titlesIDs , authorsIDs, sum(Sales_royalty) as aggregate_royalties
FROM  (
SELECT titles.title_id as titlesIDs, authors.au_id as authorsIDs, (((((titles.price*sales.qty)*titles.royalty/100)*titleauthor.royaltyper))/100) as Sales_royalty
From publications.authors 
INNER Join publications.titleauthor
on authors.au_id = titleauthor.au_id
inner join publications.titles
on titles.title_id = titleauthor.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id
Group by titlesIDs, authorsIDs, Sales_royalty) summary
group by titlesIDs, authorsIDs;

select authorsIDs, aggregate_royalties + aggregate_advance as Total_profits
FROM (
SELECT titlesIDs , authorsIDs, sum(Sales_royalty) as aggregate_royalties, aggregate_advance
FROM  (
SELECT titles.title_id as titlesIDs, authors.au_id as authorsIDs, (((((titles.price*sales.qty)*titles.royalty/100)*titleauthor.royaltyper))/100) as Sales_royalty, (titles.advance * titleauthor.royaltyper) as aggregate_advance
From publications.authors 
INNER Join publications.titleauthor
on authors.au_id = titleauthor.au_id
inner join publications.titles
on titles.title_id = titleauthor.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id
Group by titlesIDs, authorsIDs, Sales_royalty) summary
group by titlesIDs, authorsIDs) big_summary
group by authorsIDs, Total_profits
order by Total_profits DESC LIMIT 3;

/**Challenge 2**/

CREATE TEMPORARY TABLE publications.store_profit
SELECT titles.title_id as titlesIDs, authors.au_id as authorsIDs, (((((titles.price*sales.qty)*titles.royalty/100)*titleauthor.royaltyper))/100) as Sales_royalty, (titles.advance * titleauthor.royaltyper) as aggregate_advance
From publications.authors 
INNER Join publications.titleauthor
on authors.au_id = titleauthor.au_id
inner join publications.titles
on titles.title_id = titleauthor.title_id
INNER JOIN publications.sales
ON titles.title_id = sales.title_id
Group by titlesIDs, authorsIDs, Sales_royalty;

select * from publications.store_profit;
Drop table publications.store_profit;


CREATE TEMPORARY TABLE publications.aggregate_royalties
SELECT titlesIDs , authorsIDs, sum(Sales_royalty) as aggregate_royalties, aggregate_advance
From publications.store_profit summary
group by titlesIDs, authorsIDs;

select * from publications.aggregate_royalties;
Drop table publications.aggregate_royalties;

CREATE TABLE publications.most_profiting_authors
select authorsIDs, aggregate_royalties + aggregate_advance as Total_profits
FROM publications.aggregate_royalties summary
group by authorsIDs, Total_profits
order by Total_profits DESC LIMIT 3;

select * from publications.most_profiting_authors;

