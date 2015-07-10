#!/tools/bin/bash
echo app
cd app; app-attachments.sh $*; cd ..
echo avb
cd avb; avb-attachments.sh $*; cd ..
echo cs
cd cs; cs-attachments.sh $*; cd ..
echo ctrl
cd ctrl; ctrl-attachments.sh $*; cd ..
echo sbx
cd sbx; sbx-attachments.sh $*; cd ..
echo soc
cd soc; soc-attachments.sh $*; cd ..
echo wlan
cd wlan; wlan-attachments.sh $*; cd ..
perl combine_csv.pl app/output/app-attachments.csv avb/avb-attachments.csv cs/output/cs-attachments.csv ct/output/ctrl-attachments.csv sb/output/sbx-attachments.csv so/output/soc-attachments.csv wlan/output/wlan-attachments.csv >attachments.csv
