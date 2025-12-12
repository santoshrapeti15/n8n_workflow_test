-- GL Sourced Revenue

SEL
-- Time periods
apn.begin_period_date,
jl."Accounting Period Name",
jl."Accounting Year Month",

-- Contract specifics
src.src_attribute_char46 AS cdi, -- Not in GL
cust.CustomerContractHeaderId AS "Contract Number",  -- Not in GL
jl."Customer Number", -- No customer Hier in GL, need to add. Blank customer numbers in GL for Revenue Management Sourced data.
ch.cust_hier_cd as "End Customer Number",
custacct.ACCOUNTNAME AS "End Cust Name",  -- Not in GL
src.item_number AS "Item Number",  --  Not in GL
jl."Currency Code",
jl."Functional Currency Code",
--perf.CustomerContractHeadersContractCurrencyCode AS "Perf Functional Currency Code",  -- same as code in GL

-- ID Fields
jl."Journal Entry Header ID",
jl."Journal Entry Line Number", 
jl."GL Code Combination ID",
jl."General Ledger ID",

-- CoA + Customer Hier + Prod Hier
jl."Account Code",
jl."Account Hierarchy Level 1",
jl."Account Hierarchy Level 2",
jl."Account Hierarchy Level 3",
jl."Account Hierarchy Level 4",
jl."Account Hierarchy Level 5",
jl."Account Hierarchy Level 6",
jl."Account Hierarchy Level 7",
jl."Account Hierarchy Level 8",
jl."Account Hierarchy Level 9",
jl."Account Hierarchy Level 10",
ch.cust_hier_cd,
ch.cust_hier_lvl0_nm,
ch.cust_hier_lvl1_nm,
ch.cust_hier_lvl2_nm,
ch.cust_hier_lvl3_nm,
ch.cust_hier_lvl4_nm,
ch.cust_hier_lvl5_nm,
ch.location_customer,
ch.industry_customer,
jl."Company Code",
jl."Company Hierarchy Level 1",
jl."Company Hierarchy Level 2",
jl."Company Hierarchy Level 3",
jl."Company Hierarchy Level 4",
jl."Company Hierarchy Level 5",
jl."Company Hierarchy Level 6",
jl."Company Hierarchy Level 7",
jl."Company Hierarchy Level 8",
jl."Company Hierarchy Level 9",
jl."Company Hierarchy Level 10",
jl."Department Code",
jl."Department Hierarchy Level 1",
jl."Department Hierarchy Level 2",
jl."Department Hierarchy Level 3",
jl."Department Hierarchy Level 4",
jl."Department Hierarchy Level 5",
jl."Department Hierarchy Level 6",
jl."Department Hierarchy Level 7",
jl."Department Hierarchy Level 8",
jl."Department Hierarchy Level 9",
jl."Department Hierarchy Level 10",
jl."Inter Company Code",
jl. "Inter Company Hierarchy Level 1",
jl. "Inter Company Hierarchy Level 2",
jl. "Inter Company Hierarchy Level 3",
jl. "Inter Company Hierarchy Level 4",
jl. "Inter Company Hierarchy Level 5",
jl. "Inter Company Hierarchy Level 6",
jl. "Inter Company Hierarchy Level 7",
jl. "Inter Company Hierarchy Level 8",
jl. "Inter Company Hierarchy Level 9",
jl. "Inter Company Hierarchy Level 10",
jl."Line of Business Code",
jl. "Line of Business Hierarchy Level 1",
jl. "Line of Business Hierarchy Level 2",
jl. "Line of Business Hierarchy Level 3",
jl. "Line of Business Hierarchy Level 4",
jl. "Line of Business Hierarchy Level 5",
jl. "Line of Business Hierarchy Level 6",
jl. "Line of Business Hierarchy Level 7",
jl. "Line of Business Hierarchy Level 8",
jl. "Line of Business Hierarchy Level 9",
jl. "Line of Business Hierarchy Level 10",
jl."Management Group Code",
jl. "Management Group Hierarchy Level 1",
jl. "Management Group Hierarchy Level 2",
jl. "Management Group Hierarchy Level 3",
jl. "Management Group Hierarchy Level 4",
jl. "Management Group Hierarchy Level 5",
jl. "Management Group Hierarchy Level 6",
jl. "Management Group Hierarchy Level 7",
jl. "Management Group Hierarchy Level 8",
jl. "Management Group Hierarchy Level 9",
jl. "Management Group Hierarchy Level 10",
jl."Source Country Code",
--src.lob_cd AS "Line of Business Code",-- Different code vs GL LOB codes
mdmph.BUSINESS_UNIT_DESC,
mdmph.PROD_LVL1_DESC,
mdmph.PROD_LVL2_DESC,
mdmph.PROD_LVL3_DESC,
mdmph.PROD_LVL4_DESC,
mdmph.PROD_LVL5_DESC,
mdmph.PROD_LVL6_DESC,

