/*
 CSCI 3410 -- Project #1
 Name: -- Sean Hart
 Date: -- 2/4/2021
 */
/*
 DO NOT EDIT BELOW
 */
DROP SCHEMA IF EXISTS HW_Vaccine;

CREATE SCHEMA HW_Vaccine;

USE HW_Vaccine;

CREATE TABLE COMPANY (
  Name VARCHAR(50) PRIMARY KEY,
  Website VARCHAR(255) CHECK (Website LIKE "https://%")
);

CREATE TABLE DISEASE (
  Name VARCHAR(50) PRIMARY KEY,
  Communicable BOOL,
  -- Whether the disease can be transmitted from a human to
  --  another.
  TYPE ENUM ("infectious", "deficiency", "hereditary")
);

CREATE TABLE VACCINE (
  Name VARCHAR(50) PRIMARY KEY,
  Manufacturer VARCHAR(50) NOT NULL,
  FOREIGN KEY (Manufacturer) REFERENCES COMPANY (NAME) ON
    UPDATE CASCADE
);

CREATE TABLE EFFICACY (
  DiseaseName VARCHAR(50),
  VaccineName VARCHAR(50),
  Efficacy DECIMAl(5, 2),
  PRIMARY KEY (DiseaseName, VaccineName),
  FOREIGN KEY (DiseaseName) REFERENCES DISEASE (NAME),
  FOREIGN KEY (VaccineName) REFERENCES VACCINE (NAME)
);

INSERT INTO COMPANY
VALUES (
  "Moderna",
  "https://www.modernatx.com/");

INSERT INTO DISEASE
VALUES (
  "Coronavirus disease 2019",
  TRUE,
  "infectious");

INSERT INTO VACCINE
VALUES (
  "mRNA-1273",
  "Moderna");

INSERT INTO EFFICACY
VALUES (
  "Coronavirus disease 2019",
  "mRNA-1273",
  94.1);


/*
 START EDITING
 */
/*

I. Short Questions (3 pts.)

Answer the following short questions. In our implementation…

1. … can two companies have exactly the same name?
    A: No, because COMPANY Name attribute is a primary key which must be unique
2. … can two companies have the same website?
    A: Yes, they can, as the only constraint for Website is for formatting
3. … can a company not have a website?
    A: Yes, as the Website attribute is not referenced anywhere else in the database, and has no null constraint
4. … can the same vaccine be manufactured by multiple companies?
    A: No, as the primary key for VACCINE is the name it cannot be listed twice with different companies
5. … can a vaccine not have a manufacturer?
    A: No, the vaccine must have a manufacturer as this attribute has the not null constraint
6. … can a disease being neither communicable nor not communicable?
    A: Yes, as it has no not null constraints, it can be set to the DEFAULT value of null
7. … can the same vaccine have different efficacies for different diseases?
    A: Yes it can! the primary key for efficacy is (Name, Disease) so one vaccine can have different diesease efficacies
 */
/*

II. Longer Questions (6 pts.)

Answer the following questions:

1. What does `CHECK (Website LIKE "https://*")` do?
    A: It creates a formatting constraint where a website for a company has to have the "https://" at the beginning of the string value
2. Why did we picked the `DECIMAl(5,2)` datatype?
    A: Because, the efficacy is a percentage of how effective a vaccine is in combating a disease, and the DECIMAL type leads to a more precise value
3. What is the benefit / are the benefits of having a separate EFFICACY table over having something like

CREATE TABLE VACCINE(
 Name VARCHAR(50) PRIMARY KEY,
 Manufacturer VARCHAR(50),
 Disease VARCHAR(50),
 Efficacy DECIMAl(5,2),
 FOREIGN KEY (Manufacturer) REFERENCES COMPANY (Name)
);

?
    A: One main benefit is the ability to measure a singular vaccines efficacy among multiple diseases, as this is not capable in this model because Name is a primarykey.

 */
/*

III. Relational Model (6 pts.)

Draw the relational model corresponding to this code.
You can hand-draw it and join a scan or a picture, or simply hand me back a sheet.
 */
/*

IV. Simple Commands (5 pts.)

Below, you are asked to write commands that perform various actions.
Please, leave them uncommented, unless
 - you can not write them correctly, but want to share your attempt,
 - it is specified that it should return an error.

The first question is answered as an example.
 */
-- 0. Write a command that list the names of
--     all the diseases.
SELECT Name
FROM DISEASE;

-- 1. Write a command that insert "Pfizer" in the
--     COMPANY table (you can make up the website or look it)

INSERT INTO COMPANY
VALUES(
    "Pfizer",
    "https://pfizer.com");

-- 2. Write a command that insert the "Pfizer-BioNTech
--    COVID-19 Vaccine" in the VACCINE table, and a command
--    that store the efficacy of that vaccine against
--    the "Coronavirus disease 2019" disease
--    (you can make up the values or look them up).

INSERT INTO VACCINE
VALUES(
    "Pfizer-BioNTech COVID-19 Vaccine",
    "Pfizer");
UPDATE EFFICACY
SET Efficacy = '91.5'
    WHERE VaccineName = 'Pfizer-BioNTech COVID-19 Vaccine'
    AND DiseaseName = 'Coronavirus disease 2019';
--  3. Write a command that updates the name of the
--     company "Moderna" to "Moderna, Inc." everywhere.
UPDATE
    COMPANY
SET Name = 'Moderna, Inc.'
    WHERE Name = 'Moderna';

--  4. Write a command that lists the name of all the
--     companies.
SELECT Name FROM COMPANY;

--  5. Write a command that deletes the "Coronavirus disease
--     2019" entry from the DISEASE table (if only!).
--DELETE FROM DISEASE
   -- WHERE Name = 'Coronavirus disease 2019';

--  This command should return an error. Explain it and leave
--   the command commented.
--  A: It returns an error because "Coronavirus disease 2019" is referrenced in the efficacy table and DiseaseName is part of the primary key for efficacy so it cannot be null

--   6. Write two commands: one that adds "physiological" to
--      the possible types of diseases, and one that inserts
--      a physiological disease in the DISEASE table.
ALTER TABLE DISEASE
MODIFY TYPE ENUM(
    "infectious",
    "deficiency",
    "hereditary",
    "physiological");
INSERT INTO DISEASE
VALUES (
    "Polio",
    TRUE,
    "physiological"
);

--  7 (difficult). Write a command that return the list of
--                 all the companies that manufacture a
--                 vaccine against "Coronavirus disease 2019".
SELECT VACCINE.Manufacturer
FROM VACCINE,
    EFFICACY
WHERE DiseaseName = "Coronavirus disease 2019";
