#!/bin/bash
/usr/sbin/service/zerotier-one stop
sh /usr/local/bin/make-tap
/usr/sbin/service zerotier-one start
sh /usr/local/bin/bridge-start

