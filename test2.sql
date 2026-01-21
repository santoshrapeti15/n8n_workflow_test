select distinct prod_id,avg(sales) from products
group by prod_id;