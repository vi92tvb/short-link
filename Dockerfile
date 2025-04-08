FROM ruby:3.2.1

# Install bare dependencies
RUN apt-get update -qq && \
  apt-get install -y

ENV RAILS_ROOT /app

RUN mkdir $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile* ./
RUN gem install bundler

ARG SECRET_KEY_BASE=""
RUN test -z "$SECRET_KEY_BASE" || bundle config set without 'development test'

RUN bundle install -j 20 -r 5 && bundle clean --force

COPY . $RAILS_ROOT

RUN test -z "$SECRET_KEY_BASE" || RAILS_ENV=production rake assets:precompile

EXPOSE 3000 80

ENTRYPOINT ["bundle", "exec"]

CMD ["rails", "server", "-b", "0.0.0.0"]
