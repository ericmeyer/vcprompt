# where to find all the test files
testdir="$PWD"

# other globals set by functions here
vcprompt=""
tmpdir=""

# Check if some external command is available by running it
# and ensuring that it prints an expected string.  If not,
# exit with optional message.
check_available()
{
    cmd=$1
    expect=$2
    msg=$3

    if ! $cmd 2>/dev/null | grep -q "$expect"; then
        [ "$msg" ] && echo $msg
        exit 0
    fi
}

find_vcprompt()
{
    vcprompt=$testdir/../vcprompt
    if [ ! -x $vcprompt ]; then
	echo "error: vcprompt executable not found (expected $vcprompt)" >&2
	exit 1
    fi
}

setup()
{
    tmpdir=`mktemp -d /tmp/vcprompt.XXXXXX`
    if [ $? != 0 -o -z "$tmpdir" -o ! -d "$tmpdir" ]; then
        echo "error: unable to create temp dir '$tmpdir'" >&2
        exit 1
    fi
    trap cleanup 0 1 2 15
}

cleanup()
{
    echo "cleaning up $tmpdir"
    chmod -R u+rwx $tmpdir
    rm -rf $tmpdir
}

_ping ()
{
    echo '^^^^ PING ^^^^'
    if [ "$@" ]; then
        args="$@"
        echo "\$@: \`$@\`"
        for ((idx = 0; idx < $#; ++idx)); do
            echo "\$$idx: \`$args{$idx}\`";
        done
    fi
}

_pong ()
{
    echo '$$$$ PONG $$$$'
    if [ "$@" ]; then
        args="$@"
        echo "\$@: \`$@\`"
        for ((idx = 0; idx < $#; ++idx)); do
            echo "\$$idx: \`$args{$idx}\`";
        done
    fi
}

assert_vcprompt()
{
    message=$1
    expect=$2
    format=$3
    if [ -z "$format" ]; then
        format="%b"
    fi

    if [ "$format" != '-' ]; then
        actual=`VCPROMPT_FORMAT="$VCPROMPT_FORMAT" $vcprompt -f "$format"`
    else
        actual=`VCPROMPT_FORMAT="$VCPROMPT_FORMAT" $vcprompt`
    fi

    if [ "$expect" != "$actual" ]; then
        echo "fail: $message: expected \"$expect\", but got \"$actual\"" >&2
        failed="y" # this probably won't do anything, 
                   # since it isn't global.
        return 1
    else
        echo "pass: $message"
    fi
}

report()
{
    if [ "$failed" ]; then
        echo "$0: some tests failed"
        exit 1
    else
        echo "$0: all tests passed"
        exit
    fi
}
