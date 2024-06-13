# syntax=docker/dockerfile:1

FROM nginx:latest

COPY ./frontend/dist /usr/share/nginx/html

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]
