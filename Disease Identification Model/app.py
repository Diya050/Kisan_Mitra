# ========== 📦 Imports ==========
import os
from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
import pandas as pd
from tensorflow.keras.preprocessing import image
from dotenv import load_dotenv
from huggingface_hub import InferenceClient

# ========== ⚙️ Environment Setup ==========
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # Suppress TensorFlow logs
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'
load_dotenv()

# ========== 🚀 Initialize Flask App ==========
app = Flask(__name__)
CORS(app)

# ========== 🧠 Load Models ==========
leaf_nonleaf_model = tf.keras.models.load_model("leaf_vs_non-leaf.h5")
disease_model = tf.keras.models.load_model("student_model_final.h5")  # or your kfold_student_model.h5

# ========== 📋 Load Data ==========
df = pd.read_csv("plant.csv")

# ========== 🔐 HuggingFace Client ==========
client = InferenceClient(token=os.getenv("HF_API_KEY"))

# ========== 🏷️ Class Indices ==========
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

# ========== 📸 Preprocess Uploaded Image ==========
def preprocess_image(file, target_size=(128, 128)):
    img = image.load_img(file, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0
    return img_array

# ========== 🔍 Predict if Leaf or Not ==========
def predict_leaf_or_not(img_array):
    preds = leaf_nonleaf_model.predict(img_array)
    prediction = "Leaf" if preds[0][0] > 0.5 else "Non-Leaf"
    return prediction

# ========== 🦠 Predict Disease ==========
def predict_disease(img_array):
    preds = disease_model.predict(img_array)

    if isinstance(preds, list) and len(preds) >= 2:
        preds = preds[1]
    preds = np.asarray(preds).flatten()

    pred_idx = np.argmax(preds)
    inv_class_indices = {v: k for k, v in class_indices.items()}
    predicted_label = inv_class_indices.get(pred_idx, "Unknown Disease")
    return predicted_label

# ========== 📋 Fetch Recommendation from CSV ==========
def fetch_recommendation(disease_name):
    disease_info = df[df["Disease"].str.strip().str.lower() == disease_name.strip().lower()]

    if disease_info.empty:
        return None

    data = disease_info.iloc[0]
    return {
        "plant": data["Plant"],
        "symptoms": data["Symptoms"],
        "causes": data["Causes"],
        "recommended_treatment": data["Recommended Treatments"],
        "prevention": data["Preventive Measures"],
        "organic_treatment": data["Organic Treatment Options"],
        "alternative_prevention": data["Alternative Prevention Methods"],
        "procedure_video": data["Procedure Video Link"],
        "disease_image": data["Graphical Representation"]
    }

# ========== 💡 Generate Personalized Recommendation ==========
def generate_personalized_recommendation(disease, base_info, profile):
    plant_name = disease.split("_")[0]
    disease_name = " ".join(disease.split("_")[1:])

    farmer_name = profile['name']
    location = profile['location']
    soil_type = profile['soil_type']
    soil_ph = profile['soil_ph']
    farming_preference = profile['farming_preference']
    farm_size = profile.get('farm_size', 'Not specified')

    prompt = f"""
You are an expert agricultural advisor.

A farmer named {farmer_name} from {location} with {soil_type} soil (pH {soil_ph}), prefers {farming_preference} farming on a farm size of {farm_size}.

Their plant is affected by {disease_name} in {plant_name}.

Use the following disease information to generate a personalized plant disease advisory:

🌱 Plant: {plant_name}
🦠 Disease: {disease_name}

Symptoms:
{base_info.get('symptoms', 'Not available')}
Explain briefly why these symptoms are concerning.

Causes:
{base_info.get('causes', 'Not available')}
Explain how these causes contribute to the disease.

Recommended Treatment:
{base_info.get('recommended_treatment', 'Not available')}
Explain why this treatment is recommended.

Preventive Measures:
{base_info.get('prevention', 'Not available')}
Explain why these preventive measures are important.

Organic Treatment Options:
{base_info.get('organic_treatment', 'Not available')}
Since the farmer prefers {farming_preference} farming, explain how this organic option is beneficial.

Alternative Prevention Methods:
{base_info.get('alternative_prevention', 'Not available')}

Procedure Video:
{base_info.get('procedure_video', 'Not available')}

Additional Recommendations:
📅 Treatment Timing: When and how often should treatment be applied?

⚠️ Follow the format strictly. Clean output. No large continuous paragraphs.
    """

    response = client.text_generation(
        prompt=prompt,
        model="HuggingFaceH4/zephyr-7b-beta",
        max_new_tokens=700,
        temperature=0.5
    )
    return response.strip()

# ========== 🚀 API Endpoints ==========

@app.route("/predict", methods=["POST"])
def predict():
    file = request.files["image"]
    profile = request.form.to_dict()

    if not file:
        return jsonify({"error": "No file uploaded"}), 400

    img_array = preprocess_image(file)

    # Step 1: Leaf or Non-leaf prediction
    leaf_status = predict_leaf_or_not(img_array)

    if leaf_status == "Non-Leaf":
        return jsonify({
            "message": "Uploaded image is not a plant leaf.",
            "prediction": leaf_status
        }), 200

    # Step 2: Disease Prediction
    disease = predict_disease(img_array)

    # Step 3: Fetch base recommendation
    base_info = fetch_recommendation(disease)

    # Step 4: Generate personalized recommendation
    if base_info:
        personalized = generate_personalized_recommendation(disease, base_info, profile)
        result = {
            "leaf_status": leaf_status,
            "predicted_disease": disease,
            "base_recommendation": base_info,
            "personalized_recommendation": personalized
        }
    else:
        # In case base info not found, fallback to AI-only
        personalized = generate_personalized_recommendation(disease, {}, profile)
        result = {
            "leaf_status": leaf_status,
            "predicted_disease": disease,
            "personalized_recommendation": personalized,
            "message": "No base info found. Generated recommendation from AI."
        }

    return jsonify(result), 200

# ========== 🛠️ Main ==========
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
