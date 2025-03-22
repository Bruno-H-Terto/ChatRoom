FROM ruby:3.4.2

RUN apt-get update -y

WORKDIR /app/backend/

COPY Gemfile . 
COPY Gemfile.lock .

RUN bundle install

CMD [ "bin/setup" ]