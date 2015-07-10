!!!!!!!!!!  GLOBAL:    "Broadcom Corporaton"  ==>  "Broadcom"


INSERT IGNORE INTO Chip (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom Corporation", "89500_A0");

WRONG!!!!!!!!!!!!!!!!!!!!!!!!!INSERT IGNORE INTO Customer (Project, Product, Value) VALUES ("AVB", "AVB", "Broadcom Corporation");
INSERT IGNORE INTO Customer (Project, Product, Value) VALUES ("AVB", "AVB", "Broadcom");

WRONG!!!!!!!!!!!!!!!!INSERT IGNORE INTO Document (Project, Value) VALUES ("AVB", "Broadcom-BCM89501R-Polar");

INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "Broadcom-BCM89501R-Polar");

INSERT IGNORE INTO OS (Project, Value) VALUES ("AVB", "NA");

INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("AVB", "AVB", "AVB");

INSERT IGNORE INTO Product (Project, Value) VALUES ("AVB", "AVB");



WRONG!!!!!!!!!!!!!!!!INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom Corporation", "1.0.0");
WRONG!!!!!!!!!!!!!!!!INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom Corporation", "1.1.0");
WRONG!!!!!!!!!!!!!!!!INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom Corporation", "3.0.0");
WRONG!!!!!!!!!!!!!!!!INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom Corporation", "4.0.0");
WRONG!!!!!!!!!!!!!!!!INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom Corporation", "4.0.1");
WRONG!!!!!!!!!!!!!!!!  INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom Corporation", "4.1.0");

INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom Corporation", "NOT_IMPORTED");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.0.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.1.0");

!!!!!!!!!!!!!!!  START OF CORRECTED VALUES !!!!!!!!!!!!!!!!!!!!!!!!!!

INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.1.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.2.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.3.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.4.0");


!!!!!!!!!!!!!!!  END OF CORRECTED VALUES !!!!!!!!!!!!!!!!!!!!!!!!!!


INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Application");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Firmware");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Management Interface");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "NOT_IMPORTED");


!!!!!!!!!!!!!!!  START OF CORRECTED VALUES !!!!!!!!!!!!!!!!!!!!!!!!!!
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Diagnostics Shell");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Documentation");


INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("AVB", "AVB", "AVB");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("AVB", "AVB", "AVB Offline Config");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("AVB", "AVB", "Simple Linux Shell");


!!!!!!!!!!!!!!!  END OF CORRECTED VALUES !!!!!!!!!!!!!!!!!!!!!!!!!!

INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("AVB", "AVB_1_1_BRANCH");
INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("AVB", "feat_avb_polar_demo");


!!!!!!!!!!!!!!!  START OF CORRECTED VALUES !!!!!!!!!!!!!!!!!!!!!!!!!!

INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("AVB", "AVB_1_2_BRANCH");
INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("AVB", "AVB_1_3_BRANCH");



INSERT IGNORE INTO OS (Project, Value) VALUES ("AVB", "NA");
!!!!!!!!!!!!!!!  END OF CORRECTED VALUES !!!!!!!!!!!!!!!!!!!!!!!!!!
