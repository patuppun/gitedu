#!/tools/bin/bash
rm output/*.json
rm output/*.sql
time perl ../create_project.pl --source tools=source/issues.json --project "Linux CoE Development" --key LINUXDEV --nfeed output/linux-nfeed.sql $* >output/linux-project.json
