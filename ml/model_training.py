
import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import json
import joblib

# Load usage data
df = pd.read_csv("ml/data/historical_usage.csv")

# Feature selection
X = df[["avg_cpu", "avg_mem", "hour_of_day"]]
y = df["recommended_vm_size"]

# Split and train
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
model = LinearRegression()
model.fit(X_train, y_train)

# Save model
joblib.dump(model, "ml/vm_scaling_model.pkl")

# Make predictions
predictions = model.predict(X)
df["predicted_size"] = predictions.round().astype(int)

# Output JSON config
recommendations = [{"Name": name, "RecommendedSize": size}
                   for name, size in zip(df["vm_name"], df["predicted_size"])]

with open("ml/scale_recommendations.json", "w") as f:
    json.dump({"VMs": recommendations}, f, indent=2)
