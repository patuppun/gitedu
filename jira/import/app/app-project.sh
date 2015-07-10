#!/tools/bin/bash
rm output/*.json
rm output/*.sql
time perl ../create_project.pl --source rtpjira=source/14174.json --project Applications --key APP --nfeed output/app-nfeed.sql $* >output/app-project.json
#time perl ../create_project.pl --source rtpjira=source/14174.json --project Applications --key APP --nfeed output/app-nfeed.sql --pretty >output/app-project-pretty.json
