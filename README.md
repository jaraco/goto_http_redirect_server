
# Go To HTTP Redirect Server

[![CircleCI](https://circleci.com/gh/jtmoon79/coverlovin2.svg?style=svg)](https://circleci.com/gh/jtmoon79/goto_http_redirect_server)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

The **_"Go To" HTTP redirect server_**. For sharing shortened HTTP URLs on
your private network.

Trivial to run and reload.  Only uses Python built-in modules.  Super useful 😄 ‼

## Setup and run

1. create a tab-separated values file (`'\t'`) with a list of redirects.<br />
   Columns are "_from_", "_to_", "_added by user_", and "_added on datetime_".<br />
   For example,

       /builds	https://build-server.mycorp.local/build-list	alice	2019-08-10 00:05:10
       /hr	http://human-resources.mycorp.local	bob	2018-07-11 22:15:10
       /aws	https://us-west-2.console.aws.amazon.com/console/home?region=us-west-2#	carl	2019-01-05 12:35:10

2. (optional) Install<br />

       python setup.py bdist_wheel
       python -m pip install --user ./dist/goto_http_redirect_server-*-py3.7-none-any.whl

   or, try helper scripts `build-install.sh` or `build-install.ps1`.

3.  start the _Go To HTTP redirect server_

        goto_http_redirect_server --redirects .\redirects1.csv

    or, if Install step was skipped,

        python goto_http_redirect_server.py --redirects .\redirects1.csv

    Requires at least Python version 3.5.2.

### Use

From your browser, browse to a redirect path!  For example, given a network host
`goto` running `goto_http_redirect_server` on port `80`, and given the
example redirects file above, then<br />
in your browser, type **`goto/hr⏎`**. Your browser will end up at
**`http://human-resources.mycorp.local`** 😝‼

<small>

Sadly, some browsers will assume a single word host, e.g. `goto/foo`, is a
search engine query, i.e. the browser will query Google for `goto/foo`. 
Users may need to pass the local network domain name, e.g. `goto.local/hr`, to
force the browser to use host `goto.local`.\*\*

</small>

### Live Reload

When the tab-separated values files are modified, this program can reload them.
No service downtime.

#### Reload via Signals

 1. Note during startup the Process ID (or query the host System). This is
    necessary to send a process signal. 
 
 2. Send the process signal to the running `goto_http_redirect_server`.<br />
    In Unix, use `kill`.<br />
    In Windows, use [`windows-kill.exe`](https://github.com/alirdn/windows-kill/releases)<br />
    The running `goto_http_redirect_server` will re-read all files passed via
    `--redirects`.

#### Reload via browser

1. Pass `--allow-remote-reload` as a program command-line options.

2. Browse to `http://host/reload`.

### Pro Tips

- Add a DNS addressable host on your network named `goto`. Run
`goto_http_redirect_server` on the host.<br />
Network users can type in their browser address bar `goto/…⏎` to easily use the
_Go To HTTP redirect server_.\*\*

- Consider using `authbind` to run `goto_http_redirect_server` as a low
privilege process.

      apt install authbind
      touch /etc/authbind/byport/80
      chown nobody /etc/authbind/byport/80
      chmod 0500 /etc/authbind/byport/80
      sudo -u nobody -- authbind --deep python goto_http_redirect_server …

- Initiating the reload signal requires
  1. noticing a modified file
  2. signaling the `goto_http_redirect_server` process.<br />
  There are many methods to accomplish this. That is an exercise for the user.

----

## `--help` message

    usage: goto_http_redirect_server [--from-to from to]
                                     [--redirects REDIRECTS_FILES] [--ip IP]
                                     [--port PORT] [--status-code STATUS_CODE]
                                     [--allow-remote-reload]
                                     [--field-delimiter FIELD_DELIMITER]
                                     [--shutdown SHUTDOWN] [--verbose] [--version]
                                     [-?]

    The *Go To HTTP Redirect Server*!

    HTTP 308 Permanent Redirect reply server. Load this server with redirect mappings
    of "from" and "to" and let it run indefinitely. Reload the running server by
    signaling the process.

    Redirects:
      One or more required. May be passed multiple times.

      --from-to from to     A redirection pair of "from" and "to" fields. For
                            example, --from-to "foo" "http://foobar.com"
      --redirects REDIRECTS_FILES
                            File of redirection information. Within a file, is one
                            entry per line. An entry is four fields using tab
                            character for field separator. The four entry fields
                            are: "from" "to" "author" "date" separated by a tab.

    Network Options:
      --ip IP, -i IP        IP interface to listen on. Defaults to 127.0.0.1
      --port PORT, -p PORT  IP port to listen on. Defaults to 80

    Miscellaneous:
      --status-code STATUS_CODE
                            Override default HTTP Status Code as an integer. Most
                            often the desired override will be 307 (Temporary
                            Redirect). Any HTTP Status Code could be passed but
                            odd things might happen if a value like 500 was
                            passed. This Status Code is only returned when a
                            loaded redirect entry is found and returned. Default
                            Status Code is 308 (Permanent Redirect)
      --allow-remote-reload
                            Allow reloads via request URI Path "/reload". This is
                            in addition to sending the process a signal. May be a
                            potential security or stability risk.
      --field-delimiter FIELD_DELIMITER
                            Field delimiter string for --redirects files. Defaults
                            to " " (tab character) between fields.
      --shutdown SHUTDOWN   Shutdown the server after passed seconds. Intended for
                            testing.
      --verbose             Set logging level to DEBUG. Logging level default is
                            INFO.
      --version             show program version and exit
      -?, -h, --help        show this help message and exit

    About Redirect Entries:

      Entries found in --redirects file(s) and entries passed via --from-to are
      combined.
      Entries passed via --from-to override any matching "from" entry found in
      redirects files.
      The "from" field corresponds to the URI Path in the originating request.
      The "to" field corresponds to HTTP Header "Location" in the server Redirect
      reply.

      A redirects file entry has four columns separated by a tab character "\t";
      "from", "to", "added by user", "added on datetime".  For example,

        foo http://foobar.com       bob     2019-09-07 12:00:00

      The last two columns, "added by user" and "added on datetime", are intended
      for record-keeping within an organization.

      A passed redirect (either via --from-to or --redirects file) should have a
      leading "/" as this is the URI path given for processing.
      For example, the URL "http://host/foo" is parsed by goto_http_redirect_server
      as URI path "/foo".

    About Signals and Reloads:

      Sending goto_http_redirect_server the signal 21 (Signals.SIGBREAK) will cause
      a reload of any files passed via --redirects.  This allows live updating of
      redirect information without disrupting the running server process.
      On Unix, use program `kill`.  On Windows, use program `windows-kill.exe`.
      On Unix, the signal is SIGUSR1.  On Windows, the signal is SIGBREAK.

      A reload of redirection files may also be requested via URI path "/reload"
      but only if --allow-remote-reload .

      If security and stability are a concern then only allow reloads via process
      signals.

    Other Notes:

      Path "/status" will dump the current status of the process.

\*\* _Mileage May Vary_ 😔
