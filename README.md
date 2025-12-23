# Swiish

**Open-source digital business card platform with QR codes and PWA support**

Swiish is a self-hostable platform for creating and sharing digital business cards. Create beautiful, customizable business cards with QR codes, share them via links, and let users save your contact information directly to their phones.

## Features

- 📇 **Create and manage digital business cards** - Build professional digital cards with all your contact information
- 🎨 **Advanced theming engine** - Fully customizable design system with:
  - Multiple theme variants (swiish, minimal, or create your own)
  - Design token system (colors, textures, borders, border radius)
  - Background textures with customizable blend modes
  - Organization-level theme customization
  - Card-level theme selection
  - Automatic light/dark mode support
- 📱 **Progressive Web App (PWA)** - Install cards as apps on mobile devices for offline access
- 🔲 **QR code generation** - Generate QR codes with simple URLs or full vCard contact information
- 🔒 **Privacy controls** - Require interaction before revealing contact details, obfuscate contact info, and block search engines
- 📤 **File uploads** - Upload custom avatars and banner images
- 🌙 **Dark mode support** - Automatic dark mode with manual toggle
- 📱 **Responsive design** - Works beautifully on desktop, tablet, and mobile
- 🔐 **Admin dashboard** - Manage all your cards, users, and organization settings from a central dashboard

## Quick Start

### Prerequisites

- **For Docker deployment**: Docker and Docker Compose
- **For local development**: Node.js 18+ and npm

## Installation

### Option 1: Docker Deployment (Recommended)

Docker is the easiest way to deploy Swiish, whether for testing or production.

#### For Local Testing / Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/MrCrin/swiish.git
   cd swiish
   ```

2. **Set up environment:**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and set at minimum:
   ```env
   JWT_SECRET=your-secret-here  # Generate with: openssl rand -base64 32
   ADMIN_PASSWORD=your-password-here
   NODE_ENV=development  # Optional: makes APP_URL optional
   APP_URL=http://localhost:8095  # Optional if NODE_ENV=development
   ```

3. **Start the application:**
   ```bash
   docker-compose up -d
   ```

4. **Access the application:**
   - Main app: `http://localhost:8095`
   - Admin dashboard: `http://localhost:8095/admin`

#### For Production (Your Own Domain)

1. **Clone the repository on your server:**
   ```bash
   git clone https://github.com/MrCrin/swiish.git
   cd swiish
   ```

2. **Configure environment variables:**
   ```bash
   cp .env.example .env
   nano .env  # or use your preferred editor
   ```
   
   **Required settings for production:**
   ```env
   JWT_SECRET=your-strong-secret-here  # Generate with: openssl rand -base64 32
   ADMIN_PASSWORD=your-strong-password-here
   NODE_ENV=production
   APP_URL=https://yourdomain.com  # Your actual domain with https://
   ALLOWED_ORIGINS=https://yourdomain.com  # Your domain(s), comma-separated
   ```
   
   **Optional but recommended:**
   ```env
   FORCE_HTTPS=true  # If not using a reverse proxy
   # Email configuration (for invitations, password resets)
   SMTP_HOST=smtp.yourdomain.com
   SMTP_USER=your-email@yourdomain.com
   SMTP_PASSWORD=your-smtp-password
   ```

