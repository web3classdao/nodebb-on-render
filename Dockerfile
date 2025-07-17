############################
# 1) 빌드 전용 스테이지
############################
FROM nodebb/docker:latest AS builder
WORKDIR /usr/src/app

# NodeBB는 이미 /usr/src/app 에 코드 포함
COPY config.json ./

# (필요 플러그인·테마 미리 설치 예) RUN ./nodebb plugins:install nodebb-plugin-emoji

# 메모리 덜 쓰도록 직렬 빌드 (--series)
RUN ./nodebb build --series

############################
# 2) 런타임 슬림 스테이지
############################
FROM node:18-alpine     # <= slim 이미지 대신 Alpine Node 런타임 사용
WORKDIR /usr/src/app

# 실행에 필요한 **정적 자산·모듈·설정**만 복사
COPY --from=builder /usr/src/app/build   ./build
COPY --from=builder /usr/src/app/public  ./public
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package.json ./package.json
COPY config.json ./config.json

ENV NODE_ENV=production \
    NODEBB_SKIP_BUILD=1

EXPOSE 4567
CMD ["node", "nodebb", "start", "-p", "0.0.0.0"]

