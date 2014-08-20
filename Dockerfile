FROM debian:wheezy

RUN apt-get update && apt-get install -y \
		apache2 \
		curl \
		libapache2-mod-php5 \
		php5-curl \
		php5-gd \
		php5-mysql \
		wget \
		unzip \
	&& rm -rf /var/lib/apt/lists/*
RUN a2enmod rewrite

# copy a few things from apache's init script that it requires to be setup
ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars
# and then a few more from $APACHE_CONFDIR/envvars itself
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE $APACHE_RUN_DIR/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR

# make CustomLog (access log) go to stdout instead of files
#  and ErrorLog to stderr
RUN find "$APACHE_CONFDIR" -type f -exec sed -ri ' \
	s!^(\s*CustomLog)\s+\S+!\1 /proc/self/fd/1!g; \
	s!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g; \
' '{}' ';'

RUN rm -rf /var/www/html && mkdir /var/www/html
VOLUME /var/www/html
WORKDIR /var/www/html

# ToDo : insert SPIP stuff
RUN curl -SL http://files.spip.org/spip/stable/spip-3.0.zip && \
	unzip spip-3.0.zip && \
	chown -R www-data:www-data . && \
	chmod -R 550 . && \
	chmod -R 750 IMG/ tmp/ local/ plugins/auto/


EXPOSE 80
CMD ["apache2", "-DFOREGROUND"]
