#!/bin/bash
#

TOP=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

if [ "${MARVELL_SDK_PATH}" = "" ]; then
	MARVELL_SDK_PATH="$(cd "${TOP}/../.." && pwd)"
fi
if [ "${MARVELL_ROOTFS}" = "" ]; then
	source "${MARVELL_SDK_PATH}/setenv.sh" || exit 1
fi

cd "${TOP}"

wget -nc https://www.python.org/ftp/python/2.7.15/Python-2.7.15.tgz
tar xvf Python-2.7.15.tgz
cd Python-2.7.15

echo ac_cv_file__dev_ptmx=no > config.site
echo ac_cv_file__dev_ptc=no >> config.site
export CONFIG_SITE="config.site"

./configure \
	--host=arm-linux --build=x86_64-pc-linux-gnu \
	--disable-toolbox-glue --disable-framework \
	--without-pymalloc --disable-ipv6

patch Modules/Setup.dist -i ${TOP}/Setup.patch -o Modules/Setup

make $MAKE_J || exit 2

export DESTDIR="${PWD}/steamlink-build"

make install

cd ${DESTDIR}/usr/local

python -m compileall -f .
find . -type f -name "*.py" -delete
find . -type f -name "*.pyo" -delete
#rm -rf /include
#rm -rf /share

find ${DESTDIR} -type f | while read file; do
	if file ${file} | grep ELF > /dev/null; then
		echo "Stripping $(basename ${file})"
		armv7a-cros-linux-gnueabi-strip ${file} || exit 6
	fi
done

cd ${DESTDIR}/usr/local

tar -cjf ${TOP}/steamlink-python.tar.gz *

cd "${TOP}"
