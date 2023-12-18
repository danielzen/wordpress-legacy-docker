FROM php:5.6-apache

RUN a2enmod rewrite
RUN rm /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian/ stretch main" >> /etc/apt/sources.list
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian/ stretch main" >> /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian/ stretch-backports main" >> /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian-security/ stretch/updates main" >> /etc/apt/sources.list
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian-security/ stretch/updates main" >> /etc/apt/sources.list

# install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libzip-dev mysql-client \
    && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd zip
RUN docker-php-ext-install mysqli

VOLUME /var/www/html

ENV WORDPRESS_VERSION 4.3.32
ENV WORDPRESS_UPSTREAM_VERSION 4.3.32
ENV WORDPRESS_SHA1 47a76af51da5fa524065e965e97e3a19fd521c3c

# upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_UPSTREAM_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
