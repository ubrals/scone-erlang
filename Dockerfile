#FROM sconecuratedimages/perf:package-builder-alpine-3.11
#FROM alpine:3.12
#FROM pamenas/perf:cross_compiler_alpine-3.11_master
#FROM registry.scontain.com:5050/sconecuratedimages/crosscompilers:latest
#FROM pamenas/perf:cross_compiler-alpine-3.11_master
#FROM pamenas/perf:cross_compiler_mapper_sync_fork_heap
FROM pamenas/perf:cross_compiler_mapper_sync_fork_heap_rcv_sendmsg


##################################################################
USER root

#RUN sudo apk add sudo \
RUN apk add sudo \
	autoconf \
	ncurses-dev \
	linux-headers \
	shadow \
	strace
RUN echo "root       ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN sudo useradd -ms /bin/bash erlanger; \
	sudo passwd -d erlanger; \
	echo "export PATH=\"\$PATH:/opt/erlang/bin\"" >>~builder/.bashrc; \
	echo "export PS1='\u@\h:\w $ '" >>~builder/.bashrc; \
	sudo cp ~builder/.bashrc ~erlanger/.bashrc; \
#	sudo rm ~builder/.bashrc; \
	sudo chown erlanger:erlanger ~erlanger/.bashrc

COPY ./erlanger.sudoer /etc/sudoers.d/
RUN sudo chmod 440 /etc/sudoers.d/erlanger.sudoer

WORKDIR /tmp
RUN sudo mkdir building; \
	sudo chown erlanger building

RUN echo "|--> Setting up BPFTRACE STATIC";
ADD ./bpftrace_static_setup.tar.gz /tmp/building/
WORKDIR /tmp/building/bpftrace_static_setup
RUN sudo mkdir -p /mnt/bpft /opt/bpftrace/bin; \
	sudo cp file_block.ext3 /opt/bpftrace; \
	sudo cp missing_types_mig.h /opt/bpftrace/bin; \
	sudo cp bpftrace_static /opt/bpftrace/bin; \
	sudo cp mount_bpft.sh /opt/bpftrace/bin;

RUN echo "|--> Setting up ERLANG PATCHED FOR SCONE";
WORKDIR /tmp/building/
COPY ./otp_erlang_23.1_scone_setup.tar.gz /tmp/building/
RUN sudo -u erlanger tar xzf ./otp_erlang_23.1_scone_setup.tar.gz; \
	cd otp_erlang_23.1_scone_setup/; \
#	pwd; \
#	ls; \
	sudo -u erlanger tar xzf otp_src_23.1.tar.gz; \
	sudo -u erlanger cp build.cross.sh ./otp_src_23.1/; \
#	sudo -u erlanger patch -p0 < otp_23.1_scone.patch.p1; \
#	sudo -u erlanger patch -p0 < otp_23.1_scone.patch.p2; \
#	ls -l; \
	cd otp_src_23.1/; \
#	pwd; \
#	ls -l; \
	sudo -u erlanger ./build.cross.sh \
	|| echo; \
	sudo make install

RUN echo "|--> Preparing for test ERLANG HELLO WORLD"
WORKDIR /home/builder
ADD ./progs ./progs
RUN sudo chown -Rf builder:abuild progs; \
	sudo chmod go+w progs; \
	cd progs; \
	SCONE_HEAP=2G SCONE_FORK=1 /opt/erlang/bin/erlc helloworld.erl \
	|| echo;

USER builder
##################################################################

