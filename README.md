# docker-puppet-base

a base image for building puppet based docker containers
with support for test driven infrastructure.

## How to build

```
docker build -t puppet-base .
```

## Example usage

This image is a base image. Your image must use it as a base:

```
FROM benningm/puppet-base:latest
MAINTAINER John Doh <john.doe@doecorp.net>
```

### Install your puppet module

Create a `Puppetfile` which refers to your puppet module:

```
forge "https://forgeapi.puppetlabs.com"

mod "johndoe/doe_web",
  :git => "https://github.com/johndoe/puppet-doe_web.git"
```

Add this `Puppetfile` to your image in `Dockerfile` and execute
`librarian-puppet` to install the module and its dependencies:

```
ADD Puppetfile /etc/puppet/Puppetfile
RUN cd /etc/puppet && librarian-puppet install --verbose
```

### Apply your puppet configuration

Now generate a `manifest.pp` file to call the module class:

```
class { 'doe_web':
  # parameters...
}
```

and execute it with `puppet apply` in `Dockerfile`:

```
ADD manifest.pp /etc/puppet/manifests/doe_web.pp
RUN /usr/local/bin/puppet-apply-wrapper /etc/puppet/manifests
```

The puppet-apply-wrapper script is just a simple wrapper around
`puppet apply` which translates the puppet return codes to
the correct values for the shell to indicate success or failure.

Now your image should be configured. Add futher settings like
volumes and port to your `Dockerfile` as needed.

## Puppet module development

If you already have build your image and you want to futher
improve your configuration you can do this within a container.

Clone your puppet module on your host system:

```
git clone https://github.com/johndoe/puppet-doe_web.git
```

Then start the container and mount the git clone on the
location of your puppet module within the container:

```
docker run -it --rm \
  -v $PWD/puppet-doe_web:/etc/puppet/modules/doe_web \
  doeweb:latest \
  /bin/bash
```

Now you can edit the puppet module outside of the docker container
and apply the changes within the container with:

```
puppet apply /etc/puppet/manifests
```

