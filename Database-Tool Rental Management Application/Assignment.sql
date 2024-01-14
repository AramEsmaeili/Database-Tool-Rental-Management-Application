


-- CREATE TABLES

CREATE TABLE EMPLOYEE (
EmployeeID int NOT NULL,
EmployeeFullName varchar(45) NOT NULL,
EmailAddress varchar(45) NOT NULL,
Address varchar(45) NOT NULL,
HiringDate varchar(45) NOT NULL,
PhoneNumber varchar(45) NOT NULL,
OrderID int NOT NULL,
PRIMARY KEY (EmployeeID)
);

INSERT INTO EMPLOYEE VALUES (1000,'Aram Esmaeili','Aram@gmail.com','1 woodrof avenue, Ottawa, ON','1/1/2020','123-456-8520',111);
INSERT INTO EMPLOYEE VALUES (2000, 'Mahdy Dellawari', 'Mahdy@gmail.com', '2 woodrof avenue, Ottawa, ON','2/1/2020', '321-258-4569', 112);
INSERT INTO EMPLOYEE VALUES (3000, 'Mahsa Danesh', 'Mahsa@gmail.com', '3 woodrof avenue, Ottawa, ON','3/1/2020', '321-548-7516', 113);
INSERT INTO EMPLOYEE VALUES (4000, 'Rustom', 'Rustom@gmail.com', '4 woodrof avenue, Ottawa, ON', '4/1/2020','957-586-7841', 114);
INSERT INTO EMPLOYEE VALUES (5000, 'Vishali M', 'Vishali@gmail.com', '5 woodrof avenue, Ottawa, ON','5/1/2020', '658-321-6598', 115);


drop table CUSTOMER;

CREATE TABLE CUSTOMER (
  CustomerID int NOT NULL,
  CustomerName varchar(45) NOT NULL,
  Address varchar(45) NOT NULL,
  PhoneNumber varchar(45) NOT NULL,
  EmailAddress varchar(45) NOT NULL,
  OrderID int NOT NULL,
  PRIMARY KEY (CustomerID)
);

INSERT INTO CUSTOMER VALUES (1100,'Roly Roy','1 Baseline Rd, Ottawa, ON','256-526-5656','R@gmail.com', 111);
INSERT INTO CUSTOMER VALUES (2200,'Daniel K','2 Baseline Rd, Ottawa, ON','258-654-9514','D@gmail.com', 112);
INSERT INTO CUSTOMER VALUES (3300,'Hala Own','3 Baseline Rd, Ottawa, ON','123-654-7890','H@gmail.com', 113);
INSERT INTO CUSTOMER VALUES (4400,'Mathew O','4 Baseline Rd, Ottawa, ON','014-741-0147','M@gmail.com', 114);
INSERT INTO CUSTOMER VALUES (5500,'Amal Ibrahim','5 Baseline Rd, Ottawa, ON','963-357-9510','A@gmail.com', 115);


CREATE TABLE TOOL_ORDER (
  OrderID int NOT NULL,
  OrderDate varchar(45) NOT NULL,
  ReturnDate varchar(45) NOT NULL,
  TotalAmount varchar(45) NOT NULL,
  AmountOwing varchar(45) NOT NULL,
  DepositMethod varchar (45) NOT NULL,
  CustomerID int NOT NULL,
  PRIMARY KEY (OrderID)
);

INSERT INTO TOOL_ORDER VALUES (111,'1/2/2021','2/2/2021','100.00','0.00','Credit Card',1100);
INSERT INTO TOOL_ORDER VALUES (112,'1/3/2021','2/3/2021','150.00','50.00','Credit Card',2200);
INSERT INTO TOOL_ORDER VALUES (113,'1/4/2021','2/4/2021','156.00','10.00','Credit Card',3300);
INSERT INTO TOOL_ORDER VALUES (114,'1/5/2021','3/5/2021','158.00','0.00','Credit Card',4400);
INSERT INTO TOOL_ORDER VALUES (115,'1/5/2021','5/5/2021','1000.00','52.00','Credit Card',5500);


Alter table CUSTOMER
drop column ORDERID;





-- Create History Table for Employee

CREATE TABLE EMPLOYEE_HISTORY (
    EmployeeID int,
    EmployeeFullName varchar(45),
    EmailAddress varchar(45),
    Address varchar(45),
    HiringDate varchar(45),
    PhoneNumber varchar(45),
    OrderID int,
    ChangeType varchar(10), -- INSERT, UPDATE, DELETE
    ChangeDate timestamp,
    PRIMARY KEY (EmployeeID, ChangeDate)
);

--create Trigger for Employee

--EMPLOYEE INSERT TRIGGER

CREATE OR REPLACE TRIGGER EMPLOYEE_INSERT_TRIGGER
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    INSERT INTO EMPLOYEE_HISTORY VALUES (
        :NEW.EmployeeID,
        :NEW.EmployeeFullName,
        :NEW.EmailAddress,
        :NEW.Address,
        :NEW.HiringDate,
        :NEW.PhoneNumber,
        :NEW.OrderID,
        'INSERT',
        SYSTIMESTAMP
    );
END;

--EMPLOYEE UPDATE TRIGGER

