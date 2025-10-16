sel id, customer, region, amount from raw_tbl.customer where code = 12
union
sel id, customer, region, amount from raw_tbl.customer where code = 15