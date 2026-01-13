# Vercel Deployment Troubleshooting Guide

## Common Issues and Solutions

### 1. 404: DEPLOYMENT_NOT_FOUND Error

**Problem:** Vercel shows "404: NOT_FOUND" with no build logs.

**Solutions:**

#### A. Check Project Structure
Ensure your project has the correct structure:
```
F1-bot-vercel/
├── app.py              # Main Flask application
├── f1_bot_live.py      # Bot logic
├── requirements.txt     # Python dependencies
├── vercel.json         # Vercel configuration
├── streams.txt         # Stream configuration
├── README.md          # Documentation
└── .gitignore         # Git ignore rules
```

#### B. Verify Vercel.json Configuration
Make sure `vercel.json` is correctly configured:
```json
{
  "version": 2,
  "name": "f1-bot-vercel",
  "builds": [
    {
      "src": "app.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/",
      "dest": "app.py"
    },
    {
      "src": "/health",
      "dest": "app.py"
    },
    {
      "src": "/webhook",
      "dest": "app.py"
    }
  ],
  "functions": {
    "app.py": {
      "maxDuration": 30
    }
  }
}
```

#### C. Check Vercel Dashboard Settings

**Project Settings:**
- **Framework Preset:** `None` (Custom)
- **Root Directory:** `/` (project root)
- **Install Command:** `pip install -r requirements.txt`
- **Build Command:** *(leave empty)*
- **Output Directory:** *(leave empty)*

#### D. Force Re-deployment
1. Go to Vercel Dashboard
2. Select your project
3. Click "Deployments"
4. Click "New Deployment"
5. Select your GitHub repository
6. Ensure "Auto-deploy" is enabled

### 2. Build Failures

**Problem:** Deployment fails during build process.

**Solutions:**

#### A. Check Requirements.txt
Ensure `requirements.txt` has correct dependencies:
```
python-telegram-bot==20.7
flask==3.0.3
requests==2.32.3
python-dotenv==1.0.1
```

#### B. Check Python Version
Vercel uses Python 3.11 by default. Ensure compatibility.

#### C. Check Syntax Errors
Run locally to check for syntax errors:
```bash
python -m py_compile app.py
python -m py_compile f1_bot_live.py
```

### 3. Function Timeouts

**Problem:** Functions timeout or take too long to respond.

**Solutions:**

#### A. Increase Timeout
Update `vercel.json`:
```json
"functions": {
  "app.py": {
    "maxDuration": 60
  }
}
```

#### B. Optimize Code
- Reduce API call timeouts
- Add caching for frequently accessed data
- Use async/await properly

### 4. Environment Variables Not Set

**Problem:** Bot token not configured.

**Solutions:**

#### A. Set Environment Variable
In Vercel Dashboard:
1. Go to Project Settings
2. Click "Environment Variables"
3. Add: `TELEGRAM_BOT_TOKEN` with your bot token

#### B. Verify Token
Ensure your bot token is valid:
- Get token from @BotFather
- Test token: `https://api.telegram.org/bot{TOKEN}/getMe`

### 5. Webhook Not Working

**Problem:** Bot doesn't respond to messages.

**Solutions:**

#### A. Set Webhook
After deployment, set webhook:
```bash
curl -X POST "https://api.telegram.org/bot{TOKEN}/setWebhook?url=https://your-project.vercel.app/webhook"
```

#### B. Check Webhook Status
```bash
curl "https://api.telegram.org/bot{TOKEN}/getWebhookInfo"
```

#### C. Verify URL
Ensure webhook URL is correct:
- Use HTTPS
- Include full path: `/webhook`
- No trailing slash

### 6. Logs Not Visible

**Problem:** Can't see logs in Vercel dashboard.

**Solutions:**

#### A. Check Logs Endpoint
Access logs via: `https://your-project.vercel.app/logs`

#### B. Check Vercel Dashboard
1. Go to Project
2. Click "Functions"
3. Select your function
4. View logs

#### C. Add More Logging
Ensure logging is properly configured in `app.py`:
```python
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO,
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler("bot.log", mode="a")
    ]
)
```

### 7. Import Errors

**Problem:** Module import errors.

**Solutions:**

#### A. Check File Paths
Ensure all imports use correct relative paths:
```python
from f1_bot_live import (
    start,
    show_menu,
    # ... other imports
)
```

#### B. Check Dependencies
Ensure all required packages are in `requirements.txt`.

### 8. Memory Issues

**Problem:** Functions exceed memory limits.

**Solutions:**

#### A. Reduce Memory Usage
- Use generators instead of lists for large datasets
- Close file handles properly
- Use efficient data structures

#### B. Increase Memory Limit
Contact Vercel support to increase memory limits if needed.

## Debugging Steps

### 1. Local Testing
Test locally before deploying:
```bash
# Install dependencies
pip install -r requirements.txt

# Run locally
python app.py
```

### 2. Check Vercel Logs
1. Go to Vercel Dashboard
2. Select your project
3. Click "Functions"
4. View function logs

### 3. Test Endpoints
Test each endpoint individually:
```bash
# Health check
curl https://your-project.vercel.app/health

# Logs
curl https://your-project.vercel.app/logs
```

### 4. Telegram Bot Testing
Test bot functionality:
1. Send `/start` to your bot
2. Check if responses are received
3. Verify webhook is working

## Getting Help

If issues persist:

1. **Check Vercel Status:** https://www.vercel-status.com/
2. **Vercel Documentation:** https://vercel.com/docs
3. **GitHub Issues:** Check project issues
4. **Telegram Bot API:** https://core.telegram.org/bots/api

## Common Error Messages

- **"Function timed out"**: Increase `maxDuration` in vercel.json
- **"ImportError"**: Check requirements.txt and file paths
- **"404 Not Found"**: Verify vercel.json routes and file structure
- **"500 Internal Server Error"**: Check logs for specific error details
- **"Webhook not set"**: Manually set webhook using Telegram API