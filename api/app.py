from flask import Flask, request, jsonify
from PIL import Image
import numpy as np
import tensorflow as tf
import io
import os

app = Flask(__name__)

# Force CPU usage
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'

class CustomDTypePolicy:
    def __init__(self, name):
        self.name = name

    def __eq__(self, other):
        return self.name == other.name

    @classmethod
    def from_config(cls, config):
        return cls(**config)

    def get_config(self):
        return {'name': self.name}

try:
    # Register custom objects
    custom_objects = {
        'DTypePolicy': CustomDTypePolicy,
        'dtype': tf.float32
    }
    
    # Load model with custom objects
    with tf.keras.utils.custom_object_scope(custom_objects):
        model = tf.keras.models.load_model(
            'model/plant_disease_model.h5',
            compile=False
        )
        
        # Compile the model
        model.compile(
            optimizer='adam',
            loss='categorical_crossentropy',
            metrics=['accuracy']
        )
    print("Model loaded successfully!")
    
except Exception as e:
    print(f"Error loading model: {e}")
    # Print model summary to debug
    try:
        temp_model = tf.keras.models.load_model('model/plant_disease_model.h5', compile=False)
        print("\nSaved model architecture:")
        temp_model.summary()
    except Exception as debug_e:
        print(f"Error loading model for debug: {debug_e}")
    raise

def preprocess_image(image_bytes):
    image = Image.open(io.BytesIO(image_bytes))
    image = image.resize((224, 224))
    image = np.array(image) / 255.0
    return np.expand_dims(image, axis=0)

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'}), 400
    
    image_file = request.files['image']
    image_bytes = image_file.read()
    
    processed_image = preprocess_image(image_bytes)
    predictions = model.predict(processed_image)[0]
    
    classes = ['Healthy', 'Fungal Disease 1', 'Fungal Disease 2']
    results = {class_name: float(pred) for class_name, pred in zip(classes, predictions)}
    
    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True) 