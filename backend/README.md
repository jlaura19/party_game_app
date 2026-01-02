# 🎮 Party Game API Backend

FastAPI backend that securely proxies requests to Google's Gemini API for the Party Game Companion app.

## 🚀 Quick Start

### Prerequisites

- Python 3.9 or higher
- pip (Python package manager)
- Google Gemini API Key ([Get one here](https://aistudio.google.com/app/apikey))

### Installation

1. **Navigate to backend directory**:
   ```bash
   cd backend
   ```

2. **Create virtual environment** (recommended):
   ```bash
   python -m venv venv
   
   # Activate on Windows
   venv\Scripts\activate
   
   # Activate on macOS/Linux
   source venv/bin/activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables**:
   ```bash
   # Copy the example file
   copy .env.example .env
   
   # Edit .env and add your Gemini API key
   ```

5. **Run the server**:
   ```bash
   # Development mode with auto-reload
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   
   # Or use Python directly
   python main.py
   ```

The API will be available at `http://localhost:8000`

## 📚 API Documentation

Once running, visit:
- **Interactive API Docs**: http://localhost:8000/docs
- **Alternative Docs**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/api/health

## 🎯 Endpoints

All generation endpoints accept POST requests with JSON body.

### 1. Never Have I Ever
```http
POST /api/generate/never-have-i-ever
Content-Type: application/json

{
  "difficulty": "moderate"  // mild, moderate, or spicy
}
```

### 2. Most Likely To
```http
POST /api/generate/most-likely-to
Content-Type: application/json

{
  "difficulty": "moderate"
}
```

### 3. Truth
```http
POST /api/generate/truth
Content-Type: application/json

{
  "difficulty": "moderate"
}
```

### 4. Dare
```http
POST /api/generate/dare
Content-Type: application/json

{
  "difficulty": "moderate"
}
```

### 5. Roast
```http
POST /api/generate/roast
Content-Type: application/json

{
  "name": "John",
  "trait": "always being late",
  "difficulty": "moderate"
}
```

### 6. Debate Topic
```http
POST /api/generate/debate
Content-Type: application/json

{
  "difficulty": "moderate"
}
```

### 7. Cocktail Recipe
```http
POST /api/generate/cocktail
Content-Type: application/json

{
  "ingredients": "vodka, lime, mint"
}
```

### Response Format

All endpoints return:
```json
{
  "content": "Generated content here",
  "cached": false,
  "timestamp": "2026-01-01T20:57:00.000Z"
}
```

## ⚙️ Configuration

Edit `.env` file:

```env
# Required: Your Gemini API Key
GEMINI_API_KEY=your_api_key_here

# Optional: Model to use (default: gemini-1.5-pro)
GEMINI_MODEL=gemini-1.5-pro

# Optional: Rate limiting (default: 60/minute)
RATE_LIMIT=60/minute

# Optional: Cache TTL in seconds (default: 300)
CACHE_TTL=300

# Optional: CORS origins (default: *)
ALLOWED_ORIGINS=http://localhost:*,https://yourdomain.com
```

## 🔒 Security Features

- ✅ **API Key Protection**: Key stored server-side, never exposed to clients
- ✅ **Rate Limiting**: 60 requests per minute per IP (configurable)
- ✅ **CORS Protection**: Configurable allowed origins
- ✅ **Input Validation**: Pydantic models validate all requests
- ✅ **Error Handling**: Comprehensive error responses

## 🚀 Deployment

### Option 1: Render (Recommended - Free Tier Available)

1. Create account at [render.com](https://render.com)
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Configure:
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Environment Variables**: Add `GEMINI_API_KEY`
5. Deploy!

Your API will be at: `https://your-app-name.onrender.com`

### Option 2: Railway

1. Create account at [railway.app](https://railway.app)
2. Click "New Project" → "Deploy from GitHub"
3. Select your repository
4. Add environment variable: `GEMINI_API_KEY`
5. Railway auto-detects Python and deploys

### Option 3: Google Cloud Run

```bash
# Build and deploy
gcloud run deploy party-game-api \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars GEMINI_API_KEY=your_key
```

### Option 4: Docker

```dockerfile
# Dockerfile (create this file)
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

```bash
# Build and run
docker build -t party-game-api .
docker run -p 8000:8000 --env-file .env party-game-api
```

## 🧪 Testing

### Test with curl

```bash
# Health check
curl http://localhost:8000/api/health

# Generate content
curl -X POST http://localhost:8000/api/generate/never-have-i-ever \
  -H "Content-Type: application/json" \
  -d '{"difficulty": "moderate"}'
```

### Test with Python

```python
import requests

response = requests.post(
    "http://localhost:8000/api/generate/roast",
    json={
        "name": "Alex",
        "trait": "terrible jokes",
        "difficulty": "spicy"
    }
)

print(response.json())
```

## 📊 Features

- **Caching**: Responses cached for 5 minutes (configurable)
- **Retry Logic**: Automatic retry with exponential backoff
- **Rate Limiting**: Prevents API abuse
- **Logging**: Comprehensive request/error logging
- **CORS**: Configurable cross-origin support

## 🐛 Troubleshooting

### "GEMINI_API_KEY not configured"
- Make sure `.env` file exists in the backend directory
- Verify the API key is correct
- Restart the server after changing `.env`

### Rate limit errors
- Increase `RATE_LIMIT` in `.env`
- Reduce request frequency from client
- Check Gemini API quota

### CORS errors
- Add your Flutter app's origin to `ALLOWED_ORIGINS` in `.env`
- For development, use `ALLOWED_ORIGINS=*`

## 📝 License

Part of the Party Game Companion project.

---

**Made with ❤️ using FastAPI**
