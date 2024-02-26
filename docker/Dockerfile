FROM php:8.3-apache



COPY erp.api.conf /etc/apache2/sites-available/

RUN a2ensite erp.api && a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

RUN apt-get update && \
    apt-get install git libpng-dev libonig-dev postgresql postgresql-contrib libpq-dev libxrender-dev libfontconfig libzip-dev libjpeg-dev zlib1g-dev libgd-dev libfreetype6-dev -y

RUN docker-php-ext-configure gd --with-jpeg --with-jpeg=/usr/include/ --with-freetype=/usr/include/

RUN docker-php-ext-install calendar pdo_mysql mysqli pdo_pgsql pgsql zip gd  exif


RUN echo "www-data ALL=NOPASSWD: /usr/bin/php, /usr/bin/python2.7, /usr/bin/python2" >> /etc/sudoers


RUN apt-get update && \
    apt-get install -y wget gnupg git libpng-dev libonig-dev postgresql postgresql-contrib libpq-dev libxrender-dev libfontconfig libzip-dev libjpeg-dev zlib1g-dev libgd-dev libfreetype6-dev


ENV APACHE_RUN_USER erp
RUN useradd -d /var/www --uid=1000 --group=www-data -s /sbin/nologin erp


