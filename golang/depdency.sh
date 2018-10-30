#!/bin/bash

# https://github.com/Microsoft/vscode-go/blob/master/src/goInstallTools.ts
go get -u -v github.com/mdempsky/gocode
go get -u -v github.com/stamblerre/gocode
go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
go get -u -v github.com/ramya-rao-a/go-outline
go get -u -v github.com/acroca/go-symbols
go get -u -v golang.org/x/tools/cmd/guru
go get -u -v golang.org/x/tools/cmd/gorename
go get -u -v github.com/fatih/gomodifytags
go get -u -v github.com/haya14busa/goplay/cmd/goplay
go get -u -v github.com/josharian/impl
go get -u -v github.com/tylerb/gotype-live
go get -u -v github.com/rogpeppe/godef
go get -u -v github.com/ianthehat/godef
go get -u -v github.com/zmb3/gogetdoc
go get -u -v golang.org/x/tools/cmd/goimports
go get -u -v github.com/sqs/goreturns
go get -u -v winterdrache.de/goformat/goformat
go get -u -v golang.org/x/lint/golint
go get -u -v github.com/cweill/gotests/...
go get -u -v github.com/alecthomas/gometalinter
go get -u -v honnef.co/go/tools/...
go get -u -v github.com/golangci/golangci-lint/cmd/golangci-lint
go get -u -v github.com/mgechev/revive
go get -u -v github.com/sourcegraph/go-langserver
go get -u -v github.com/derekparker/delve/cmd/dlv
go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct

# vendor tools
go get -u -v github.com/Masterminds/glide
go get -u -v github.com/golang/dep/cmd/dep
go get -u -v github.com/kardianos/govendor
