ARG RUBY=3.2
FROM ruby:${RUBY}

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

RUN apt-get update && apt-get install -y build-essential \
    imagemagick git-flow \
    sudo \
    vim \
    gawk \
    curl \
    less \
    bash-completion \
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
ENV NVM_DIR=/workspaces/.nvm

USER vscode
RUN bash -lc "set -eo pipefail; curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash"
RUN bash -lc "set -eo pipefail; . \"${NVM_DIR}/nvm.sh\" && nvm install --lts && nvm alias default 'lts/*'"
COPY bashrc /workspaces/.bashrc
USER root
RUN chown vscode:vscode /workspaces/.bashrc || true
RUN mkdir -p /home/vscode && \
    echo 'if [ -f /workspaces/.bashrc ]; then' > /home/vscode/.bash_profile && \
    echo '  . /workspaces/.bashrc' >> /home/vscode/.bash_profile && \
    echo 'fi' >> /home/vscode/.bash_profile && \
    chown vscode:vscode /home/vscode/.bash_profile || true
USER vscode
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
