Files for adding the _"Go To" HTTP Redirect Server_ as a Linux systemd service.

----

<!-- python -m md_toc README.md github -->

- [`setuptools` Install Instrucions](#setuptools-install-instrucions)
- [Manual Install Instructions](#manual-install-instructions)
  - [Create HTTP Redirects File](#create-http-redirects-file)
  - [Install Files](#install-files)
  - [Enable and Start systemd Service](#enable-and-start-systemd-service)
  - [Check systemd Service](#check-systemd-service)
  - [OS-Specific](#os-specific)
  - [(optional) Harden the Process with authbind and Low Privilege User](#optional-harden-the-process-with-authbind-and-low-privilege-user)
- [Notes](#notes)

----

## `setuptools` Install Instructions

As `root` user, replace `*`

1. unpack the wheel package

       python -m wheel unpack goto_http_redirect_server-*-py3-none-any.whl

2. make installer scripts executable

       chmod -Rv +x goto_http_redirect_server-*/service/

3. run `systemd_install` command

       python ./goto_http_redirect_server-*/setup.py systemd_install

   There are options for the `systemd_install` command. Pass `--help`.

4. if needed it can be uninstalled.<br />
   Run `systemd_uninstall` command

       python ./goto_http_redirect_server-*/setup.py systemd_uninstall

   There are options for the `systemd_uninstall` command. Pass `--help`.

## Manual Install Instructions

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

- `/etc/goto_http_redirect_server.conf`
  ```
  curl -o /etc/goto_http_redirect_server.conf https://raw.githubusercontent.com/jtmoon79/goto_http_redirect_server/master/service/goto_http_redirect_server.conf
  chmod 0755 /etc/goto_http_redirect_server.conf
  ```
  Adjust this file as preferred.

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

### OS-Specific

#### CentOS

Allow access through the CentOS firewall.

    firewall-cmd --permanent --add-service=http
    firewall-cmd --reload

### (optional) Harden the Process with authbind and Low Privilege User

The wrapper-script `goto_http_redirect_server.sh` accepts options to run
`goto_http_redirect_server` with lower privileges.

Using a package manager, install `authbind`.

Setup the low privilege port for user `nobody`:

    touch /etc/authbind/byport/80
    chmod 0500 /etc/authbind/byport/80
    chgrp nogroup /etc/authbind/byport/80
    chown nobody /etc/authbind/byport/80

The systemd service configuration `/etc/goto_http_redirect_server.conf` can
be modified to pass necessary options to `/etc/goto_http_redirect_server.sh`.

## Notes

Tested on multiple platforms in [Azure Pipelines](../.azure-pipelines/azure-pipelines.yml).
