# Quick Start Guide - FastAPI Backend

## 🚀 Getting Started

Follow these steps to set up and run the Party Game App with the FastAPI backend.

### Step 1: Backend Setup

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Install Python dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure environment**:
   ```bash
   # Copy the example file
   copy .env.example .env
   ```

4. **Edit `.env` file** and add your Gemini API key:
   ```env
   GEMINI_API_KEY=your_actual_api_key_here
   GEMINI_MODEL=gemini-1.5-pro
   RATE_LIMIT=60/minute
   CACHE_TTL=300
   ALLOWED_ORIGINS=*
   ```

5. **Start the backend server**:
   ```bash
   python main.py
   ```
   
   You should see:
   ```
   INFO:     Uvicorn running on http://0.0.0.0:8000
   ```

### Step 2: Test the Backend

Open a new terminal and test the health endpoint:

```bash
curl http://localhost:8000/api/health
```

You should get:
```json
{
  "status": "healthy",
  "timestamp": "2026-01-01T...",
  "gemini_configured": true
}
```

### Step 3: Run the Flutter App

1. **Open a new terminal** (keep the backend running!)

2. **Navigate to project root**:
   ```bash
   cd C:\Users\JULIENT\OneDrive\Desktop\PROJECTS\party_game_app
   ```

3. **Install Flutter dependencies** (if not already done):
   ```bash
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   # For Android
   flutter run

   # For Windows
   flutter run -d windows
   ```

### Step 4: Test the Integration

1. Open the app
2. Select any game mode (e.g., "Never Have I Ever")
3. Click the "Generate AI Content" button
4. You should see AI-generated content!

## 🔧 Troubleshooting

### "Cannot connect to server"
- Make sure the backend is running on port 8000
- Check if `http://localhost:8000/api/health` works in your browser

### "GEMINI_API_KEY not configured"
- Verify your `.env` file in the `backend/` directory
- Make sure the API key is valid
- Restart the backend server after changing `.env`

### Backend not starting
- Check if Python 3.9+ is installed: `python --version`
- Try installing dependencies again: `pip install -r requirements.txt`
- Check if port 8000 is already in use

## 🚀 Production Deployment

### Deploy Backend to Render (Free)

1. Push your code to GitHub
2. Go to [render.com](https://render.com) and sign up
3. Click "New +" → "Web Service"
4. Connect your repository
5. Configure:
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Environment Variables**: Add `GEMINI_API_KEY`
6. Deploy!

### Update Flutter App for Production

Edit `lib/services/api_service.dart`:

```dart
static const String _prodBaseUrl = 'https://your-app.onrender.com';
```

Then rebuild your app:

```bash
flutter build apk --release
```

## 📚 Next Steps

- Read the [Backend README](backend/README.md) for API documentation
- Explore the [Main README](README.md) for app features
- Check out the deployment options in the backend docs

---

**Need help?** Create an issue in the repository!
