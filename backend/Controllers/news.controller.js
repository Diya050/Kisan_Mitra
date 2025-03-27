import { News } from "../Models/news.model.js";

const getNews = async(req, res) => {
    try {
        const news = await News.find({});
        res.status(200).json({data: news, success: true});
    } catch (error) {
        console.log("Error Fetching News: ", error);
        res.status(500).json({message: "Error Fetching News", success: true});
    }
}

const getSpecificNews = async(req, res) => {
    try {
        const {id} = req.params;
        const news = await News.find({_id: id});
        const sortedResult = news.sort((a, b) => b.publishedAt > a.publishedAt);
        res.status(200).json({data: sortedResult, success: true});
    } catch (error) {
        console.log("Error Fetching News: ", error);
        res.status(500).json({message: "Error Fetching All News", success: true});
    }
}

const postNews = async(req, res) => {
    try {
        const {title, content, author, category, publishedAt} = req.body;
        if (
            [title, content, author, category, publishedAt].some(
              (val) => val === ""
            )
        ) {
            return res.status(400).json({message: "All fields are Required", success: false});
        }
        
        const newsImage = req.file?.path;
        let uploadResult;
        if (newsImage) {
            uploadResult = await uploadCloudinary(newsImage);
        }

        if(!uploadResult){
            return res.status(400).json({message: "Error Uploading to Cloudinary", success: false});
        }

        const isExistingNews = await News.findOne({ title: title });
        if (isExistingNews) {
            return res.status(400).json({message: "News Already Exists", success: false});
        }

        const newNews = await News.create({
            title,
            content,
            image: uploadResult?.url,
            author,
            category,
            publishedAt,
        })

        return res.status(200).json({data: newNews, success: true});
        
    } catch (error) {
        console.log("Error Posting News: ", error);
        res.status(500).json({message: "Error Posting News", success: false});
    }
}

const postMultipleNews = async(req, res) => {
    try {
        const { multipleNewsData } = req.body;

        if (!multipleNewsData || !Array.isArray(multipleNewsData) || multipleNewsData.length === 0) {
            return res.status(400).json({ message: "Data is Empty or Invalid", success: false });
        }

        let failedUploads = [];
        let successfulUploads = [];

        // Get uploaded files from request
        const uploadedFiles = req.files || [];

        for (let i = 0; i < multipleNewsData.length; i++) {
            const newsData = multipleNewsData[i];
            const { title, content, author, category, publishedAt } = newsData;

            // Validate fields
            if ([title, content, author, category, publishedAt].some((val) => !val)) {
                failedUploads.push({ title, reason: "Missing required fields" });
                continue;
            }

            // Check if news already exists
            const isExistingNews = await News.findOne({ title });
            if (isExistingNews) {
                failedUploads.push({ title, reason: "News already exists" });
                continue;
            }

            // Upload corresponding image (if provided)
            let uploadResult = null;
            if (uploadedFiles[i]?.path) {
                try {
                    uploadResult = await uploadCloudinary(uploadedFiles[i].path);
                } catch (uploadError) {
                    failedUploads.push({ title, reason: "Cloudinary upload failed" });
                    continue;
                }
            }

            // Save news to database
            await News.create({
                title,
                content,
                image: uploadResult?.url || null, // Store image URL if uploaded
                author,
                category,
                publishedAt,
            });

            successfulUploads.push(title);
        }

        return res.status(200).json({
            message: "News upload process completed",
            success: true,
            successfulUploads,
            failedUploads,
        });
        
    } catch (error) {
        console.log("Error Posting News: ", error);
        res.status(500).json({message: "Error Posting News", success: false});
    }
}

export {
    getNews,
    getSpecificNews,
    postNews,
    postMultipleNews,
}