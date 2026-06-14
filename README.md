<h1 align="center">🌐 Miljul</h1>
<p align="center"><b>Real-time online classroom & meeting app built with Flutter</b></p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" />
  <img src="https://img.shields.io/badge/WebRTC-333333?style=for-the-badge&logo=webrtc&logoColor=white" />
  <img src="https://img.shields.io/badge/Riverpod-1B1B1B?style=for-the-badge" />
</p>

> Create or join live classes, chat in real time, share your screen, and manage participants — all from one Flutter app.

---

## ✨ Features

- 🔐 Google Sign-In authentication
- 🏫 Create & join live classes / meetings
- 🎤 Mute / unmute audio on the fly
- 📹 Enable / disable video
- 🧑‍🏫 Admin & user role system
- 👤 Change display name before joining
- 👥 Live participant list with real-time count
- ✅ Accept / reject participants (admin only)
- ❌ Remove users from class (admin only)
- 🔄 Switch between front / rear camera
- 💬 Real-time chat during class
- 📊 Grid view of all participants
- 📺 Screen sharing support
- 🚪 End class / logout system

---

## 🛠️ Tech Stack

| Layer | Tech |
|---|---|
| Framework | Flutter & Dart |
| State Management | Riverpod |
| Backend / Auth | Firebase (Auth, Firestore) |
| Real-time Communication | WebRTC |

---

## 📂 Project Structure

```
lib/
├── models/        # Data models (user, class, participant)
├── providers/      # Riverpod providers / state management
├── services/      # Firebase & WebRTC service logic
├── screens/        # App screens (login, lobby, class room)
├── widgets/        # Reusable UI components
└── main.dart
```

---

## 🚀 Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/DivyanshMahor/miljul-app.git
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Add your Firebase config
Place your `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) inside the respective platform folders.

### 4. Run the app
```bash
flutter run
```

---

## 📸 Screenshots

> _Add screenshots / screen recordings of the lobby, live class, and chat screens here — visuals make a big difference!_

---

## 💡 What I Learned

- Real-time data sync with Firebase
- Implementing WebRTC for audio/video calls
- Role-based access control (admin vs participant)
- State management at scale using Riverpod
- Building a multi-screen, production-style Flutter app

---

## 🔥 Roadmap

- [ ] Recording of live classes
- [ ] Whiteboard / annotation tools
- [ ] Push notifications for class reminders
- [ ] Web build polish

---

## 👨‍💻 Developer

**Divyansh Mahor** — Flutter Developer
🔗 [LinkedIn](https://www.linkedin.com/in/divyansh-mahor/) · [GitHub](https://github.com/DivyanshMahor)

---

<p align="center">⭐ If you found this project interesting, consider giving it a star!</p>
