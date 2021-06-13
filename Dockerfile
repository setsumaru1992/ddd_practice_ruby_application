FROM ruby:2.7.1

CMD [ "/bin/bash" ]
ENV LANG C.UTF-8

ARG BUNDLER_VERSION="2.1.2"

RUN sed -i -e "s/deb.debian.org/cloudfront.debian.net/g" /etc/apt/sources.list \
&&  apt-get update -y \
&&  apt-get install -y apt-transport-https \
&&  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&&  echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list \
&&  curl -sS https://deb.nodesource.com/setup_10.x | bash - \
&&  apt-get install -y yarn \
&&  apt-get purge -y apt-transport-https \
&&  apt-get autoremove \
&&  apt-get autoclean \
&&  apt-get clean \
&&  gem install bundler -v ${BUNDLER_VERSION}

COPY Gemfile Gemfile.lock ./
RUN bundle install

ARG appname=ddd_practice_ruby_application
ARG apppath="/root/$appname"
WORKDIR $apppath

CMD [ "./entrypoint.sh" ]