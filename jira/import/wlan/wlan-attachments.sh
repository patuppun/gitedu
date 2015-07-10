#!/tools/bin/bash
time perl ../import_attachments.pl --source jira=source/14158.json --source rtpjira=source/14155.json --filter "Project = WLAN" $* >output/wlan-attachments.csv
