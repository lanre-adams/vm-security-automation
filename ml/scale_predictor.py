import pandas as pd
from sklearn.linear_model import LinearRegression
import json

data = pd.read_csv("ml/data/historical_usage.csv")
X = data[['avg_cpu', 'avg_mem', 'hour_of_day']]
y = data['recommended_vm_size']

model = LinearRegression().fit(X, y)
predictions = model.predict(X)

output = [{'Name': name, 'RecommendedSize': int(pred)} for name, pred in zip(data['vm_name'], predictions)]
with open('ml/scale_recommendations.json', 'w') as f:
    json.dump({'VMs': output}, f, indent=2)
