-- Database Setup
DROP DATABASE IF EXISTS united_helpers;
CREATE DATABASE united_helpers;
USE united_helpers;

-- Create Tables
CREATE TABLE task_type (
  taskTypeId INT AUTO_INCREMENT PRIMARY KEY,
  taskTypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE task_status (
  taskStatusId INT AUTO_INCREMENT PRIMARY KEY,
  taskStatusName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE package_type (
  packageTypeId INT AUTO_INCREMENT PRIMARY KEY,
  packageTypeName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE packing_list (
  packingListId INT AUTO_INCREMENT PRIMARY KEY,
  packingListName VARCHAR(100) NOT NULL,
  packingListDescription TEXT
);

CREATE TABLE volunteer (
  volunteerId INT AUTO_INCREMENT PRIMARY KEY,
  volunteerName VARCHAR(50) NOT NULL,
  volunteerAddress VARCHAR(100),
  volunteerTelephone VARCHAR(30)
);

CREATE TABLE task (
  taskId INT AUTO_INCREMENT PRIMARY KEY,
  taskCode VARCHAR(20) NOT NULL UNIQUE,
  taskDescription TEXT,
  taskTypeId INT,
  taskStatusId INT,
  packingListId INT,
  FOREIGN KEY (taskTypeId) REFERENCES task_type(taskTypeId)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (taskStatusId) REFERENCES task_status(taskStatusId)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (packingListId) REFERENCES packing_list(packingListId)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE package (
  packageId INT AUTO_INCREMENT PRIMARY KEY,
  packageCreateDate DATE NOT NULL,
  packageWeight DECIMAL(6,2) NOT NULL,
  taskId INT,
  packageTypeId INT,
  FOREIGN KEY (taskId) REFERENCES task(taskId)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (packageTypeId) REFERENCES package_type(packageTypeId)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE item (
  itemId INT AUTO_INCREMENT PRIMARY KEY,
  itemDescription VARCHAR(200) NOT NULL,
  itemValue DECIMAL(8,2) NOT NULL,
  quantityOnHand INT NOT NULL
);

CREATE TABLE package_contents (
  packageContentsId INT AUTO_INCREMENT PRIMARY KEY,
  packageId INT,
  itemId INT,
  itemQuantity INT NOT NULL,
  FOREIGN KEY (packageId) REFERENCES package(packageId)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (itemId) REFERENCES item(itemId)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE assignment (
  assignmentId INT AUTO_INCREMENT PRIMARY KEY,
  volunteerId INT,
  taskId INT,
  startDateTime DATETIME,
  endDateTime DATETIME,
  FOREIGN KEY (volunteerId) REFERENCES volunteer(volunteerId)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (taskId) REFERENCES task(taskId)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insert Data
INSERT INTO task_type (taskTypeName) VALUES
('packing'),
('recurring'),
('logistics'),
('administrative'),
('medical');

INSERT INTO task_status (taskStatusName) VALUES
('open'),
('ongoing'),
('completed'),
('cancelled');

INSERT INTO package_type (packageTypeName) VALUES
('basic_medical'),
('child_care'),
('food'),
('hygiene'),
('blanket');

INSERT INTO packing_list (packingListName, packingListDescription) VALUES
('basic_medical_kit', 'Wipes, bandages, gloves, ointment.'),
('child_care_kit', 'Diapers, toys, baby wipes, feeding spoon.'),
('food_basic_kit', 'Canned meals, protein bars, juice box, meat.'),
('hygiene_kit', 'Soap, toothbrush, toothpaste, towel.');

-- Volunteers
INSERT INTO volunteer (volunteerName, volunteerAddress, volunteerTelephone) VALUES
('Maria', '12 Maple St, Albany NY', '111-333-0101'),
('James', '99 Pine Ave, Schenectady NY', '222-555-0102'),
('Aisha', '45 Oak Rd, Troy NY', '333-444-0103'),
('Lia', '77 Elm St, Albany NY', '111-555-0104'),
('Lucy', '201 River Rd, Cohoes NY', '666-555-0105'),
('Olivia', '5 Birch Ln, Albany NY', '777-555-0106'),
('Noah', '8 Cedar Dr, Schenectady NY', '888-111-0107'),
('Emma', '30 Spruce St, Troy NY', '555-111-0108'),
('Daniel', '14 Willow Ave, Albany NY', '999-222-0109'),
('Sophia', '220 Market St, Cohoes NY', '333-111-0110');

-- Tasks
-- Assume taskTypeId: packing=1, recurring=2, logistics=3, administrative=4, medical=5
-- Assume taskStatusId: open=1, ongoing=2, completed=3, cancelled=4
-- Assume packingListId matches earlier inserts (1–4)
INSERT INTO task (taskCode, taskDescription, taskTypeId, taskStatusId, packingListId) VALUES
('T101', 'Answer incoming calls and log disaster reports', 2, 1, NULL),
('T102', 'Prepare 5,000 food packages for shelters', 1, 1, 3),
('T103', 'Transport donated supplies to regional warehouse', 3, 2, NULL),
('T104', 'Assemble 2,000 basic medical kits for clinics', 1, 2, 1),
('T105', 'Set up intake station at community center', 3, 2, NULL),
('T106', 'Data entry and update of item inventory', 4, 1, NULL),
('T107', 'Coordinate mobile medical support team', 5, 2, NULL),
('T108', 'Assemble 500 child-care packages', 1, 1, 2),
('T109', 'Distribute hygiene kits at shelters', 3, 2, NULL),
('T110', 'Inventory audit of main warehouse', 4, 1, NULL);

-- Packages (only for packing tasks)
-- Packing tasks: T102 (food), T104 (medical), T108 (child-care)

INSERT INTO package (packageCreateDate, packageWeight, taskId, packageTypeId) VALUES
('2025-09-11', 2.50, 2, 3),
('2025-09-11', 2.70, 2, 3),
('2025-09-12', 2.60, 2, 3),
('2025-09-13', 2.55, 2, 3),
('2025-09-13', 2.65, 2, 3),
('2025-09-14', 0.85, 4, 1),
('2025-09-14', 0.88, 4, 1),
('2025-09-14', 0.90, 4, 1),
('2025-09-21', 1.20, 8, 2),
('2025-09-22', 1.25, 8, 2),
('2025-09-23', 3.50, 4, 4),
('2025-09-24', 3.60, 4, 4);

-- Items
INSERT INTO item (itemDescription, itemValue, quantityOnHand) VALUES
('Antiseptic wipe packet', 0.25, 1200),
('Adhesive bandage', 0.10, 5000),
('Disposable gloves', 0.50, 800),
('Antibiotic ointment (tube)', 1.50, 300),
('Diaper', 0.40, 1500),
('Small plush toy', 2.50, 600),
('Canned meal', 1.75, 4000),
('Protein bar', 1.20, 3500),
('Juice box', 0.90, 2000),
('Soap bar', 0.60, 1800),
('Toothbrush', 0.80, 2200),
('Toothpaste', 1.10, 1500),
('Small towel', 3.00, 400),
('Blanket', 8.50, 250),
('Surgical mask', 0.20, 3000);


-- Package Contents
-- Food packages
INSERT INTO package_contents (packageId, itemId, itemQuantity) VALUES
(1, 7, 3), (1, 8, 2), (1, 9, 1),
(2, 7, 3), (2, 8, 2), (2, 9, 1),
(3, 7, 3), (3, 8, 2), (3, 9, 1),
(4, 7, 3), (4, 8, 2), (4, 9, 1),
(5, 7, 3), (5, 8, 2), (5, 9, 1);

-- Medical packages
INSERT INTO package_contents (packageId, itemId, itemQuantity) VALUES
(6, 1, 2), (6, 2, 5), (6, 3, 1), (6, 4, 1),
(7, 1, 2), (7, 2, 5), (7, 3, 1),
(8, 1, 3), (8, 2, 6), (8, 3, 1), (8, 4, 1);

-- Child-care packages
INSERT INTO package_contents (packageId, itemId, itemQuantity) VALUES
(9, 5, 2), (9, 6, 1), (9, 9, 1),
(10, 5, 2), (10, 6, 1), (10, 11, 1);

-- Hygiene / blanket packages
INSERT INTO package_contents (packageId, itemId, itemQuantity) VALUES
(11, 10, 1), (11, 11, 1), (11, 12, 1), (11, 13, 1),
(12, 10, 1), (12, 11, 1), (12, 12, 1), (12, 14, 1);

-- Volunteer Assignments
INSERT INTO assignment (volunteerId, taskId, startDateTime, endDateTime) VALUES
(1, 1, '2025-09-01 08:00:00', '2025-12-31 16:00:00'),
(1, 2, '2025-09-10 08:00:00', '2025-09-30 12:00:00'),
(1, 6, '2025-09-06 09:00:00', '2025-09-30 13:00:00'),
(2, 2, '2025-09-11 09:00:00', '2025-09-25 14:00:00'),
(2, 4, '2025-09-12 10:00:00', '2025-09-20 13:00:00'),
(3, 3, '2025-09-15 07:00:00', '2025-09-15 19:00:00'),
(4, 5, '2025-09-13 06:30:00', '2025-09-18 18:00:00'),
(5, 8, '2025-09-21 08:00:00', '2025-09-28 12:00:00'),
(6, 9, '2025-09-25 09:00:00', '2025-10-05 17:00:00'),
(7, 10, '2025-09-08 08:30:00', '2025-09-12 12:00:00'),
(8, 4, '2025-09-23 10:00:00', '2025-09-30 15:00:00'),
(9, 2, '2025-09-12 08:00:00', '2025-09-22 12:00:00'),
(10, 4, '2025-09-13 11:00:00', '2025-09-20 14:00:00'),
(5, 2, '2025-09-22 09:00:00', '2025-10-01 13:00:00');

