#!/bin/bash

# Copyright (c) 2010, Prakash Mohan and Sivaramakrishnan Swaminathan
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice,this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the copyright holder nor the names of its
#       contributors may be used to endorse or promote products derived from
#       this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# A shell interface upload files to pastebin.com
# More information in the README file.
# TODO BlogPost
# Create a MAN page
# Whats the difference b/w SH(dash), BASH and ZSH. Which is standard ?

PROG_NAME=$(basename $0)

usage() {
    echo "Usage:    $PROG_NAME <path-to-file> [OPTIONS]";
    echo
    echo "Options:"
    echo "          -f FORMAT   Specify the syntax highlighting format to be used"
    echo "          -a AUTHOR   Specify the author name"
    echo "          -x EXPIRY   Valid options are ( N - never, 10M - 10 minutes, 1H - 1 hour, 1D - 1 Day, 1M - 1 Month) "
    echo "          -v          Verbose, print more stuff"
    echo "          -h          Display this help and exit"
    echo
    echo "The program will return the URL to your post as the output.";
}

file="$1"

if [[ -f "$1" ]] ; then
    shift 1
fi

test_format="pass"
test_expiry="pass"
verbose=""

# can be written without getopts, using case command
while getopts f:a:x:vh op
do
    case $op in
        f) format=$OPTARG
            test_format="";;
        a) author=$OPTARG;;
        x) expiry=$OPTARG
            test_expiry="";;
        v)verbose="true";;
        h) usage
            exit 0;
            ;;
        \?)echo
            usage
            exit 2;;
    esac
done

if [[ -z "$file"  ]] ; then
    echo "ERROR: File to be pasted not specified"
    echo
    usage
    exit 1 ;
elif [[ ! -f "$file" ]]; then
    echo "ERROR: File provided is invalid"
    echo
    usage
    exit 1;
fi


if [[ ! -z "$verbose" ]]; then
    echo "Contents of file $file are accepted."
fi

# Testing for validity of format
if [[ ! -z $format ]] ; then
    formats=(abap actionscript actionscript3 ada apache \
            applescript apt_sources asm asp autoit avisynth \
            bash basic4gl bibtex blitzbasic bnf boo bf c \
            c_mac cill csharp cpp caddcl cadlisp cfdg \
            klonec klonecpp cmake cobol cfm css d dcs \
            delphi dff div dos dot eiffel email erlang \
            fo fortran freebasic gml genero gettext groovy \
            haskell hq9plus html4strict idl ini inno intercal \
            io java java5 javascript kixtart latex lsl2 \
            lisp locobasic lolcode lotusformulas lotusscript \
            lscript lua m68k make matlab matlab mirc \
            modula3 mpasm mxml mysql text nsis oberon2 objc \
            ocaml-brief ocaml glsl oobas oracle11 oracle8 \
            pascal pawn per perl php php-brief pic16 \
            pixelbender plsql povray powershell progress prolog \
            properties providex python qbasic rails rebol reg \
            robots ruby gnuplot sas scala scheme scilab \
            sdlbasic smalltalk smarty sql tsql tcl tcl \
            teraterm thinbasic typoscript unreal vbnet verilog \
            vhdl vim visualprolog vb visualfoxpro whitespace \
            whois winbatch xml xorg_conf xpp z80);
    for i in ${formats[*]} ; do
        if [[ "$format" = "$i" ]] ; then
            test_format="pass";
        fi;
    done

    if [[ -z $test_format ]] ; then
        echo "Invalid format, enter again."
        exit 3;
    elif [[ ! -z "$verbose" ]]; then
        echo "Format accepted.";
    fi
fi

#Testing for validity of expiry
if [[ ! -z $expiry ]] ; then
    expirys=(N 10M 1H 1D 1M);
    #if [[ ! -z "$expiry" ]] ; then
    for j in ${expirys[*]};do
        if [[ "$expiry" = "$j" ]] ; then
    #        echo "expiry pass";
            test_expiry="pass";
        fi
    done

    if [[ -z $test_expiry ]] ; then
        echo "Invalid expiry time, enter again."
        exit 4;
    elif [[ ! -z "$verbose" ]]; then
        echo "Expiry time accepted.";
    fi
fi

#sending the contents to pastebin
if [[ ! -z "$verbose" ]]; then
    echo "Sending the contents to pastebin.com ...";
fi

curl http://pastebin.com/api_public.php -d \
    paste_format=$format --data-urlencode paste_code@"$file" \
    --data-urlencode paste_name=$author -d paste_expiry=$expiry; 
echo

if [[ "$?" == "0" ]] ; then
    if [[ ! -z "$verbose" ]]; then
        echo "There's the link! :-)";
    fi
else
    echo "There was an error in sending your post"
fi
