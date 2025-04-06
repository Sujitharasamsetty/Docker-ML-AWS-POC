from fastapi import FastAPI
from pydantic import BaseModel
import pickle
import numpy as np
import os

app = FastAPI()

# Dynamically get the full path to model.pkl
base_dir = os.path.dirname(__file__)
model_path = os.path.join(base_dir, "model.pkl")

# Load the model
with open(model_path, "rb") as f:
    model = pickle.load(f)

# Request model
class IrisInput(BaseModel):
    sepal_length: float
    sepal_width: float
    petal_length: float
    petal_width: float

# Prediction endpoint
@app.post("/predict")
def predict(data: IrisInput):
    input_data = np.array([[data.sepal_length, data.sepal_width, data.petal_length, data.petal_width]])
    prediction = model.predict(input_data)
    return {"prediction": int(prediction[0])}
