# syntax=docker/dockerfile:1

FROM node:alpine3.20

RUN mkdir -p /app/frontend
WORKDIR /app/frontend
COPY ./frontend/package.json .
RUN npm install

COPY ./frontend .

RUN npm run build

EXPOSE 4173

CMD [ "npm", "run", "preview", "--host 0.0.0.0"]