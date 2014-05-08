FROM ubuntu:14.04
MAINTAINER Alex Dergachev <alex@evolvingweb.ca>

# update OS
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update

# support docker host running squid-deb-proxy, optionally
# If host is running squid-deb-proxy, populate /etc/apt/apt.conf.d/30proxy
RUN route -n | awk '/^0.0.0.0/ {print $2}' > /tmp/host_ip.txt
RUN echo "HEAD /" | nc `cat /tmp/host_ip.txt` 8000 | grep squid-deb-proxy \
  && (echo "Acquire::http::Proxy \"http://$(cat /tmp/host_ip.txt):8000\";" > /etc/apt/apt.conf.d/30proxy) \
  || echo "No squid-deb-proxy detected"

# Install dependencies
RUN apt-get install -y ruby1.9.1-dev build-essential git curl vim openssl
RUN gem install bundler

# Build Octopress from github
RUN git clone https://github.com/imathis/octopress.git /srv/octopress-master

# Install Octopress dependencies
WORKDIR /srv/octopress-master
RUN bundle install

# Install the default theme
RUN rake install

# Link config files to the mapped directory
RUN mkdir config
RUN mv Rakefile config/Rakefile
RUN mv _config.yml config/
RUN ln -s config/_config.yml ./_config.yml
RUN ln -s config/Rakefile ./Rakefile

# Install script to ensures that newly created files are 775 by default
ADD docker-umask-wrapper.sh /bin/docker-umask-wrapper.sh
RUN chmod u+x /bin/docker-umask-wrapper.sh

# Prevents prompt for authenticating SSH host key on each 'rake deploy' (INSECURE)
RUN mkdir -p /root/.ssh && echo "StrictHostKeyChecking no" >> /root/.ssh/config

# Expose default Octopress port
EXPOSE 4000

# Run Octopress
CMD ["rake", "preview"]
