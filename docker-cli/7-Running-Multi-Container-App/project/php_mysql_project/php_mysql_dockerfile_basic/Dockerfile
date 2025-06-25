FROM php:8.1-apache
RUN docker-php-ext-install pdo_mysql
COPY index.php /var/www/html/
RUN a2enmod rewrite
EXPOSE 80
CMD ["apache2-foreground"]
