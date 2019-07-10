/*CHALLENGE 1 Step 1*/ 

select titles.title_id as 'TitleID', 
authors.au_id as 'AuthorID', 
(sales.qty*titles.price*titles.royalty/100 *titleauthor.royaltyper/100) as 'SalesRoyalty'
from publications.authors authors
inner join publications.titleauthor titleauthor 
on authors.au_id = titleauthor.au_id
inner join publications.titles titles
on titleauthor.title_id = titles.title_id
inner join publications.sales sales
on titles.title_id = sales.title_id;


/*CHALLENGE 1 Step 2*/ 

SELECT TitleID, AuthorID, SUM(SalesRoyalty) AS 'Sales Royalty'
FROM (
	select titles.title_id as 'TitleID', 
	authors.au_id as 'AuthorID', 
	(sales.qty*titles.price*titles.royalty/100 *titleauthor.royaltyper/100) as 'SalesRoyalty'
	from publications.authors authors
	inner join publications.titleauthor titleauthor 
	on authors.au_id = titleauthor.au_id
	inner join publications.titles titles
	on titleauthor.title_id = titles.title_id
	inner join publications.sales sales
	on titles.title_id = sales.title_id
) summary
GROUP BY AuthorID, TitleID;

/*CHALLENGE 1 Step 3*/ 


/*CHALLENGE 2 Step 1*/ 

CREATE TEMPORARY TABLE publications.sales_royalty
SELECT titles.title_id as 'TitleID', 
authors.au_id as 'AuthorID',
(sales.qty*titles.price*titles.royalty/100 *titleauthor.royaltyper/100) as 'Sales Royalty'
FROM publications.authors authors
inner join publications.titleauthor titleauthor 
on authors.au_id = titleauthor.au_id
inner join publications.titles titles
on titleauthor.title_id = titles.title_id
inner join publications.sales sales
on titles.title_id = sales.title_id;

SELECT * FROM publications.sales_royalty;


/*CHALLENGE 2 Step 2*/ 

CREATE TEMPORARY TABLE publications.total_royalty
SELECT TitleID, AuthorID, SUM(SalesRoyalty) AS 'Sales Royalty'
FROM (
	select titles.title_id as 'TitleID', 
	authors.au_id as 'AuthorID', 
	(sales.qty*titles.price*titles.royalty/100 *titleauthor.royaltyper/100) as 'SalesRoyalty'
	from publications.authors authors
	inner join publications.titleauthor titleauthor 
	on authors.au_id = titleauthor.au_id
	inner join publications.titles titles
	on titleauthor.title_id = titles.title_id
	inner join publications.sales sales
	on titles.title_id = sales.title_id
) summary
GROUP BY AuthorID, TitleID;

SELECT * FROM publications.total_royalty;


/*CHALLENGE 3*/ 

CREATE TABLE publications.most_profiting_author
select  authors.au_id as 'Author ID', 
(sum(titles.advance + sales.qty*titles.price*titles.royalty/100) *titleauthor.royaltyper/100) as 'Profit'
from publications.authors authors
inner join publications.titleauthor titleauthor 
on authors.au_id = titleauthor.au_id
inner join publications.titles titles
on titleauthor.title_id = titles.title_id
inner join publications.sales sales
on titles.title_id = sales.title_id
group by authors.au_id
order by Profit DESC;
