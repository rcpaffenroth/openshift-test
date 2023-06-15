#! /bin/bash

x=`mktemp -p /home/rcpaffenroth/tmp -t singularity.XXXX -d` && \
ssh-keygen -t ed25519 -f $x/ssh_host_ed25519_key -N "" && \
cp /etc/ssh/sshd_config $x && \
sed -i "s|#HostKey.*$|HostKey ${x}/ssh_host_ed25519_key|" $x/sshd_config && \
sed -i "s|#PidFile.*$|PidFile ${x}/sshd.pid|" $x/scode shd_config && \
exec /usr/sbin/sshd -f $x/sshd_config -D
