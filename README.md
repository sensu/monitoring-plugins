[![Sensu Bonsai Asset](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/sensu/monitoring-plugins)
# Sensu Assets: Monitoring Plugins

## Overview

An attempt at packaging individual C plugins from the excellent Monitoring
Plugins project [https://monitoring-plugins.org][1] in the [Sensu Go][2]
[Asset][3] format. The goal of the project is to provide a simple workflow for
creating a Sensu Go Asset containing the C plugins.

## Goal

The goal of this project is to provide Sensu Go Assets for CentOS/Rocky/RHEL Linux
(7, 8, 9), Debian Linux (9, 10, 11), Ubuntu Linux (18.04, 20.04, 22.04),
Amazon Linux (2, 2022), and Alpine Linux containing a good subset of the
plugins from the Monitoring Plugins project.

### Current Status

Currently, This project will attempt to provide support for the following plugins:

- `check_disk`
- `check_dns`
- `check_http`
- `check_load`
- `check_log`
- `check_ntp`
- `check_ntp_peer`
- `check_ntp_time`
- `check_ping`
- `check_procs`
- `check_smtp`
- `check_snmp`
- `check_ssh`
- `check_swap`
- `check_tcp`
- `check_time`
- `check_users`


### Caveats

Several plugins, though compiled binaries, require that certain commands be available from the OS.

Examples (not exhaustive):

* `check_snmp` requires `snmpget`
* `check_procs` requires `ps`
* `check_dns` requires `nslookup`

## Configuration
### Sensu Go
#### Asset registration

Assets are the best way to make use of this plugin. If you're not using an asset, please
consider doing so! If you're using sensuctl 5.13 or later, you can use the following
command to add the asset:

`sensuctl asset add sensu/monitoring-plugins`

If you're using an earlier version of sensuctl, you can download the asset definition from [this project's Bonsai Asset Index page](https://bonsai.sensu.io/assets/sensu/monitoring-plugins).

## Build

1. Clone this repo:

   ~~~
   $ git clone git@github.com:sensu/monitoring-plugins.git
   $ cd monitoring-plugins
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
