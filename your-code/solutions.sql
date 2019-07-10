use publications;
################################### Challenge 1 ###################################
create temporary table publications.resultadoStep1
select titles.title_id, authors.au_id, ((titles.price* sales.qty)*(titles.royalty/100))*(titleauthor.royaltyper/100) as 'ROYALTY'
from authors
join titleauthor
on authors.au_id = titleauthor.au_id
join titles
on titleauthor.title_id = titles.title_id
join sales
on titles.title_id = sales.title_id;

create temporary table publications.resultadoStep1_2
select title_id, au_id, sum(royalty) as 'royalBook'
from publications.resultadoStep1
group by au_id, title_id;

create temporary table publications.resultadoStep1_3
select publications.resultadoStep1_2.au_id, ifnull((royalbook)+(titles.advance * (titleauthor.royaltyper/100)), 0)as'profit'
from publications.resultadoStep1_2
join titleauthor
on publications.resultadoStep1_2.au_id = titleauthor.au_id
join titles
on titleauthor.title_id = titles.title_id
group by au_id;

select *
from publications.resultadoStep1_3 
order by profit desc
limit 3;

################################### Fin del challenge 1 ###################################
################################### Challenge 2 ###################################
select authors.au_id as 'Autor', titles.title_id as 'Titulo', (titles.price * sales.qty)*(titles.royalty/100)*(titleauthor.royaltyper/100)as'PROFIT'
from authors
inner join titleauthor
on authors.au_id = titleauthor.au_id
inner join titles
on titleauthor.title_id = titles.title_id
inner join sales
on titles.title_id = sales.title_id;

select autores, Titulos, PROFIT
from (
select authors.au_id as 'autores', titles.title_id  as 'Titulos', (titles.price * sales.qty)*(titles.royalty/100)*(titleauthor.royaltyper/100)as'PROFIT'
from authors
inner join titleauthor
on authors.au_id = titleauthor.au_id
inner join titles
on titleauthor.title_id = titles.title_id
inner join sales
on titles.title_id = sales.title_id
)as tabla1;

#parte dos

select autores, titulos, sum(profit) as 'royalbook'
from(
select autores, Titulos, PROFIT
from (
select authors.au_id as 'autores', titles.title_id  as 'Titulos', (titles.price * sales.qty)*(titles.royalty/100)*(titleauthor.royaltyper/100)as'PROFIT'
from authors
inner join titleauthor
on authors.au_id = titleauthor.au_id
inner join titles
on titleauthor.title_id = titles.title_id
inner join sales
on titles.title_id = sales.title_id
)as tabla1
) as tabla2
group by autores, titulos;

#parte tres
select autores, ifnull(suma+(advance *porcentajeA), 0)as'profit'
from(
	select autores, titulos, sum(profit) as 'suma', advance, porcentajeA
	from(
		select autores, Titulos, PROFIT, advance, porcentajeA
			from (
				select authors.au_id as 'autores', titles.title_id  as 'Titulos', titles.advance as 'advance', (titleauthor.royaltyper/100) as 'porcentajeA',(titles.price * sales.qty)*(titles.royalty/100)*(titleauthor.royaltyper/100)as'PROFIT'
				from authors
				inner join titleauthor
				on authors.au_id = titleauthor.au_id
				inner join titles
				on titleauthor.title_id = titles.title_id
				inner join sales
				on titles.title_id = sales.title_id
				)as tabla1
		) as tabla2
        group by autores
	) as tabla3;

################################### Fin del challenge 2 ###################################
################################### Challenge 3 ###################################
create table publications.most_profiting_authors
select autores, ifnull(suma+(advance *porcentajeA), 0)as'profit'
from(
	select autores, titulos, sum(profit) as 'suma', advance, porcentajeA
	from(
		select autores, Titulos, PROFIT, advance, porcentajeA
			from (
				select authors.au_id as 'autores', titles.title_id  as 'Titulos', titles.advance as 'advance', (titleauthor.royaltyper/100) as 'porcentajeA',(titles.price * sales.qty)*(titles.royalty/100)*(titleauthor.royaltyper/100)as'PROFIT'
				from authors
				inner join titleauthor
				on authors.au_id = titleauthor.au_id
				inner join titles
				on titleauthor.title_id = titles.title_id
				inner join sales
				on titles.title_id = sales.title_id
				)as tabla1
		) as tabla2
        group by autores
) as tabla3;