FROM python:3.6-alpine as base
RUN apk add --update --no-cache gcc build-base linux-headers pcre-dev

FROM base as builder
RUN mkdir /install
WORKDIR /install
COPY ./requirements.txt requirements.txt
RUN pip install --prefix=/install --no-cache-dir --upgrade -r requirements.txt

FROM python:3.6-alpine as app
RUN apk add --update --no-cache pcre
COPY --from=builder /install /usr/local
COPY . /app
WORKDIR /app
CMD ["uwsgi", "--socket", "0.0.0.0:5000", "--protocol=http", "-w", "wsgi:app"]
