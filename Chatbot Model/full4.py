# ========== 📦 Imports ==========
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'  # Suppress TensorFlow info/warnings
os.environ['TF_ENABLE_ONEDNN_OPTS'] = '0'  # Disable oneDNN optimization logs
from dotenv import load_dotenv
from huggingface_hub import InferenceClient
import tensorflow as tf
import numpy as np
import pandas as pd
import cv2
from tensorflow.keras.preprocessing import image
from IPython.display import display, Image as IPImage

# ========== 🔐 Load Environment Variables ==========
load_dotenv()

# ========== 🔐 Hugging Face API Client ==========
client = InferenceClient(token=os.getenv("HF_API_KEY"))

# ========== 🧠 Load Trained Model ==========
model = tf.keras.models.load_model("kfold_student_model.h5")

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

# ========== 🌿 Load Plant Disease Dataset ==========
df = pd.read_csv("plant.csv")

# ========== 📸 Preprocess Image ==========
def load_and_preprocess_image(img_path, target_size=(128, 128)):
    img = image.load_img(img_path, target_size=target_size)
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0
    return img_array

# ========== 🔍 Predict Disease ==========
def predict_disease(img_path):
    img_array = load_and_preprocess_image(img_path)
    preds = model.predict(img_array)

    if isinstance(preds, list) and len(preds) >= 2:
        preds = preds[1]
    preds = np.asarray(preds).flatten()

    pred_idx = np.argmax(preds)
    inv_class_indices = {v: k for k, v in class_indices.items()}
    predicted_label = inv_class_indices.get(pred_idx, "Unknown Disease")

    print(f"\n🦠 Predicted Disease: {predicted_label}")
    return predicted_label

# ========== 📋 Fetch Recommendation from CSV ==========
def fetch_recommendation(disease_name):
    disease_info = df[df["Disease"].str.strip().str.lower() == disease_name.strip().lower()]

    if disease_info.empty:
        print("\nNo recommendation found for this disease. It may be a healthy plant.")
        return None

    plant = disease_info.iloc[0]["Plant"]
    symptoms = disease_info.iloc[0]["Symptoms"]
    causes = disease_info.iloc[0]["Causes"]
    treatment = disease_info.iloc[0]["Recommended Treatments"]
    prevention = disease_info.iloc[0]["Preventive Measures"]
    organic_treatment = disease_info.iloc[0]["Organic Treatment Options"]
    alternative_prevention = disease_info.iloc[0]["Alternative Prevention Methods"]
    procedure_video = disease_info.iloc[0]["Procedure Video Link"]
    disease_image = disease_info.iloc[0]["Graphical Representation"]

    recommendation = f"""
    🌱 Plant: {plant}
    🦠 Disease: {disease_name}
    🔬 Symptoms: {symptoms}
    ⚠  Causes: {causes}
    💊 Recommended Treatment: {treatment}
    ✅ Preventive Measures: {prevention}
    🌿 Organic Treatment Options: {organic_treatment}
    🔄 Alternative Prevention Methods: {alternative_prevention}
    🎥 Procedure Video: {procedure_video}
    """

    if pd.notna(disease_image) and disease_image.startswith("http"):
        display(IPImage(url=disease_image, width=400))

    return recommendation

# ========== 👨‍🌾 Collect Farmer Details ==========
def collect_farmer_profile():
    print("\nPlease provide your farming details:")
    name = input("👤 Your Name: ")
    location = input("📍 Your Location (District/State): ")
    soil_type = input("🧪 Soil Type (e.g., Loamy, Sandy, Clayey): ")
    soil_ph = input("🧪 Soil pH Level (e.g., 6.5): ")
    farming_preference = input("🌿 Farming Preference (Organic/Chemical): ")
    farm_size = input("🌾 Farm Size (Optional, e.g., 2 acres): ")

    return {
        "name": name,
        "location": location,
        "soil_type": soil_type,
        "soil_ph": soil_ph,
        "farming_preference": farming_preference,
        "farm_size": farm_size if farm_size else None
    }

