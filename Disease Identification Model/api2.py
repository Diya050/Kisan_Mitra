# ========== 📦 Imports ==========
import os
from dotenv import load_dotenv
from huggingface_hub import InferenceClient
import tensorflow as tf
from flask import Flask, request, jsonify
from flask_cors import CORS

# ========== 🔐 Load Environment Variables ==========
load_dotenv()

# ========== 🔐 Hugging Face API Client ==========
client = InferenceClient(token=os.getenv("HF_API_KEY"))

# Initialize app
app = Flask(__name__)
CORS(app)

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

# ========== 📡 API Endpoints ==========

@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Welcome to the Kisan Mitra Farming Assistant API!"})

@app.route("/query", methods=["POST"])
def query():
    data = request.json

    required_profile_fields = ["name", "location", "soil_type", "soil_ph", "farming_preference"]
    missing_fields = [field for field in required_profile_fields if field not in data.get("profile", {})]

    if not data or not data.get("query") or missing_fields:
        return jsonify({
            "error": "Invalid request. Make sure 'query' and required profile fields are provided.",
            "required_profile_fields": required_profile_fields
        }), 400

    profile = data["profile"]
    query_text = data["query"]

    try:
        response = get_llm_response(query_text, profile)
        return jsonify({
            "farmer_name": profile["name"],
            "query": query_text,
            "response": response
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
