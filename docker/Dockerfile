ARG RUBY=3.2
FROM ruby:${RUBY}

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

RUN apt-get update && apt-get install -y build-essential \
    imagemagick git-flow \
    sudo \
    vim \
    gawk \
    less \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /workspaces -s /bin/bash vscode
RUN echo "vscode ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vscode

ENV REDMINE_ROOT=/usr/local/redmine
WORKDIR /usr/local
ARG REDMINE_VERSION=master
RUN git clone https://github.com/redmine/redmine.git -b ${REDMINE_VERSION}
WORKDIR /usr/local/redmine
RUN chown -R vscode .
COPY database.yml /usr/local/redmine/config/database.yml

RUN mv .git .git.sv

COPY Gemfile.local /usr/local/redmine/Gemfile.local

ENV DB=sqlite3

USER vscode
COPY bashrc /workspaces/.bashrc
RUN bundle install
RUN bundle exec rake db:migrate
RUN bundle exec rake db:migrate RAILS_ENV=test
RUN bundle exec rake test:scm:setup:all 
RUN mkdir -p .vscode
COPY launch.json /usr/local/redmine/.vscode/

USER root
RUN chown -R vscode:vscode /usr/local/redmine/.vscode

RUN sed -i "s/^end/  config.hosts.clear if config.respond_to?(:hosts)\nend/" config/environments/development.rb 


WORKDIR /workspaces
