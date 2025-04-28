# 1️⃣ Build Stage
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN NODE_OPTIONS=--openssl-legacy-provider npm run build

# 2️⃣ Production Stage
FROM node:20-alpine

WORKDIR /app

# Only copy the necessary files from build stage
COPY --from=builder /app/package.json /app/package-lock.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist  # Assuming your build output is in /dist

EXPOSE 3000

CMD ["sh", "-c", "NODE_OPTIONS=--openssl-legacy-provider npm start"]
