FROM mariadb:10.3

MAINTAINER Sten Martinez

COPY custom.cnf /etc/mysql/conf.d/custom.cnf

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
