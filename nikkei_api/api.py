from flask import Flask, request, jsonify
import numpy as np
import joblib
from tensorflow.keras.models import load_model

app = Flask(__name__)

model  = load_model("nikkei_lstm.h5")
scaler = joblib.load("nikkei_scaler.pkl")

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json(force=True)
    hist = data.get("history", None)
    if hist is None or len(hist) != model.input_shape[1]:
        return jsonify({
            "error": f"Send JSON: {{'history': [list of {model.input_shape[1]} prices]}}"
        }), 400

    arr = np.array(hist).reshape(-1,1)
    arr_scaled = scaler.transform(arr)
    x_input = arr_scaled.reshape((1, arr_scaled.shape[0], 1))

    y_scaled = model.predict(x_input)
    y_pred = scaler.inverse_transform(y_scaled)[0,0]

    return jsonify({"predicted_close": float(y_pred)})

import os

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    print(f"▶️  Starting Flask on 0.0.0.0:{port}", flush=True)
    app.run(host="0.0.0.0", port=port)



