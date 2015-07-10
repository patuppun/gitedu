#!/tools/bin/bash
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  # 64-bit stuff here
  /tools/coverity/prevent/7.0/Linux-64/bin/cov-configure --compiler $1 --config ./config/7.0/coverity.xml
else
  # 32-bit stuff here
  /tools/coverity/prevent/7.0/Linux/bin/cov-configure --compiler $1 --config ./config/7.0/coverity.xml
fi
