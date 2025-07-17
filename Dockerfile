FROM nodebb/docker:latest AS builder
WORKDIR /usr/src/app
COPY config.json ./
RUN ./nodebb build --series

FROM node:18-alpine
WORKDIR /usr/src/app

COPY --from=builder /usr/src/app /usr/src/app

ENV NODE_ENV=production \
    NODEBB_SKIP_BUILD=1
EXPOSE 4567
CMD ["./nodebb", "start", "-p", "0.0.0.0"]

