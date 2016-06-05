FROM tutum/apache-php
RUN apt-get update && apt-get install -yq git php5-mysqlnd && rm -rf /var/lib/apt/lists/* && \
rm -fr /app && \
git clone https://github.com/NamelessMC/Nameless.git /app

