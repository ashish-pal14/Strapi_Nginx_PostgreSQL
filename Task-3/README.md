# Strapi Project Setup with Docker, Postgres, and Nginx

This project contains a **Strapi v5** application configured with **PostgreSQL** as the database and **Nginx** as a reverse proxy. The setup uses Docker and Docker Compose for containerization.

---
## Prerequisites

- Docker (≥ 20.x)
- Docker Compose (≥ 2.x)
- Node.js (≥ 18)
- npm (≥ 9)
- Git

---Docker Setup
Dockerfile (my-app/Dockerfile)
# Use official Node.js 18 image
FROM node:18

# Set working directory
WORKDIR /app

# Enable Yarn
RUN corepack enable && corepack prepare yarn@4.5.0 --activate

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Expose Strapi port
EXPOSE 1337

# Start Strapi
CMD ["npm", "run", "develop"]

Nginx Configuration (my-app/nginx.conf)
server {
    listen 80;

    location / {
        proxy_pass http://strapi-app:1337;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

Docker Compose (my-app/docker-compose.yml)
services:
  strapi-app:
    build: .
    container_name: strapi-app
    environment:
      DATABASE_CLIENT: postgres
      DATABASE_NAME: strapidb
      DATABASE_HOST: strapi-postgres
      DATABASE_PORT: 5432
      DATABASE_USERNAME: strapi
      DATABASE_PASSWORD: yourpassword
    ports:
      - "1337:1337"
    depends_on:
      - strapi-postgres
    networks:
      - strapi-net

  strapi-postgres:
    image: postgres:15
    container_name: strapi-postgres
    environment:
      POSTGRES_DB: strapidb
      POSTGRES_USER: strapi
      POSTGRES_PASSWORD: yourpassword
    volumes:
      - strapi_postgres_data:/var/lib/postgresql/data
    networks:
      - strapi-net

  strapi-nginx:
    image: nginx:latest
    container_name: strapi-nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - strapi-app
    networks:
      - strapi-net

networks:
  strapi-net:

volumes:
  strapi_postgres_data:

Running the Application

Build and start containers:

docker-compose up --build -d


Check running containers:

docker ps


Access the application:

Strapi Admin: http://localhost:1337/admin

Nginx proxy: http://localhost/
