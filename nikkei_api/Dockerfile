# 1. Use a lightweight Python base image
FROM python:3.12-slim

# 2. Set working directory inside container
WORKDIR /app

# 3. Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copy your api code + model files
COPY api.py .
COPY nikkei_lstm.h5 .
COPY nikkei_scaler.pkl .

# 5. Expose port 5001
EXPOSE 5001

# 6. Run the API when container starts
CMD ["python", "api.py"]
