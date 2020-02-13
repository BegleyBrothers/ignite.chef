# SPDX-License-Identifier: Apache 2.0
# Copyright:: 2020, Begley Brothers.
#
FROM ubuntu:18.04

ENV CHEF_LICENSE=accept

RUN apt-get update \
    && apt-get install --yes \
        build-essential \
        curl \
        docker.io \
        iproute2 \
        libgit2-dev \
        locales \
        net-tools \
        vim
    
# Match user on the host:
#  - 501 appears to be the first user ID Mac
#  - 1000 | 1001 appear to be the first user ID Linux
RUN locale-gen en_US.UTF-8 \
    && mkdir -p /home/appuser \
    && groupadd --gid 1000 appuser \
    #&& groupadd docker \
    && useradd --non-unique --uid 1000 --no-create-home --home-dir /home/appuser --gid 1000 appuser \
    && useradd --non-unique --uid 1001 --no-create-home --home-dir /home/appuser --gid 1000 appuser2 \
    && useradd --non-unique --uid 501 --no-create-home --home-dir /home/appuser --gid 1000 appuser3 \
    && chown appuser:appuser /home/appuser \
    && chmod -R 770 /home/appuser \
    # Need to be able to talk to the Docker socket
    && usermod --append --groups staff,docker appuser \
    && usermod --append --groups staff,docker appuser2 \
    && usermod --append --groups staff,docker appuser3 \
    && touch /var/run/docker.sock \
    && chmod 777 /var/run/docker.sock

# The second 7 gives full access to group members, -R makes it recursive
# Install gems in a folder locally rather than globally
RUN curl -O https://packages.chef.io/files/stable/chefdk/3.11.3/ubuntu/18.04/chefdk_3.11.3-1_amd64.deb \
    && CHEF_LICENSE=accept dpkg -i chefdk_3.11.3-1_amd64.deb \
    # Install apt based dependencies required to run test-kitchen as 
    # well as RubyGems. As the Ruby image itself is based on a 
    # Debian image, we use apt-get to install those.
    && mkdir /app \
    && chown 1000:1000 /app \
    && chmod -R 770 /app

# Setup IPv6 which allows kitchen to SSH between DinD.
COPY ./config/etc/docker/daemon.conf /etc/docker/daemon.conf

# Use the ruby, bundle, gem etc that comes with chef
ENV PATH="/opt/chefdk/embedded/bin:${PATH}"
# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
#COPY Gemfile ./ 
# Now it should only be neccessary to execute/run `bundle update`
#RUN gem install bundler && bundle install --deployment --jobs 20 --retry 5

# Copy the main application.
#COPY . .

# Expose port 3000 to the Docker host, so we can access it 
# from the outside.
#EXPOSE 3000

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.
#CMD ["bundle", "exec"]

# This results in a single layer image
# FROM scratch
#COPY --from=build / /

#ENTRYPOINT ["bash", "/app/scripts/entypoint.sh"]

LABEL maintainer=beggleybrothers@gmail.com
