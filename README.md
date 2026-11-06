# 📱 AhmadBlog - Flutter App

A beautiful Flutter application for sharing articles about technology, creativity, lifestyle, and more.

## ✨ Features
- 📚 Browse articles across multiple categories
- 🎯 Search functionality
- 💾 Offline article viewing (cached)
- 🎨 Modern, responsive UI
- 🔗 Backend API integration with EC2

## 📋 Prerequisites
- Flutter SDK >= 2.19.0
- Dart SDK >= 2.19.0
- MySQL (on EC2)
- AWS Account (for Amplify & EC2)

## 🚀 Quick Start

### 1. Clone Repository
\`\`\`bash
git clone https://github.com/Ahmadansari1942/fluterappsimple.git
cd fluterappsimple
\`\`\`

### 2. Setup Environment Variables
\`\`\`bash
cp .env.example .env
# Edit .env with your EC2 IP address
\`\`\`

### 3. Install Dependencies
\`\`\`bash
flutter pub get
\`\`\`

### 4. Run App
\`\`\`bash
flutter run
\`\`\`

## 🔧 Backend Setup

See `backend_setup.md` for complete EC2 & MySQL configuration.

## 📲 Deployment

### AWS Amplify Deployment
1. Connect GitHub repository to AWS Amplify
2. Select main branch
3. Use default build settings
4. Add environment variables in Amplify console
5. Deploy

### Web Version
\`\`\`bash
flutter build web --release
\`\`\`

## 📊 Project Structure

- **lib/pages/** - UI screens
- **lib/models/** - Data models
- **lib/services/** - API integration
- **lib/widgets/** - Reusable components
- **assets/** - Images and icons

## 🌍 API Endpoints (Backend)

- `GET /api/articles` - Get all articles
- `GET /api/articles/:id` - Get article by ID
- `POST /api/articles` - Create new article
- `PUT /api/articles/:id` - Update article
- `DELETE /api/articles/:id` - Delete article

## 🔐 CORS Configuration

Backend is configured to accept requests from:
- `http://localhost:3000` (local testing)
- AWS Amplify domain
- Production domain (when added)

## 📧 Contact

**Developer:** Ahmad Ansari  
**GitHub:** [@Ahmadansari1942](https://github.com/Ahmadansari1942)

## 📄 License

MIT License - feel free to use this project as you wish.
