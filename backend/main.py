"""
FastAPI Backend for Party Game Companion App
Securely proxies requests to Google's Gemini API
"""

import os
import logging
from typing import Optional
from datetime import datetime, timedelta
from functools import lru_cache

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from dotenv import load_dotenv
import google.generativeai as genai
from cachetools import TTLCache

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Party Game API",
    description="AI-powered content generation for party games",
    version="1.0.0"
)

# Rate limiting
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# CORS Configuration
allowed_origins = os.getenv("ALLOWED_ORIGINS", "*").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins if allowed_origins != ["*"] else ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Cache configuration (5 minute TTL)
cache_ttl = int(os.getenv("CACHE_TTL", "300"))
response_cache = TTLCache(maxsize=100, ttl=cache_ttl)

# Gemini Configuration
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-1.5-pro")

if not GEMINI_API_KEY:
    logger.warning("GEMINI_API_KEY not found in environment variables!")
else:
    genai.configure(api_key=GEMINI_API_KEY)
    logger.info(f"Gemini API configured with model: {GEMINI_MODEL}")


# Request/Response Models
class GenerateRequest(BaseModel):
    difficulty: Optional[str] = Field(default="moderate", description="Difficulty level: mild, moderate, or spicy")


class RoastRequest(BaseModel):
    name: str = Field(..., description="Name of the person to roast")
    trait: str = Field(default="", description="Trait or characteristic to roast about")
    difficulty: Optional[str] = Field(default="moderate", description="Difficulty level")


class CocktailRequest(BaseModel):
    ingredients: str = Field(..., description="Ingredients or vibe for the cocktail")


class GenerateResponse(BaseModel):
    content: str
    cached: bool = False
    timestamp: str


# Difficulty level prompts
def get_difficulty_guide(difficulty: str) -> str:
    """Get content guidance based on difficulty level"""
    guides = {
        "mild": "Keep it family-friendly and safe for all audiences.",
        "moderate": "Make it fun and slightly cheeky, appropriate for a standard party.",
        "spicy": "Make it bold, daring, and adult-oriented. Push boundaries."
    }
    return guides.get(difficulty.lower(), guides["moderate"])


def get_roast_intensity(difficulty: str) -> str:
    """Get roast intensity based on difficulty"""
    intensities = {
        "mild": "playful and lighthearted",
        "moderate": "witty and slightly savage",
        "spicy": "brutal, savage, and hilariously mean"
    }
    return intensities.get(difficulty.lower(), intensities["moderate"])


def get_debate_intensity(difficulty: str) -> str:
    """Get debate topic intensity"""
    intensities = {
        "mild": "silly and wholesome",
        "moderate": "silly, absurd, or funny",
        "spicy": "controversial, provocative, or hilariously inappropriate"
    }
    return intensities.get(difficulty.lower(), intensities["moderate"])


async def generate_with_retry(prompt: str, max_retries: int = 3) -> str:
    """Generate content with retry logic"""
    if not GEMINI_API_KEY:
        raise HTTPException(status_code=503, detail="Gemini API key not configured")
    
    # Check cache first
    cache_key = f"{prompt}"
    if cache_key in response_cache:
        logger.info(f"Cache hit for prompt: {prompt[:50]}...")
        return response_cache[cache_key]
    
    model = genai.GenerativeModel(
        model_name=GEMINI_MODEL,
        system_instruction="You are a creative AI assistant for party games. Generate fun, engaging content."
    )
    
    for attempt in range(max_retries):
        try:
            response = model.generate_content(prompt)
            
            if not response.text:
                raise HTTPException(status_code=500, detail="Empty response from AI")
            
            result = response.text.strip()
            
            # Cache the result
            response_cache[cache_key] = result
            logger.info(f"Generated and cached content (attempt {attempt + 1})")
            
            return result
            
        except Exception as e:
            logger.error(f"Generation error (attempt {attempt + 1}/{max_retries}): {str(e)}")
            
            if attempt == max_retries - 1:
                raise HTTPException(
                    status_code=500,
                    detail=f"Failed to generate content after {max_retries} attempts: {str(e)}"
                )
            
            # Exponential backoff
            import asyncio
            await asyncio.sleep(2 ** attempt)
    
    raise HTTPException(status_code=500, detail="Failed to generate content")


# Health check endpoint
@app.get("/api/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "gemini_configured": bool(GEMINI_API_KEY)
    }


# Game content generation endpoints
@app.post("/api/generate/never-have-i-ever", response_model=GenerateResponse)
@limiter.limit(os.getenv("RATE_LIMIT", "60/minute"))
async def generate_never_have_i_ever(request: Request, body: GenerateRequest):
    """Generate a Never Have I Ever statement"""
    intensity_guide = get_difficulty_guide(body.difficulty)
    prompt = (
        f"Generate a single, unique, creative, and funny 'Never Have I Ever' "
        f"statement for a group of 20-year-olds. {intensity_guide} "
        f"Keep it short (under 20 words). Do not include quotes or numbering."
    )
    
    content = await generate_with_retry(prompt)
    is_cached = f"{prompt}" in response_cache
    
    return GenerateResponse(
        content=content,
        cached=is_cached,
        timestamp=datetime.now().isoformat()
    )


