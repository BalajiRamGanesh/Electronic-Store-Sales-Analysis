# Electronic Store: Sales and Customer Purchase Analysis

## Overview

This project analyzes electronic store sales and customer data to uncover purchasing patterns, evaluate product performance, and measure the impact of loyalty programs and customer demographics on overall sales.

## Objective

- Measure total sales, order volume, and average order value (AOV) across completed and cancelled orders
- Identify top-performing product categories and shipping methods
- Analyze customer segments based on loyalty status, gender, and purchase frequency
- Examine add-on purchase trends and their impact on overall revenue
- Track seasonal trends in AOV to evaluate promotional effectiveness
- Apply SQL and Power BI for data cleaning and analysis, and leverage Power BI to develop interactive reports and visualizations

## Data Description

- Data source : [Kaggle](https://www.kaggle.com/datasets/cameronseamons/electronic-sales-sep2023-sep2024)
- Rows : 20,000
- Columns : 16
- Time period: Sep 2023-Sep 2024 

## Tools Used

 - **MySQL** – Querying and analyzing data.
- **Power BI** – Data cleaning (Power Query), modeling (DAX), and dashboard creation.

## Data Cleaning & Engineering

- Handled missing and null values during preprocessing.
- Split multi-column add-on purchases into rows using Power Query to simplify analysis.
- Created new column order id and new table for Add-ons for establishing relationships between tables in the Power BI data model to enable cross-filtering.
- Created DAX measures for Total Sales, Average Order Value (AOV), and Add-ons Orders, along with dynamic titles based on order status. Also developed calculated columns such as Month Year and Customer Type to enhance analysis.

## Data Model

![Data Model](https://github.com/BalajiRamGanesh/Electronic-Store-Sales-Dashboard/blob/main/Images/Data%20Model.png?raw=true)

The Add-Ons table is created from the Electronic Sales table.

## Dashboard Preview

![Electronic Store Sales Dashoard](https://github.com/BalajiRamGanesh/Electronic-Store-Sales-Dashboard/blob/main/Images/Sales%20Dashboard.png?raw=true)

![Electronic Store Customer Purchase Behaviour Dashboard](https://github.com/BalajiRamGanesh/Electronic-Store-Sales-Dashboard/blob/main/Images/Purchase%20Behaviour%20Dashboard.png?raw=true)

## Key Insights

- The store recorded total sales revenue of $43.47 million from 73,650 units sold across 13,432 orders, resulting in an average order value (AOV) of $3,240. However, the store also experienced a loss of $21.38 million in sales, with 6,568 cancelled orders, a cancelled quantity of 36,061 units, and a lost AOV of $3,260.
- Smartphones generated the highest revenue of $14 million and recorded the highest number of orders at 4,004.
- Add-on purchases are nearly equally distributed across Impulse Items (6,568 purchases), Accessories (6,713 purchases), and Extended Warranty (6,713 purchases), indicating a balanced customer interest in all three categories.
- Standard delivery generated significantly higher sales compared to other shipping types.
- Average order values (AOV) saw a significant increase from the end of December to the first week of January, indicating a possible holiday or festival shopping surge.
- Loyalty members contributed to only 21.35% of total sales, amounting to $9.28 million, indicating lower engagement compared to non-members.
- Male and female customers exhibit similar purchasing behavior, with average order values of $3.2K and $3.3K respectively.
- Smartphones have the highest customer rating among other products, with a rating of 3.33, while Tablets have a rating of 3.03, and other product categories are near 3.
- Returning customers contribute to 47.3% of the total orders, highlighting their significant role in overall sales activity.

## Recommendations

- **Encourage active engagement** by offering better reward programs, cashback, and personalized deals to increase the number of active customers.
- **Promote smartphones and top selling products**  as they contribute the highest revenue and order volume.
- **Improve loyalty program participation** through targeted promotions and exclusive benefits, as loyalty members contribute significantly less in orders and sales.
- **Address high cancellation rates** by investigating common reasons for order cancellations and improving the checkout or shipping process.
- **Seasonal trends discounts** to increase more sales during holidays.
- **Focus on customer feedback** to understand the reasons behind low product ratings and improve product quality or customer support.
