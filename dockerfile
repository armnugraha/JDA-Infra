FROM openswoole/swoole:4.12-php8.2-alpine

# RUN apk add --no-cache postgresql-client

# PHP
# RUN docker-php-ext-install -j$(nproc) pdo pdo_pgsql pdo_mysql
RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql
RUN docker-php-ext-configure pcntl --enable-pcntl \
  && docker-php-ext-install \
    pcntl

#ext-zip
RUN apk add --no-cache \
      libzip-dev \
      zip \
    && docker-php-ext-install zip
    
# Setup GD extension
RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      # --with-png=/usr/include/ \ # No longer necessary as of 7.4; https://github.com/docker-library/php/pull/910#issuecomment-559383597
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*

# COMPOSER
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# NODEJS
RUN apk add nodejs npm automake libpng-dev

CMD tail -f /dev/null
