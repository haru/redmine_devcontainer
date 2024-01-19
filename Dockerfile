ARG RUBY=3.2-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/ruby:0-${RUBY}-bullseye

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

RUN apt-get update
RUN apt-get install -y imagemagick git-flow

ENV REDMINE_ROOT=/usr/local/redmine
WORKDIR /usr/local
ARG REDMINE_VERSION=master
RUN git clone https://github.com/redmine/redmine.git -b ${REDMINE_VERSION}
WORKDIR /usr/local/redmine
RUN chown -R vscode .
COPY database.yml /usr/local/redmine/config/database.yml

RUN mv .git .git.sv

RUN echo "gem 'debug'" >> Gemfile
RUN echo "gem 'rufo'" >> Gemfile
ENV DB=sqlite3
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
