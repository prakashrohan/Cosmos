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
   <img width="100%"  alt="Screenshot 2025-07-20 at 3 04 01 AM" src="https://github.com/user-attachments/assets/c05069d9-950b-45a1-8d35-6421b069dcd8" />
   >/td>
</tr>
</table>

> Image cards showing NASA’s APOD. Each card can be expanded to full view with description and AR viewing support.

---

### 🔍 Constellation Scanner

<table>
<tr>
<td width="378">
<img width="392" alt="Screenshot 2025-07-20 at 2 56 57 AM" src="https://github.com/user-attachments/assets/cb630e48-0d2b-4ea5-93a1-4fb3e42cd7d8" />
</td>
<td width="378">
<img src="https://github.com/user-attachments/assets/5ceb6f92-3216-4f55-a030-cd928dfe54e7" width="100%">
</td>

</tr>
</table>



> Take or upload a photo of the night sky. CoreML + Vision pipeline predicts visible constellations with interactive confidence display and 3D AR option.

---

### 📱 Augmented Reality Spotlight (ARKit)

<img src="./screenshots/ar.png" width="100%">

> Constellations are rendered as 3D objects and placed into real-world space using ARKit and SceneKit. A floating label identifies the constellation in view.

---

### 📰 Space News Feed

<img src="./screenshots/news.png" width="100%">

> Stay updated with news about missions, launches, discoveries, and agency events. Optimized for readability with one-tap sharing and preview.

---

### 🔐 Login & Profile

<img src="./screenshots/login.png" width="100%">

> Modern login UI with Firebase email-password and Google Sign-In. Authenticated users can manage their profile and personalized content.

---

### 🌌 Star Register Viewer

<img src="./screenshots/star-register.png" width="100%">

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
   git clone https://github.com/your-username/Cosmos.git
   cd Cosmos
