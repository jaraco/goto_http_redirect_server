Files for adding the _"Go To" HTTP Redirect Server_ as a Linux systemd service.

_Tested on Debian Linux 9. MMV._

----

<!-- python -m md_toc README.md github -->

- [Install Instructions](#install-instructions)
  - [Create HTTP Redirects File](#create-http-redirects-file)
  - [Install Files](#install-files)
  - [Enable and Start systemd Service](#enable-and-start-systemd-service)
  - [Check systemd Service](#check-systemd-service)
  - [(optional) Harden the Process with authbind and Low Privilege User](#optional-harden-the-process-with-authbind-and-low-privilege-user)

----

## Install Instructions

As `root` user,

### Create HTTP Redirects File

Create a tab-separated values file (`'\t'`) with a list of HTTP redirects at
path `/usr/local/share/goto_http_redirect_server.csv`

    touch /usr/local/share/goto_http_redirect_server.csv

This file is described in the top-level [README.md](./../README.md).

### Install Files

- `/usr/local/bin/goto_http_redirect_server`

  See top-level [README.md](./../README.md).

- `/usr/local/bin/goto_http_redirect_server.sh`
  ```
  curl -o /usr/local/bin/goto_http_redirect_server.sh https://raw.githubusercontent.com/jtmoon79/goto_http_redirect_server/master/service/goto_http_redirect_server.sh
  chmod 0555 /usr/local/bin/goto_http_redirect_server.sh
  ```
  The wrapper-script expects the Python package to install to
  `/usr/local/bin/goto_http_redirect_server`.  The wrapper-script has options
  for environment variable overrides.

- `/etc/systemd/user/goto_http_redirect_server.service`
  ```
  curl -o /etc/systemd/user/goto_http_redirect_server.service https://raw.githubusercontent.com/jtmoon79/goto_http_redirect_server/master/service/goto_http_redirect_server.service
  chmod 0444 /etc/systemd/user/goto_http_redirect_server.service
  ```

### Enable and Start systemd Service

    systemctl enable /etc/systemd/user/goto_http_redirect_server.service    
    systemctl start goto_http_redirect_server.service

### Check systemd Service

    systemctl status goto_http_redirect_server.service

### (optional) Harden the Process with authbind and Low Privilege User

The wrapper-script `goto_http_redirect_server.sh` accepts options to run
`goto_http_redirect_server` with lower privileges.

Using a package manager, install `authbind`.

Setup the low privilege port for user `nobody`:

     touch /etc/authbind/byport/80
     chmod 0500 /etc/authbind/byport/80
     chgrp nogroup /etc/authbind/byport/80
     chown nobody /etc/authbind/byport/80

In systemd service script `/etc/systemd/user/goto_http_redirect_server.service`
adjust declaration `ExecStart` and then restart the service.  User `nobody` may
be any other user.