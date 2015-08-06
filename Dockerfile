FROM debian:jessie
MAINTAINER Markus Benning <ich@markusbenning.de>

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y puppet git puppet-module-puppetlabs-stdlib puppet-module-puppetlabs-apt supervisor

RUN apt-get -y install rubygems 
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install librarian-puppet

