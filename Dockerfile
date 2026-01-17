# Build Stage
FROM node:18-alpine as build
WORKDIR /app

# Install git to allow branch detection
RUN apk add --no-cache git

COPY package*.json ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY scripts/ scripts/
RUN npm install

COPY public/ public/
COPY src/ src/
COPY .git/ .git/

# Create version.json with the branch info (using the script for reliability)
RUN node scripts/capture-git-info.js && rm -rf .git

RUN npm run build

# Production Stage
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app/build ./build
COPY --from=build /app/src/active-branch.json ./active-branch.json
COPY package*.json ./
RUN npm install --production
COPY server.js .
COPY database.json .
COPY migrations/ ./migrations/

# Create dirs for volumes
RUN mkdir data
RUN mkdir uploads

EXPOSE 3000
CMD ["node", "server.js"]
