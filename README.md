# TalkLoop

> **Connect. Chat. Stay Anonymous.**

TalkLoop is a real-time anonymous chat application built with Flutter and Node.js. It allows users to create an anonymous identity, find strangers, and communicate in real time without exposing their account identity to the person they are chatting with.

## 📱 Screenshots

### Splash Screen
![TalkLoop Splash Screen](screenshots/01_splash.jpg)

### Create Account
![Create Account](screenshots/02_create_account.jpg)

### Profile Setup
![Profile Setup](screenshots/03_profile_setup.jpg)

### Anonymous Identity
![Anonymous Identity](screenshots/04_anonymous_identity.jpg)

### Home
![TalkLoop Home](screenshots/05_home.jpg)

### User Profile
![User Profile](screenshots/06_profile.jpg)

### Searching for a Stranger
![Searching for a Stranger](screenshots/07_searching.jpg)

### Real-Time Chat
![Real-Time Chat](screenshots/08_chat.jpg)

### Report User
![Report User](screenshots/09_report_user.jpg)

### Settings
![Settings](screenshots/10_settings_drawer.jpg)

### Appearance
![Appearance](screenshots/11_appearance.jpg)

### About TalkLoop
![About TalkLoop](screenshots/12_about_talkloop.jpg)

### Privacy Policy
![Privacy Policy](screenshots/13_privacy_policy.jpg)

### Rate TalkLoop
![Rate TalkLoop](screenshots/14_rate_talkloop.jpg)

---

## ✨ Features

- Anonymous stranger conversations
- Random stranger matching
- Interest-based matching
- Real-time messaging with Socket.IO
- Real-time typing indicator
- Anonymous display name and avatar
- Anonymous profile management
- User profile management
- Block users
- Report users
- Blocked/reported users are excluded from matching
- Skip/end-chat functionality
- Automatic stranger-disconnect handling
- Network/disconnection handling
- Online user count
- Message rate limiting
- Stranger matching rate limiting
- Profile and anonymous identity change limits
- Light, dark, and system appearance modes
- Privacy Policy and About screens
- Rate-app screen

## 🛠️ Tech Stack

### Frontend

- Flutter
- Dart
- Dio
- Socket.IO Client

### Backend

- Node.js
- Express.js
- Socket.IO
- MongoDB
- Mongoose
- JWT
- bcryptjs
- Multer
- Cloudinary
- Express Rate Limit

### Deployment

- Render
- MongoDB

## 🏗️ Architecture

```text
                    ┌──────────────────────┐
                    │     Flutter App      │
                    │       Android        │
                    └──────────┬───────────┘
                               │
                    REST API + Socket.IO
                               │
                               ▼
                    ┌──────────────────────┐
                    │    Node.js Server    │
                    │ Express + Socket.IO  │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       MongoDB        │
                    │       Mongoose       │
                    └──────────────────────┘
```

## 🔐 Anonymous Matching

TalkLoop keeps the user's account identity separate from their anonymous chat identity.

During a conversation, the stranger sees the anonymous profile rather than the user's account email or other account credentials.

Matching also takes blocking and reporting relationships into account so users who should not interact are excluded from the matching pool.

## 💬 Real-Time Communication

Socket.IO is used for real-time communication between matched users.

The application handles:

- Stranger matching
- Room creation
- Message delivery
- Typing events
- Stop-typing events
- Chat termination
- Stranger disconnection
- Reconnection/network-related states

Each active conversation is associated with a Socket.IO room.

## 🛡️ Safety Features

TalkLoop includes basic user-safety controls:

- **Block** — prevents unwanted interaction with a user.
- **Report** — allows users to report inappropriate behavior/content.
- **Matching filters** — blocked and reported relationships are considered before creating a match.
- **Rate limiting** — limits abusive or excessive API/socket actions.

## 📂 Project Structure

```text
TalkLoop/
│
├── frontend/
│   ├── lib/
│   ├── assets/
│   ├── android/
│   └── pubspec.yaml
│
├── backend/
│   ├── src/
│   │   ├── config/
│   │   ├── controllers/
│   │   ├── middleware/
│   │   ├── models/
│   │   ├── routes/
│   │   └── sockets/
│   ├── package.json
│   └── server.js
│
└── README.md
```

## 🚀 Running Locally

### 1. Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd TalkLoop
```

### 2. Backend setup

```bash
cd backend
npm install
```

Create a `.env` file:

```env
PORT=3000
MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret
```

Add the remaining environment variables required by your Cloudinary/auth configuration.

Start the backend:

```bash
npm run dev
```

or:

```bash
node server.js
```

### 3. Flutter setup

Open a new terminal:

```bash
cd frontend
flutter pub get
flutter run
```

For a release APK:

```bash
flutter build apk --release
```

## ⚙️ Production

The backend is deployed on Render and the Flutter application communicates with the production REST API and Socket.IO server.

For local development, update the frontend API configuration to point to your local backend instead of the production server.

## 🔒 Privacy

TalkLoop includes an in-app Privacy Policy covering account information, anonymous profiles, anonymous conversations, blocking/reporting, and related data handling.

## 📌 Project Status

**Completed — production-tested prototype**

The core application flow has been implemented and tested across Android and web clients, including real-time matching and chat behavior.

## 👨‍💻 Developer

**Karan Yadav**

GitHub: [Shunya-karan](https://github.com/Shunya-karan)

LinkedIn: [Karan Yadav](https://www.linkedin.com/in/karan-yadav-7a600431b/)

## 📄 License

This project is licensed under the MIT License.
