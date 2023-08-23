FROM php:8.1.2-apache

RUN apt update && apt install -y p7zip-full git

RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer | php -- \
	&& mv composer.phar /usr/local/bin/composer

RUN curl -sS https://get.symfony.com/cli/installer -o installer.sh \
    && bash installer.sh \
    && rm installer.sh \
    && mv /root/.symfony5/bin/symfony /usr/local/bin

RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www

ADD /.server-conf/000-default.conf /etc/apache2/sites-available/
WORKDIR /var/www
