FROM nodebb/docker:latest AS builder
WORKDIR /usr/src/app

COPY config.json ./

RUN ./nodebb build --series

FROM node:18-alpine
WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/build   ./build
COPY --from=builder /usr/src/app/public  ./public
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package.json ./package.json
COPY config.json ./config.json

ENV NODE_ENV=production \
    NODEBB_SKIP_BUILD=1

EXPOSE 4567
CMD ["node", "nodebb", "start", "-p", "0.0.0.0"]

