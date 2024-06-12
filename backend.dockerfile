# syntax=docker/dockerfile:1

FROM python:3.12

RUN mkdir -p /app/backend
WORKDIR /app/backend
COPY ./backend/config/requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY ./backend .

EXPOSE 8000
CMD ["fastapi", "run", "main.py"]
