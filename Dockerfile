FROM node:lts-bullseye-slim AS base
WORKDIR /app
COPY --link .yarnrc.yml ./
COPY --link .yarn/ ./.yarn
COPY --link .pnp* package.json yarn.lock ./

FROM base AS builder
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends python3 g++ make
WORKDIR /app
RUN yarn rebuild
COPY --link . .
RUN chmod +x build.js
RUN yarn node ./build.js


FROM base AS production
WORKDIR /app
COPY --from=builder /app/.yarn/ ./.yarn
COPY --from=builder /app/out ./


FROM node:lts-bullseye-slim AS runner
WORKDIR /app
COPY --from=production /app ./
CMD ["yarn", "node", "--enable-source-maps", "index.js"]
