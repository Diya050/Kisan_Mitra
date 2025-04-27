from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
import pandas as pd
import os
from tensorflow.keras.preprocessing import image

# Initialize app
app = Flask(__name__)
CORS(app)

# Load model and class indices
model = tf.keras.models.load_model("student_model_final.h5")

class_indices = {
    'Apple_Apple Scab': 0, 'Apple_Black Rot': 1, 'Apple_Cedar Apple Rust': 2, 'Apple_Healthy': 3,
    'Bell Pepper_Bacterial Spot': 4, 'Bell Pepper_Healthy': 5, 'Cherry_Healthy': 6, 'Cherry_Powdery Mildew': 7,
    'Corn (Maize)_Cercospora Leaf Spot': 8, 'Corn (Maize)_Common Rust': 9, 'Corn (Maize)_Healthy': 10,
    'Corn (Maize)_Northern Leaf Blight': 11, 'Grape_Black Rot': 12, 'Grape_Esca (Black Measles)': 13,
    'Grape_Healthy': 14, 'Grape_Leaf Blight': 15, 'Peach_Bacterial Spot': 16, 'Peach_Healthy': 17,
    'Potato_Early Blight': 18, 'Potato_Healthy': 19, 'Potato_Late Blight': 20, 'Strawberry_Healthy': 21,
    'Strawberry_Leaf Scorch': 22, 'Tomato_Bacterial Spot': 23, 'Tomato_Early Blight': 24, 'Tomato_Healthy': 25,
    'Tomato_Late Blight': 26, 'Tomato_Septoria Leaf Spot': 27, 'Tomato_Yellow Leaf Curl Virus': 28
}

inv_class_indices = {v: k for k, v in class_indices.items()}
df = pd.read_csv("plant.csv")

UPLOAD_FOLDER = os.path.join("static", "uploads")
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def load_and_preprocess_image(img_path, target_size=(128, 128)):
    img = image.load_img(img_path, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0
    return img_array

def predict_disease(img_path):
    img_array = load_and_preprocess_image(img_path)
    preds = model.predict(img_array)
    if isinstance(preds, list) and len(preds) >= 2:
        preds = preds[1]
    pred_idx = np.argmax(np.asarray(preds).flatten())
    return inv_class_indices.get(pred_idx, "Unknown Disease")

def get_recommendation(disease_name):
    disease_info = df[df["Disease"].str.strip().str.lower() == disease_name.strip().lower()]
    if disease_info.empty:
        return {"message": "No recommendation found for this disease. The leaf is healthy."}
    
    row = disease_info.iloc[0]
    return {
        "plant": row["Plant"],
        "disease": disease_name,
        "symptoms": row["Symptoms"],
        "causes": row["Causes"],
        "recommended_treatment": row["Recommended Treatments"],
        "preventive_measures": row["Preventive Measures"],
        "organic_treatment": row["Organic Treatment Options"],
        "alternative_prevention": row["Alternative Prevention Methods"],
        "video_link": row["Procedure Video Link"],
        "image_url": row["Graphical Representation"]
    }

@app.route("/predict", methods=["POST"])
def predict():
    if "image" not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    file = request.files["image"]
    if file.filename == "":
        return jsonify({"error": "No file selected"}), 400

    file_path = os.path.join(app.config["UPLOAD_FOLDER"], file.filename)
    file.save(file_path)

    # Predict disease
    predicted_disease = predict_disease(file_path)
    recommendation = get_recommendation(predicted_disease)

    response = {
        "predicted_disease": predicted_disease,
        "recommendation": recommendation
    }

    return jsonify(response)

if __name__ == "__main__":
    app.run(debug=True)