@app.post("/api/generate/most-likely-to", response_model=GenerateResponse)
@limiter.limit(os.getenv("RATE_LIMIT", "60/minute"))
async def generate_most_likely_to(request: Request, body: GenerateRequest):
    """Generate a Most Likely To scenario"""
    intensity_guide = get_difficulty_guide(body.difficulty)
    prompt = (
        f"Generate a single, unique, creative, and funny 'Most Likely To' "
        f"statement for a group of 20-year-olds. {intensity_guide} "
        f"Keep it short (under 20 words). Do not include quotes or numbering."
    )
    
    content = await generate_with_retry(prompt)
    is_cached = f"{prompt}" in response_cache
    
    return GenerateResponse(
        content=content,
        cached=is_cached,
        timestamp=datetime.now().isoformat()
    )


@app.post("/api/generate/truth", response_model=GenerateResponse)
@limiter.limit(os.getenv("RATE_LIMIT", "60/minute"))
async def generate_truth(request: Request, body: GenerateRequest):
    """Generate a Truth question"""
    intensity_guide = get_difficulty_guide(body.difficulty)
    prompt = (
        f"Generate a Truth question for a party game for young adults. "
        f"{intensity_guide} Keep it short."
    )
    
    content = await generate_with_retry(prompt)
    is_cached = f"{prompt}" in response_cache
    
    return GenerateResponse(
        content=content,
        cached=is_cached,
        timestamp=datetime.now().isoformat()
    )


@app.post("/api/generate/dare", response_model=GenerateResponse)
@limiter.limit(os.getenv("RATE_LIMIT", "60/minute"))
async def generate_dare(request: Request, body: GenerateRequest):
    """Generate a Dare challenge"""
    intensity_guide = get_difficulty_guide(body.difficulty)
    prompt = (
        f"Generate a Dare challenge for a party game for young adults. "
        f"{intensity_guide} Physical or social. Keep it short."
    )
    
    content = await generate_with_retry(prompt)
    is_cached = f"{prompt}" in response_cache
    
    return GenerateResponse(
        content=content,
        cached=is_cached,
        timestamp=datetime.now().isoformat()
    )


@app.post("/api/generate/roast", response_model=GenerateResponse)
@limiter.limit(os.getenv("RATE_LIMIT", "60/minute"))
async def generate_roast(request: Request, body: RoastRequest):
    """Generate a roast"""
    intensity = get_roast_intensity(body.difficulty)
    trait = body.trait if body.trait else "being basic"
    prompt = (
        f"Write a {intensity} roast for a friend "
        f"named {body.name} who is known for: {trait}. "
        f"Keep it under 2 sentences. Direct address (use 'You')."
    )
    
    content = await generate_with_retry(prompt)
    is_cached = f"{prompt}" in response_cache
    
    return GenerateResponse(
        content=content,
        cached=is_cached,
        timestamp=datetime.now().isoformat()
    )


@app.post("/api/generate/debate", response_model=GenerateResponse)
@limiter.limit(os.getenv("RATE_LIMIT", "60/minute"))
async def generate_debate(request: Request, body: GenerateRequest):
    """Generate a debate topic"""
    intensity = get_debate_intensity(body.difficulty)
    prompt = (
        f"Generate a {intensity} debate topic for two friends. "
        f"Examples: 'Is a hotdog a sandwich?' or 'Would you rather have fingers "
        f"for toes or toes for fingers?'. Keep it short."
    )
    
    content = await generate_with_retry(prompt)
    is_cached = f"{prompt}" in response_cache
    
    return GenerateResponse(
        content=content,
        cached=is_cached,
        timestamp=datetime.now().isoformat()
    )


@app.post("/api/generate/cocktail", response_model=GenerateResponse)
@limiter.limit(os.getenv("RATE_LIMIT", "60/minute"))
async def generate_cocktail(request: Request, body: CocktailRequest):
    """Generate a cocktail recipe"""
    prompt = (
        f"Invent a creative, funny, or weird cocktail recipe based on these "
        f"ingredients/vibe: \"{body.ingredients}\". Give it a cool name. "
        f"Keep instructions short."
    )
    
    content = await generate_with_retry(prompt)
    is_cached = f"{prompt}" in response_cache
    
    return GenerateResponse(
        content=content,
        cached=is_cached,
        timestamp=datetime.now().isoformat()
    )


# Root endpoint
@app.get("/")
async def root():
    """Root endpoint with API information"""
    return {
        "name": "Party Game API",
        "version": "1.0.0",
        "status": "running",
        "endpoints": {
            "health": "/api/health",
            "never_have_i_ever": "/api/generate/never-have-i-ever",
            "most_likely_to": "/api/generate/most-likely-to",
            "truth": "/api/generate/truth",
            "dare": "/api/generate/dare",
            "roast": "/api/generate/roast",
            "debate": "/api/generate/debate",
            "cocktail": "/api/generate/cocktail"
        }
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
