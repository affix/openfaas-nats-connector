FROM ruby:alpine

RUN mkdir /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY nats-client.rb /app/

WORKDIR /app
RUN apk --update add g++ musl-dev make
RUN gem install bundler
RUN bundle install
RUN chmod +x /app/nats-client.rb

CMD ["/app/nats-client.rb"]