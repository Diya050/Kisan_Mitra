import mongoose from "mongoose";

const connectDb = async () => {
    const DB_NAME = "kisan_mitra";
    try {
        const dbInstance = await mongoose.connect(`${process.env.MONGO_DB_URL}/${DB_NAME}`)
        console.log("Database connected successfully on HOST:",dbInstance.connection.host)
    } catch (error) {
        console.log(error)
        throw new Error(500,"Error in connecting database")
    }
}

export {connectDb}