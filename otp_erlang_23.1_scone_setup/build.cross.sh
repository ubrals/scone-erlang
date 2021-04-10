#!/bin/bash

export ERL_TOP=`pwd`
export PATH="$PATH:$ERL_TOP/bin"
echo "..:INF:Executing otp_build autoconf" \
&& \
CC=/usr/bin/gcc CXX=/usr/bin/g++ ./otp_build autoconf \
&& \
echo "..:INF:Executing configure --enable-bootstrap-only" \
&& \
CC=/usr/bin/gcc CXX=/usr/bin/g++ ./configure --enable-bootstrap-only \
&& \
echo "..:INF:Executing make" \
&& \
CC=/usr/bin/gcc CXX=/usr/bin/g++ make \
&& \
echo "..:INF:Executing configure --disable-dirty-schedulers --disable-plain-emulator --disable-kernel-poll" \
&& \
cd .. \
&& \
patch -p0 < otp_23.1_scone.patch.p1 \
&& \
cd - \
&& \
CC=/usr/local/bin/gcc CXX=/usr/local/bin/g++ SCONE_FORK=1 ./configure --disable-dirty-schedulers --disable-plain-emulator --disable-kernel-poll --build="x86_64-unknown-linux-gnu" --host="x86_64-linux-musl" --prefix="/opt/erlang" \
&& \
echo "..:INF:Executing make" \
&& \
CC=/usr/local/bin/gcc CXX=/usr/local/bin/g++ SCONE_FORK=1 make \
&& \
echo "..:INF:Executing make install" \
&& \
sudo make install


