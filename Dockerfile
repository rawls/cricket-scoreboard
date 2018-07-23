FROM ruby:2.5-alpine
MAINTAINER Will Brown <mail@willbrown.name>
# https://hub.docker.com/_/ruby/

# Need node for JS compression & XML parsing
RUN apk add --update \
  build-base \
  nodejs \
  libxml2-dev \
  libxslt-dev \
  && rm -rf /var/cache/apk/*

# Throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1 

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR APP_HOME

# Install Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Upload source
COPY . $APP_HOME/

# Start the app
EXPOSE 4567
ENV CONTAINER true
CMD ["ruby", "/app/bin/scoreboard"]
