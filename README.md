# SQL



# ✈️ Airline Loyalty Program Analysis  
**SQL Analytics Project | CLV • Churn • Profitability**

---

## 📌 Project Overview
This project analyzes a fictional airline loyalty program to answer **executive-level business questions** around customer value, churn risk, and program profitability.

The airline operates three tiers: `Star`, `Aurora`, and `Nova`.  
The goal is to determine:
- Whether loyalty tiers actually drive behavior  
- Where financial liability (unredeemed points) is concentrated  
- Which high-value customers are at risk of churn  

All analysis was performed in **SQL Server** using relational datasets.

---

## 🎯 Objective
Deliver **data-driven insights** that help the airline:
- Maximize **Customer Lifetime Value (CLV)**  
- Reduce **churn risk**  
- Optimize **loyalty program profitability**  

---

## 🚀 Key Business Goals
- 🔍 Identify high-value members (Top 10% CLV)
- ✈️ Validate whether higher tiers drive more flights
- ⚠️ Detect churn patterns across enrollment cohorts
- 💰 Quantify financial liability from unredeemed points
- 🌍 Analyze profitability by region
- 🎯 Build a **targeted retention (“save list”) strategy**

---

## 🧠 Skills Demonstrated

| Category | Skills |
|----------|--------|
| **SQL Server** | CTEs, Window Functions (`NTILE`, `LAG`, `SUM() OVER`), `PERCENTILE_CONT`, Date Functions |
| **Analytics** | Cohort Analysis, RFM Segmentation, Churn Analysis, CLV Modeling |
| **Business Thinking** | ROI Analysis, Customer Segmentation, Revenue Leakage Detection |
| **Data Quality** | NULL Handling, Join Validation, Outlier Filtering |
| **Communication** | Insight storytelling, Executive recommendations |

---

## 🗂️ Data Overview

### 1️⃣ `customer_loyalty_history` (Dimension Table)
- **Grain:** One row per customer  
- **Key Fields:**  
  `loyalty_number`, `country`, `province`, `city`, `education`,  
  `loyalty_card`, `CLV`, `enrollment_year`, `cancellation_year`,  
  `salary`, `marital_status`

### 2️⃣ `customer_flight_activity` (Fact Table)
- **Grain:** Monthly activity per customer  
- **Key Fields:**  
  `total_flight`, `distance`, `points_accumulated`,  
  `points_redeemed`, `dollar_cost_point_redeemed`

🔗 **Relationship:**  
`customer_loyalty_history` (1) → (N) `customer_flight_activity`

---

## ⚙️ Data Transformation Highlights
- 🔢 **Decile Segmentation:** `NTILE(10)` for top CLV members  
- 📆 **Time Indexing:** `year * 12 + month` for trend analysis  
- 🔁 **Churn Flag:** Derived from cancellation behavior  
- 💵 **Salary Bands:** For behavioral segmentation  
- 🟢 **Active Status:** Monthly activity indicator  
- 📊 **Liability Tracking:** Running balance of unredeemed points
  

---


## 📊 Business Questions Answered

| # | Business Question | Method |
|---|------------------|--------|
| 1 | Who are our most valuable members? | CLV decile analysis + demographic grouping |
| 2 | Do higher tiers fly more? | Compare avg flights, distance, points by tier |
| 3 | Where are we losing customers? | Churn rate by cohort + time-to-cancel |
| 4 | What is our points liability? | Running balance of unredeemed points |
| 5 | Who hoards vs redeems points? | Redemption rate by income & demographics |
| 6 | Which high-value customers are at risk? | CLV + inactivity + churn signals |
| 7 | Which regions are profitable? | Revenue vs redemption cost by region |

📁 SQL queries available in `/sql/` with full documentation.

---

## 💡 Key Insights & Recommendations

### 🏆 High-Value Segment
- Top 10% CLV concentrated in `Nova` tier  
- 📈 **Action:** Introduce VIP perks → expected +5% retention  

### ⚖️ Tier Optimization
- `Aurora` benefits outweigh behavior uplift  
- 📈 **Action:** Adjust thresholds or incentivize flights  

### ⚠️ Churn Risk
- 2023 cohorts show **28% churn spike**  
- 📈 **Action:** Improve onboarding + early engagement  

### 💰 Liability Risk
- Points liability grew **40% in Q4**  
- 📈 **Action:** Launch “points + cash” redemption campaigns  

### 🎯 Retention Opportunity
- 200+ high-CLV inactive customers identified  
- 📈 **Action:** Targeted offers → potential **80x ROI**

### 🌍 Regional Profitability
- Calgary profitable (+$82k) vs Halifax loss (-$19k)  
- 📈 **Action:** Geo-targeted pricing & rewards  

---

## 🧾 Conclusion
This project highlights strong **80/20 dynamics**:
- A small segment drives most revenue  
- Misaligned incentives reduce profitability  
- Churn is **predictable and preventable**  


---

## 👤 Author
**Yakubu Hamza Ugbedeojo**  
📧 mailx0hamza@gmail.com  

---
