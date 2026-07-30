# Run Derrick server and a single runner locally

Sometimes it's easier to run the process locally for development. These
scripts will start up a local derrick server and runner for dev.

The shutdown scripts will attempt to stop the server and runner gracefully with
an interrupt signal rather than a kill.

_Note_: This method for running Derrick is not officially supported in any way.
It is mainly for developers and contributors to have an easy way to bring up
a server and runner for local development and is not expected to run in production.

## setup-derrick-local.sh

This script will automatically start up a server and a runner locally using
the `derrick` binary configured to your local path. It will automatically
bootstrap your CLI context once the server has been installed.

### Server and runner logs

When your server and runner start with `setup-derrick-local.sh`, they write their
logs to specific txt files (by default, they go to `/tmp`). You can use tools
like `tail` or `multitail` to watch the server and runner logs.

## shutdown-derrick-local.sh

This script will attempt to gracefully shut down the server and runner with a
SIGINT rather than something more forceful like a SIGKILL. Note that it will
not clean up logs or the database.
