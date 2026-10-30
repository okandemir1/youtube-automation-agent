# Server image: Node 22, FFmpeg, and Playwright's Chromium for the slideshow renderer.
FROM node:22-bookworm-slim

ENV NODE_ENV=production \
    TZ=Europe/Istanbul \
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

WORKDIR /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends ffmpeg ca-certificates fonts-dejavu-core \
 && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json ./
RUN npm ci --omit=dev \
 && npx playwright install --with-deps chromium \
 && npm cache clean --force

COPY . .
RUN mkdir -p data uploads logs config \
 && chown node:node data uploads logs config

USER node
EXPOSE 3456
CMD ["node", "index.js"]
