FROM debian:buster

MAINTAINER Miguel Angel Fernandez Carrillo

RUN apt update && \
	apt install -y mariadb-server nginx php-fpm php-mysql

COPY	srcs/index.html /var/www/migferna/html/
COPY 	srcs/migferna /etc/nginx/sites-available/
ADD		srcs/wordpress.tar.gz /var/www/migferna/html/
ADD		srcs/phpMyAdmin.tar.gz /var/www/migferna/html/phpMyAdmin
COPY	srcs/config.inc.php /var/www/migferna/html/phpMyAdmin/
COPY	srcs/init.sql	/tmp/

RUN rm -rf /etc/nginx/sites-available/default && \
	rm -rf /etc/nginx/sites-enabled/default && \
	ln -sf /etc/nginx/sites-available/migferna /etc/nginx/sites-enabled/ && \
	chown -R www-data:www-data /var/www/* && \
	chmod -R 755 /var/www/* && \
	service mysql start && \
	mysql -u root -p < /tmp/init.sql

CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	bash
