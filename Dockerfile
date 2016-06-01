FROM tutum/apache-php
RUN apt-get update && apt-get install -yq git php5-mysqlnd && rm -rf /var/lib/apt/lists/*
RUN rm -fr /app
RUN git clone https://github.com/NamelessMC/Nameless.git /app

