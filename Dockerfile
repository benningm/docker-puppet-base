FROM debian:jessie
MAINTAINER Markus Benning <ich@markusbenning.de>

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y puppet librarian-puppet git puppet-module-puppetlabs-stdlib puppet-module-puppetlabs-apt supervisor
