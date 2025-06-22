ARG RUBY_TAG=3.2-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/ruby:${RUBY_TAG}

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

RUN apt-get update && apt-get install -y imagemagick git-flow clang \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV REDMINE_ROOT=/usr/local/redmine
WORKDIR /usr/local
ARG REDMINE_VERSION=master
RUN git clone https://github.com/redmine/redmine.git -b ${REDMINE_VERSION} \
    && chown -R vscode /usr/local/redmine \
    && mv /usr/local/redmine/.git /usr/local/redmine/.git.sv

WORKDIR /usr/local/redmine
COPY database.yml /usr/local/redmine/config/database.yml

RUN echo "gem 'debug'" >> Gemfile
RUN echo "gem 'rufo'" >> Gemfile
ENV DB=sqlite3
RUN bundle config set --local path vendor/bundle
RUN mkdir -p vendor/bundle && chown -R vscode:vscode vendor/bundle
USER vscode
RUN bundle install
RUN bundle exec rake db:migrate
RUN bundle exec rake db:migrate RAILS_ENV=test
RUN bundle exec rake test:scm:setup:all 
RUN mkdir -p .vscode
COPY launch.json /usr/local/redmine/.vscode/

USER root

RUN sed -i "s/^end/  config.hosts.clear if config.respond_to?(:hosts)\nend/" config/environments/development.rb 


WORKDIR /workspaces
