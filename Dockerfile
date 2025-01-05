# Stage 1: Build Stage
FROM node:22.12.0-alpine AS build

WORKDIR /app

COPY pnpm-lock.yaml package.json ./

COPY . .

RUN corepack enable
RUN pnpm install --frozen-lockfile --prod

RUN pnpm run build

# Stage 2: Final Stage
FROM node:22.12.0-alpine AS final

WORKDIR /app

COPY --from=build /app/.output .output

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