CREATE OR REPLACE TRIGGER EMPLOYEE_UPDATE_TRIGGER
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF :OLD.EmployeeFullName != :NEW.EmployeeFullName OR
       :OLD.EmailAddress != :NEW.EmailAddress OR
       :OLD.Address != :NEW.Address OR
       :OLD.HiringDate != :NEW.HiringDate OR
       :OLD.PhoneNumber != :NEW.PhoneNumber OR
       :OLD.OrderID != :NEW.OrderID THEN
       
        INSERT INTO EMPLOYEE_HISTORY VALUES (
            :OLD.EmployeeID,
            :OLD.EmployeeFullName,
            :OLD.EmailAddress,
            :OLD.Address,
            :OLD.HiringDate,
            :OLD.PhoneNumber,
            :OLD.OrderID,
            'UPDATE',
            SYSTIMESTAMP
        );
    END IF;
END;

--EMPLOYEE DELETE TRIGGER

CREATE OR REPLACE TRIGGER EMPLOYEE_DELETE_TRIGGER
BEFORE DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    INSERT INTO EMPLOYEE_HISTORY VALUES (
        :OLD.EmployeeID,
        :OLD.EmployeeFullName,
        :OLD.EmailAddress,
        :OLD.Address,
        :OLD.HiringDate,
        :OLD.PhoneNumber,
        :OLD.OrderID,
        'DELETE',
        SYSTIMESTAMP
    );
END;


--create History table for Customer

CREATE TABLE CUSTOMER_HISTORY (
    CustomerID int,
    CustomerName varchar(45),
    Address varchar(45),
    PhoneNumber varchar(45),
    EmailAddress varchar(45),
    ChangeType varchar(10), -- INSERT, UPDATE, DELETE
    ChangeDate timestamp,
    PRIMARY KEY (CustomerID, ChangeDate)
);

-- create Triggers for CUSTOMER

--CUSTOMER INSERT TRIGGER
CREATE OR REPLACE TRIGGER CUSTOMER_INSERT_TRIGGER
AFTER INSERT ON CUSTOMER
FOR EACH ROW
BEGIN
    INSERT INTO CUSTOMER_HISTORY VALUES (
        :NEW.CustomerID,
        :NEW.CustomerName,
        :NEW.Address,
        :NEW.PhoneNumber,
        :NEW.EmailAddress,
        'INSERT',
        SYSTIMESTAMP
    );
END;

-- CUSTOMER UPDATE  TRIGGER

CREATE OR REPLACE TRIGGER CUSTOMER_UPDATE_TRIGGER
BEFORE UPDATE ON CUSTOMER
FOR EACH ROW
BEGIN
    IF :OLD.CustomerName != :NEW.CustomerName OR
       :OLD.Address != :NEW.Address OR
       :OLD.PhoneNumber != :NEW.PhoneNumber OR
       :OLD.EmailAddress != :NEW.EmailAddress THEN
       
        INSERT INTO CUSTOMER_HISTORY VALUES (
            :OLD.CustomerID,
            :OLD.CustomerName,
            :OLD.Address,
            :OLD.PhoneNumber,
            :OLD.EmailAddress,
            'UPDATE',
            SYSTIMESTAMP
        );
    END IF;
END;

 -- CUSTOMER DELETE TRIGGER
 
CREATE OR REPLACE TRIGGER CUSTOMER_DELETE_TRIGGER
BEFORE DELETE ON CUSTOMER
FOR EACH ROW
BEGIN
    INSERT INTO CUSTOMER_HISTORY VALUES (
        :OLD.CustomerID,
        :OLD.CustomerName,
        :OLD.Address,
        :OLD.PhoneNumber,
        :OLD.EmailAddress,
        'DELETE',
        SYSTIMESTAMP
    );
END;



--Part 3
--Altering the EMPLOYEE_HISTORY TO ADD Roles column for the purpose of multi_valued historical data field.
ALTER TABLE EMPLOYEE_HISTORY
ADD Roles VARCHAR2(255);

-- Update the roles for EmployeeID 1000
UPDATE EMPLOYEE
SET EMPLOYEEFULLNAME ='Aram E',
    EMAILADDRESS='aram@gmail.com',
    Address ='1 Woodroof',
    HIRINGDATE='1-02-2023',
    PHONENUMBER ='613-225-9854',
    ORDERID = 1
WHERE EmployeeID = 1000;


-- Add more role updates as needed

SELECT * FROM EMPLOYEE_HISTORY;

UPDATE EMPLOYEE
SET EMPLOYEEFULLNAME ='N E',
    EMAILADDRESS='N@gmail.com',
    Address ='1 carling',
    HIRINGDATE='10-02-2023',
    PHONENUMBER ='613-225-9874',
    ORDERID = 114
WHERE EmployeeID = 6000;

insert into  EMPLOYEE (EmployeeID, EMPLOYEEFULLNAME,EMAILADDRESS, Address,HIRINGDATE,PHONENUMBER,ORDERID)
values (6000, 'Nic', 'nic@gmail.com', '2 baseline', '05/08/2014', '613-254-9874',114);



Alter table EMPLOYEE_HISTORY
DROP COLUMN Roles;



SELECT * FROM CUSTOMER_HISTORY;
