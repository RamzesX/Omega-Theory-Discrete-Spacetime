# OmegaTheory site — Astro static build (Node 20 LTS)
#
# This Dockerfile is designed for `docker compose run` with the repo root
# bind-mounted, so the prebuild scripts can read PhysicsPapers/. The image
# itself only installs Node + npm deps; the actual build happens at run-time.
#
# Usage (from repo root):
#   docker compose run --rm site-build           # build → ./site/dist
#   docker compose up site                        # serve at http://localhost:8080
#   docker compose run --rm site-dev              # dev server with HMR :4321

FROM node:22-bookworm-slim

WORKDIR /site

# Cache the npm-deps layer separately from sources for fast rebuilds
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund

# Sources are bind-mounted at runtime by docker-compose so we don't COPY them
# here — keeps the image tiny and avoids stale-rebuild issues.

# Default: build the site (overridden by docker-compose service-specific commands)
CMD ["npm", "run", "build"]
