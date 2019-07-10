# Challenge 2
create temporary table
publications.temp_step1
select Title as 'Title ID', Author as 'Author ID', Royalty as 'Royalty Sales'
from ( select titles.title_id as Title,
authors.au_id as Author,
titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 as Royalty
from publications.authors
inner join publications.titleauthor
on authors.au_id = titleauthor.au_id
inner join publications.titles
on titleauthor.title_id = titles.title_id
inner join publications.sales
on sales.title_id = titles.title_id) titleid_authorid_royalty
group by Title;
