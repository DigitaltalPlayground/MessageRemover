FROM node:lts-bullseye-slim AS builder
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends python3 g++ make
WORKDIR /app
COPY .yarnrc.yml ./
COPY .yarn/ ./.yarn
COPY .pnp* package.json yarn.lock ./
RUN yarn rebuild
COPY . .
RUN chmod +x build.js
RUN yarn node ./build.js


FROM node:lts-bullseye-slim AS production
WORKDIR /app
COPY --from=builder /app/.yarn/ ./.yarn
COPY --from=builder /app/out ./


FROM node:lts-bullseye-slim AS runner
WORKDIR /app
COPY --from=production /app ./
CMD ["yarn", "node", "--enable-source-maps", "index.js"]
