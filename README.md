# 🎉 Party Game Companion

A modern Flutter app featuring 7 fun party games with AI-powered content generation using Google's Gemini API.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Gemini_AI-8E75B2?style=for-the-badge&logo=google&logoColor=white)

## 🎮 Game Modes

### 1. Never Have I Ever 🍺
Classic party game with preset statements and AI-generated custom content.

### 2. Most Likely To 👥
Vote on who's most likely to do hilarious scenarios. AI creates unique situations.

### 3. Truth or Dare 🔥
Choose between revealing truths or accepting dares. AI generates spicy questions and challenges.

### 4. Roast Master 🎤
AI-powered roast generator. Enter a name and trait, get a witty roast.

### 5. Debate Duel ⚖️
AI generates absurd debate topics to settle friendly arguments.

### 6. Cursed Bartender 🍹
Describe your ingredients or vibe, get an AI-generated cocktail recipe.

### 7. Dice Roller 🎲
Beautiful 3D animated dice for board games and decision-making.

## ✨ Features

- 🤖 **AI Integration**: Powered by Google's Gemini 1.5 Pro
- 🎨 **Modern UI**: Material 3 design with gradient themes
- ✨ **Smooth Animations**: Flutter Animate for delightful transitions
- 📱 **Haptic Feedback**: Vibration on interactions
- 💾 **Offline Mode**: All games work without internet (AI optional)
- 🎯 **State Management**: Clean architecture with Riverpod
- 🌈 **Custom Themes**: Each game has unique gradient colors
- 🔄 **Smart API Management**: Rate limiting, caching, and retry logic
- 📦 **Async Initialization**: Proper async/await for storage and services

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Windows/Android/iOS development setup
- Google Gemini API Key (for AI features)

### Get Your API Key

1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Click "Create API Key"
3. Copy your API key
4. Create a `.env` file in the project root (never commit this file!)
5. Add your key: `GEMINI_API_KEY=your_api_key_here`

### Installation

1. **Clone or navigate to the project**:
   ```bash
   cd C:\Users\JULIENT\OneDrive\Desktop\PROJECTS\party_game_app
   ```

2. **Create .env file with your API key**:
   ```bash
   # Copy the example
   copy .env.example .env
   # Edit .env with your actual API key
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   # For Android with .env file:
   flutter run
   
   # For production (pass API key directly):
   flutter run --dart-define=GEMINI_API_KEY=your_api_key
   ```

## 📦 Build for Production

### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle
```bash
flutter build appbundle --release
```

### Windows
```bash
flutter build windows --release
```

### iOS (macOS only)
```bash
flutter build ios --release
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9.2
- **Language**: Dart 3.9.2
- **State Management**: Riverpod 2.6.1
- **AI**: Google Generative AI 0.4.6
- **Animations**: Flutter Animate 4.5.0
- **Storage**: SharedPreferences 2.3.3
- **Haptics**: Vibration 2.0.0

## 📁 Project Structure

```
party_game_app/
├── backend/                     # FastAPI backend server
│   ├── main.py                 # API endpoints
│   ├── requirements.txt        # Python dependencies
│   ├── .env                    # Environment config (gitignored)
│   └── README.md               # Backend documentation
├── lib/
│   ├── main.dart               # App entry point
│   ├── constants/              # App constants
│   │   ├── api_config.dart    # API configuration
│   │   ├── app_colors.dart    # Color palette
│   │   └── game_data.dart     # Preset game content
│   ├── models/                 # Data models
│   │   ├── game_mode.dart
│   │   └── game_card.dart
│   ├── services/               # Business logic
│   │   ├── api_service.dart   # HTTP client for backend
│   │   ├── gemini_service.dart # AI integration wrapper
│   │   └── storage_service.dart # Local persistence
│   ├── providers/              # State management
│   │   ├── app_providers.dart
│   │   └── game_providers.dart
│   ├── widgets/                # Reusable widgets
│   │   ├── gradient_button.dart
│   │   ├── animated_game_card.dart
│   │   └── animated_dice.dart
│   └── screens/                # App screens
│       ├── main_menu_screen.dart
│       ├── card_game_screen.dart
│       ├── truth_dare_screen.dart
│       ├── roast_master_screen.dart
│       ├── debate_duel_screen.dart
│       ├── bartender_screen.dart
│       └── dice_roller_screen.dart
```

### Backend Architecture (NEW!)

The app now uses a **FastAPI backend** to securely proxy Gemini API requests:

```
Flutter App → FastAPI Backend → Gemini API
```

**Benefits**:
- 🔒 API key stays secure on the server
- 🚀 Better rate limiting and caching
- 🔄 Easy to switch AI providers
- 📊 Centralized monitoring and logging

**Setup**:

1. **Start the backend** (see [backend/README.md](backend/README.md)):
   ```bash
   cd backend
   pip install -r requirements.txt
   # Add your GEMINI_API_KEY to .env
   python main.py
   ```

2. **Configure Flutter app**:
   - For local development, the app uses `http://localhost:8000` by default
   - For production, update the URL in `lib/services/api_service.dart`

**Deployment**: The backend can be deployed to Render, Railway, Google Cloud Run, or any Python hosting service. See [backend/README.md](backend/README.md) for detailed instructions.

> **Note**: The old direct API integration is replaced with this more secure backend approach.

###🎨 Customization

### Change Colors
Edit `lib/constants/app_colors.dart` to customize the color scheme.

### Add Game Content
Add new statements/questions to `lib/constants/game_data.dart`.

### Modify AI Prompts
Update prompts in `lib/services/gemini_service.dart` to change AI behavior.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Add new game modes
- Improve animations
- Enhance AI prompts
- Fix bugs
- Improve documentation

## 📋 Recent Updates (v2.0.0)

- ✅ **NEW: FastAPI Backend** - Secure proxy for Gemini API calls
- ✅ Added backend with rate limiting, caching, and retry logic
- ✅ Created HTTP service for backend communication
- ✅ Updated GeminiService to use backend instead of direct API
- ✅ Improved security by keeping API key server-side
- ✅ Added comprehensive backend documentation
- ✅ Fixed StorageService initialization with async/await pattern
- ✅ Fixed text overflow on game mode cards

## �📝 License

This project is open source and available for personal and educational use.

## 🙏 Acknowledgments

- Original HTML/React version inspiration
- Google Gemini AI for content generation
- Flutter team for the amazing framework
- Community packages used in this project

## 📧 Support

For issues or questions, please create an issue in the repository.

---

**Made with ❤️ using Flutter**

Enjoy your party! 🎉🎊🥳
