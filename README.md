# 🇧🇷 Brazilian E-Commerce Supply Chain Analysis

![Power BI Dashboard](dashboard.jpg)

## 📌 Project Overview
The Olist Store (a Brazilian e-commerce giant) faced a growing number of customer complaints regarding shipping delays. Management lacked visibility into whether these delays were a nationwide systemic failure or isolated to specific regions.

I analyzed a dataset of **99,000+ real orders** to pinpoint logistics bottlenecks, calculate delivery performance metrics, and build an interactive dashboard for the operations team.

## 💼 Business Problem
* **The Goal:** Identify which states have the highest "Late Delivery Risk" to renegotiate carrier contracts.
* **The Data:** 100k records covering orders, customers, and delivery timestamps (2016-2018).
* **The KPIs:** Total Volume, On-Time Delivery Rate (%), Average Delivery Time (Days).

## 🛠️ Tech Stack
* **SQL (MySQL):** Used for Data Extraction, Transformation, and Loading (ETL).
    * Performed `INNER JOINS` to merge customer location data with order timestamps.
    * Used `CASE` statements to flag late orders.
    * Aggregated data using `GROUP BY` and Window Functions.
* **Power BI:** Used for Data Visualization and Storytelling.
    * Created a "Master Table" data model for full interactivity.
    * Used **DAX** to calculate dynamic measures (`Late %`, `Avg Delivery Days`).
    * Implemented **Conditional Formatting** to highlight underperforming regions (Red vs. Blue).

## 🔍 Key Findings & Insights
1.  **The "Rio" Bottleneck:** While Sao Paulo (SP) has the highest order volume, it is highly efficient. **Rio de Janeiro (RJ)**, however, is a critical bottleneck with a **Late Delivery Rate of >12%**, which is double the national average.
2.  **Average Delivery Time:** The average shipping time across the country is **12.00 Days**.
3.  **Growth Trajectory:** The company saw explosive order volume growth from 2017 to 2018, correlating with the strain on logistics in coastal regions.
4.  **Peak Activity:** Customer purchasing activity peaks between **10 AM and 4 PM**, dropping significantly after 9 PM.

## 💻 SQL Logic Snippet
Here is the core logic used to categorize delivery performance before visualization:

```sql
SELECT 
    o.order_id,
    c.customer_state,
    o.purchase_date,
    -- Calculate delivery speed
    DATEDIFF(o.delivered_date, o.purchase_date) as actual_delivery_days,
    -- Flag late orders
    CASE 
        WHEN o.delivered_date > o.estimated_date THEN 'Late' 
        ELSE 'OnTime' 
    END as delivery_status
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id;
