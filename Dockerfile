#
# Sorghum - A Gluten-free mock for Ohmbrewer
# See http://ohmbrewer.org for more information
#

FROM ruby:2.2.1
MAINTAINER Kyle Oliveira <kyle.oliveira@cornell.edu>

# Handy variables...
ENV APP_HOME /sorghum

RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev

# Provide a cache for the Gemfile, etc. so Docker builds faster
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install --quiet

# Add all the app files
ADD . $APP_HOME