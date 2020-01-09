FROM debian:buster

MAINTAINER Miguel Angel Fernandez Carrillo

RUN apt update && \
	apt install -y mariadb-server nginx php-fpm php-mysql php-mbstring openssl

COPY	srcs/index.html /var/www/migferna/html/
COPY 	srcs/migferna /etc/nginx/sites-available/
COPY	srcs/wordpress /var/www/migferna/html/wordpress
COPY	srcs/phpMyAdmin /var/www/migferna/html/phpMyAdmin
COPY	srcs/config.inc.php /var/www/migferna/html/phpMyAdmin/
COPY	srcs/init.sql	/tmp/
COPY	srcs/wordpress.sql /tmp/

RUN rm -rf /etc/nginx/sites-available/default && \
	rm -rf /etc/nginx/sites-enabled/default && \
	ln -sf /etc/nginx/sites-available/migferna /etc/nginx/sites-enabled/ && \
	chown -R www-data:www-data /var/www/* && \
	chmod -R 755 /var/www/* && \
	service mysql start && \
	mysql -u root --password= < /tmp/init.sql && \
	mysql wordpress -u root --password= < /tmp/wordpress.sql && \
	chmod 700 /etc/ssl/private && \
	openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 -subj "/C=SP/ST=Spain/L=Madrid/O=42/CN=127.0.0.1" \
	-keyout /etc/ssl/private/migferna.key \
	-out /etc/ssl/certs/migferna.crt && \
	openssl dhparam -out /etc/nginx/dhparam.pem 1000
CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	bash
