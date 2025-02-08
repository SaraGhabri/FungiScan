

## **FUNGISCAN AI** - Détection Automatisée des Maladies Fongiques  

### **🔹 Description**  
FungiScan AI est une solution basée sur l’intelligence artificielle pour détecter et diagnostiquer automatiquement les maladies fongiques sur les cultures. Elle utilise **la vision par ordinateur et le deep learning** pour analyser des images capturées via **smartphone, drone ou capteurs embarqués**, et fournit des recommandations adaptées aux agriculteurs.  

---

## **🚀 Fonctionnalités**  
✅ **Détection des maladies fongiques** à partir d’images de plantes  
✅ **Modèle CNN entraîné** sur le dataset [PlantVillage](https://data.mendeley.com/datasets/tywbtsjrjv/1)  
✅ **Recommandations intelligentes** basées sur les résultats du scan  
✅ **Application mobile (Flutter)** pour une utilisation facile sur le terrain  
✅ **API REST (Flask)** pour traiter les images et retourner les prédictions  
✅ **Interface utilisateur intuitive**  

### 🎥 Démos
[![Démo Model Postman](https://lien-vers-ta-demo-api.com](https://drive.google.com/file/d/1I7-J7frpIH3dpExJtJ47UMXkSTPCqZjj/view?usp=sharing) 
[![Démo Model Application Mobile ](https://drive.google.com/file/d/12c24XEK6FBndGeqwAJZKvnqJHnevUZle/view?usp=sharing)


---

## **📂 Architecture du Projet**  

### **1️⃣ Backend - Flask API**  
L’API est développée en **Python (Flask)** et expose des endpoints permettant :  
- **/predict** : Prendre une image en entrée, analyser la maladie et retourner le résultat  
- **/info** : Fournir des détails sur la maladie détectée et des recommandations  
- **/health** : Vérifier l’état de l’API  

📌 **Dépendances principales** :  
- TensorFlow / PyTorch (pour le modèle CNN)  
- OpenCV (pour le traitement des images)  
- Flask (pour le serveur API)  

---

### **2️⃣ Modèle d’IA - Vision par Ordinateur**  
Le modèle utilise un **réseau de neurones convolutifs (CNN)**, optimisé pour classifier différentes maladies fongiques. Il est entraîné sur des milliers d’images annotées et atteint une haute précision sur les cultures courantes comme les tomates, pommes et pommes de terre.  

---

### **3️⃣ Frontend - Application Flutter**  
L’application mobile permet aux utilisateurs de :  
- Capturer ou importer une image de plante  
- Envoyer l’image à l’API Flask pour analyse  
- Recevoir un diagnostic et des recommandations de traitement  

📌 **Dépendances principales** :  
- Flutter (Dart)  
- HTTP package (communication avec l’API)  
- Camera package (prise de photos)  

---

## **🛠 Installation et Utilisation**  

### **1️⃣ Installation du Backend**  
```bash
git clone https://github.com/votre-repo/FungiScan-AI.git  
cd backend  
pip install -r requirements.txt  
python app.py  
```

### **2️⃣ Lancement de l’Application Mobile**  
```bash
cd frontend  
flutter pub get  
flutter run  
```

---

## **📌 API Utilisation (Exemple d’appel avec cURL)**  
```bash
curl -X POST "http://localhost:5000/predict" -F "image=@plant.jpg"
```
Réponse JSON :  
```json
{
  "disease": "Mildiou",
  "confidence": 97.5,
  "recommendation": "Utilisez un fongicide adapté et surveillez l'humidité."
}
```

---

## **📜 Licence**  
Ce projet est open-source sous la licence **MIT**.  