-- Value fields
jl."Credit Amount - Entered",
jl."Debit Amount - Entered",
jl."Net Amount - Entered",

jl."Credit Amount - Local",
jl."Debit Amount - Local",
jl."Net Amount - Local",

jl."Credit Amount - US",
jl."Debit Amount - US",
jl."Net Amount - US",

jl."Credit Amount - Accounted Local",                                                              
jl."Debit Amount - Accounted Local",
jl."Net Amount - Accounted Local",

jl."Credit Amount - Accounted USD",
jl."Debit Amount - Accounted USD",
jl. "Net Amount - Accounted USD",

-- Line description
REGEXP_REPLACE(jl."Journal Entry Line Description", '.*Performance Obligation Line Item: ([^ ]+) -.*', '\1')  AS item_nbr,
REGEXP_REPLACE(jl."Journal Entry Line Description", '.*Revenue Contract Number: ([0-9]+).*', '\1') AS cntrct_nbr,
REGEXP_REPLACE(jl."Journal Entry Line Description", '.*Performance Obligation Number: ([0-9]+).*', '\1') AS performance_obligation_number,
REGEXP_REPLACE(jl."Journal Entry Line Description", '.*Performance Obligation Line Number: ([0-9]+).*','\1') AS performance_obligation_line_number,
jl."Journal Entry Line Description",
jl."Journal Entry Source Name"

-- FROM 
from acc_ted_op_vw.gl_jrnl_entry_lines_dn jl -- Gl jounral entry lines dn
--FROM adltrd_finance.gl_jrnl_entry_lines_dn_20250730_vw JL -- datalab test
LEFT JOIN raw_erp_op_vw.all_modules_XLA_cur xla -- xla
ON jl."GL Code Combination ID"  = xla.code_combination_id
AND jl."Journal Entry Header ID"  = xla.je_header_id
AND jl."Journal Entry Line Number"   = xla.je_line_num
LEFT JOIN raw_erp_op_vw.customercontractheaders_cur cust-- Customer Contract Headers
ON cust.CustContHeadersCustomerContractNumber =  xla.SOURCE_ID_INT_1
AND cust.CustContHeadersLegalEntityId = xla.LEGAL_ENTITY_ID
LEFT JOIN raw_erp_op_vw.perfobligationlines_cur perf  --  Perf Obligation Lines
ON performance_obligation_number = perf.PerfObligationsPerfObligationNumber 
AND performance_obligation_line_number = perf.PerfObligationLinesPerfObligationLineNumber
LEFT JOIN
(SEL
document_line_id,
item_number,
src_attribute_char46,
src_attribute_char25 AS rev_cat,
src_attribute_char26 AS lob_cd, 
src_attribute_char22 AS end_cust_nbr, 
document_date,
source_documents_currency_code,
doc_id_int_1,
source_documents_bill_to_customer_id,
satisfaction_measurement_model
FROM  raw_erp_op_vw.sourcedocumentlines_cur  ---- source doc lines
GROUP BY 1,2,3,4,5,6,7,8,9,10,11
) src  -- Source Document Lines
ON perf.sourcedoclinesdocumentlineid = src.document_line_id
LEFT JOIN acc_tedfin_op_vw.cust_hier ch  --  Customer Hierarchy
ON ch.cust_hier_cd  = src.end_cust_nbr
LEFT JOIN raw_erp_op_vw.customeraccount_cur custacct  --- Customer account
ON src.SOURCE_DOCUMENTS_BILL_TO_CUSTOMER_ID = custacct .custaccountid
left join mdm_edw_sub.prod_hier_dim_vw mdmph  -- MDM product hierarchy
on mdmph.formatted_product_id = src.item_number
LEFT JOIN 
(
SEL 
accounting_period_name ,
begin_period_date,
end_period_date ,
accounting_yr_month
FROM tedw.accounting_period_name
) apn -- Accounting period name
ON apn.accounting_period_name = jl."Accounting Period Name"

-- Filters
WHERE accounting_yr_month IN 
(
SEL accounting_yr_month 
FROM tedw.accounting_period_name
WHERE end_period_date  < Add_Months (DATE,-1) 
)
and jl."Journal Entry Source Name" IN ('Revenue Management')
AND jl."Ledger Category Name" = 'Primary'
AND jl."Account Hierarchy Level 1" IN ('Total Revenues')
and ch.prim_hier_ind = 1

