USE publications;
#Step 1: Calculate the royalties of each sales for each author
# I started selecting all the sales of books from sales
#SELECT sales.ord_num
#FROM sales;

#Then I made two inner joins in order to now the author (au_id) of each book sold,
#extracted from titleauthor passing over titles, I rised titleauthor because I need royaltyper term
#SELECT sales.title_id AS Title_ID,titleauthor.au_id AS Author_ID,(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalties
#FROM sales
#INNER JOIN titles
#ON titles.title_id = sales.title_id
#INNER JOIN titleauthor
#ON titles.title_id = titleauthor.title_id;

#Until this point I have access to all the terms to calculate Royalties per sale.

#Step 2: Aggregate the total royalties for each title for each author
#In order to obtain the royalties per each title and not by sales, we GROUP BY au_id and title_id; then we sum the royalties 
#SELECT sales.title_id AS Title_ID,titleauthor.au_id AS Author_ID,SUM(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS RoyaltiesBook
#FROM sales
#INNER JOIN titles
#ON titles.title_id = sales.title_id
#INNER JOIN titleauthor
#ON titles.title_id = titleauthor.title_id
#GROUP BY titleauthor.au_id,titles.title_id;

#At this point we have Royalties per book sold

#Step 3: Calculate the total profits of each author
# So at the end we change the "GROUP BY titleauthor.au_id,titles.title_id;" for "GROUP BY titleauthor.au_id;"
# in order to obtain the author Royalties per author, we also add the advance per sales, order and limit to top 3
# giving Author ID and Profits

#SELECT titleauthor.au_id AS Author_ID,SUM((titles.advance* titleauthor.royaltyper / 100) +(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)) AS Profits
#FROM sales
#INNER JOIN titles
#ON titles.title_id = sales.title_id
#INNER JOIN titleauthor
#ON titles.title_id = titleauthor.title_id
#GROUP BY titleauthor.au_id
#ORDER BY Profits DESC
#LIMIT 3;

## Challenge 2 - Alternative Solution
# We use subqueries for this challenge


# We use the Royalties per book and Group in order to obtain RoyaltiesAuthor 
SELECT Title_ID,Author_ID,SUM(RoyaltiesBook) AS Profits
FROM(
# We use the Royalties data and get Royalties per book
SELECT Title_ID,Author_ID,SUM(Advance + Royalties) AS RoyaltiesBook,Advance
FROM(
# My first subquerie get the Royalties per sales
SELECT sales.title_id AS Title_ID,titleauthor.au_id AS Author_ID,(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100) AS Royalties,(titles.advance* titleauthor.royaltyper / 100) AS Advance
FROM sales
INNER JOIN titles
ON titles.title_id = sales.title_id
INNER JOIN titleauthor
ON titles.title_id = titleauthor.title_id
)royalties_per_sale
GROUP BY Author_ID,Title_ID
)royalties_per_author
GROUP BY Author_ID
ORDER BY Profits DESC
LIMIT 3;

## Challenge 3
#CREATE TABLE publications.most_profiting_authors
#SELECT titleauthor.au_id AS Author_ID,SUM((titles.advance* titleauthor.royaltyper / 100) +(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100)) AS Profits
#FROM sales
#INNER JOIN titles
#ON titles.title_id = sales.title_id
#INNER JOIN titleauthor
#ON titles.title_id = titleauthor.title_id
#GROUP BY titleauthor.au_id
#ORDER BY Profits DESC
#LIMIT 3;