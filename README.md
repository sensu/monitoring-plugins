# Monitoring Plugins Assets

## Overview

An attempt at packaging individual C plugins from the [Monitoring Plugins][1]
project in the new [Sensu 2.0][2] [Asset][3] format. The goal of the project is
to provide a simple workflow for creating Sensu 2.0 Assets containing individual
C plugins (nice and small!).

## Usage

1. Clone this repo:

   ~~~
   $ git clone git@github.com:calebhailey/monitoring-plugins-assets.git
   $ cd monitoring-plugins-assets
   ~~~

2. Build the Docker container:

   ~~~
   $ docker build -t monitoring-plugins:latest .
   ~~~

3. Export Sensu 2.0 Assets:

   ~~~
   $ docker run -v $PWD:/output -e "PLUGINS=check_http check_tcp" monitoring-plugins:latest
   ~~~

   The Docker container will output a single [Sensu 2.0 Asset][3] per plugin
   into your local working directory, and then exit.

## Project Status

This is a prototype! My initial build target is Alpine Linux. Instead of
compiling the plugins myself, I'm being lazy and using the [Alpine Linux
monitoring-plugins packages][4]. Eventually I'd like to add support for more
platforms (e.g. for Ubuntu/RHEL/etc), but the interface should always be a two
step process of building a container, and running it to export assets containing
individual C plugins.

## Next Steps / Project Goals

- Hook up a build pipeline to automatically build/package all of the plugins and
  upload them as [GitHub Releases][4] (i.e. use GitHub Releases to host the
  assets).


[1]: https://www.monitoring-plugins.org
[2]: https://github.com/sensu/sensu-go
[3]: https://docs.sensu.io/sensu-core/2.0/reference/assets/
[4]: https://help.github.com/articles/about-releases/
