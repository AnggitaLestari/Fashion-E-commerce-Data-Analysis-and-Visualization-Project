# Fashion E-commerce Data Analysis and Visualization Project

## Table of Contents
1. [Project Overview](#project-overview)
2. [Dataset](#dataset)
3. [Entity-Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
4. [Data Processing with Python](#data-processing-with-python)
5. [Business Case Analysis](#business-case-analysis)
6. [Dashboard Metrics](#dashboard-metrics)
7. [Dashboard Visualization](#dashboard-visualization)
8. [Key Insights](#key-insights)
9. [Tools Used](#tools-used)
10. [How to Run](#how-to-run)
11. [Conclusion and Connect with Me](#conclusion-and-connect-with-me)

## Project Overview
This project showcases a comprehensive analysis of a fashion e-commerce dataset, demonstrating skills in data engineering, SQL querying, and data visualization. The goal is to derive meaningful insights from sales data to inform marketing strategies and business decisions.

## Dataset
The project utilizes a fashion e-commerce dataset containing information about users, items, and sales records. The data is initially stored in SQL format and processed using Python and PostgreSQL.

**[Fashion_E-commerce Dataset (sql file)](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/fashion_dataset.sql)**

## Entity-Relationship Diagram (ERD)
The database schema for this project consists of three main tables: users, items, and sales_records. Here's a description of each table and their relationships:

### Users Table
- Primary Key: id (serial)
- Columns: 
  - name (varchar)
  - gender (integer)
  - age (integer)

### Items Table
- Primary Key: id (serial)
- Columns:
  - name (varchar)
  - gender (integer)
  - price (integer)
  - cost (integer)

### Sales_Records Table
- Primary Key: id (serial)
- Foreign Keys:
  - user_id (references Users table)
  - item_id (references Items table)
- Columns:
  - purchased_at (date)

### ERD Diagram
![ERD Diagram](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/ERD.JPG?raw=true)

### Relationships:
- A User can have many Sales_Records (one-to-many)
- An Item can be in many Sales_Records (one-to-many)
- A Sales_Record belongs to one User and one Item (many-to-one for both)

This ERD represents a typical e-commerce database structure where users can purchase multiple items, and each sale is recorded with details of the user, the item, and the purchase date. The gender field in both Users and Items tables allows for gender-specific analysis of both customers and products.

## Data Processing with Python

**[Fashion_E-commerce Data Processing (Python file)](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/fashion.py)**

The data processing phase involves several steps to prepare and transform the data for analysis. Here's a detailed breakdown of the process:

1. **Reading the SQL File**
   The Python script starts by reading the `fashion_dataset.sql` file containing the initial dataset.

   ```python
   with open('fashion_dataset.sql', 'r') as file:
       sql_content = file.read()
   ```

2. **Parsing SQL Commands**
   The SQL content is parsed to separate individual SQL commands.

   ```python
   sql_commands = re.split(r';\s*$', sql_content, flags=re.MULTILINE)
   ```

3. **Database Connection**
   A connection to PostgreSQL is established using psycopg2.

   ```python
   conn = psycopg2.connect(
    dbname="database name",
    user="your user name",
    password="your password",
    host="host name",
    port="port number"
   )

   cursor = conn.cursor()
   ```

4. **Executing SQL Commands**
   Each SQL command is executed to create and populate the necessary tables.

   ```python
   for command in sql_commands:
     if command.strip():
         command = re.sub(r'--.*$', '', command, flags=re.MULTILINE)
         try:
             cursor.execute(command)
             conn.commit()
         except psycopg2.Error as e:
             print(f"Error executing command: {e}")
             conn.rollback()
         else:
             conn.commit()
   ```

5. **Data Transformation**
   After the initial data load, we perform specific transformations on the 'gender' column in both the 'users' and 'items' tables.

   - **Altering column type:**

     ```python
     alter_users = "ALTER TABLE users ALTER COLUMN gender TYPE VARCHAR(10);"
     alter_items = "ALTER TABLE items ALTER COLUMN gender TYPE VARCHAR(10);"
     ```

   - **Transforming gender values:**

     *For users table:*
     ```python
     transform_users = """
     UPDATE users
     SET gender = CASE
         WHEN gender = '0' THEN 'Male'
         WHEN gender = '1' THEN 'Female'
         ELSE 'Other'
     END;
     """
     ```

     *For items table:*
     ```python
     transform_items = """
     UPDATE items
     SET gender = CASE
         WHEN gender = '0' THEN 'Male'
         WHEN gender = '1' THEN 'Female'
         WHEN gender = '2' THEN 'Other'
         ELSE 'Other'
     END;
     """
     ```

6. **Executing Transformations**
   The transformation queries are executed:

   ```python
   try:
       cursor.execute(alter_users)
       cursor.execute(alter_items)
       cursor.execute(transform_users)
       cursor.execute(transform_items)
       conn.commit()
       print("Transformation completed successfully.")
   except psycopg2.Error as e:
       print(f"Error during transformation: {e}")
       conn.rollback()
   ```

7. **Closing Database Connection**
   Finally, the cursor and database connection are closed, and a completion message is printed:

   ```python
   cursor.close()
   conn.close()

   print("All operations completed.")
   ```

This process ensures that the data is properly loaded into the PostgreSQL database and transformed to a format suitable for analysis. The gender values are converted from numeric codes to descriptive strings, making the data more interpretable for subsequent analysis and visualization steps.

## Business Case Analysis

**[Fashion_E-commerce Business Case Analysis (sql file)](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Business_Case_Analysis_Query.sql)**

Several SQL queries were developed to answer specific business questions. For each query, we provide the actual results as captured in images:

1. **Most Sold Product and Date**:
   * Identifies the product with the highest sales and the date it occurred.
   * Result:

     ![Most Sold Product and Date](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/Result.SQL.1._Most%20Sold%20Product%20and%20Date.JPG?raw=true)
   * This image shows the item ID, product name, quantity sold, and the date of highest sales.

2. **Top Customer by Quantity**:
   * Finds the customer who purchased the most items.
   * Result:

     ![Top Customer by Quantity](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/Result.SQL.2._Top%20Customer%20by%20Quantity.JPG?raw=true)
   * This result displays the customer name and their total number of purchases.

3. **Total Cost Analysis**:
   * Calculates the total cost for purchasing 'Jaket Kulit' (Leather Jacket).
   * Result:

     ![Total Cost Analysis](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/Result.SQL.3._Total%20Cost%20Analysis_Jaket%20Kulit.JPG?raw=true)
   * This table shows the product name, unit cost, number of purchases, and total cost for the leather jacket.

4. **Active User Analysis**:
   * Determines the number and percentage of active users.
   * Result:

     ![Active User Analysis](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/Result.SQL.4._Active%20User%20Analysis.JPG?raw=true)
   * This result displays the total number of users, number of active users, and the percentage of active users.

5. **User Purchasing Behavior**:
   * Analyzes average purchase frequency, average expenditure, and average expenditure per purchase for active users.
   * Results:

     ![User Purchasing Behavior - Frequency](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/Result.SQL.5a._Analyzes%20average%20purchase%20frequency.JPG?raw=true)

     ![User Purchasing Behavior - Average Expenditure](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/Result.SQL.5b._average%20expenditure.JPG?raw=true)

     ![User Purchasing Behavior - Average Expenditure per Purchase](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/Result.SQL.5c._average%20expenditure%20per%20purchase%20for%20active%20users.JPG?raw=true)
   * These images show the total purchases, number of active users, average purchase frequency, average expenditure per user, and average expenditure per purchase.

These query results provide valuable insights into product performance, customer behavior, and overall business metrics, enabling data-driven decision-making for marketing strategies and inventory management.

## Dashboard Metrics

**[Fashion_E-commerce Business Dashboard Metrics Query (sql file)](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/metrics_dashboard.sql)**

**[Fashion_E-commerce Business Dashboard Metrics Result (csv file)](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/tree/main/CSV_metrics_dashboard)**

The following SQL queries were used to generate metrics for the dashboard:

1. **Product Sales Performance**

This metric provides insights into the sales performance of each product, including quantity sold and total revenue.

```sql
SELECT 
  i.name AS product_name,
  i.price,
  COUNT(*) AS total_quantity_sold,
  SUM(i.price) AS total_revenue
FROM sales_records sr
JOIN items i ON sr.item_id = i.id
GROUP BY i.name, i.price
ORDER BY total_quantity_sold DESC
```

***Expected output***:

```
product_name    | price | total_quantity_sold | total_revenue
----------------|-------|---------------------|---------------
kaos putih      |    20 |                  68 |          1360
kaos polo putih |    30 |                  65 |          1950
celana denim    |    60 |                  61 |          3660
sweater         |    34 |                  58 |          1972
rok             |    40 |                  52 |          2080
```

2. **Daily Product Sales Report**

This report shows the daily sales for each product, including quantity sold and total sales.

```sql
SELECT
  DATE(sr.purchased_at) AS sale_date,
  sr.item_id, i.name, i.price,
  COUNT(*) AS quantity_sold,
  (price * count(*)) as total_sales
FROM sales_records sr
JOIN items i ON sr.item_id = i.id
GROUP BY sr.purchased_at, sr.item_id, i.price, i.name
```

***Expected output***:

```
sale_date   | item_id | name       | price | quantity_sold | total_sales
------------|---------|------------|-------|---------------|------------
2018-07-01  |      28 | hoodie abu |    42 |             1 |          42
2018-07-01  |       8 | celana pen |    32 |             1 |          32
2018-07-01  |      17 | sepatu lar |    75 |             2 |         150
2018-07-01  |      22 | skinny jea |    32 |             1 |          32
2018-07-01  |      19 | skinny jea |    38 |             1 |          38
```

3. **User Activation Overview**

This metric provides an overview of user activation, showing the total number of users, active users, and the percentage of active users.

```sql
SELECT
  COUNT(DISTINCT users.id) AS total_users,
  COUNT(DISTINCT sales_records.user_id) AS active_users,
  COUNT(DISTINCT sales_records.user_id) * 100.0 / 
  COUNT(DISTINCT users.id) AS active_user_percentage
FROM users
LEFT JOIN sales_records ON users.id = sales_records.user_id
```

***Expected output***:

```
total_users | active_users | active_user_percentage
------------|--------------|-------------------------
        325 |          283 |        87.0769230769231
```

4. **Customer Purchase Frequency by Age Group**

This report shows the purchase frequency of customers categorized by age groups.

```sql
SELECT
  u.name AS customer_name,
  COUNT(sr.id) AS total_purchases,
  u.age AS age_customer,
  CASE
    WHEN u.age BETWEEN 13 AND 22 THEN 'Teenagers'
    WHEN u.age BETWEEN 23 AND 34 THEN 'Young Adults'
    WHEN u.age BETWEEN 35 AND 49 THEN 'Middle-aged Adult'
    WHEN u.age >= 50 THEN 'Senior Adults'
    ELSE 'Unidentified'  
  END AS age_group
FROM users u
LEFT JOIN sales_records sr ON u.id = sr.user_id
GROUP BY u.name, u.age
ORDER BY total_purchases DESC
```

***Expected output***:

```
customer_name | total_purchases | age_customer | age_group
--------------|-----------------|--------------|------------
Hobie         |              11 |           24 | Young Adults
Burch         |              10 |           33 | Young Adults
Sam           |               9 |           25 | Young Adults
Cale          |               8 |           33 | Young Adults
Conrade       |               8 |           40 | Middle-aged Adult
```

5. **Customer Purchases by Gender**

This metric shows the distribution of customer purchases by gender.

```sql
SELECT 
  gender,
  COUNT(DISTINCT user_id) AS num_customers,
  SUM(i.price) AS total_purchases
FROM sales_records sr
JOIN items i ON sr.item_id = i.id
GROUP BY gender
ORDER BY total_purchases DESC
```

***Expected output***:

```
gender | num_customers | total_purchases
-------|---------------|------------------
Female | 158           | 26055
Male   | 89            | 14730
Other  | 36            | 5994
```

6. **Product Profitability Analysis**

This analysis provides insights into the profitability of each product, considering revenue and cost.

```sql
WITH revenue AS (
  SELECT
    i.name AS product_name,
    i.price AS price,
    i.cost AS cost_per_unit,
    COUNT(*) AS total_quantity_sold,
    SUM(i.price) AS total_revenue
  FROM sales_records sr
  JOIN items i ON sr.item_id = i.id
  GROUP BY i.name, i.price, i.cost
)
SELECT
  product_name,
  price,
  cost_per_unit,
  total_quantity_sold,
  total_revenue,
  ROUND(total_revenue - (total_quantity_sold * cost_per_unit), 2) AS total_profit
FROM revenue
ORDER BY total_profit DESC
```

***Expected output***:

```
product_name    | price | cost_per_unit | total_quantity_sold | total_revenue | total_profit
----------------|-------|---------------|---------------------|---------------|-------------
celana denim    |    60 |            26 |                  61 |          3660 |      2074.00
kaos polo putih |    30 |            12 |                  65 |          1950 |      1170.00
rok             |    40 |             8 |                  52 |          2080 |      1664.00
kaos putih      |    20 |             8 |                  68 |          1360 |       816.00
sweater         |    34 |             2 |                  58 |          1972 |      1856.00
```

These metrics provide a comprehensive overview of the e-commerce platform's performance, including product sales, user activation, customer behavior, and profitability analysis.

## Dashboard Visualization

The dashboard provides a visual representation of the key metrics and insights derived from our data analysis. Here's a snapshot of one of the visualizations:

![Fashion E-commerce Sales Dashboard](https://github.com/AnggitaLestari/Fashion-E-commerce-Data-Analysis-and-Visualization-Project/blob/main/Picture/Fashion_E-commerce_Sales_Dashboard.jpg?raw=true)

For a more comprehensive view of all visualizations and interactive features, you can access the full dashboard on Looker Studio:

### [View Full Dashboard on Looker Studio](https://lookerstudio.google.com/reporting/aa992b57-39bd-42fe-a659-6ef298caf92c)

This dashboard presents a holistic view of our e-commerce data, including sales trends, product performance, customer demographics, and more. It's designed to provide actionable insights for business decision-making.

## Key Insights

From the dashboard visualization and SQL analysis, we can derive several key insights:

1. **Overall Performance:**
   - Total revenue: 46,779 (currency units)
   - Total quantity sold: 910 items
   - Total users: 325
   - Active user percentage: 87%

2. **Daily Sales Trend:**
   - The sales trend shows fluctuations over time, with some notable peaks and troughs.
   - This information can be used for inventory management and promotional planning.

3. **Top Selling Products:**
   - The best-selling product is "kaos putih" (white t-shirt) with 68 units sold and 1,360 in revenue.
   - Other top-selling items include "kaos polo putih", "celana denim", "sweater", and "rok".

4. **Customer Leaderboard:**
   - The top 5 customers by purchase frequency are identified, with "Hobie" leading the list.

5. **Product Cost Analysis:**
   - The chart shows the cost, price, and profit for different products.
   - "Jaket kulit" (leather jacket) appears to have the highest profit margin.

6. **Customer Demographics:**
   - Gender Distribution: Female customers dominate with 55.7% of purchases, followed by Male (31.5%) and Other (12.9%).
   - Age Groups: Young Adults are the most active buyers (51.9%), followed by Middle-aged Adult (22.1%), Teenagers (17.4%), and Senior Adults (8.7%).

These insights can be used to inform marketing strategies, inventory management, and customer engagement initiatives. For example, the business could:
- Focus on expanding the range of popular items like t-shirts and denim pants.
- Develop targeted marketing campaigns for the young adult demographic.
- Investigate why certain products have higher profit margins and potentially adjust pricing or promotion strategies.
- Implement a loyalty program to encourage repeat purchases from top customers.
- Plan promotions or stock increases around peak sales days identified in the daily trend.

## Tools Used
- Python
- PostgreSQL
- SQL
- Looker Studio

## How to Run
1. Ensure you have Python and PostgreSQL installed.
2. Clone this repository.
3. Install required Python packages: `pip install psycopg2`
4. Update the database connection details in the Python script.
5. Run the Python script to process and transform the data.
6. Execute the SQL queries to perform business case analysis.
7. Use the processed data to create visualizations in Looker Studio.

Note: The Looker Studio dashboard is not directly runnable from this repository. Please refer to the dashboard link provided separately.

## Conclusion and Connect with Me
Thank you for exploring this Fashion E-commerce Data Analysis and Visualization Project. I hope you found the insights valuable and the methodologies informative.

### Explore More Projects
If you enjoyed this project, you might be interested in checking out some of my other work:

1. [End-to-End Pipeline and Visualization for Bikeshare](https://github.com/AnggitaLestari/End-to-end-pipeline-and-visualization-for-bikeshare)
2. [Mock Test BIA-BIE Project](https://github.com/AnggitaLestari/Mocktest-BIA-BIE)

### Let's Connect!
I'm always excited to connect with fellow data enthusiasts, professionals in the BI field, or anyone interested in data-driven insights and analytics. Whether you have questions about this project, want to discuss potential collaborations, or wish to share ideas, I'd love to hear from you!

- 💼 Connect with me on [LinkedIn](https://www.linkedin.com/in/4nggitalestari)
- 📧 Email me at anggitalestari@gmail.com
- 🌐 Check out [my GitHub profile](https://github.com/AnggitaLestari) for more projects

I'm passionate about continuous learning and improving in Business Intelligence and Data Analytics. 

Your feedback, questions, or insights are always welcome and appreciated.

Thank you for visiting this repository. Let's keep learning, coding, and making data-driven decisions! 🚀📊


