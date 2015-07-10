#!/tools/bin/bash
rm source/*.json

#caladan2
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query "key = SDK-59486 or key = SDK-58638 or key = SDK-58394 or key = SDK-63403 or key = SDK-63404 or key = SDK-64112 or key = SDK-58832 or key = SDK-54187" --set Product=Caladan2 > source/caladan2.json

#caladan3
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query "key = SDK-52356 or key = SDK-33408 or key = SDK-65306 or key = SDK-64211 or key = SDK-65535 or key = SDK-65068 or key = SDK-56459 or key = SDK-56457 or key = SDK-53570 or key = SDK-53590 or key = SDK-50035 or key = SDK-45506 or key = SDK-51377 or key = SDK-57557 or key = SDK-65369 or key = SDK-64399 or key = SDK-63329 or key = SDK-61775 or key = SDK-61772 or key = SDK-61997 or key = SDK-65961 or key = SDK-65636 or key = SDK-64452 or key = SDK-58947 or key = SDK-59168 or key = SDK-40707 or key = SDK-56810 or key = SDK-56899 or key = SDK-55485 or key = SDK-55153 or key = SDK-53068 or key = SDK-52888 or key = SDK-52887 or key = SDK-52884 or key = SDK-51690 or key = SDK-58053 or key = SDK-57422 or key = SDK-57419 or key = SDK-57418 or key = SDK-57391 or key = SDK-57390 or key = SDK-63402 or key = SDK-47736 or key = SDK-48711 or key = SDK-47935 or key = SDK-47371 or key = SDK-55690 or key = SDK-49406 or key = SDK-48853 or key = SDK-41692 or key = SDK-59546 or key = SDK-47731 or key = SDK-55805 or key = SDK-54273 or key = SDK-54404 or key = SDK-53988 or key = SDK-53865 or key = SDK-48968 or key = SDK-46575 or key = SDK-48311 or key = SDK-45512 or key = SDK-52958 or key = SDK-52359 or key = SDK-58532 or key = SDK-66578" --set Product=Caladan3 > source/caladan3.json

#fabric
perl ../export_jira.pl --server engjira.sj.broadcom.com:8080 --query "key = SDK-64553 or key = SDK-60941 or key = SDK-60837 or key = SDK-60266 or key = SDK-59869 or key = SDK-54674 or key = SDK-54673 or key = SDK-54647 or key = SDK-54415 or key = SDK-65460 or key = SDK-65617 or key = SDK-65615" --set Product=Fabric > source/fabric.json


