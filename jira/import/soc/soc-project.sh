#!/tools/bin/bash
time perl ../create_project.pl --source iprocsw=source/IPROCSW.json --source pos=source/POS.json --project SOC --key SOC --nfeed output/soc-nfeed.sql $* >output/soc-project.json