UNION

-- Manual Revenue

SEL
-- Time periods
apn.begin_period_date,
jl."Accounting Period Name",
jl."Accounting Year Month",

-- Contract specifics
src.src_attribute_char46 AS cdi, -- Not in GL
cust.CustomerContractHeaderId AS "Contract Number",  -- Not in GL
jl."Customer Number", -- No customer Hier in GL, need to add. Blank customer numbers in GL for Revenue Management Sourced data.
ch.cust_hier_cd as "End Customer Number",
custacct.ACCOUNTNAME AS "End Cust Name",  -- Not in GL
src.item_number AS "Item Number",  --  Not in GL
jl."Currency Code",
jl."Functional Currency Code",
--perf.CustomerContractHeadersContractCurrencyCode AS "Perf Functional Currency Code",  -- same as code in GL

-- ID Fields
jl."Journal Entry Header ID",
jl."Journal Entry Line Number", 
jl."GL Code Combination ID",
jl."General Ledger ID",

-- CoA + Customer Hier
jl."Account Code",
jl."Account Hierarchy Level 1",
jl."Account Hierarchy Level 2",
jl."Account Hierarchy Level 3",
jl."Account Hierarchy Level 4",
jl."Account Hierarchy Level 5",
jl."Account Hierarchy Level 6",
jl."Account Hierarchy Level 7",
jl."Account Hierarchy Level 8",
jl."Account Hierarchy Level 9",
jl."Account Hierarchy Level 10",
ch.cust_hier_cd,
ch.cust_hier_lvl0_nm,
ch.cust_hier_lvl1_nm,
ch.cust_hier_lvl2_nm,
ch.cust_hier_lvl3_nm,
ch.cust_hier_lvl4_nm,
ch.cust_hier_lvl5_nm,
ch.location_customer,
ch.industry_customer,
jl."Company Code",
jl."Company Hierarchy Level 1",
jl."Company Hierarchy Level 2",
jl."Company Hierarchy Level 3",
jl."Company Hierarchy Level 4",
jl."Company Hierarchy Level 5",
jl."Company Hierarchy Level 6",
jl."Company Hierarchy Level 7",
jl."Company Hierarchy Level 8",
jl."Company Hierarchy Level 9",
jl."Company Hierarchy Level 10",
jl."Department Code",
jl."Department Hierarchy Level 1",
jl."Department Hierarchy Level 2",
jl."Department Hierarchy Level 3",
jl."Department Hierarchy Level 4",
jl."Department Hierarchy Level 5",
jl."Department Hierarchy Level 6",
jl."Department Hierarchy Level 7",
jl."Department Hierarchy Level 8",
jl."Department Hierarchy Level 9",
jl."Department Hierarchy Level 10",
jl."Inter Company Code",
jl. "Inter Company Hierarchy Level 1",
jl. "Inter Company Hierarchy Level 2",
jl. "Inter Company Hierarchy Level 3",
jl. "Inter Company Hierarchy Level 4",
jl. "Inter Company Hierarchy Level 5",
jl. "Inter Company Hierarchy Level 6",
jl. "Inter Company Hierarchy Level 7",
jl. "Inter Company Hierarchy Level 8",
jl. "Inter Company Hierarchy Level 9",
jl. "Inter Company Hierarchy Level 10",
jl."Line of Business Code",
jl. "Line of Business Hierarchy Level 1",
jl. "Line of Business Hierarchy Level 2",
jl. "Line of Business Hierarchy Level 3",
jl. "Line of Business Hierarchy Level 4",
jl. "Line of Business Hierarchy Level 5",
jl. "Line of Business Hierarchy Level 6",
jl. "Line of Business Hierarchy Level 7",
jl. "Line of Business Hierarchy Level 8",
jl. "Line of Business Hierarchy Level 9",
jl. "Line of Business Hierarchy Level 10",
jl."Management Group Code",
jl. "Management Group Hierarchy Level 1",
jl. "Management Group Hierarchy Level 2",
jl. "Management Group Hierarchy Level 3",
jl. "Management Group Hierarchy Level 4",
jl. "Management Group Hierarchy Level 5",
jl. "Management Group Hierarchy Level 6",
jl. "Management Group Hierarchy Level 7",
jl. "Management Group Hierarchy Level 8",
jl. "Management Group Hierarchy Level 9",
jl. "Management Group Hierarchy Level 10",
jl."Source Country Code",
--src.lob_cd AS "Line of Business Code",-- Different code vs GL LOB codes
mdmph.BUSINESS_UNIT_DESC,
mdmph.PROD_LVL1_DESC,
mdmph.PROD_LVL2_DESC,
mdmph.PROD_LVL3_DESC,
mdmph.PROD_LVL4_DESC,
mdmph.PROD_LVL5_DESC,
mdmph.PROD_LVL6_DESC,

