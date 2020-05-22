# FROM node:8.6.0
FROM node:12.6.0

RUN apt-get update && apt-get install -y gettext netcat gconf-service \
        libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
        libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 \
        libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 \
        libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 \
        libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
        libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 \
        lsb-release xdg-utils wget

WORKDIR /app/

#Optimize building time. Cache npm install on this layer so that it is cached between code updates.
ADD package.json /app/
RUN npm install
RUN npm install -g jest

ENV WAIT_TIME_SECONDS '1'
ENV WAIT_CONNECT_HOST ''
ENV WAIT_CONNECT_PORT ''

ENV JEST_TEST_TIMEOUT '10000'
ENV JEST_MAX_CONCURRENCY '5'
ENV JEST_RUN_IN_BAND 'true'
ENV JEST_MAX_FAILURES '1'

ADD startup.sh /

ADD / /app/

EXPOSE 2000
CMD ["/startup.sh"]

