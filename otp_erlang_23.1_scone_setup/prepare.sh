#!/bin/sh

tar xzf otp_src_23.1.tar.gz
cp build.cross.sh ./otp_src_23.1/
patch < otp_23.1_scone.patch
cd ./otp_src_23.1/
