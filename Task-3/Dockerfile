# Use official Node 18 image
FROM node:18

# Enable Corepack (optional for yarn)
RUN corepack enable

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy all project files
COPY . .

# Expose Strapi default port
EXPOSE 1337

# Start Strapi in development mode
CMD ["npm", "run", "develop"]

