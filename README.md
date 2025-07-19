<img src="https://github.com/user-attachments/assets/2b103b96-e69f-4844-9916-e41b614a8fb4" alt="final-image-3" width="100" height="100">

# COSMOS – Explore the Universe in Your Pocket

**Cosmos** is a beautifully designed iOS app that brings the wonders of space to your fingertips. From viewing NASA’s Astronomy Picture of the Day, scanning constellations using your camera, exploring real-time star maps, to staying updated with the latest space news—Cosmos is your all-in-one stargazing companion.


https://github.com/user-attachments/assets/dbe6930e-ce1b-4189-8f33-b63131509973




---

## ✨ Features

### 🛰️ NASA Astronomy Picture of the Day (APOD)
- View stunning daily space imagery from NASA's APOD API.
- Tap any image to view details, description, and explore it in **Augmented Reality**.

### 🔭 AR Constellation Scanner
- Upload or take a photo of the night sky.
- Using CoreML + Vision, the app predicts the visible **constellations**.
- Tap any result to view that constellation in **3D AR**, projected in your space.

### 🌠 Star Register Viewer
- Search registered stars with your official registration number.
- Visualize constellations in real-time with native overlays and interactive controls.
- Uses the [Star Register](https://software.star-register.com) embedded tool with custom SwiftUI chrome.

### 📰 Space News (via Spaceflight API)
- Get the latest headlines from top space news sites.
- Filter by launch events, agencies, or authors.
- Tap to read full articles with smooth WebView transition.

### 🕓 Constellation Visibility Timings
- See when constellations rise, fully appear, and set.
- Calculate **astronomical night** timeframes for best viewing.
- Future support planned for **location-based visibility**.

### 🪪 Profile View (using Firebase)
- Sign up and login with **Email/Password** or **Google**.
- View personalized content and saved history.
- More features coming: saved stars, dark mode preferences, etc.

---

## 🛠️ Technologies Used

- **SwiftUI** for declarative and modern iOS UI
- **ARKit + SceneKit** for 3D star model projections
- **CoreML + Vision** for constellation recognition from images
- **Firebase Auth** for login, session management
- **Google Sign-In** integration
- **WKWebView** for embedded star register viewer
- **Spaceflight News API** for real-time space articles
- **NASA APOD API** for daily media

---

## 🧪 Screenshots

### 🌌 Home & APOD
![APOD Screen](./screenshots/apod.png)
> Displays daily NASA image with AR viewing option.

### 🔎 Constellation Scanner
![Scanner](./screenshots/scanner.png)
> Upload or capture sky photos and detect constellations.

### 📲 AR View
![AR View](./screenshots/ar.png)
> Visualizes constellation model in 3D space using ARKit.

### 📰 Space News
![News Feed](./screenshots/news.png)
> Spaceflight news with source, summary, and shareable links.

### 🔐 Login & Profile
![Login](./screenshots/login.png)
> Firebase-backed login with Google and email options.

### 🌟 Star Register (WebView)
![Star Register](./screenshots/star-register.png)
> A smooth embedded star map browser with native navigation overlays.

---

## 🔧 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Cosmos.git
   cd Cosmos

