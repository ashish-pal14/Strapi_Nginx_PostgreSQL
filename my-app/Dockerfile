# Stage 1: Build
FROM node:18-bullseye-slim AS build

WORKDIR /app

# Install build dependencies for native modules
RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies inside Docker
RUN npm install

# Copy the rest of the app
COPY . .

# Build Strapi admin panel
RUN npm run build

# Stage 2: Run
FROM node:18-bullseye-slim

WORKDIR /app

# Copy app from build stage (including Linux-built node_modules)
COPY --from=build /app ./

EXPOSE 1337

CMD ["npm", "start"]

