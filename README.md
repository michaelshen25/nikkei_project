# Nikkei 225 LSTM Predictor

Yifan Shen’s STAT 418 final project: a cloud-hosted LSTM model for next-day Nikkei 225 forecasting, with both a Flask API and an R Shiny front end.

---

## Repository Structure

```
nikkei_project/
├── nikkei_api/           # Flask API & Docker container
│   ├── api.py
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── nikkei_lstm.h5
│   └── nikkei_scaler.pkl
├── nikkei_shiny/         # Shiny app that calls the Flask API
│   └── app.R
├── Stock_Predict.ipynb    # Jupyter notebook: model training & evaluation
├── nikkei_terminal_typein.rtf
└── README.md             # ← You are here
```

---

## nikkei\_api (Flask)

### 1. Build Docker image

```bash
cd nikkei_api
docker build -t <your-dockerhub-username>/nikkei-api:latest .
```

### 2. Push to Docker Hub

```bash
docker tag nikkei-api:latest <your-dockerhub-username>/nikkei-api:latest
docker push <your-dockerhub-username>/nikkei-api:latest
```

### 3. Run locally

```bash
cd nikkei_api
python api.py  # listens on 0.0.0.0:$PORT (default 5001)
```

### 4. Endpoint

**POST** `/predict`

* **Request JSON**

  ```json
  {
    "history": [ day1, day2, …, day10 ]
  }
  ```
* **Response JSON**

  ```json
  {
    "predicted_close": 20087.84
  }
  ```

---

## nikkei\_shiny (R Shiny)

1. Install dependencies and deploy to shinyapps.io:

   ```r
   install.packages(c("shiny","httr","jsonlite"))
   rsconnect::deployApp("nikkei_shiny")
   ```

2. Usage:

   * Enter your last 10 daily closes in the sidebar.
   * Click **Predict** → the app calls your Flask API and displays the next-day forecast.

---

## Cloud Deployment

* **Flask API**: hosted on Google Cloud Run (or any container service) using your pushed Docker image.
* **Shiny App**: hosted on shinyapps.io (free tier, easy to tear down after course).

---

## Notes

* All model artifacts (`.h5`, `.pkl`) live under `nikkei_api/`.
* Make sure your Flask API URL (in `app.R`) matches your deployed endpoint.
* After June 10, feel free to archive or delete both services to avoid any billing.

---

## License & Credits

Model trained by Yifan Shen. Shiny app UI and API wiring by Michael Shen.
Feel free to fork and customize!
