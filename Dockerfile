FROM node:16-alpine AS base
WORKDIR /app
COPY .yarnrc.yml ./
COPY .yarn/ ./.yarn
COPY .pnp* package.json yarn.lock ./

FROM base AS builder
RUN apk add -U python3 make g++
WORKDIR /app
RUN yarn rebuild
COPY . .
RUN chmod +x build.js
RUN yarn node ./build.js


FROM base AS production
WORKDIR /app
COPY --from=builder /app/.yarn/ ./.yarn
COPY --from=builder /app/out ./


FROM node:16-alpine AS runner
WORKDIR /app
COPY --from=production /app ./
CMD ["yarn", "node", "index.js"]
