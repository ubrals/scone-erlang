# scone-erlang
Porting Erlang to SCONE in TU Dresden M.Sc. DSE

# Warning
If `otp_erlang_23.1_scone_setup.tar.gz` is of a different version (TAG) from directory `otp_erlang_23.1_scone_setup/`, it is because GIT may have blocked a large file. Another situation is due to some change in the %script `build.cross.sh` or a patch to be added and later applied by the %script. Just run:

`tar cf otp_erlang_23.1_scone_setup.tar otp_erlang_23.1_scone_setup/`

`gzip otp_erlang_23.1_scone_setup.tar`


# Build
`docker image build --rm --no-cache -t TAG_IT:NAME_IT .`

# Execute
`docker run --rm TAG_IT:NAME_IT`
Hello, world!

