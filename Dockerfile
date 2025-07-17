FROM nodebb/docker:latest
COPY config.json /usr/src/app/config.json
RUN ./nodebb build --series
