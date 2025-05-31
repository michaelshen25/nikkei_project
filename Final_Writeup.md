# Nikkei 225 LSTM Forecasting — Final Write-Up

## 1. Introduction
I build and deploy a recurrent neural network (LSTM) to forecast the next-day closing value of the Nikkei 225 index based on its past 10 trading days. The model is exposed as a serverless REST API on Google Cloud Run and consumed by a lightweight Shiny web front end.

## 2. Data Collection & Exploratory Analysis
- **Source:** Daily Nikkei 225 closing prices from FRED via `pandas_datareader` (May 2020–May 2025).  
- **Cleaning:** Linear interpolation filled occasional market-holiday gaps.  
- **Visualization:**    
  - Shows overall upward trend from 2020–2021, drawdowns in 2022 and early 2025, and recent recovery.  
  - No strong seasonality; close values range roughly 32k–42k.  

## 3. Methodology
1. **Preprocessing:**  
   - Scale prices to [0,1] with `MinMaxScaler`.  
   - Create sliding windows of length 10 (`X`) and the next day’s price (`y`).  
   - Train/test split: 80% train, 20% hold-out.  
2. **Model Architecture:**  
   - Single-layer LSTM (300 units) → Dense(1).  
   - Loss: MSE; metric: MAE; optimizer: Adam (lr=0.001).  
   - Early stopping on validation MAE (patience=7).  
3. **Training:**  
   - 50 epochs, batch size 30, with 10% of train set held out for validation.

## 4. Results
- **Training metrics:**  
  - Final training MSE ≈ 2.96×10⁻⁴, MAE ≈ 0.0135  
  - Final validation MSE ≈ 4.97×10⁻⁴, MAE ≈ 0.0168  
- **Forecast vs. Actual:**  
  ![Forecast Plot](nikkei_shiny/eda/forecast_vs_actual.png)  
  - R² ≈ 0.80 on unseen test data → model explains ~80% of variance.  
  - Predicted (blue) closely tracks actual closes (orange), including drawdowns.

## 5. Deployment
- **Cloud Run API:**  
    POST https://nikkei-api-609056186247.us-central1.run.app/predict
    Content-Type: application/json

    { "history": [day₁, day₂, …, day₁₀] }
    → { "predicted_close": [value] }

- **Shiny Web App:**  
- Hosted at https://michaelshen25.shinyapps.io/nikkei-forecast/  
- Simple form to enter 10 past closes and display the next-day forecast.
