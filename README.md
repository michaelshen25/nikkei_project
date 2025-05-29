# Nikkei 225 LSTM Predictor

This project implements a complete end-to-end pipeline for forecasting the next-day closing price of Japan’s Nikkei 225 index using a Long Short-Term Memory (LSTM) neural network. Historical daily closing prices are preprocessed into 10-day sequences, and the model predicts the following day’s close. You can interact with the service in two ways:

**Access**

* **API**: Send a `POST` request with a JSON body:

  ```
 curl -X POST https://nikkei-api-609056186247.us-central1.run.app/predict \
  -H "Content-Type: application/json" \
  -d '{"history":[h1, h2, ..., h10]}'
  ```

  and receive a response:

  ```json
  {"predicted_close": <value>}
  ```

* **Web Interface**: Visit the Shiny application at:

  ```
  https://michaelshen25.shinyapps.io/nikkei-forecast/
  ```

  Enter the last 10 daily closes in the form and click **Predict** to see the forecast interactively.