-- Value fields
jl."Credit Amount - Entered",
jl."Debit Amount - Entered",
jl."Net Amount - Entered",

jl."Credit Amount - Local",
jl."Debit Amount - Local",
jl."Net Amount - Local",

jl."Credit Amount - US",
jl."Debit Amount - US",
jl."Net Amount - US",

jl."Credit Amount - Accounted Local",                                                              
jl."Debit Amount - Accounted Local",
jl."Net Amount - Accounted Local",

jl."Credit Amount - Accounted USD",
jl."Debit Amount - Accounted USD",
jl. "Net Amount - Accounted USD",

-- Line description
case when (left ("Journal Entry Line Description", 23) = 'Revenue Contract Number') then 
RegExp_Replace("Journal Entry Line Description", '(Revenue Contract Number:. *)([0-9]*)','\2',1,1) else '' end AS "Contract Number",
''  AS item_nbr,
'' AS performance_obligation_number,
''  AS performance_obligation_line_number,
jl."Journal Entry Line Description",
jl."Journal Entry Source Name"

-- FROM 
from acc_ted_op_vw.gl_jrnl_entry_lines_dn jl -- Gl jounral entry lines dn
--FROM adltrd_finance.gl_jrnl_entry_lines_dn_20250730_vw JL -- datalab test
LEFT JOIN raw_erp_op_vw.all_modules_XLA_cur xla -- xla
ON jl."GL Code Combination ID"  = xla.code_combination_id
AND jl."Journal Entry Header ID"  = xla.je_header_id
AND jl."Journal Entry Line Number"   = xla.je_line_num
LEFT JOIN raw_erp_op_vw.customercontractheaders_cur cust-- Customer Contract Headers
ON cust.CustContHeadersCustomerContractNumber =  xla.SOURCE_ID_INT_1
AND cust.CustContHeadersLegalEntityId = xla.LEGAL_ENTITY_ID
LEFT JOIN raw_erp_op_vw.perfobligationlines_cur perf  --  Perf Obligation Lines
ON performance_obligation_number = perf.PerfObligationsPerfObligationNumber 
AND performance_obligation_line_number = perf.PerfObligationLinesPerfObligationLineNumber
LEFT JOIN
(SEL
document_line_id,
item_number,
src_attribute_char46,
src_attribute_char25 AS rev_cat,
src_attribute_char26 AS lob_cd, 
src_attribute_char22 AS end_cust_nbr, 
document_date,
source_documents_currency_code,
doc_id_int_1,
source_documents_bill_to_customer_id,
satisfaction_measurement_model
FROM  raw_erp_op_vw.sourcedocumentlines_cur  ---- source doc lines
GROUP BY 1,2,3,4,5,6,7,8,9,10,11
) src  -- Source Document Lines
ON perf.sourcedoclinesdocumentlineid = src.document_line_id
LEFT JOIN acc_tedfin_op_vw.cust_hier ch  --  Customer Hierarchy
ON ch.cust_hier_cd  = src.end_cust_nbr
LEFT JOIN raw_erp_op_vw.customeraccount_cur custacct  --- Customer account
ON src.SOURCE_DOCUMENTS_BILL_TO_CUSTOMER_ID = custacct .custaccountid
left join mdm_edw_sub.prod_hier_dim_vw mdmph  -- MDM product hierarchy
on mdmph.formatted_product_id = src.item_number
LEFT JOIN 
(
SEL 
accounting_period_name ,
begin_period_date,
end_period_date ,
accounting_yr_month
FROM tedw.accounting_period_name
) apn -- Accounting period name
ON apn.accounting_period_name = jl."Accounting Period Name"

-- Filters
WHERE accounting_yr_month IN 
(
SEL accounting_yr_month 
FROM tedw.accounting_period_name
WHERE end_period_date  < Add_Months (DATE,-1) 
)
and "Journal Entry Source Name" IN ('Cash Management','Receivables','Spreadsheet')
AND "Ledger Category Name" = 'Primary'
AND jl."Account Hierarchy Level 1" IN ('Total Revenues')
;