FROM php:8-apache

# Install MySQLi
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update && apt-get upgrade -y

RUN a2enmod ssl && a2enmod rewrite && \
  mkdir -p /etc/apache2/ssl && \
  mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

ENV NODE_VERSION=18.16.1
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

COPY ./WordPress /var/www/html
# COPY ./jquery-wp-content /var/www/html/jquery-wp-content

EXPOSE 80
EXPOSE 443
