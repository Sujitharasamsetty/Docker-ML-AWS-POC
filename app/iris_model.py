from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
import pickle
import os

def train_and_save_model():
    iris=load_iris()
    X,y=iris.data,iris.target
    model=RandomForestClassifier()
    model.fit(X,y)

    with open("model.pkl","wb") as f:
        pickle.dump(model,f)
    print("Model trained and saved as model.pkl")

train_and_save_model()
