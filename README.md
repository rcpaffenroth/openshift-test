* This is a base, simplest, useful docker container.  It has

- openssh server
- rcpaffenroth user
- wget

* Command to run this all at once

make build && make reset && ssh -p 2022 -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" rcpaffenroth@localhost


# This is the command to do everything from scratch
# in fish!
set -x BASE 20.04; set -x PORT 2004;make fresh
set -x BASE 22.04; set -x PORT 2204;make fresh