# ========== 💡 Generate Personalized Recommendation ==========
def generate_personalized_recommendation(disease, base_recommendation, profile):
    plant_name = disease.split("_")[0]  
    disease_name = " ".join(disease.split("_")[1:])  

    disease_info = df[df["Disease"].str.strip().str.lower() == disease.strip().lower()]
    
    if disease_info.empty:
        print("No base recommendation found for this disease.")
        return "No recommendation available."
    
    symptoms = disease_info.iloc[0]["Symptoms"] if not disease_info.empty else "Symptoms not available."
    causes = disease_info.iloc[0]["Causes"] if not disease_info.empty else "Causes not available."
    treatment = disease_info.iloc[0]["Recommended Treatments"] if not disease_info.empty else "Treatment not available."
    prevention = disease_info.iloc[0]["Preventive Measures"] if not disease_info.empty else "Prevention not available."
    organic_treatment = disease_info.iloc[0]["Organic Treatment Options"] if not disease_info.empty else "Organic treatments not available."
    alternative_prevention = disease_info.iloc[0]["Alternative Prevention Methods"] if not disease_info.empty else "Alternative prevention not available."
    procedure_video = disease_info.iloc[0]["Procedure Video Link"] if not disease_info.empty else "Procedure video not available."
    
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

Use the following disease information to generate a **personalized plant disease advisory** in this strict format:

🌱 Plant: {plant_name}
🦠 Disease: {disease_name}

Symptoms:
{symptoms}
Explain briefly why these symptoms are concerning.

Causes:
{causes}
Explain how these causes contribute to the disease.

Recommended Treatment:
{treatment}
Explain why this treatment is recommended.

Preventive Measures:
{prevention}
Explain why these preventive measures are important.

Organic Treatment Options:
{organic_treatment}
Since the farmer prefers {farming_preference} farming, explain how this organic option is beneficial.

Alternative Prevention Methods:
{alternative_prevention}

Procedure Video:
Share the link: {procedure_video}

Additional Recommendations:
📅 Treatment Timing: When and how often should treatment be applied?

⚠️ Very Important: Write cleanly. Follow the given format exactly. Keep the points **separated**. No large continuous paragraphs.
    """
    
    response = client.text_generation(
        prompt=prompt,
        model="HuggingFaceH4/zephyr-7b-beta", 
        max_new_tokens=700, 
        temperature=0.5
    )

    return response.strip()

# ========== 💬 Handle Farmer Query ==========
def get_llm_response(query, profile=None):
    context = ""
    if profile:
        context += (
            f"The farmer's name is {profile['name']}, located in {profile['location']}, "
            f"prefers {profile['farming_preference']} farming, soil type is {profile['soil_type']} with pH {profile['soil_ph']}."
        )
        if profile.get('farm_size'):
            context += f" The farm size is {profile['farm_size']}."

    prompt = context + f"\n\nThe farmer {profile['name']} is asking: '{query}'. " \
             f"Kindly reply in a friendly tone, addressing the farmer by their name, and provide a simple, useful farming recommendation." \
             f" Please avoid any repetition, and keep the response concise. Sign off as 'Kisan Mitra Team'."

    response = client.text_generation(
        prompt=prompt,
        model="HuggingFaceH4/zephyr-7b-beta",
        max_new_tokens=700,
        temperature=0.7
    )
    return response.strip()


def handle_query(profile):
    print(f"\n🌟 Hello {profile['name']}! Feel free to ask your farming question. 🌾")
    query = input("\n💬 Please enter your query: ")
    response = get_llm_response(query, profile)
    print(f"\n🧠 AI Response for {profile['name']}:\n", response)

def detect_disease_and_recommend(profile):
    image_path = input("\n🖼️ Enter path to the plant image: ")

    disease = predict_disease(image_path)

    base_recommendation = fetch_recommendation(disease)
    if base_recommendation:
        personalized = generate_personalized_recommendation(disease, base_recommendation, profile)
        
        print("\n🧠 Personalized Recommendation:")
        print(personalized)

        print("\n✅ Summary of Recommendation:")
        print(base_recommendation)
    else:
        print("\n🔍 No database match. Trying to fetch AI-only recommendation...")
        personalized = generate_personalized_recommendation(disease, "", profile)
        
        print("\n🧠 AI-Generated Recommendation:")
        print(personalized)

# ========== 🚀 Start Kisan Mitra ==========
def start_kisan_mitra():
    print("\n🌱 Welcome to Kisan Mitra! 🌿")
    
    # Ask profile ONCE at the start
    profile = collect_farmer_profile()
    
    while True:
        print("\n1. Detect Plant Disease")
        print("2. Ask Farming Question")
        print("3. Exit")

        choice = input("Choose an option: ")

        if choice == '1':
            detect_disease_and_recommend(profile)
        elif choice == '2':
            handle_query(profile)
        elif choice == '3':
            print("🌾 Thank you for using Kisan Mitra! Happy farming! 🌱")
            break
        else:
            print("Invalid option. Please try again.")

# Start the program
if __name__ == "__main__":
    start_kisan_mitra()
