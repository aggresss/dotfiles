#!/usr/bin/env bash

npm config set registry https://registry.npmmirror.com

npm install -g n
sudo ${HOME}/.local/bin/n stable

npm install -g npm
npm install -g npm-check
npm install -g yarn
npm install -g gulp-cli
npm install -g grunt-cli
npm install -g typescript
npm install -g ts-node
npm install -g serve
npm install -g http-server
npm install -g live-server
npm install -g create-react-app
