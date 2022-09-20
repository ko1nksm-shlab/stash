#!/bin/sh

. ./stash.sh

foo() {
    stash_push var1 var2 var3
    var1="abc" var3="xyz"
    unset var2

    echo "[foo:before] var1: ${var1-unset}, var2: ${var2-unset}, var3: ${var3-unset}"
    bar
    echo "[foo:after] var1: ${var1-unset}, var2: ${var2-unset}, var3: ${var3-unset}"

    (exit 10)
    stash_pop "$?"
    return $?
}

bar() {
    stash_push var1 var2 var3

    var1=A var2=B var3=C
    echo "[bar] var1: ${var1-unset}, var2: ${var2-unset}, var3: ${var3-unset}"

    stash_pop "$?"
    return $?
}

var1=123 var2=456
unset var3

echo "[top:before] var1: ${var1-unset}, var2: ${var2-unset}, var3: ${var3-unset}"
foo
echo "exit status: $?"
echo "[top:after] var1: ${var1-unset}, var2: ${var2-unset}, var3: ${var3-unset}"

