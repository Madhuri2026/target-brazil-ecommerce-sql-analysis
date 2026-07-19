# Target Brazil E-commerce Business Analysis
Full findings, interpretations and recommendations from the SQL analysis of 1,00,000+ Target Brazil orders (2016-2018).

## I. Exploratory Analysis

### Findings
- The dataset contains orders placed between 4 September 2016 and 17 October 2018.
- Customers placed orders from 4,119 cities across 27 Brazilian states.

Business Interpretation: 

- Target has established a broad geographic presence across Brazil, providing sufficient coverage to analyze regional customer behavior and operational performance.

## II. In-depth Exploration

### Finding 1 - Annual order growth

| Year | Orders |
|-----:|-------:|
| 2016 | 329 |
| 2017 | 45,101 |
| 2018 | 54,011 |

Orders increased by approximately 13,600% from 2016 to 2017, reflecting Target's early-stage hyper-growth phase in Brazil. Growth continued into 2018 but at a much slower rate (~20% YoY), suggesting the business is transitioning from explosive acquisition to a more mature growth phase.

Business Interpretation: 

- The deceleration in 2018 is a strategic signal. 
- At this stage, acquiring new customers becomes more expensive while retaining existing ones becomes more valuable.
- Target should invest in loyalty programmes, repeat-purchase incentives, and personalised recommendations to maintain revenue momentum without relying solely on new customer acquisition.

### Finding 2 - Monthly seasonality

- Monthly orders grew steadily from 800 in January 2017 to a peak of over 7,500 in November 2017.
- A significant spike in November 2017 is consistent.
- Order volumes stabilised in 2018 at approximately 6,000–7,000 orders per month.
- By October 2018 (end of dataset), order counts drop sharply — likely a data truncation effect rather than a business decline

Business Interpretation:

- November is a reliably high-demand period. This is not a one-time anomaly — it is a predictable seasonal pattern that should be built into annual planning. 
- Target should begin scaling logistics capacity, warehouse stock, and customer support bandwidth from September onwards each year to handle the November surge without delivery delays or stockouts, which would damage customer satisfaction at the highest-volume point of the year.


### Finding 3 - Time of day ordering pattern 

| Time of Day | Hours | Orders |
|------------|:------:|-------:|
| Afternoon | 13:00–18:00 | 38,135 |
| Night | 19:00–23:00 | 28,331 |
| Morning | 07:00–12:00 | 27,733 |
| Dawn | 00:00–06:00 | 5,242 |

Brazilian customers place 38% of all orders in the afternoon (13:00–18:00). Afternoon volume is 7.3× higher than dawn and meaningfully higher than night or morning.

Business Interpretation: 

- This is one of the most immediately actionable findings in the dataset. 
- All time-sensitive customer-facing activity — flash sales, push notifications, email campaigns, limited-time offers — should be scheduled to launch between 13:00 and 16:00 Brazil local time to intercept customers at peak purchase intent. 
- Dawn-hour campaigns are largely wasted spend.

## III. Regional Distribution

### Finding 1 - Month on Month order by State

State-level monthly order data shows that order growth is heavily concentrated in a small number of states, particularly São Paulo (SP), while remote northern states like RR, AP, and AC show consistently low order volumes throughout the period.

### Finding 2 - Customer distribution across States

- The majority of Target's customer base is concentrated in SP, RJ, MG, RS, and PR.
- Remote northern states represent a tiny fraction of total customers but face disproportionately high freight and delivery burderns.

Business Interpretation:

- São Paulo is the operational centre of gravity for Target Brazil. Any logistics optimisation, warehouse placement, or promotional investment will have the highest return when directed at SP and its neighbouring states first. 
- However, the northern states, though small in volume represent an underserved segment where poor delivery experience is likely suppressing demand. Improving logistics in these regions could unlock latent growth.

## IV. Economic Impact 

### Finding 1 - Total and average order value by state

| State | Total Value (R$) | Avg Value (R$) |
|:-----:|-----------------:|---------------:|
| SP | Highest total | — |
| AC | 19,680.62 | 234.29 |
| AL | 96,962.06 | 227.08 |
| AM | 27,966.93 | 181.60 |
| BA | 616,645.82 | 170.82 |

SP generates the highest total revenue by a significant margin, consistent with its dominant customer share. Interestingly, some smaller states (AC, AL, AP) show higher average order values than larger states, suggesting that customers in these regions may be purchasing higher-ticket items despite lower overall volumes.

Business Interpretation:

- High average order value in low-volume states is worth investigating further. It may indicate that customers in remote regions are willing to consolidate purchases into fewer, larger orders to justify high freight costs. 
- If true, this is a pricing and bundling opportunity — offering freight discounts or bundle deals for orders above a threshold could increase both conversion and basket size in these markets.

### Finding 2 - Total and average freight by state 

| State | Total Freight (R$) | Avg Freight (R$) |
|:-----:|-------------------:|-----------------:|
| SP | 718,723.07 | 15.15 *(Lowest)* |
| RJ | 305,589.31 | 20.96 |
| MG | 270,853.46 | 20.63 |
| RR | — | 42.98 *(Highest)* |
| PB | — | 42.72 |

SP pays the most in total freight simply due to volume, but its average freight per order is the lowest in the country at R$15.15. Remote northern states pay nearly 3× more per order in freight — RR at R$42.98, PB at R$42.72.

Business Interpretation:

- The freight cost disparity directly impacts customer affordability and conversion in remote states. 
- A customer in RR pays almost R$43 in freight on an average order — a cost that may represent 15–25% of the total order value for mid-range purchases. 
- This is a structural barrier to growth in these regions and a candidate for a subsidised freight programme or regional logistics investment.

## V. Payment Analysis

### Finding 1 - Monthly orders by payment type

- Credit card dominates every single month across the entire period.
- UPI appears as a secondary method, particularly in late 2016.
- Vouchers and debit cards are minor payment methods.

 ## Business Recommendations

- Prioritize customer retention: 
As order growth begins to stabilize, retaining existing customers through loyalty programs, personalized recommendations, and targeted offers can drive sustainable long-term growth.
- Optimize seasonal planning: 
Increase inventory levels, strengthen logistics capacity, and launch promotional campaigns ahead of peak shopping periods, particularly during November, to effectively manage higher demand.
- Leverage customer purchasing patterns: 
Schedule marketing campaigns, promotional notifications, and flash sales during afternoon hours, when customer purchase activity is highest, to improve campaign effectiveness.
- Maintain flexible payment options: 
Continue supporting multiple payment methods and installment plans to enhance customer convenience and encourage larger purchases.
- Use geographic insights for strategic planning: 
Target's extensive presence across Brazil provides opportunities to develop region-specific marketing strategies and optimize resource allocation based on customer demand.
