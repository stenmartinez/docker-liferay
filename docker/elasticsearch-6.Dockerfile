FROM buildpack-deps:stretch

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN apt-get update && apt-get install -y apt-transport-https default-jdk-headless
RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends elasticsearch=6.6.2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/share/elasticsearch

RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done

# Install Elasticsearch plug-ins
RUN bin/elasticsearch-plugin install analysis-icu --batch
RUN bin/elasticsearch-plugin install analysis-kuromoji --batch
RUN bin/elasticsearch-plugin install analysis-smartcn --batch
RUN bin/elasticsearch-plugin install analysis-stempel --batch

COPY es-logging.yml /etc/elasticsearch/logging.yml
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY elasticsearch-entrypoint.sh /docker-entrypoint.sh

USER elasticsearch

# Set environment
ENV NAMESPACE default
ENV ES_HEAP_SIZE 512m
ENV CLUSTER_NAME elasticsearch-default
ENV NODE_MASTER true
ENV NODE_DATA true
ENV HTTP_ENABLE true
ENV NETWORK_HOST _site_
ENV HTTP_CORS_ENABLE true
ENV HTTP_CORS_ALLOW_ORIGIN *
ENV NUMBER_OF_MASTERS 1
ENV DISCOVERY_SERVICE elasticsearch-discovery
ENV PATH=$PATH:/usr/share/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200 9300
