# Sensu Assets: Monitoring Plugins

## Overview

An attempt at packaging individual C plugins from the excellent Monitoring
Plugins project (https://monitoring-plugins.org)[1] in the [Sensu Go][2]
[Asset][3] format. The goal of the project is to provide a simple workflow for
creating a Sensu Go Asset containing the C plugins.

## Goal

The goal of this project is to provide Sensu Go Assets for CentOS Linux, Debian
Linux, and Alpine Linux containing all of the plugins from the Monitoring
Plugins project.

### Current Status

Currently, This project will attempt to provide support for the following plugins:

- `check_disk`
- `check_dns`
- `check_http`
- `check_ntp`
- `check_ntp_peer`
- `check_ntp_time`
- `check_ping`
- `check_procs`
- `check_smtp`
- `check_ssh`
- `check_swap`
- `check_tcp`
- `check_time`
- `check_users`

### Next Steps

In no particular order:

- Add support for platform-specific exclusions in the build script (i.e. if
  `check_snmp` is available for CentOS and Debian, but not for Alpine, just skip
  it on Alpine?)
- Build the plugins from scratch instead of installing the distribution packages
  (which are inconsistent between Alpine, Debian, and CentOS)
- Hook up a CI pipeline to automate the builds

## Build

1. Clone this repo:

   ~~~
   $ git clone git@github.com:calebhailey/sensu-assets-monitoring-plugins.git
   $ cd sensu-assets-monitoring-plugins
   ~~~

2. Build the Docker containers and extract the Sensu assets:

   ~~~
   $ ./build.sh
   ~~~

   _NOTE: if your local docker installation is configured to require root access
   you will need to run the build script as root (i.e. `sudo ./build.sh`)._


[1]: https://www.monitoring-plugins.org
[2]: https://github.com/sensu/sensu-go
[3]: https://docs.sensu.io/sensu-go/latest/reference/assets/
