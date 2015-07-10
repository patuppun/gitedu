#!/tools/bin/bash
echo APP
cd app; app-extract.sh; cd ..
echo AVB
cd avb; avb-extract.sh; cd ..
echo Client Security
cd cs; cs-extract.sh; cd ..
#echo ctrl
#cd ctrl; ctrl-extract.sh; cd ..
echo Linux COE Development
cd linux; linux-extract.sh; cd ..
echo SBX
cd sbx; sbx-extract.sh; cd ..
echo SOC
cd soc; soc-extract.sh; cd ..
echo WLAN
cd wlan; wlan-extract.sh; cd ..
