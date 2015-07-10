cqperl ../export_cq.pl --db Cont --repo Controller --type Defect --query "Public Queries/CCX-SW JIRA Import/CCX-SW JIRA Import-All NX1" >source/ctrl_all_nx1.json
cqperl ../export_cq.pl --db Cont --repo Controller --type users --query "Personal Queries/Users" >source/users.json
