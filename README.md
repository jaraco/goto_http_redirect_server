
# Go To HTTP Redirect Server

[![CircleCI](https://circleci.com/gh/jtmoon79/coverlovin2.svg?style=svg)](https://circleci.com/gh/jtmoon79/goto_http_redirect_server)
[![Build Status](https://dev.azure.com/jtmmoon/goto_http_redirect_server/_apis/build/status/jtmoon79.goto_http_redirect_server?branchName=master)](https://dev.azure.com/jtmmoon/goto_http_redirect_server/_build/latest?definitionId=1&branchName=master)
[![Requirements Status](https://requires.io/github/jtmoon79/goto_http_redirect_server/requirements.svg?branch=master)](https://requires.io/github/jtmoon79/goto_http_redirect_server/requirements/?branch=master)
[![PyPI version](https://badge.fury.io/py/goto-http-redirect-server.svg)](https://badge.fury.io/py/goto-http-redirect-server)
[![Python versions](https://img.shields.io/pypi/pyversions/goto-http-redirect-server.svg?longCache=True)](https://pypi.org/pypi/goto-http-redirect-server/)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The **_"Go To" HTTP Redirect Server_** for sharing custom shortened HTTP URLs
on your network.

Trivial to run and reload.  Only uses Python built-in modules.  Super handy 😄 ‼

## Setup and run

1. create a tab-separated values file (`'\t'`) with a list of HTTP redirects.<br />
   Fields are "_from path_", "_to URL_", "_added by user_", and "_added on datetime_".<br />
   For example, given a file `./redirects1.csv`

       /builds	https://build-server.mycorp.local/build-list	alice	2019-08-10 00:05:10
       /hr	http://human-resources.mycorp.local/login	bob	2018-07-11 22:15:10
       /aws	https://us-west-2.console.aws.amazon.com/console/home?region=us-west-2#	carl	2019-01-05 12:35:10

2. (optional) Install

    - Install manually
      ```
      python setup.py bdist_wheel
      python -m pip install --user ./dist/goto_http_redirect_server-*-py3-none-any.whl
      ```

    - Or, try helper scripts [`tools/build-install.sh`](./tools/build-install.sh) or [`tools/build-install.ps1`](./tools/build-install.ps1)

    - Or, try [`tools/eazy-run.sh`](./tools/eazy-run.sh) and pass command-line options as if
      running `goto_http_redirect_server.py`.

3.  start the _Go To HTTP Redirect Server_

        goto_http_redirect_server --redirects ./redirects1.csv

    or, if Install step was skipped,

        python goto_http_redirect_server.py --redirects ./redirects1.csv

    Requires at least Python version 3.5.2.

### Use

From your browser, browse to a redirect path!  For example, given a network host
`goto` running `goto_http_redirect_server` on port `80`, and given the
example redirects file `./redirects1.csv` above, then<br />
in your browser, type **`goto/hr⏎`**. Your browser will end up at
**`http://human-resources.mycorp.local/login`** 😝‼

<small>

Sadly, some browsers will assume a single word host, e.g. `goto/hr`, is a
search engine query, i.e. the browser will query Google for "`goto/hr`".
Either, type in the local network domain name, e.g. `goto.local/hr`,
or, type in a prepended http protocol, e.g. `http://goto/hr`.\*\*

</small>

### Live Reload

When the tab-separated values files are modified, this program can reload them.
No service downtime!

#### Reload via Signals

 1. Note during startup the Process ID (or query the host System).
 
 2. Send the process signal to the running `goto_http_redirect_server`.<br />
    In Unix, use `kill`.<br />
    In Windows, use [`windows-kill.exe`](https://github.com/alirdn/windows-kill/releases)<br />
    The running `goto_http_redirect_server` will re-read all files passed via
    `--redirects`.

#### Reload via browser

1. Pass `--reload-path /reload` as a program command-line options.

2. Browse to `http://host/reload`.

### Pro Tips

- Add a DNS addressable host on your network named `goto`. Run
  `goto_http_redirect_server` on the host.<br />
  Network users can type in their browser address bar `goto/…⏎` to easily use
  the _"Go To" HTTP Redirect Server_.\*\*

- There are many methods to secure a running process.
  One method is to use `authbind` to run `goto_http_redirect_server` as a low
  privilege process.

      apt install authbind
      touch /etc/authbind/byport/80
      chown nobody /etc/authbind/byport/80
      chmod 0500 /etc/authbind/byport/80
      sudo -u nobody -- authbind --deep python goto_http_redirect_server …

<br />

\*\* _Mileage May Vary_ 😔

----

## `--help` message

    usage: goto_http_redirect_server [--from-to from to]
                                     [--redirects REDIRECTS_FILES] [--ip IP]
                                     [--port PORT] [--status-path STATUS_PATH]
                                     [--reload-path RELOAD_PATH]
                                     [--redirect-code REDIRECT_CODE]
                                     [--field-delimiter FIELD_DELIMITER]
                                     [--shutdown SHUTDOWN] [--log LOG] [--debug]
                                     [--version] [-?]

    The "Go To" HTTP Redirect Server! For sharing custom shortened HTTP URLs on your
    network.

    HTTP 308 Permanent Redirect reply server. Load this server with redirects of "from path" and
    "to URL" and let it run indefinitely. Reload the running server by
    signaling the process.

    Redirects:
      One or more required. May be passed multiple times.

      --from-to from to     A single redirection of "from path" and "to URL"
                            fields. For example, --from-to "/hr" "http://human-
                            resources.mycorp.local/login"
      --redirects REDIRECTS_FILES
                            File of redirection information. Within a file, is one
                            redirection entry per line. An entry is four fields
                            using tab character for field separator. The four
                            entry fields are: "from path", "to URL", "added by
                            user", and "added on datetime" separated by a tab.

    Network Options:
      --ip IP, -i IP        IP interface to listen on. Default is 127.0.0.1 .
      --port PORT, -p PORT  IP port to listen on. Default is 80 .

    Miscellaneous Options:
      --status-path STATUS_PATH
                            Override status page path. This is the page that dumps
                            information about the process and loaded redirects.
                            This can be the default landing page e.g. --status-
                            path "/" . Default status page path is "/status".
      --reload-path RELOAD_PATH
                            Allow reloads by HTTP GET Request to passed URI Path.
                            e.g. --reload-path "/reload". May be a potential
                            security or stability issue. The program will always
                            allow reload by process signal. Default is off.
      --redirect-code REDIRECT_CODE
                            Override default HTTP Redirect Status Code as an
                            integer. Most often the desired override will be 307
                            (Temporary Redirect). Any HTTP Status Code could be
                            used but odd things will happen if a value like 500 is
                            returned. This Status Code is only returned when a
                            loaded redirect entry is found and returned. Default
                            successful redirect Status Code is 308 (Permanent
                            Redirect).
      --field-delimiter FIELD_DELIMITER
                            Field delimiter string for --redirects files. Default
                            is " " (tab character) between fields.
      --shutdown SHUTDOWN   Shutdown the server after passed seconds. Intended for
                            testing.
      --log LOG             Log to file at path LOG. Default logging is to
                            sys.stderr.
      --debug               Set logging level to DEBUG. Default is INFO.
      --version             Print "goto_http_redirect_server 0.4.1" and exit.
      -?, -h, --help        Print this help message and exit.

    About Redirect Entries:

      Entries found in --redirects file(s) and entries passed via --from-to are
      combined.
      Entries passed via --from-to override any matching "from path" entry found in
      redirects files.
      The "from path" field corresponds to the URI Path in the originating request.
      The "to URL" field corresponds to HTTP Header "Location" in the server
      Redirect reply.

      A redirects file entry has four fields separated by a tab character "\t";
      "from path", "to URL", "added by user", "added on datetime".  For example,

        hr  http://human-resources.mycorp.local/login       bob     2019-09-07 12:00:00

      The last two fields, "added by user" and "added on datetime", are intended
      for record-keeping within an organization.

      A passed redirect (either via --from-to or --redirects file) should have a
      leading "/" as this is the URI path given for processing.
      For example, the URL "http://host/hr" is processed by goto_http_redirect_server
      as URI path "/hr".

    About Paths:

      Options --status-path and --reload-path may be passed paths to obscure access
      from unauthorized users. e.g.

          --status-path '/fc8953c0-1cde-4254-8974-d23c61678310'

    About Reloads:

      Sending a process signal to the running process will cause
      a reload of any files passed via --redirects.  This allows live updating of
      redirect information without disrupting the running server process.
      On Unix, the signal is SIGUSR1.  On Windows, the signal is SIGBREAK.
      On this system, the signal is Signals.SIGBREAK (21).
      On Unix, use program `kill`.  On Windows, use program `windows-kill.exe`.

      A reload of redirection files may also be requested via passed URI path
      --reload-path '/path'.

      If security and stability are a concern then only allow reloads via process
      signals.

----

<a href="https://stackexchange.com/users/216253/jamesthomasmoon1979"><img src="https://stackexchange.com/users/flair/216253.png" width="208" height="58" alt="profile for JamesThomasMoon1979 on Stack Exchange, a network of free, community-driven Q&amp;A sites" title="profile for JamesThomasMoon1979 on Stack Exchange, a network of free, community-driven Q&amp;A sites" /></a>
