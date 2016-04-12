FROM debian:jessie
MAINTAINER Markus Benning <ich@markusbenning.de>

RUN apt-get update \
  && apt-get install -y curl apt-transport-https \
  && curl https://markusbenning.de/debian/repo.gpg.key | apt-key add - \
  && curl -o /etc/apt/sources.list.d/markusbenning.list \
     "https://markusbenning.de/debian/markusbenning.list" \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
    git \
    puppet \
    rubygems \
    libtest-bdd-cucumber-perl \
    libtest-bdd-cucumber-harness-html-perl \
    libtest-bdd-cucumber-harness-nagios-perl \
    libtest-bdd-infrastructure-perl \
    vim-nox \
  && apt-get clean

# explicit use activesupport 4.2.5 since 4.5.0 required ruby 2.2.2
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc \
  && gem install activesupport -v 4.2.5 \
  && gem install librarian-puppet

ADD puppet-apply-wrapper /usr/local/bin/puppet-apply-wrapper
RUN chown root:root /usr/local/bin/puppet-apply-wrapper \
  && chmod 755 /usr/local/bin/puppet-apply-wrapper

ADD entrypoint.sh /
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
