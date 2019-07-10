# Step 3 - Total profits for each author 
select Author_ID as 'Author ID', Royalty_Sales as 'Royalty Sales'
from(select Title as Title_ID, Author as Author_ID, Royalty as Royalty_Sales
from (select titles.title_id as Title,
authors.au_id as Author,
		sum(titles.price*sales.qty*titles.royalty/100*titleauthor.royaltyper/100 + titles.advance*titleauthor.royaltyper/100) as Royalty
from publications.authors
		inner join publications.titleauthor
        on authors.au_id = titleauthor.au_id
        		inner join publications.titles
                on titleauthor.title_id = titles.title_id
                inner join publications.sales
                on sales.title_id = titles.title_id
                group by Author, Title)
                summary_step1
                ) summary_step2;
                