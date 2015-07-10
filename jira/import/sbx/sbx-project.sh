#!/tools/bin/bash
time perl ../create_project.pl --source engjira:sbx_caladan2=source/18300.json --source engjira:sbx_caladan3=source/18234.json --project SBX --key SBX --nfeed output/sbx-nfeed.sql $* >output/sbx-project.json
