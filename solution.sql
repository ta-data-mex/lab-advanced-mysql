
/* Challenge 1*/
Select at.au_fname, at.au_lname, ti.title, (((ta.royaltyper/100)*(ti.royalty/100)*sa.qty*ti.price)+ti.advance) as profit from sales as sa join titles as ti on ti.title_id = sa.title_id join titleauthor as ta on ta.title_id = sa.title_id join authors as at on at.au_id=ta.au_id GROUP BY ti.title_id, at.au_id ORDER by profit DESC limit 3

/* Challenge 2*/
create TEMPORARY TABLE sales_royalty
Select at.au_fname, at.au_lname, ti.title, ((ta.royaltyper/100)*(ti.royalty/100)*sa.qty*ti.price) as sales_royalty, ti.advance from sales as sa join titles as ti on ti.title_id = sa.title_id join titleauthor as ta on ta.title_id = sa.title_id join authors as at on at.au_id=ta.au_id GROUP BY ti.title_id, at.au_id;

SELECT au_fname, au_lname, title, (sales_royalty+advance) as profit from sales_royalty ORDER by profit DESC Limit 3;

/* Challenge 3*/
create TEMPORARY TABLE sales_royalty
Select at.au_id, ti.title, ((ta.royaltyper/100)*(ti.royalty/100)*sa.qty*ti.price) as sales_royalty, ti.advance from sales as sa join titles as ti on ti.title_id = sa.title_id join titleauthor as ta on ta.title_id = sa.title_id join authors as at on at.au_id=ta.au_id GROUP BY ti.title_id, at.au_id;


create table most_profiting_authors as
SELECT au_id, (sales_royalty+advance) as profit from sales_royalty ORDER by profit DESC Limit 3;