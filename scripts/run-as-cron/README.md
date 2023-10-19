
Useful for running cron job scripts immediately for testing.

Setup
=====

Fetch cron's environment for testing. This script takes a minute to execute,
but only needs to be run once:
```
./setup.sh
```

Run
===

```
run-as-cron "my command and parameters"
```

Inspired by
===========
https://stackoverflow.com/a/44358180
https://stackoverflow.com/a/29170502
https://serverfault.com/a/532121
