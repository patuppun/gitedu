#!/tools/bin/bash
time perl ../create_project.pl --source engjira:sbx_caladan2=source/caladan2.json --source engjira:sbx_caladan3=source/caladan3.json --source engjira:sbx_caladan3=source/fabric.json --project SBX --key SBX --nfeed output/sbx2-nfeed.sql $* >output/sbx2-project.json
