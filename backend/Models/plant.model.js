import mongoose from "mongoose"

const plantSchema = new mongoose.Schema({
    name: { type: String, required: true },
    diseases: [
      {
        name: { type: String, required: true },
        symptoms: { type: [String], required: true },
        solutions: { type: [String], required: true },
        preventions: {type: [String]},
      }
    ],
    image: { type: String }  // Optional image URL
  });
  
export const Plant = mongoose.model("Plant", plantSchema)