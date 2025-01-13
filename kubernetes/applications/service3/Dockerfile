FROM php:8.1-apache

# Install additional PHP extensions if needed
RUN docker-php-ext-install opcache

# Configure Apache
RUN a2enmod rewrite

# Configure PHP
COPY php.ini /usr/local/etc/php/conf.d/app.ini

# Copy application code
COPY index.php /var/www/html/

# Configure Apache document root
ENV APACHE_DOCUMENT_ROOT /var/www/html
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Switch to non-root user
USER www-data

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]