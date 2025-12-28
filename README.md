# Vercel blob server

> Mocking a vercel blob server **_ONLY FOR LOCAL DEVELOPMENT_**.

The code is **NOT TESTED**, contributions are welcome.

Supported API:

- `get`
- `head`
- `put`
- `copy`
- `del`

## Run with docker compose

### Option 1: Use Pre-built Image from GitHub Container Registry

Pull the latest image directly from GitHub Packages:

```shell
$ docker pull ghcr.io/omer9564/vercel-blob-server:latest
```

### Option 2: Build Docker Image Locally

The Dockerfile now builds the project automatically - no need to build `dist` beforehand:

```shell
$ docker build -t vercel-blob-server .
```

Or using the npm script:

```shell
$ pnpm run build:docker
```

### Add container config to your docker compose

- volume: `/var/vercel-blob-store` stores all uploaded file and meta info.
- port: `3000`: container http server port

```yaml
vercel-blob-server:
  ports:
    - '9966:3000'
  # Use the GitHub Container Registry image or your locally built image
  image: ghcr.io/omer9564/vercel-blob-server:latest
  # Or use local image: image: vercel-blob-server
  volumes:
    - ./dev/vercel-blob-store:/var/vercel-blob-store
```

## Usage

Edit your .env.local

```dotenv
# This env cheats @vercel/blob's internal pre checks
BLOB_READ_WRITE_TOKEN=vercel_blob_rw_somefakeid_nonce
# This port should be same to your mapped port
VERCEL_BLOB_API_URL=http://localhost:9966
```

Just use `@vercel/blob` as before

## CI/CD

This repository includes automated GitHub Actions workflows:

### Docker Build & Push

The workflow automatically:
- Builds Docker images on push to `main`/`master` branches
- Pushes images to GitHub Container Registry (ghcr.io)
- Creates multi-architecture images (linux/amd64, linux/arm64)
- Tags images with:
  - `latest` for the default branch
  - Branch name for branch pushes
  - Semantic version for tags (v1.0.0)
  - Git SHA for traceability

### Using the Published Images

Images are available at: `ghcr.io/omer9564/vercel-blob-server`

Pull specific versions:
```shell
# Latest version
docker pull ghcr.io/omer9564/vercel-blob-server:latest

# Specific version tag
docker pull ghcr.io/omer9564/vercel-blob-server:v1.0.0

# Specific commit
docker pull ghcr.io/omer9564/vercel-blob-server:main-abc1234
```
