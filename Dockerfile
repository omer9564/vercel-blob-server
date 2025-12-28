# Build stage
FROM oven/bun:1 AS builder

WORKDIR /build

# Copy package files
COPY package.json bun.lockb* package-lock.json* pnpm-lock.yaml* ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy source code
COPY src ./src
COPY tsconfig.json ./

# Build the application
RUN bun run build

# Production stage
FROM oven/bun:1-slim AS production

WORKDIR /app

# Create volume directory
ENV VERCEL_STORE_PATH=/var/vercel-blob-store
RUN mkdir -p ${VERCEL_STORE_PATH}

# Copy only the built application from builder
COPY --from=builder /build/dist/server.js ./server.js

# Expose port
EXPOSE 3000

# Run the application
CMD ["bun", "server.js"]
