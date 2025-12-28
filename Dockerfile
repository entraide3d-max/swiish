# Build Stage
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
RUN npm install
COPY public/ public/
COPY src/ src/
RUN npm run build

# Production Stage
FROM node:18-alpine
WORKDIR /app
COPY --from=build /app/build ./build
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
