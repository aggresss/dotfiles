#!/usr/bin/env bash
mkdir -p ${HOME}/bin
## clang tools
ln -sf $(brew --prefix llvm)/bin/clang-format ${HOME}/bin/clang-format
ln -sf $(brew --prefix llvm)/bin/clang-tidy ${HOME}/bin/clang-tidy
## mosquitto
ln -sf $(brew --prefix llvm)/bin/mosquitto_pub ${HOME}/bin/mosquitto_pub
ln -sf $(brew --prefix llvm)/bin/mosquitto_sub ${HOME}/bin/mosquitto_sub
ln -sf $(brew --prefix llvm)/bin/mosquitto_passwd ${HOME}/bin/mosquitto_passwd
ln -sf $(brew --prefix llvm)/bin/mosquitto_rr ${HOME}/bin/mosquitto_rr
## curl
ln -sf $(brew --prefix curl)/bin/curl ${HOME}/bin/curl
## openjdk
sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

