#!/usr/bin/env bash
# hello test for various kinds of language

# linux shell color support.
BLACK="\\033[30m"
RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
BLUE="\\033[34m"
MAGENTA="\\033[35m"
CYAN="\\033[36m"
WHITE="\\033[37m"
NORMAL="\\033[m"
LIGHT="\\033[1m"
INVERT="\\033[7m"

TMP_PATH="${HOME}/tmp"
if [ ! -d ${TMP_PATH} ]; then
    TMP_PATH="/tmp"
fi

HELLO_TYPE=$1
case ${HELLO_TYPE} in
c)
    cat <<END >${TMP_PATH}/hello.c
#include <stdio.h>
#include <signal.h>

static int interrupted = 0;

static void handleInterrupt(int sig)
{
    interrupted = 1;
}

int main(int argc, const char * argv[])
{
    (void)signal(SIGINT, handleInterrupt);
    (void)signal(SIGTERM, handleInterrupt);
    (void)signal(SIGKILL, handleInterrupt);

    printf("Hello, World!\n");
    while(!interrupted) {
    }
    return 0;
}

END
    echo "${TMP_PATH}/hello.c"
    #gcc -v ${TMP_PATH}/hello.c 2> ${TMP_PATH}/hello.c.txt
    #gcc -v ${TMP_PATH}/hello.c
    #rm -rf ${TMP_PATH}/hello.c* a.out
    ;;
h)

    cat <<END >${TMP_PATH}/hello.h
/* License */

#ifndef HELLO_H
#define HELLO_H

/* Includes */

/* Public defines */

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

/* Public structures */

/* Function declarations */

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* HELLO_H */

END
    echo "${TMP_PATH}/hello.h"
    ;;
cpp)
    cat <<END >${TMP_PATH}/hello.cpp
#include <iostream>

class Foo {
   public:

   protected:
   private:
};

struct Bar {

};

int main(int argc, const char * argv[])
{
    std::cout << "Hello, World!" << std::endl;
    return 0;
}

END
    echo "${TMP_PATH}/hello.cpp"
    #g++ -v ${TMP_PATH}/hello.cpp 2> ${TMP_PATH}/hello.cpp.txt
    #g++ -v ${TMP_PATH}/hello.cpp
    #rm -rf ${TMP_PATH}/hello.cpp* a.out
    ;;
go)
    cat <<END >${TMP_PATH}/hello.go
package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	ch := make(chan os.Signal, 1)
	signal.Notify(ch, syscall.SIGINT, syscall.SIGTERM, syscall.SIGKILL)

	fmt.Println("Hello, World!")

	select {
	case s := <-ch:
		fmt.Println(s.String())
	}
}

END
    echo "${TMP_PATH}/hello.go"
    #go build -o a.out ${TMP_PATH}/hello.go
    #rm -rf ${TMP_PATH}/hello.go a.out
    ;;
rs)
    cat <<END >${TMP_PATH}/hello.rs
fn main() {
    println!("Hello, world!");
}

END
    echo "${TMP_PATH}/hello.rs"
    #rustc ${TMP_PATH}/hello.rs
    #rm -rf ${TMP_PATH}/hello.rs ${TMP_PATH}/hello

    ;;
py)
    cat <<END >${TMP_PATH}/hello.py
# -*- coding: UTF-8 -*-
print('Hello, World!')

END
    echo "${TMP_PATH}/hello.py"
    #python ${TMP_PATH}/hello.py
    #rm -rf ${TMP_PATH}/hello.py
    ;;
sh)
    cat <<END >${TMP_PATH}/hello.sh
#!/usr/bin/env bash

function hello () {
    echo "\$(echo "Hello, World!")"
}

hello \$@
END
    echo "${TMP_PATH}/hello.sh"
    chmod +x ${TMP_PATH}/hello.sh
    #bash ${TMP_PATH}/hello.sh
    #rm -rf ${TMP_PATH}/hello.sh
    ;;
pl)
    cat <<END >${TMP_PATH}/hello.pl
#!/usr/bin/env perl

print "Hello, World!\n"

END
    echo "${TMP_PATH}/hello.pl"
    chmod +x ${TMP_PATH}/hello.pl
    #perl ${TMP_PATH}/hello.pl
    #rm -rf ${TMP_PATH}/hello.pl

    ;;
cmake)
    cat <<END >${TMP_PATH}/CMakeLists.txt
cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(HELLO C)
set(CMAKE_VERBOSE_MAKEFILE ON)
file(WRITE \${CMAKE_BINARY_DIR}/main.c "#include <stdio.h>\nint main(void){printf(\"Hello, World!\\\\n\");return 0;}\n")
add_executable(main main.c)
install(TARGETS main RUNTIME DESTINATION bin)

END
    echo "${TMP_PATH}/CMakeLists.txt"
    ;;
make)
    cat <<END >${TMP_PATH}/Makefile
ifeq (\$(OUTPUT), )
    OUTPUT:=Hello, World!
endif

all:
	@echo \$(OUTPUT)

END
    ;;
nodejs)
    cat <<END >${TMP_PATH}/hello.js
#!/usr/bin/env node

'use strict'
const http = require('http');
const port = process.env.PORT || 8080;

(async function() {
  http.createServer(async (req, res) => {
    res.writeHead(200, {
      "Content-Type": "text/plain",
      "Access-Control-Allow-Origin": "*"
      });
    res.end('Hello, World!\n');
  }).listen(port, "0.0.0.0");
  console.log(\`Server running at http://:localhost:\${port}/\`);
})();

END
    echo "${TMP_PATH}/hello.js"
    chmod +x ${TMP_PATH}/hello.js
    ;;
html)
    cat <<END >${TMP_PATH}/hello.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Hello, World!</title>
    <link rel="help" href="https://github.com/aggresss/dotfiles">
    <style type="text/css">
      h1 {color:magenta}
      p {color:cyan}
    </style>
  </head>
  <body>
    <h1>Hello, World!</h1>
    <p>Hello, World!</p>
    <script>
      console.log('Hello, World!')
    </script>
  </body>
</html>

END
    echo "${TMP_PATH}/hello.html"
    ;;
java)
    cat <<END >${TMP_PATH}/hello.java
public class hello{
    public static void main(String[] args){
         System.out.println("Hello, World!");
    }
}

END
    echo "${TMP_PATH}/hello.java"
    ;;
lua)
    cat <<END >${TMP_PATH}/hello.lua
#!/usr/bin/env lua

function printHello(printString)
    print(printString)
end

printHello("Hello, World!")

END
    echo "${TMP_PATH}/hello.lua"
    chmod +x ${TMP_PATH}/hello.lua
    ;;
rb)
    cat <<END >${TMP_PATH}/hello.rb
#!/usr/bin/env ruby

puts "Hello, World!"

END
    echo "${TMP_PATH}/hello.rb"
    chmod +x ${TMP_PATH}/hello.rb
    ;;
*)
    echo -e "${GREEN}Support Lang:"
    echo -e "  c\n  h\n  cpp\n  go\n  rs\n  py\n  sh\n  pl\n  cmake\n  make\n  nodejs\n  html\n  java\n  lua\n  rb\n${NORMAL}"
    ;;
esac
