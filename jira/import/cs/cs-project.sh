#!/tools/bin/bash
rm output/*.json
rm output/*.sql
time perl ../create_project.pl --source engjira=source/ESPSW.json --project "Client Security"  --key CS --nfeed output/cs-nfeed.sql $* >output/cs-project.json
