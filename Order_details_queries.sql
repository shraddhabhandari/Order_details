select * from Order_details

--Q1. Get total revenue generated for each channel. Which channel is most profitable?
    select channel,
      ROUND(SUM(revenue),2) as total_revenue,
      ROUND(SUM(profit),2) as total_profit
      from Order_details
      group by channel
      order by channel

--Q2. Find pct of orders delivered vs other status for each region
      Select 
      region,
      ROUND(100*SUM(case when order_status='Delivered' then 1 else 0 end)/Count(*),2) AS del_pct,
      ROUND(100*SUM(case when order_status!='Delivered' then 1 else 0 end)/Count(*),2) AS other_pct
      from Order_details
      group by region

--Q3. Which products drive maximum profit
      With cte as
      (select product_name,
        sum(profit) as total_profit
        from Order_details
        group by product_name)

        select top 3 product_name, max(total_profit) as max_profit from cte
        group by product_name
        order by max(total_profit) desc
       

--Q4 Calculate total revenue and sales for each product
      select product_name,
      sum(revenue) as revenue,
      count(order_id) as sales
      from Order_details
      group by product_name
      order by sum(revenue) desc

      select product_name,
          count(customer_id) as sales
          from Order_details
          group by product_name
          order by count(customer_id) desc

--Q5 What is the most common payment method among customers
     select top 1 payment_method,
     count(customer_id) as sales
      from order_details
      group by payment_method
      order by count(customer_id) desc

--Q6 Find total sales for each region. Which is most profitable?
     select region, count(*) as sales,
      sum(profit) as total_profit
     from order_details
     group by region
     order by region

?-- Q7 Are discounts eating out profit? (discount_pct)
      select 
      sum(unit_price*units_sold) as total_price,
       sum(discount_pct) as discount,
       sum(revenue) as revenue,
       sum(profit) as profit
       from order_details


--Q8 Reveue & profit over time
     select year(order_date) as year,
     month(order_date) as month,
     sum(revenue) as revenue,
     sum(profit) as profit
     from Order_details
     group by year(order_date), month(order_date)

--Q9 Which are most valuable customers? 
-- Find Total revenue per customer, Total profit per customer, 
--Frequency of orders, Average order value per customer
select distinct customer_name,
       sum(revenue) as revenue,
       sum(profit) as profit,
       count(order_id) as orders,
       avg(cost) as order_value
       from order_details
       group by customer_name
       order by customer_name

-- Q10. What are high profit orders? and customer for highest profit order
      select order_id,
      customer_name,
             product_name,
             sum(profit) as profit
            from Order_details
            where profit IN (select max(profit) from Order_details)
            group by order_id, customer_name, product_name
            order by order_id

--Q11. Total repeat customers/ orders more than 1
        select customer_id,
             customer_name,
             count(order_id) as cnt
             from Order_details
             group by customer_id, customer_name
             having count(order_id)>1
             order by customer_id

    --% of customers who are repeat buyers
     SELECT
    ROUND(COUNT(DISTINCT CASE WHEN total_orders > 1 THEN customer_id END) * 100.0
    / COUNT(DISTINCT customer_id),2) AS repeat_customer_percentage
    FROM (
    SELECT customer_id, COUNT(order_id) AS total_orders
    FROM Order_Details
    GROUP BY customer_id
     ) t;