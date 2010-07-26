#!/bin/sh

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

if [[ ! -f "$1" ]] ; then
    echo "Usage: $0 <path-to-file>"
    echo "Or,    $0 <path-to-file> <format> <paste-name> <expiry time (N, 10M, 1H, 1D, 1M)>"
    echo "You will get the pastebin.com url as the output!"
    exit
fi

test=""
 if [[ ! -z "$2" ]] ; then
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
        whois winbatch xml xorg_conf xpp z80 \
        )
    for i in ${formats[*]} ; do
        if [[ "$2" = $i ]] ; then
            test="pass"
        fi
    done
    if [[ -z "$test" ]]; then
        echo "Invalid Format, enter again"
        exit 1
    fi
 fi

expiry="N"

if [[ ! -z $4 ]] ; then
    expiry=$4
fi

curl http://pastebin.com/api_public.php -d paste_format="$2" --data-urlencode paste_code@$1 --data-urlencode paste_name="$3" -d paste_expiry="$4"
echo
