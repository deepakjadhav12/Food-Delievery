# Use node base image
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Build the app
COPY . .
RUN npm run build

# Install serve globally
RUN npm install -g serve

# Expose port 3000
EXPOSE 3000

# Start the app using 'serve'
CMD ["serve", "-s", "build", "-l", "3000"]
