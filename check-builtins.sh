#!/bin/sh

{
	cat <<\EOF
sayIt:
	$(foreach b,$(BUILT_INS),echo XXX $(b:$X=) YYY;)
EOF
	cat Makefile
} |
make -f - sayIt 2>/dev/null |
sed -n -e 's/.*XXX \(.*\) YYY.*/\1/p' |
sort |
{
    bad=0
    while read builtin
    do
	base=$(expr "$builtin" : 'gnostr-git-\(.*\)')
	x=$(sed -ne 's/.*{ "'$base'", \(cmd_[^, ]*\).*/'$base'	\1/p' gnostr-git.c)
	if test -z "$x"
	then
		echo "$base is builtin but not listed in gnostr-git.c command list"
		echo "$     is builtin but not listed in gnostr-git.c command list"
		bad=1
	fi
	for sfx in sh perl py
	do
		if test -f "$builtin.$sfx"
		then
			echo "$base is builtin but $builtin.$sfx still exists"
			bad=1
		fi
	done
    done
    exit $bad
}
