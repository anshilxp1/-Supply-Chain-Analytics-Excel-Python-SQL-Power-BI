# 📦 Supply Chain Analytics — Excel, Python, SQL & Power BI

An end-to-end data analytics project that takes raw e-commerce supply chain data through cleaning, SQL-based business analysis, and an executive-style Power BI dashboard — built to answer real operational and business questions, not just display charts.

---

## Project Overview

This project analyzes a global e-commerce supply chain dataset (2015–2018, ~180,000+ order records across 5 markets) to uncover insights on sales performance, delivery reliability, product profitability, and customer behavior.

The project follows a complete analyst workflow:
**Excel (extraction & deduplication) → Python (cleaning & preprocessing) → SQL (business analysis) → Power BI (dashboard & storytelling)**

Each stage is kept in its own folder in this repository so the full workflow — not just the final dashboard — is visible and reviewable.

---

## Business Problem & Objectives

A supply chain business needs to know which markets, categories, and products drive revenue and profit, whether delivery performance meets customer expectations, whether discounting strategy is helping or hurting margin, and how much of the customer base returns versus buys only once. This project answers those questions by:

- Cleaning and structuring a multi-table, multi-year supply chain dataset
- Writing business-focused SQL queries covering joins, window functions, subqueries, and aggregation
- Building a 3-page, executive-style Power BI dashboard with DAX-driven KPIs
- Translating technical analysis into clear business insights and recommendations

---

## Dataset Description

Source: DataCo Smart Supply Chain dataset (5 related tables, ~180,519 order-line records, Jan 2015 – Jan 2018, 5 global markets: Pacific Asia, USCA, Africa, Europe, LATAM).

| Table | Description |
|---|---|
| `orders` | Order-line level data — sales, profit, discount, market, region, dates |
| `shipping` | One record per order — shipping mode, delivery status, scheduled vs. actual delivery days |
| `products` | Product catalog — name, category ID, price |
| `category` | Category ID mapped to category and department name |
| `customers` | Customer ID mapped to name, city, state, country |

---

## Tools & Technologies Used

- **Excel** — data extraction, duplicate removal
- **Python (pandas)** — data cleaning, null-value analysis, date standardization, feature preparation
- **MySQL** — relational database for SQL analysis (loaded via SQLAlchemy)
- **SQL** — joins, aggregation, window functions, subqueries
- **Power BI** — data modeling, DAX measures, interactive dashboard design
- **DAX** — KPI and time-intelligence calculations

---

## SQL Concepts Used

- Multi-table `JOIN`s (`INNER JOIN`, `LEFT JOIN`)
- `GROUP BY` and `HAVING`
- `CASE WHEN` for segmentation and bucketing
- Window functions — `RANK() OVER (PARTITION BY ...)`, `LAG()`
- Common Table Expressions (`CTE`s)
- Subqueries (correlated aggregate comparison)
- `NULL` handling / data-quality checks via `LEFT JOIN ... IS NULL`

12 business-focused queries were written — see `04_SQL_Queries/` for the full script with comments.

---

## Power BI Features Used

- 3-page report: **Executive Dashboard**, **Sales Analysis**, **Profitability & Delivery Analysis**
- Slicers: Market, Order Region, Category Name (consistent across all pages)
- Year and Month button-style filters
- Combo charts (dual-axis line + column) to pair volume metrics with rate/risk metrics
- Scatter chart for sales-quantity-vs-profit analysis by product
- Matrix visuals with conditional formatting / heatmap shading for category-by-month breakdowns
- KPI cards for headline business metrics

---

## DAX Measures Used

```dax
Total Sales = SUM(orders[Total Sales])

Total Orders = DISTINCTCOUNT(orders[Order Id])

Total Profit = SUM(orders[Benefit per order])

Profit Margin % = DIVIDE([Total Profit], [Total Sales], 0)

On-Time Delivery Rate = 
DIVIDE(
    CALCULATE(DISTINCTCOUNT(shipping[Order Id]), shipping[Delivery Status] = "Shipping on time"),
    DISTINCTCOUNT(shipping[Order Id]), 0
)

Late Delivery Rate = DIVIDE(SUM(shipping[Late_delivery_risk]), COUNTROWS(shipping), 0)

Avg Discount % = AVERAGE(orders[Order Item Discount Rate]) * 100

Avg Order Value = DIVIDE([Total Sales], [Total Orders], 0)
```

---

## Dashboard Features

- **Page 1 — Executive Dashboard:** headline KPIs, monthly sales trend, sales-vs-late-delivery combo chart, sales-vs-profit scatter, category sales bar chart, top 10 products table
- **Page 2 — Sales Analysis:** multi-line sales trend by category, expandable category-product matrix with heatmap shading and totals
- **Page 3 — Profitability & Delivery Analysis:** profit margin vs discount combo chart, order-volume trend, orders-by-delivery-status breakdown, category-by-month margin and discount matrices

---

## Key Insights

1. The **Fishing** category is the top-performing category by a wide margin, generating close to 6.9M in sales.
2. The single best-selling product accounts for roughly 6.93M in sales alone, making it the most important SKU in the catalog.
3. The dashboard's on-time delivery KPI currently shows an unusually low value, flagged for validation against the underlying measure logic before being treated as final.
4. Late-delivery risk stays consistently high (roughly 54–56%) across nearly every month, suggesting a systemic delivery issue rather than a one-off event.
5. Certain regions show a cancellation rate clearly above the company-wide average, worth investigating for fulfillment or fraud-related causes.
6. Some categories show large month-to-month swings in profit margin, suggesting inconsistent discounting or pricing practices.
7. Several catalog categories show no recorded sales activity at all, meaning the active product range is smaller than the full catalog suggests.
8. A meaningful share of the customer base are one-time buyers rather than repeat customers.
9. Net order volume trends downward toward the end of the dataset, consistent with the dataset simply ending in early 2018.
10. Shipping modes differ measurably in their on-time delivery percentage, useful evidence for reviewing carrier SLAs.

---

## Business Recommendations

- Validate the on-time delivery KPI before using it in any executive reporting.
- Introduce a discount cap for categories where profit margin clearly drops as discount rate increases.
- Launch a retention campaign targeting one-time customers.
- Prioritize inventory and marketing investment around the Fishing category and top 10 products.
- Review fulfillment processes in regions with above-average cancellation rates.
- Audit and consider retiring catalog categories with zero recorded sales.
- Standardize delivery SLAs by shipping mode based on actual performance data.
- ## 📁 Repository Structure

```text
└── Supply-Chain-Analytics-Excel-Python-SQL-Power-BI/
    ├── Dashboard/                # Interactive Power BI / Tableau dashboard files
    ├── Excel_work/               # Cleaned data, pivot tables, and Excel analysis
    ├── Python_work/              # Jupyter Notebooks for EDA and data preprocessing
    ├── Report/                   # Documentation and executive summary reports
    ├── SQL_work/                 # SQL scripts for database creation and queries
    ├── dashboard_pdf             # Exported PDF version of the final dashboard
    └── DataCoSupplyChainDataset.xlsx  # Raw supply chain dataset

## Learning Outcomes

- Practiced a complete, connected analyst workflow across four tools instead of a single-tool exercise


## 👤 Author

**Anshil Gautam** — B.Tech CSE | Data Analytics  

