# Start from the official Node.js LTS base image
FROM node:18-alpine as base

# Set the working directory to /app and install dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install

# build the app
FROM base AS builder
COPY . .
RUN npm run build

# create the 'release' image
FROM node:18-alpine AS release
WORKDIR /app
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# RUN useradd --user-group --create-home --shell /bin/bash app && \
#   chown -R app:app /app
# USER app:app

# Add the time to the build
# RUN date -u +"%Y-%m-%dT%H:%M:%SZ" > build-time.txt

# Expose port 3000 for the Next.js app to be accessible
EXPOSE 3000

# Start the Next.js app
CMD ["npm", "start"]