FROM php:5.6-apache

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*
RUN cd /tmp && \
  curl -sSL http://files.spip.org/spip/stable/spip-3.0.zip -o spip.zip && \
	unzip -q spip.zip  && \
	mv spip/* /var/www/html/ && \
	cd /var/www/html/ && \
  mkdir -p plugins/auto && \
	chown -R www-data:www-data . && \
	chmod -R 550 . && \
	chmod -R 750 IMG/ tmp/ local/ plugins/auto/ && \
  echo "date.timezone = America/New_York" >> /usr/local/etc/php/conf.d/timezone.ini

CMD ["apache2", "-DFOREGROUND"]
