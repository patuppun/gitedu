INSERT IGNORE INTO Customer (Project, Product, Value) VALUES ("APP", "ePTN", "Broadcom");

WRONG!!!!!!!!!!!!!!!!!!!!!!!!!!  INSERT IGNORE INTO Document (Project, Value) VALUES ("APP", "BCM58525");
WRONG!!!!!!!!!!!!!!!!!!!!!!!!!!  INSERT IGNORE INTO Document (Project, Value) VALUES ("APP", "Broadcom-BCM958522ER-Vega+");
WRONG!!!!!!!!!!!!!!!!!!!!!!!!!!  INSERT IGNORE INTO Document (Project, Value) VALUES ("APP", "LVL7 FastPath");
WRONG!!!!!!!!!!!!!!!!!!!!!!!!!!  INSERT IGNORE INTO Document (Project, Value) VALUES ("APP", "Product Specification");
WRONG!!!!!!!!!!!!!!!!!!!!!!!!!!  INSERT IGNORE INTO Document (Project, Value) VALUES ("APP", "RoBo");


INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("APP", "ePTN", "Broadcom", "ALL");
INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("APP", "ePTN", "Broadcom", "BCM58525");
INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("APP", "ePTN", "Broadcom", "Broadcom-BCM958522ER-Vega+");
INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("APP", "ePTN", "Broadcom", "NA");
INSERT IGNORE INTO Hardware_Board_Revision (Project, Product, Customer, Value) VALUES ("APP", "ePTN", "Broadcom", "RoBo");

INSERT IGNORE INTO OS (Project, Value) VALUES ("APP", "Linux 2.6");
INSERT IGNORE INTO OS (Project, Value) VALUES ("APP", "Linux");
INSERT IGNORE INTO OS (Project, Value) VALUES ("APP", "eCOS");

INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("APP", "ePTN", "Base");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("APP", "ePTN", "CLI");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("APP", "ePTN", "Documentation");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("APP", "ePTN", "Metro");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("APP", "ePTN", "QoS");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("APP", "ePTN", "SNMP");
INSERT IGNORE INTO Package (Project, Product, Value) VALUES ("APP", "ePTN", "Switching");

INSERT IGNORE INTO Product (Project, Value) VALUES ("APP", "ePTN");

WRONG!!!!!!!!!!!!!!!!!!!!!!!!!!  INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("APP", "ePTN", "Broadcom", "EPTN-1.0");
INSERT IGNORE INTO Releases (Project, Product, Customer, Value) VALUES ("APP", "ePTN", "Broadcom", "EPTN-1.0.0");

INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "ACL");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "CLI");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "Configuration File System");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "DOT1AG");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "DOT3AH");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "Documentation");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "MMU");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "MPLS");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "QoS");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "SIM");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "Switching");
INSERT IGNORE INTO Software_Component (Project, Product, Value) VALUES ("APP", "ePTN", "System");

INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("APP", "NOT_IMPORTED");
INSERT IGNORE INTO Target_Branch (Project, Value) VALUES ("APP", "feat_eptn_mpls-tp");

