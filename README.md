

# Olist E-Commerce Analysis

E-Commerce nalysis of 100,000 Brazilian e-commerce orders exploring what drives late deliveries and customer dissatisfaction — including a machine learning model that predicts late orders before they happen.

## Business Question
What causes late deliveries, how do they affect customer satisfaction, and can we predict which orders are at risk?

## Tools & Technologies
- **SQL (MySQL)** — exploratory analysis, multi-table joins, delivery performance queries
- **Python (pandas, matplotlib, seaborn, scikit-learn)** — data cleaning, feature engineering, visualization, logistic regression model
- **Power BI** — interactive dashboard (in progress)

## Dataset
Brazilian E-Commerce Public Dataset by Olist — 100,000 orders across 9 relational tables.
Source: [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Key Findings
1. **Late deliveries devastate reviews** : on-time orders average 4.29 stars, late orders average 2.57. The gap widens sharply beyond 8 days late.
2. **Seller location is the strongest predictor** : sellers in AM (Amazonas) have a 33% late rate vs the national average of 6.6%. MA (Maranhão) follows at 19%.
3. **Extreme delays drive the worst outcomes** : orders 15+ days late collapse to ~1.7 stars. Fixing extreme cases would have the highest impact on satisfaction.
4. **Category is a weak predictor** — all major product categories cluster between 5-8% late rate, confirming the problem is logistical not product-related.

## Machine Learning Model
Built a logistic regression model to predict whether an order will be late using seller state, customer state, price, freight value and product category.
- Addressed class imbalance (6.6% late rate) using `class_weight='balanced'`
- Achieved 51% recall on late orders — catches half of at-risk orders before delivery
- Key limitation: label encoding of categorical variables limits direct coefficient interpretability : one-hot encoding would improve this

## Project Structure
- `olist_analysis.sql` — 8 exploratory queries covering delivery performance, seller analysis and category breakdown
- `olist_analysis.ipynb` — full Python notebook: data loading, cleaning, visualization and ML model
- `late_by_state.csv` — aggregated late rate by seller state
- `late_by_category.csv` — aggregated late rate by product category



