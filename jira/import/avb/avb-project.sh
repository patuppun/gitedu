#!/tools/bin/bash
rm output/*.json
rm output/*.sql
time perl ../create_project.pl --source rtpjira=source/14152.json --source engjira=source/21985.json --project AVB --key AVB --nfeed output/avb-nfeed.sql $* >output/avb-project.json
#time perl ../create_project.pl --source rtpjira=source/14152.json --source engjira=source/21985.json --project AVB --key AVB --nfeed output/avb-nfeed.sql --pretty >output/avb-project-pretty.json
