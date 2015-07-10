#!/tools/bin/bash
echo app; cd app; app-project.sh $* 2>&1 |tee output/errors.txt; cd ..
echo avb; cd avb; avb-project.sh $* 2>&1 |tee output/errors.txt; cd ..
echo cs; cd cs; cs-project.sh $* 2>&1 |tee output/errors.txt; cd ..
echo ctrl; cd ctrl; ctrl-project.sh $* 2>&1 |tee output/errors.txt; cd ..
echo linux; cd linux; linux-project.sh $* 2>&1 |tee output/errors.txt; cd ..
#echo sbx; cd sbx; sbx-project.sh $* 2>&1 |tee output/errors.txt; cd ..
echo soc; cd soc; soc-project.sh $* 2>&1 |tee output/errors.txt; cd ..
echo wlan; cd wlan; wlan-project.sh $* 2>&1 |tee output/errors.txt; cd ..

combine_projects.sh
