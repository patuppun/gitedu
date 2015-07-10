#!/tools/bin/bash
time perl ../create_project.pl --source ctrl=source/ctrl_all_nx1.json --users source/users.json --project Controller --key CTRL --nfeed output/ctrl-nfeed.sql >output/ctrl-project.json