3. **Set up a reverse proxy (nginx/Traefik) with SSL:**
   
   **Example nginx configuration:**
   ```nginx
   server {
       listen 80;
       server_name yourdomain.com;
       return 301 https://$server_name$request_uri;
   }
   
   server {
       listen 443 ssl http2;
       server_name yourdomain.com;
       
       ssl_certificate /path/to/cert.pem;
       ssl_certificate_key /path/to/key.pem;
       
       location / {
           proxy_pass http://localhost:8095;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```
   
   Or use a service like [Traefik](https://traefik.io/) or [Caddy](https://caddyserver.com/) for automatic SSL.

4. **Start with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

5. **Access your application:**
   - Main app: `https://yourdomain.com`
   - Admin dashboard: `https://yourdomain.com/admin`

**Note:** The Docker container runs on port 8095 by default. If you're using a reverse proxy, you can change the port mapping in `docker-compose.yml` or keep it as-is and proxy to `localhost:8095`.

### Option 2: Manual Installation (For Development)

For local development without Docker:

1. **Clone and install dependencies:**
   ```bash
   git clone https://github.com/MrCrin/swiish.git
   cd swiish
   npm install
   ```

2. **Configure environment:**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and set:
   ```env
   JWT_SECRET=your-secret-here
   ADMIN_PASSWORD=your-password-here
   NODE_ENV=development  # Makes APP_URL optional
   # APP_URL is optional in development (defaults to http://localhost:3000)
   ```

3. **Start development server (with hot reload):**
   ```bash
   # Terminal 1: React development server (hot reload)
   npm start
   # Runs on http://localhost:3000
   ```
   
   **OR** build and serve production build:
   ```bash
   # Build the React application
   npm run build
   
   # Start the server
   npm run serve
   # Runs on http://localhost:3000 (or PORT from .env)
   ```

The application will run on the port specified in your `.env` file (default: 3000).

## Configuration

All configuration is done via environment variables. Copy `.env.example` to `.env` and fill in your values.

### Required Variables

- **`JWT_SECRET`** - Secret key for JWT token signing. **Always required.** Generate a strong random string:
  ```bash
  openssl rand -base64 32
  ```
- **`ADMIN_PASSWORD`** - Password for accessing the admin dashboard. **Always required.** Use a strong, unique password.
- **`APP_URL`** - Base URL for the application. 
  - **Required in production** (when `NODE_ENV=production`): Set to your actual domain with protocol, e.g., `https://yourdomain.com`
  - **Optional in development** (when `NODE_ENV=development`): Defaults to `http://localhost:3000`
  - Used for generating email links (invitations, password resets) and QR codes

### Optional Variables

- **`NODE_ENV`** - Environment mode. Set to `production` for production deployments (default: `development`)
  - In `development`: APP_URL is optional, more verbose error messages
  - In `production`: APP_URL is required, generic error messages, security features enabled
  
- **`PORT`** - Server port (default: `3000`). Note: Docker maps this to port 8095 by default
  
- **`JWT_EXPIRES_IN`** - JWT token expiration time (default: `24h`)
  
- **`ALLOWED_ORIGINS`** - Comma-separated list of allowed CORS origins
  - For local testing: `http://localhost:8095` or `http://localhost:3000`
  - For production: `https://yourdomain.com` (your actual domain)
  
- **`MAX_FILE_SIZE`** - Maximum file upload size in bytes (default: `5242880` = 5MB)
  
- **`FORCE_HTTPS`** - Set to `true` to force HTTPS redirects (default: `false`)
  - Usually not needed if using a reverse proxy (nginx/Traefik) which handles HTTPS
  
- **`ADMIN_EMAIL`** - Email for the default admin user (default: `admin@localhost`)
  
- **Email Configuration (SMTP)** - Optional, for email features:
  - `SMTP_HOST` - Your SMTP server
  - `SMTP_PORT` - SMTP port (usually 587 for TLS, 465 for SSL)
  - `SMTP_SECURE` - `true` for SSL (port 465), `false` for TLS (port 587)
  - `SMTP_USER` - SMTP username
  - `SMTP_PASSWORD` - SMTP password
  - `SMTP_FROM` - From address (defaults to ADMIN_EMAIL)
  
  If not configured, email features (invitations, password resets) will be logged to console in development mode.

See `.env.example` for all available options and their descriptions.

## Usage

### Creating Your First Card

1. Access the admin dashboard at `/admin`
2. Log in with your `ADMIN_PASSWORD`
3. Click "Create New Card"
4. Enter a unique slug (e.g., `john-doe`)
5. Fill in your contact information, upload images, customize the theme
6. Click "Save"
7. Your card is now available at `http://your-domain.com/john-doe`

### Sharing Cards

- **Direct Link**: Share the card URL directly
- **QR Code**: Click the share button on any card to generate a QR code
  - **Simple Mode**: QR code contains just the card URL
  - **Full Details Mode**: QR code contains vCard data for direct contact saving

### Privacy Controls

Each card supports three privacy options:

- **Require Interaction**: Users must click "See my details" before contact info is revealed
- **Client-Side Obfuscation**: Contact information is obfuscated in the HTML (basic protection)
- **Block Robots**: Prevents search engines from indexing the card

### Theme Customisation

Swiish features a powerful, centralized theming engine that gives you complete control over the application's appearance. The theming system operates at multiple levels, from application-wide design tokens to organization-level theme customization.

#### Theming Architecture

Swiish uses a **design token system** where all visual properties (colors, textures, border radius, border width) are defined in theme files. This makes it easy to create custom themes or modify existing ones.

**Theme Files Location:**
- `src/theme/swiish.js` - Default theme (included)
- `src/theme/minimal.js` - Minimal theme variant (included)
- Create your own theme files following the same structure

**How It Works:**
1. Theme files export design tokens (colors, textures, border radius, border width)
2. These tokens are converted to CSS custom properties at runtime
3. All components use these CSS variables, so changes apply site-wide automatically
4. Multiple theme variants can be switched via organization settings

#### Application Theme Customization

All design tokens are defined in theme files (e.g., `src/theme/swiish.js`). This is the single source of truth for the application's visual design.

**Customizing Colors:**

Edit `src/theme/swiish.js` to change any color. All colors support both light and dark themes:

```javascript
colors: {
  main: {
    light: '#fafaf9',   // Main page background (light theme)
    dark: '#18181b',    // Main page background (dark theme)
  },
  card: {
    light: '#ffffff',   // Card backgrounds (light theme)
    dark: '#27272a',    // Card backgrounds (dark theme)
  },
  // ... more colors
}
```

**Available Color Tokens:**
- `main` - Main page backgrounds
- `card` - Card and modal backgrounds
- `surface` - Secondary backgrounds, input fields
- `action` / `actionHover` - Primary action buttons
- `textPrimary` / `textSecondary` / `textMuted` / `textMutedSubtle` - Text colors (hierarchical)
- `border` / `borderSubtle` - Border colors
- `success` / `successHover` / `successBg` / `successText` / `successBorder` - Success states
- `error` / `errorHover` / `errorBg` / `errorText` / `errorBorder` - Error states
- `info` / `infoHover` / `infoBg` / `infoText` / `infoBorder` - Info states
- `link` / `linkBg` / `linkBorder` / `linkHover` - Link colors
- `inputBg` / `inputBorder` / `inputText` - Input field colors
- `focusRing` - Focus ring color
- `overlay` - Modal overlay color
- `confirm` / `confirmHover` - Confirm button colors

**All colors support both light and dark themes** - simply define `light` and `dark` properties for each color token.

**Customizing Border Radius:**

Control corner rounding throughout the app:

```javascript
borderRadius: {
  'card': '1rem',        // Cards, modals
  'page': '1.5rem',      // Setup/login pages
  'button': '9999px',    // Buttons (full circle)
  'input': '0.75rem',    // Input fields
  'badge': '0.5rem',     // Badges, small elements
}
```

**Customizing Border Width:**

Control border thickness:

```javascript
borderWidth: {
  'default': '1px',      // Standard borders
  'thick': '2px',        // Thick borders
  'avatar': '6px',       // Avatar borders
  'device': '8px',       // Device preview borders
}
```

**Using Hex Values:**

You can use hex values directly or Tailwind color references:

```javascript
// Hex values (recommended for exact control)
main: {
  light: '#fafaf9',
  dark: '#18181b',
}

// Or Tailwind references
const tailwindColors = require('tailwindcss/colors');
main: {
  light: tailwindColors.stone[50],
  dark: tailwindColors.zinc[900],
}
```

**Customizing Textures:**

The theming system supports background textures with customizable blend modes and opacity:

```javascript
textures: {
  main: {
    light: '/textures/sandTexture.jpg',  // Texture image path
    dark: '/textures/sandTexture.jpg',
    size: '540px 540px',                  // Texture size
    blendLight: 'multiply',                // CSS blend mode (light theme)
    blendDark: 'overlay',                  // CSS blend mode (dark theme)
    opacityLight: 0.08,                    // Opacity (0-1) for light theme
    opacityDark: 0.1                       // Opacity (0-1) for dark theme
  },
  surface: { /* ... */ },
  card: { /* ... */ }
}
```

**Creating Custom Theme Variants:**

1. Create a new file in `src/theme/` (e.g., `src/theme/custom.js`)
2. Export the same structure as `swiish.js`:
   ```javascript
   module.exports = {
     colors: { /* your colors */ },
     textures: { /* your textures */ },
     borderRadius: { /* your border radius */ },
     borderWidth: { /* your border widths */ }
   };
   ```
3. Import and register it in `src/App.js`:
   ```javascript
   const customTheme = require('./theme/custom');
   const THEME_FILES = { swiish: swiishTheme, minimal: minimalTheme, custom: customTheme };
   ```
4. Rebuild the application (`npm run build`)

**How It Works:**

1. Edit values in theme files (`src/theme/*.js`)
2. Rebuild the application (`npm run build`)
3. Changes apply site-wide automatically
4. Switch theme variants via organization settings in the admin dashboard

#### Organization-Level Theme Customization

Organizations can customize the theme colors available to their users:

- **Theme Variant Selection**: Choose between built-in theme variants (swiish, minimal) or custom variants
- **Custom Color Palette**: Define a custom color palette that users can choose from when creating cards
- **Theme Customization Control**: Enable or disable user theme customization per organization
- **Card-Level Themes**: Users can select from organization-approved colors or create custom hex color themes for individual cards

These card themes affect gradients, buttons, links, and text colors on the card itself, separate from the application theme. This allows organizations to maintain brand consistency while giving users flexibility.

## Development

### Local Development Setup

For active development with hot reload:

1. **Clone and install:**
   ```bash
   git clone https://github.com/MrCrin/swiish.git
   cd swiish
   npm install
   ```

2. **Set up environment:**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env`:
   ```env
   JWT_SECRET=dev-secret-change-in-production
   ADMIN_PASSWORD=dev-password
   NODE_ENV=development
   ALLOWED_ORIGINS=http://localhost:3000
   # APP_URL is optional in development
   ```

3. **Start development server:**
   ```bash
   # Terminal 1: React development server (hot reload)
   npm start
   # Runs on http://localhost:3000
   ```
   
   The React development server includes hot reload, so changes to React components will update automatically.
   
   **Note:** For full-stack development (testing API endpoints), you'll also need to run the backend:
   ```bash
   # Terminal 2: Build and run Express backend
   npm run build
   npm run serve
   ```
   
   Or use the watch mode for automatic rebuilds:
   ```bash
   # Terminal 2: Watch mode (rebuilds on file changes)
   npm run dev
   ```

### Project Structure

```
swiish/
├── src/                    # React frontend source
│   ├── App.js             # Main application component
│   ├── index.js           # React entry point
│   ├── index.css          # Global styles and CSS custom properties
│   └── theme/             # Theming engine - design tokens
│       ├── swiish.js      # Default theme variant (colors, textures, borders)
│       └── minimal.js     # Minimal theme variant
├── public/                # Static assets
│   ├── index.html         # HTML template
│   ├── manifest.json      # PWA manifest
│   ├── service-worker.js  # PWA service worker
│   ├── graphics/          # Logo files (SVG)
│   └── textures/          # Background texture images
├── data/                  # SQLite database (created automatically, gitignored)
│   └── .gitkeep          # Keeps directory in git
├── uploads/               # User-uploaded images (gitignored)
│   └── .gitkeep          # Keeps directory in git
├── server.js              # Express backend server
├── tailwind.config.js     # Tailwind configuration (uses theme files)
├── postcss.config.js      # PostCSS configuration
├── nodemon.json           # Nodemon configuration for development
├── Dockerfile             # Container build instructions
├── docker-compose.yml     # Container orchestration
├── .dockerignore          # Files excluded from Docker builds
├── .env.example           # Environment variables template
├── .gitignore             # Git ignore rules
├── package.json           # Node.js dependencies and scripts
├── CHANGELOG.md           # Version history
├── LICENSE                # AGPL-3.0 license
├── TRADEMARKS.md          # Trademark policy
└── README-SECURITY.md     # Security documentation
```

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Deployment

### Updating the Application

When new versions are released:

```bash
# On your server
cd /path/to/swiish
git pull origin master
docker-compose build --no-cache  # Rebuild to get latest code
docker-compose up -d  # Restart with new image
```

Your data (database and uploads) will persist across updates thanks to Docker volumes.

### Backup Recommendations

Regularly backup:
- `data/cards.db` - Your SQLite database
- `uploads/` - User-uploaded images

These directories are mounted as volumes in Docker, so backup the host directories. You can use:
```bash
# Backup database
cp data/cards.db backups/cards-$(date +%Y%m%d).db

# Backup uploads
tar -czf backups/uploads-$(date +%Y%m%d).tar.gz uploads/
```

### Production Deployment Checklist

Before deploying to production:

- [ ] Set `NODE_ENV=production` in `.env`
- [ ] Set `APP_URL` to your actual domain with `https://` (e.g., `https://yourdomain.com`)
- [ ] Set `ALLOWED_ORIGINS` to your domain(s)
- [ ] Generate a strong `JWT_SECRET` using `openssl rand -base64 32`
- [ ] Use a strong, unique `ADMIN_PASSWORD`
- [ ] Set up a reverse proxy (nginx/Traefik) with SSL certificates
- [ ] Configure SMTP settings if you need email features
- [ ] Test the deployment locally first with `NODE_ENV=production`
- [ ] Set up regular backups of `data/` and `uploads/` directories
- [ ] Review and adjust rate limits if needed
- [ ] Never commit `.env` files to git

### Production Considerations

- **HTTPS**: Always use HTTPS in production. Set up a reverse proxy (nginx, Traefik, Caddy) with SSL certificates
- **Environment Variables**: Never commit `.env` files. Use `.env.example` as a template
- **Strong Secrets**: Use strong, randomly generated values for `JWT_SECRET` and `ADMIN_PASSWORD`
- **CORS**: Configure `ALLOWED_ORIGINS` with your actual domain(s)
- **Rate Limiting**: Default rate limits are configured, but adjust as needed for your use case
- **Reverse Proxy**: Recommended for production. Handles SSL termination, can add additional security headers

See [README-SECURITY.md](./README-SECURITY.md) for detailed security information.

## Trademark Notice

"Swiish" and the Swiish logo are trademarks of Michael Crinnion. The software 
is licensed under AGPL-3.0, but this license does not grant permission to use 
the Swiish trademarks. 

You may use the Swiish name when describing the software you are running, but 
you may not use the Swiish name or logo in connection with competing products 
or services, or claim that your fork is the "official" Swiish.

See [TRADEMARKS.md](./TRADEMARKS.md) for the full trademark policy.

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

This means:
- ✅ You can use, modify, and distribute the software
- ✅ You can use it for commercial purposes
- ✅ You must disclose source code if you host it publicly
- ✅ You must include the license and copyright notice

See [LICENSE](./LICENSE) for the full license text.

## Security

Swiish includes comprehensive security features:
- JWT-based authentication
- Input validation and sanitization
- XSS protection with DOMPurify
- CSRF protection
- Rate limiting
- Secure file upload validation
- Security headers via Helmet

For detailed security documentation, see [README-SECURITY.md](./README-SECURITY.md).

## Support

- **Issues**: Report bugs or request features on [GitHub Issues](https://github.com/MrCrin/swiish/issues)
- **Security**: For security vulnerabilities, please review [README-SECURITY.md](./README-SECURITY.md)

## Links

- **Repository**: https://github.com/MrCrin/swiish
- **License**: [AGPL-3.0](./LICENSE)
- **Security Documentation**: [README-SECURITY.md](./README-SECURITY.md)

---

**Swiish** - Share your contact information beautifully. Self-hosted and privacy-focused.

