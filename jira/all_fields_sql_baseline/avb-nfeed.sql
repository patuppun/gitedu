INSERT IGNORE INTO Product (Project, Value) VALUES ("AVB", "AVB");


INSERT IGNORE INTO Customer (Project, Product, Value) VALUES ("AVB", "AVB", "Broadcom");

INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "NOT_IMPORTED");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.0.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.1.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.2.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.3.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "AVB-1.4.0");


INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "ALL");
INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "NA");
INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "Broadcom-BCM89501R-Polar");

INSERT IGNORE INTO Chip (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "89500_A0");
INSERT IGNORE INTO Chip (Project, Product, Customer, Value) VALUES ("AVB", "AVB", "Broadcom", "89500_B0");



INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Application");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Firmware");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Management Interface");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "NOT_IMPORTED");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Diagnostics Shell");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("AVB", "AVB", "Documentation");



INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("AVB", "AVB", "AVB");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("AVB", "AVB", "AVB Offline Config");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("AVB", "AVB", "Simple Linux Shell");


INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("AVB", "feat_avb_polar_demo");
INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("AVB", "AVB_1_1_BRANCH");
INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("AVB", "AVB_1_2_BRANCH");
INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("AVB", "AVB_1_3_BRANCH");


INSERT IGNORE INTO OS (Project, Value) VALUES ("AVB", "NA");
