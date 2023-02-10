FROM reg.1cb.kz/dockerhub/library/node:16.17.1-alpine3.15 as build

WORKDIR /var/www
COPY . ./
RUN ls /var/www

RUN yarn install

ENV NODE_ENV=production

RUN npm run build:static

RUN ls /var/www/dist

FROM reg.1cb.kz/dockerhub/library/nginx:latest

COPY --from=build /var/www/dist/static /var/www
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

ARG BACKEND_URL

RUN echo $BACKEND_URL

RUN sed -i "s|%%BACKEND_URL_PRE_CHECK%%|${BACKEND_URL}|g" /etc/nginx/conf.d/default.conf
