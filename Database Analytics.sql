/* 1. The total number of vendors types and their transaction value, 
which would help them know the most important vendor types.*/
select Vendor_Type, sum(Value) as `Total Value`
from vendor
inner join transaction
on transaction.Vendor_Name =  vendor.Vendor_Name
group by Vendor_Type
order by sum(Value) desc;

/* 2. The quarterly breakdown of packaging costs.*/
select sum(Value) as `Total Value`, Quarter
from transaction
inner join time 
on transaction.`Order Date` = time.Date
group by Quarter
order by sum(Value) desc;

/* 3. The total number of transactions based on the number of receipts 
broken down by quarter.*/
select count(distinct(`Receipt No.`)) as `Total Transactions`, quarter
from transaction
inner join time 
on transaction.`Order Date` = time.Date
group by Quarter
order by `Total Transactions` desc;

/* 4. The total cost of transactions divided by city and state. 
This would help them to know the areas where the spend is higher.*/
select City, State, sum(Value) as `Total Value`
from transaction
inner join vendor on vendor.Vendor_ID = transaction.Vendor_ID
inner join vendor_location on vendor.Vendor_ID = vendor_location.Vendor_ID
inner join location on vendor_location.zip_code = location.Zipcode
group by City, State
order by `Total Value` desc;

/* 5. The city and state of each vendor to keep track of the supply chain.*/
select city, state, Vendor_ID
from location
inner join vendor_location on vendor_location.zip_code = location.zipcode
group by city, state;

/* 6. Segregated data for each month and analyze the monthly rise in costs.*/
select sum(Value) as `Total Value`, month
from transaction
inner join time 
on transaction.`Order Date` = time.Date
group by month
order by month;

/* 7. The average transaction cost each year and 
how pandemic has affected the supply chain.*/
select avg(Value) as `Average Transaction Value`, Year
from transaction
inner join time
on time.Date = transaction.`Order Date`
group by year
order by year desc;

/* 8. The costliest vendors to work with in 2021. 
This could help them analyze which vendors to negotiate with.*/
select vendor.Vendor_ID, Vendor_Type, sum(Value) as `2021 Value`
from vendor
inner join transaction on transaction.Vendor_ID = vendor.Vendor_ID
inner join time on transaction.`Order Date` = time.Date
where year = 2021
group by Vendor_Type
order by `2021 Value` desc
limit 1;

/* 9. The cheapest vendors to work with which would help them to increase profits.*/
select vendor.Vendor_Name, sum(Value) as `2021 Value`
from vendor
inner join transaction on transaction.Vendor_ID = vendor.Vendor_ID
inner join time on transaction.`Order Date` = time.Date
where year = 2021
group by Vendor_Name
order by `2021 Value`
limit 5;

/* 10. The vendors with which the company has done maximum business with 
since the vendors were active.*/
select transaction.Vendor_ID, count(`Receipt No.`) as `Number of Transactions`,
count(`Receipt No.`)/(year(now()) - active_since) as 'Average Transactions per year'
from vendor_location
inner join vendor on vendor.Vendor_ID = vendor_location.Vendor_ID
inner join transaction on transaction.Vendor_ID = vendor.Vendor_ID
group by transaction.Vendor_ID
order by count(`Receipt No.`)/(year(now()) - active_since) desc
limit 3;
