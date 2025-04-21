-- Initial FanshaweDroneShare Database which MUST be used for Project2
--/*
Use Master;
GO
Alter database FanshaweDroneShare set single_user with rollback immediate;  
GO
DROP Database FanshaweDroneShare;  
GO 
CREATE DATABASE FanshaweDroneShare;  
GO
USE FanshaweDroneShare;
GO
-- Station
CREATE TABLE dbo.Station (
    StationID   INT IDENTITY CONSTRAINT PK_Station PRIMARY KEY,
    StationName NVARCHAR(50) NOT NULL,  
    MaxCapacity    INT NOT NULL
    -- NOTE: Current count should not be included. Violates 3NF.

	CONSTRAINT CK_Station CHECK (MaxCapacity >=0)
);

-- Pilot
CREATE TABLE dbo.Pilot (
    PilotID          INT IDENTITY CONSTRAINT PK_Pilot PRIMARY KEY,   
    FirstName        NVARCHAR(50) NOT NULL,
    LastName         NVARCHAR(50) NOT NULL,
    TransportCanadaCertNumber    NVARCHAR(80) NOT NULL, 
    PilotSIN         CHAR(9) NOT NULL, 
    DateOfBirth      DATE NOT NULL

	CONSTRAINT CK_Pilot CHECK (DateOfBirth <= GETDATE())
);

-- EquipmentType
CREATE TABLE dbo.EquipmentType (
    EquipmentTypeID   INT IDENTITY CONSTRAINT PK_EquipmentType PRIMARY KEY,
    EquipmentTypeName NVARCHAR(50) NOT NULL 

);
-- Manufacturer
CREATE TABLE dbo.Manufacturer (
    ManufacturerID   INT IDENTITY CONSTRAINT PK_Manufacturer PRIMARY KEY,
    ManufacturerName NVARCHAR(80) NOT NULL 

);
-- Model
CREATE TABLE dbo.Model (
    ModelID   INT IDENTITY CONSTRAINT PK_Model PRIMARY KEY,
    ModelName NVARCHAR(80) NOT NULL,
    ManufacturerID   INT NULL CONSTRAINT FK_Manufacturer  REFERENCES dbo.Manufacturer  (ManufacturerID ), 

);
-- DroneEquipment
CREATE TABLE dbo.DroneEquipment (
    DroneEquipmentID INT IDENTITY CONSTRAINT PK_DroneEquipment PRIMARY KEY,
    HomeStationID    INT NOT NULL CONSTRAINT FK_DroneEquipment_Station_Home REFERENCES dbo.Station ( StationID ),
    CurrentStationID INT NOT NULL CONSTRAINT FK_DroneEquipment_Station_Current REFERENCES dbo.Station ( StationID ),
    PilotID          INT NULL CONSTRAINT FK_DroneEquipment_Pilot REFERENCES dbo.Pilot ( PilotID ),
    EquipmentTypeID  INT NULL CONSTRAINT FK_DroneEquipment_EquipmentTypeID  REFERENCES dbo.EquipmentType ( EquipmentTypeID  ),
    TransportCanadaIdentMarking    NVARCHAR(80) NULL,    -- Accessory equipment does not have to have this marking, so can be NULL...
    ModelID          INT NULL CONSTRAINT FK_DroneEquipment_Model  REFERENCES dbo.Model ( ModelID ),
    Weight           INT NOT NULL,
    SerialNumber     NVARCHAR(50) NOT NULL,
    ManufacturedDate DATETIME NULL

	CONSTRAINT CK_DroneEquipment CHECK (ManufacturedDate <= GETDATE()),
	CONSTRAINT CK_DroneEquipment_2 CHECK (weight >=0)

);


-- Account
CREATE TABLE dbo.Account (
    AccountID       INT IDENTITY CONSTRAINT PK_Accounts PRIMARY KEY,
    PrimaryPilotID  INT NOT NULL CONSTRAINT FK_Account_Pilot REFERENCES dbo.Pilot ( PilotID ),
    AccountNumber   CHAR(20) NOT NULL,
    CurrentBalance  MONEY NOT NULL CONSTRAINT DF_Account_CurrentBalance DEFAULT 0,
    AccountOpenDate DATE NOT NULL CONSTRAINT DF_Account_AccountOpenDate DEFAULT GETDATE()
	
	CONSTRAINT CK_Account CHECK (AccountOpenDate <= GETDATE())
);

-- PilotAccount
CREATE TABLE dbo.PilotAccount (
    PilotAccountID INT IDENTITY,
    PilotID        INT NOT NULL,
    AccountID      INT NOT NULL,
    PilotAccountStartDate DATE NOT NULL CONSTRAINT DF_PilotAccount_PilotAccountStartDate DEFAULT GETDATE()
	

    
    CONSTRAINT PK_PilotAccount PRIMARY KEY ( PilotAccountID ),    
    CONSTRAINT FK_PilotAccount_Pilot FOREIGN KEY ( PilotID ) REFERENCES dbo.Pilot ( PilotID ),
    CONSTRAINT FK_PilotAccount_Account FOREIGN KEY ( AccountID ) REFERENCES dbo.Account ( AccountID ),
	CONSTRAINT CK_PilotAccount CHECK (PilotAccountStartDate <= GETDATE())
);


-- Address
CREATE TABLE dbo.Address (
    AddressID INT IDENTITY CONSTRAINT PK_Address PRIMARY KEY,
    Street    NVARCHAR(50),
    City      NVARCHAR(50) CONSTRAINT DF_Address_City DEFAULT 'London',
    Province  NVARCHAR(50) CONSTRAINT DF_Address_Province DEFAULT 'Ontario',
    PostalCode    CHAR(6)
);

-- PilotAddress
CREATE TABLE dbo.PilotAddress (
    PilotAddressID INT IDENTITY,
    PilotID        INT NOT NULL,
    AddressID      INT NOT NULL,
    PilotAddressStartDate DATE NOT NULL CONSTRAINT DF_PilotAddress_PilotAddressStartDate DEFAULT GETDATE(),

    CONSTRAINT PK_PilotAddress PRIMARY KEY ( PilotAddressID ),
    CONSTRAINT FK_PilotAddress_Pilot FOREIGN KEY ( PilotID ) REFERENCES dbo.Pilot ( PilotID ),
    CONSTRAINT FK_PilotAddress_Address FOREIGN KEY ( AddressID ) REFERENCES dbo.Address ( AddressID )
);

GO

CREATE UNIQUE INDEX IX_DroneEquipment_SerialNumber ON dbo.DroneEquipment(SerialNumber);
CREATE UNIQUE INDEX IX_Account_AccountNumber ON dbo.Account(AccountNumber);
CREATE INDEX IX_Station_StationName ON dbo.Station(StationName);
CREATE UNIQUE INDEX IX_Pilot_TransportCanadaCertNumber ON dbo.Pilot(TransportCanadaCertNumber);
CREATE INDEX IX_Account_PrimaryPilotID ON dbo.Account(PrimaryPilotID);
CREATE INDEX IX_Address_Province_City ON dbo.Address(Province,City);
CREATE INDEX IX_Address_Province ON dbo.Address(Province);
CREATE INDEX IX_Address_City ON dbo.Address(City);
CREATE INDEX IX_Pilot_By_Address ON dbo.PilotAddress(PilotID, AddressID);
CREATE INDEX IX_Address_By_Pilot ON dbo.PilotAddress(AddressID,PilotID);
CREATE INDEX IX_Account_By_Pilot ON dbo.PilotAccount(AccountID,PilotID);
CREATE INDEX IX_Pilot_By_Account ON dbo.PilotAccount(PilotID,AccountID);
CREATE INDEX IX_Model_ManufacturerID ON dbo.Model(ManufacturerID);
CREATE INDEX IX_PilotAccount_Account ON dbo.PilotAccount(AccountID);
CREATE INDEX IX_PilotAccount_Pilot ON dbo.PilotAccount(PilotID);
CREATE INDEX IX_PilotAddress_Address ON dbo.PilotAddress(AddressID);
CREATE INDEX IX_PilotAddress_Pilot ON dbo.PilotAddress(PilotID);
