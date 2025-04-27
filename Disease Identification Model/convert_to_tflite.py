import tensorflow as tf

# 1. Load your existing Keras model
model = tf.keras.models.load_model("student_model_final.h5")

# 2. (Optional) If you have any custom layers/objects, 
#    provide them here as a dict: e.g.
# custom_objects = {"MyLayer": MyLayer}
# model = tf.keras.models.load_model("student_model_final.h5", custom_objects=custom_objects)

# 3. Create a converter
converter = tf.lite.TFLiteConverter.from_keras_model(model)

# 4. (Optional) Enable optimizations to reduce size & improve inference speed
converter.optimizations = [tf.lite.Optimize.DEFAULT]

# 5. (Optional) If you want further size reduction with quantization:
# converter.target_spec.supported_types = [tf.float16]

# 6. Perform the conversion
tflite_model = converter.convert()

# 7. Save the .tflite file
with open("student_model_final.tflite", "wb") as f:
    f.write(tflite_model)

print("✅ TensorFlow Lite model saved as student_model_final.tflite")
