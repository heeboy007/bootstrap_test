# Dockerfile
# My first docker project(image)!

# Version Info :
# Ruby : 2.7.4
# Node : 14.17.4
# Bootstarp : 5.0.2

FROM ubuntu:18.04

# apt update
RUN apt update

# installing requirements
RUN apt purge ruby -y
RUN apt install apache2 apache2-dev curl dirmngr git gpg curl\
    build-essential libapr1-dev libaprutil1-dev libssl-dev libyaml-dev libreadline-dev openssl git-core\
    zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev libsqlite3-dev sqlite3 -y

# setting environment variables for apache2
ENV APACHE_RUN_USER = www-data
ENV APACHE_RUN_GROUP = www-data
ENV APACHE_LOG_DIR = /var/log/apache2
ENV APACHE_PID_FILE = /var/run/apache2/apache2.pid

# making user for administration.
RUN useradd rails -m
RUN usermod rails -s /bin/bash
USER rails
ENV HOME="/home/rails"

#version manager install(asdf, rbenv)
RUN git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch v0.8.1
RUN git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build

RUN echo ". ${HOME}/.asdf/asdf.sh" >> ${HOME}/.bashrc
RUN echo ". ${HOME}/.asdf/completions/asdf.bash" >> ${HOME}/.bashrc
RUN echo 'export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"' >> ${HOME}/.bashrc
RUN echo 'eval "$(rbenv init - bash)"' >> ${HOME}/.bashrc

ENV PATH="$PATH:/home/rails/.asdf/shims:/home/rails/.asdf/bin:/home/rails/.rbenv/bin:/home/rails/.rbenv/shims"

#nodejs install
#USER root
RUN ["/bin/bash", "-c", "asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git"]
RUN ["/bin/bash", "-c", "asdf install nodejs 14.17.4"]
RUN ["/bin/bash", "-c", "asdf global nodejs 14.17.4"]

#ruby install
RUN ["/bin/bash", "-c", "rbenv install 2.7.4"]
RUN ["/bin/bash", "-c", "rbenv global 2.7.4"]

#install bootstrap, rails, bundler 
RUN ["/bin/bash", "-c", "gem install --no-document globalid -v 0.4.2"]
RUN ["/bin/bash", "-c", "gem install --no-document bundler passenger"]
RUN ["/bin/bash", "-c", "gem install --no-document rails -v 6.1.4"]
RUN ["/bin/bash", "-c", "gem install --no-document bootstrap -v 5.0.1"]

RUN mkdir /home/rails/blog

USER root
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

EXPOSE 80
CMD [ "/usr/sbin/apache2ctl", "-D", "FOREGROUND" ]
