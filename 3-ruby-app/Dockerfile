FROM ruby:3.0.0

RUN mkdir -p /opt/app
RUN gem install rails bundler
WORKDIR /opt/app
RUN rails new dbapp

COPY ./files/external_database.yml /opt/app/dbapp/config/
COPY ./files/external_databases.rb /opt/app/dbapp/config/initializers/
COPY ./files/external_db_object.rb /opt/app/dbapp/app/models/

CMD ["/bin/sh"]