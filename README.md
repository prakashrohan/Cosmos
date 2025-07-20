<img src="https://github.com/user-attachments/assets/2b103b96-e69f-4844-9916-e41b614a8fb4" alt="final-image-3" width="100" height="100">

#  COSMOS — Explore the Universe in Your Pocket

**Cosmos** is a beautifully crafted iOS application that brings space exploration to your fingertips. Whether you're a casual stargazer, astronomy enthusiast, or space science nerd, Cosmos provides a feature-rich, immersive experience powered by NASA, Spaceflight News, ARKit, and CoreML.

From visualizing celestial objects in AR to checking constellation rise/set timings, Cosmos combines advanced technologies with a sleek user experience.


https://github.com/user-attachments/assets/e1487d49-c585-405f-a35a-234dd8ea4c5b


---

## 🚀 Features

### 🛰️ Astronomy Picture of the Day (APOD)
- Browse high-definition space images curated by NASA.
- Tap on any APOD card to view detailed metadata and descriptions.
- Dive deeper with **AR visualization** of media using ARKit.

### 🔭 AR Constellation Scanner (CoreML + Vision)
- Capture or upload a sky photo to detect visible constellations.
- Uses a trained **CoreML model** to classify and label constellations.
- Interactive list of predictions with confidence scores and **AR View** integration.

### 🌞 3D Solar System View 
- Explore a fully interactive, real-time **3D model of the solar system**.
- Zoom, rotate, and tap on planets to learn facts and view animations.
- Built using WebKit and optimized for smooth rendering on iPhones.

### 🌟 Star Register Lookup
- Enter your registered star number to locate it in the sky.
- Embedded web viewer of [Star Register](https://software.star-register.com) with custom UI overlays.
- Fullscreen support, native SwiftUI navigation, and intuitive toggles for constellation overlays, meridian, horizon, etc.

### 📰 Real-time Space News (Spaceflight API)
- Fetch latest headlines from sources like NASA, SpaceX, and more.
- Display news with images, publication date, author, and tags.
- Open detailed views using `WKWebView` with smooth transitions.

### 🌌 Constellation Visibility Timings
- Calculates when each constellation **rises**, is **fully visible**, and **sets**.
- Provides **astronomical night** windows for optimal observation.
- Supports future enhancement for **location-based** predictions.

### 👤 Profile Management (Firebase)
- Sign up or log in using **Email/Password** or **Google Sign-In**.
- Manage your preferences, session, and history.
- Seamless Firebase Authentication integration.

---

## 🖼️ Screenshots & Descriptions

### 🌌 Home Screen + NASA APOD

<table>
<tr>
<td width="378">
<img src="https://github.com/user-attachments/assets/419ba944-7c88-4c58-b6ac-3b0bdca142f1" width="100%">
</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/88868858-e00e-4fed-a7e7-b344f06c3cdf" width="100%">
</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/c05069d9-950b-45a1-8d35-6421b069dcd8" width="100%">
</td>
</tr>
</table>

> Image cards showing NASA’s APOD. Each card can be expanded to full view with description and AR viewing support.

---

### 🔍 Constellation Scanner

<table>
<tr>
<td width="378">
<img src="https://github.com/user-attachments/assets/cb630e48-0d2b-4ea5-93a1-4fb3e42cd7d8" width="100%">

</td>
<td width="378">
   
<img src="https://github.com/user-attachments/assets/5ceb6f92-3216-4f55-a030-cd928dfe54e7" width="100%">
</td>

</tr>
</table>



> Take or upload a photo of the night sky. CoreML + Vision pipeline predicts visible constellations with interactive confidence display and 3D AR option.

---

### 🌍 3D Solar System View

<table>
<tr>
<td width="378">
   
<img src="https://github.com/user-attachments/assets/910cbc43-266d-459b-b8c0-53d9816b96c7" width="100%">
</td>
<td width="378">
<img  src="https://github.com/user-attachments/assets/0a72dc15-757d-4a8a-9e46-4e5f3acbb1fb"  width="100%">

</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/f8f21e50-3af4-43d3-8040-fdccba74e862" width="100%">


</td>
</tr>
</table>


> An interactive SceneKit-based solar system model. Explore planets, orbits, and facts with intuitive zoom and gestures. Educational + stunning!

---

### 📱 Augmented Reality Spotlight (ARKit)

<table>
<tr>
<td width="378">
<img src="https://github.com/user-attachments/assets/bdbf1f4a-a2eb-4782-8ba9-007a0fa7b6eb" width="100%">
</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/893ffc65-524a-4383-96b8-a2f40fffb308" width="100%">

</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/a0b4b627-95e5-4bd5-8ec3-c36d949aa8c2" width="100%">

</td>
</tr>
</table>


> Constellations are rendered as 3D objects and placed into real-world space using ARKit and SceneKit. A floating label identifies the constellation in view.

---

### 📰 Space News Feed

<table>
<tr>
<td width="378">
<img  src="https://github.com/user-attachments/assets/bc50c39b-d334-4b31-b047-2eb245c842c9" width="100%">
</td>
<td width="378">
   
<img src="https://github.com/user-attachments/assets/0c56f174-122e-4cd0-be57-3dd11aa28536" width="100%">

</td>

</tr>
</table>

> Stay updated with news about missions, launches, discoveries, and agency events. Optimized for readability with one-tap sharing and preview.

---

### 🔐 Login & Profile

<table>
<tr>
<td width="378">
<img src="https://github.com/user-attachments/assets/6549031f-38a3-4da1-a001-2fd4631ce67f" width="100%">
</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/7fd8fed3-9341-44bf-b3e5-5baa3718d9a5" width="100%">
</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/606cc63b-e78b-4478-9e69-991a1e8cce09" width="100%">
</td>
</tr>
</table>

> Modern login UI with Firebase email-password and Google Sign-In. Authenticated users can manage their profile and personalized content.

---

### 🌌 Star Register Viewer

<table>
<tr>
<td width="378">
<img src="https://github.com/user-attachments/assets/a198dbe1-d613-47a8-ac59-88ee245eab07" width="100%">
</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/8fa9ae22-99e9-477a-86c0-f8b2dbc771cf" width="100%">
</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/a3439a2e-9a91-453b-9f5c-6be0cabba631" width="100%">
</td>
</tr>
</table>

> A full-screen WebView wrapped in SwiftUI, integrating the Star Register’s constellation explorer. Native UI overlays offer a seamless app-like experience.

---

## ⚙️ Tech Stack

| Layer | Tools Used |
|-------|-------------|
| UI | SwiftUI, UIKit, BlurView, Animations |
| AR | ARKit, SceneKit |
| AI | CoreML, Vision, Custom Trained Constellation Classifier |
| Backend | Firebase Auth, Google Sign-In |
| Networking | URLSession, JSONDecoder |
| APIs | NASA APOD API, Spaceflight News API, Star Register Viewer |
| WebView | WKWebView integration for embedded experiences |

---

## 📦 Installation Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/prakashrohan/Cosmos
   ```
 2. Navigate to Root Directory
   ```bash
   cd Cosmos
   ``` 
   

## Credits
- NASA Open APIs
- Spaceflight News API
- Star Register Tool
- Apple’s ARKit, Vision, and CoreML frameworks
- Solar System assets by NASA 3D Resources
