#!/usr/bin/env bash
# nbdkit
# Copyright (C) 2016 Red Hat Inc.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# * Neither the name of Red Hat nor the names of its contributors may be
# used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY RED HAT AND CONTRIBUTORS ''AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL RED HAT OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
# USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

source ./functions.sh
set -e
set -x

output="$(nbdkit --version)"
if [[ ! ( "$output" =~ ^nbdkit\ 1\. ) ]]; then
    echo "$0: unexpected output from nbdkit --version"
    echo "$output"
    exit 1
fi

# Run nbdkit plugin --version for each plugin.
# However some of these tests are expected to fail.
do_test ()
{
    vg=; [ "$NBDKIT_VALGRIND" = "1" ] && vg="-valgrind"
    case "$1$vg" in
        vddk | vddk-valgrind)
            echo "$0: skipping $1$vg because VDDK cannot run without special environment variables"
            ;;
        python-valgrind | ruby-valgrind | tcl-valgrind)
            echo "$0: skipping $1$vg because this language doesn't support valgrind"
            ;;
        *)
            nbdkit $1 --version
            ;;
    esac
}
foreach_plugin do_test
