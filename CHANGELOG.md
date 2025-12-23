# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-20

### Added
- Initial release of Swiish
- Digital business card creation and management
- QR code generation (simple URL and vCard formats)
- Progressive Web App (PWA) support with offline capabilities
- Admin dashboard for card management
- Privacy controls (require interaction, obfuscation, block robots)
- Theme customization (pre-built Tailwind themes and custom hex colors)
- File upload support for avatars and banner images
- Dark mode support (automatic and manual toggle)
- Responsive design for desktop, tablet, and mobile
- Docker support with docker-compose for easy deployment
- JWT-based authentication
- CSRF protection
- Rate limiting
- Input validation and sanitization
- Security headers via Helmet
- SQLite database for data storage

### Security
- JWT-based authentication with httpOnly cookies
- XSS protection with DOMPurify
- CSRF token validation
- Rate limiting on sensitive endpoints
- Secure file upload validation (MIME type checking)
- Security headers via Helmet middleware
- Input validation and sanitization

