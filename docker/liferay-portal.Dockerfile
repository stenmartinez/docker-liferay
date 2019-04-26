FROM buildpack-deps:stretch

# Install Liferay
# run `gradle distBundleTar` then copy here
ADD liferay-docker.tar.gz /opt/liferay
ADD run-liferay.sh /opt/liferay/run-liferay.sh

RUN chmod +x /opt/liferay/run-liferay.sh

# Install and Setup Apache
RUN apt-get update && apt-get install -y --no-install-recommends \
		openjdk-8-jdk-headless \
		apache2 \
		ssl-cert \
		vim \
		imagemagick \
		ghostscript \
	&& rm -rf /var/lib/apt/lists/*
RUN a2disconf serve-cgi-bin
RUN a2enmod proxy_ajp
RUN a2enmod rewrite
RUN a2enmod ssl
ADD apache-proxy.conf /etc/apache2/sites-enabled/000-default.conf
ADD apache-ssl-proxy.conf /etc/apache2/sites-enabled/default-ssl.conf

# Ports
EXPOSE 80
EXPOSE 443

# EXEC
ENTRYPOINT ["/opt/liferay/run-liferay.sh"]
#CMD ["run"]
