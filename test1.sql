select distinct prod_id, avg(sales) from product 
group by prod_id;