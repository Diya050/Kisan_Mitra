import multer from "multer";
import path from "path";

// Basic storage in temp folder (you can change if needed)
const storage = multer.diskStorage({
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});

export const upload = multer({ storage });
