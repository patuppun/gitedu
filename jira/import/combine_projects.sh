#!/tools/bin/bash
echo Merging nFEED files...
cat truncate_tables.sql > projects.sql 
cat ./app/output/*.sql >> projects.sql 
cat ./avb/output/*.sql >> projects.sql 
cat ./cs/output/*.sql >> projects.sql 
cat ./ctrl/output/*.sql >> projects.sql
cat ./linux/output/*.sql >> projects.sql 
cat ./sbx/output/*.sql >> projects.sql
cat ./soc/output/*.sql >> projects.sql 
cat ./wlan/output/*.sql >> projects.sql 
cat initial_values.sql >> projects.sql

echo Merging Project files...
perl combine_json.pl ./app/output/app-project.json ./avb/output/avb-project.json ./cs/output/cs-project.json ./ctrl/output/ctrl-project.json ./linux/output/linux-project.json ./sbx/output/sbx-project.json ./soc/output/soc-project.json ./wlan/output/wlan-project.json > projects.json

#./sbx/output/sbx-project.json
#./ctrl/output/ctrl-project.json
