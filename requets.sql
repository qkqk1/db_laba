--1)


SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    CASE 
        WHEN p.product_category_name LIKE 'moveis%' THEN 'furniture'
        WHEN p.product_category_name = 'eletronicos' THEN 'electronics'
        WHEN p.product_category_name = 'brinquedos' THEN 'toys'
        ELSE p.product_category_name
    END AS category,
    COUNT(*) AS items_count
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
WHERE 
    c.customer_city = 'belo horizonte'
    AND (
        p.product_category_name = 'eletronicos' 
        OR p.product_category_name = 'brinquedos'
        OR p.product_category_name LIKE 'moveis%'
    )
GROUP BY 
    month, 
    CASE 
        WHEN p.product_category_name LIKE 'moveis%' THEN 'furniture'
        WHEN p.product_category_name = 'eletronicos' THEN 'electronics'
        WHEN p.product_category_name = 'brinquedos' THEN 'toys'
        ELSE p.product_category_name
    END
ORDER BY 
    category, month;


--2)


SELECT 
    t.product_category_name_english AS category,
    COUNT(*) AS cancelled_orders_count
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE 
    c.customer_state = 'RJ'
    AND o.order_status = 'canceled'
    AND p.product_category_name IS NOT NULL
GROUP BY 
    category
ORDER BY 
    cancelled_orders_count DESC;


--3)


WITH order_totals AS (
    SELECT 
        o.order_id,
        c.customer_state,
        SUM(op.payment_value) AS order_total
    FROM 
        orders o
    JOIN 
        customers c ON o.customer_id = c.customer_id
    JOIN 
        order_payments op ON o.order_id = op.order_id
    WHERE 
        c.customer_state IN ('SP', 'PE')
    GROUP BY 
        o.order_id, c.customer_state
)

SELECT 
    customer_state AS state,
    AVG(order_total) AS avg_check
FROM 
    order_totals
GROUP BY 
    customer_state;


--4)

SELECT customer_id, COUNT(*) 
FROM orders 
GROUP BY customer_id 
HAVING COUNT(*) > 1 
ORDER BY COUNT(*) DESC 
LIMIT 10;
