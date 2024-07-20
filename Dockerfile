FROM node:20.10.0-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . ./
RUN npm run build \
    && rm -rf ./src \
    && rm -rf node ./node_modules

FROM node:20.10.0-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev --no-audit --no-fund

COPY --from=build /app/dist /app/dist
COPY --from=build /app/src/server /app/src/server
COPY --from=build /app/src/common /app/src/common

EXPOSE 3000
CMD ["npm", "start"]
