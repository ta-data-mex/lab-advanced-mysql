/*Challenge 1*/

/*Step1*/
select Title as 'Title ID', Author as 'Author ID', Royalty as 'Royalty Sales'
from ( select titles.title_id as Title, 
authors.au_id as Author, 
titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 as Royalty
from publications.authors authors
inner join publications.titleauthor titleauthor 
on authors.au_id = titleauthor.au_id
inner join publications.titles titles
on titleauthor.title_id = titles.title_id
inner join publications.sales sales
on sales.title_id = titles.title_id) titleid_authorid_royalty
group by Title
;


/*Step2*/
select Title as 'Title ID', Author as 'Author ID', Royalty as 'Royalty Sales'
from ( select titles.title_id as Title, 
authors.au_id as Author, 
sum(titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100) as Royalty
from publications.authors authors
inner join publications.titleauthor titleauthor 
on authors.au_id = titleauthor.au_id
inner join publications.titles titles
on titleauthor.title_id = titles.title_id
inner join publications.sales sales
on sales.title_id = titles.title_id
group by Author, Title) titleid_authorid_royalty;

/*step 3*/
select Author_ID as 'Author ID', Royalty_Sales as 'Royalty Sales'
from(select Title as Title_ID, Author as Author_ID, Royalty as Royalty_Sales
	from (select titles.title_id as Title, 
		authors.au_id as Author, 
		sum(titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 + titles.advance*titleauthor.royaltyper/100) as Royalty
		from publications.authors authors
		inner join publications.titleauthor titleauthor on authors.au_id = titleauthor.au_id
		inner join publications.titles titles on titleauthor.title_id = titles.title_id
		inner join publications.sales sales
		on sales.title_id = titles.title_id group by Author, Title
        ) titleid_authorid_royalty
	)step2;


# Challenge 2    
create temporary table 
publications.temporary_step1
select Title as 'Title ID', Author as 'Author ID', Royalty as 'Royalty Sales'
from ( select titles.title_id as Title, 
authors.au_id as Author, 
titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 as Royalty
from publications.authors authors
inner join publications.titleauthor titleauthor 
on authors.au_id = titleauthor.au_id
inner join publications.titles titles
on titleauthor.title_id = titles.title_id
inner join publications.sales sales
on sales.title_id = titles.title_id) titleid_authorid_royalty
group by Title;

create temporary table 
publications.temporary_step2_00
select Title as TitleID, Author as AuthorID, Royalty
from ( select titles.title_id as Title, 
authors.au_id as Author, 
sum(titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100) as Royalty
from publications.authors authors
inner join publications.titleauthor titleauthor 
on authors.au_id = titleauthor.au_id
inner join publications.titles titles
on titleauthor.title_id = titles.title_id
inner join publications.sales sales
on sales.title_id = titles.title_id
group by Author, Title) titleid_authorid_royalty;

create temporary table
temporary_step2_02
select Title as TitleID, Author as AuthorID, Royalty_advances
from ( select titles.title_id as Title, 
authors.au_id as Author, 
sum(titles.advance*titleauthor.royaltyper/100) as Royalty_advances
from publications.authors authors
inner join publications.titleauthor titleauthor 
on authors.au_id = titleauthor.au_id
inner join publications.titles titles
on titleauthor.title_id = titles.title_id
inner join publications.sales sales
on sales.title_id = titles.title_id
group by Author, Title) titleid_authorid_royalty;

/*
select * from temporary_step2_0;
select * from temporary_step2_2;
select TitleID, AuthorID ,temporary_step2_00.Royalty + temporary_step2_02.Royalty_advances
from temporary_step2_00 
inner join temporary_step2_02
on temporary_step2_00.TitleID = temporary_step2_02.TitleID AND temporary_step2_00.AuthorID = temporary_step2_02.AuthorID;
*/

CREATE TEMPORARY table
step3
select Author_ID as 'Author ID', Royalty_Sales as 'Royalty Sales'
from(select Title as Title_ID, Author as Author_ID, Royalty as Royalty_Sales
	from (select titles.title_id as Title, 
		authors.au_id as Author, 
		sum(titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 + titles.advance*titleauthor.royaltyper/100) as Royalty
		from publications.authors authors
		inner join publications.titleauthor titleauthor on authors.au_id = titleauthor.au_id
		inner join publications.titles titles on titleauthor.title_id = titles.title_id
		inner join publications.sales sales
		on sales.title_id = titles.title_id group by Author, Title
        ) titleid_authorid_royalty
	)step2;
    
/* Challange 3...*/
create table
Challange3_table
select Author_ID as 'Author ID', Royalty_Sales as 'Royalty Sales'
from(select Title as Title_ID, Author as Author_ID, Royalty as Royalty_Sales
	from (select titles.title_id as Title, 
		authors.au_id as Author, 
		sum(titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 + titles.advance*titleauthor.royaltyper/100) as Royalty
		from publications.authors authors
		inner join publications.titleauthor titleauthor on authors.au_id = titleauthor.au_id
		inner join publications.titles titles on titleauthor.title_id = titles.title_id
		inner join publications.sales sales
		on sales.title_id = titles.title_id group by Author, Title
        ) titleid_authorid_royalty
	)step2


/* OR ONE CAN ALSO MAKE OTHER TABLES FOR CHALLENGE 2 AND 3: */

# Challenge 2 and 3. 

select authors.au_id
from publications.authors authors;

create temporary table
publications.all_information
select titleauthor.au_id, titleauthor.title_id, royaltyper, qty, advance, price, royalty
from (select sales.title_id, qty, advance, price, royalty
from publications.sales sales
inner join publications.titles titles
on titles.title_id = sales.title_id) intermediate
inner join publications.titleauthor titleauthor
on titleauthor.title_id = intermediate.title_id
inner join publications.authors authors
on titleauthor.au_id = authors.au_id
group by titleauthor.au_id;

create temporary table
publications.helper1
select title_id, au_id, (price*qty*royalty/100)*royaltyper/100 as royalty_sales
from publications.all_information;

create temporary table
publications.helper_advances
select title_id, au_id, (advance)*royaltyper/100 as royalty_advances
from publications.all_information;

create table publications.Profit
select advancest.title_id, advancest.au_id, royalty_sales+royalty_advances as Profit
from publications.helper1 helper1
inner join publications.helper_advances advancest
on advancest.title_id = helper1.title_id;

select * from publications.Profit
