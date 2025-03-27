import express from "express";
import multer from "multer";
import { getNews, getSpecificNews, postNews, postMultipleNews } from "../Controllers/news.controller.js";

// Multer setup for file upload
const upload = multer({ dest: 'uploads/' });
const newsRouter = express.Router();

newsRouter.route("/get-news/:id").get(getSpecificNews);
newsRouter.route("/get-news").get(getNews);
newsRouter.route("/post-news").post(upload.single("newsImage"), postNews)
newsRouter.route('/post-multiple-news').post(upload.array("files", 20), postMultipleNews);
export default newsRouter