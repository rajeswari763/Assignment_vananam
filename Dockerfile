FROM node:20

WORKDIR /app

ADD index.js /app
ADD package.json /app

RUN npm install

EXPOSE 8080

CMD ["node" , "/app/index.js"]
