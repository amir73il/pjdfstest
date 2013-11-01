#!/bin/sh
# $FreeBSD: src/tools/regression/fstest/tests/symlink/10.t,v 1.1 2007/01/17 01:42:11 pjd Exp $

desc="symlink returns EROFS if the file name2 would reside on a read-only file system"

dir=`dirname $0`
. ${dir}/../misc.sh

case "${os}:${fs}" in
FreeBSD:UFS)
	echo "1..7"

	n0=`namegen`
	n1=`namegen`
	n2=`namegen`

	expect 0 mkdir ${n0} 0755
	n=`mdconfig -a -n -t malloc -s 1m`
	newfs /dev/md${n} >/dev/null
	mount /dev/md${n} ${n0}

	expect 0 symlink test ${n0}/${n1}
	expect 0 unlink ${n0}/${n1}
	mount -ur /dev/md${n}
	expect EROFS symlink test ${n0}/${n1}
	mount -uw /dev/md${n}
	expect 0 symlink test ${n0}/${n1}
	expect 0 unlink ${n0}/${n1}

	umount /dev/md${n}
	mdconfig -d -u ${n}
	expect 0 rmdir ${n0}
	;;
*)
	quick_exit_ok
	;;
esac
