# ---------- 1) 빌드 전용 스테이지 ----------
FROM nodebb/docker:latest AS builder
WORKDIR /usr/src/app

# config.json 사전 복사
COPY config.json ./

# (필요한 플러그인·테마 미리 설치)
# RUN ./nodebb plugins:install nodebb-plugin-emoji

# 메모리를 덜 쓰도록 --series 옵션
RUN ./nodebb build --series
# 빌드가 끝나면 build/, public/, node_modules 일부가 완성됨

# ---------- 2) 런타임 슬림 스테이지 ----------
FROM nodebb/docker:slim
WORKDIR /usr/src/app

#  빌드 산출물만 복사
COPY --from=builder /usr/src/app/build ./build
COPY --from=builder /usr/src/app/public ./public
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY config.json ./config.json

# 실행 시 빌드 스킵
ENV NODE_ENV=production \
    NODEBB_SKIP_BUILD=1

EXPOSE 4567
CMD ["./nodebb", "start", "-p", "0.0.0.0"]

