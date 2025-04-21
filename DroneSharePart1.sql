
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
CREATE TABLE Stations(

	Stations_id INT IDENTITY(1,1) NOT NULL,
	StationName VARCHAR(50) NOT NULL,
	MaxDrones INT NOT NULL,
	DronesAtStation INT NOT NULL

	CONSTRAINT PK_Stations PRIMARY KEY (Stations_id)
	
);
CREATE TABLE Manufacturer(
	
	Manufacturer_id INT IDENTITY(1,1) NOT NULL,
	Manufacturer_name VARCHAR(100) NOT NULL

	CONSTRAINT PK_Manufacturer PRIMARY KEY(Manufacturer_id)

);
CREATE TABLE Drones(
	
	Drones_id INT IDENTITY(1,1) NOT NULL,
	Model_id INT NOT NULL,
	DroneIdentification VARCHAR(14) NOT NULL,
	Manufacturer_id INT NOT NULL,
	SerialNumber VARCHAR(50) NOT NULL,
	DroneWeight INT  NOT NULL,
	HomeStation INT  NOT NULL,
	CurrentLocation INT  NOT NULL,
	ManufactureDate DATE NULL,

	CONSTRAINT PK_Drones PRIMARY KEY(Drones_id),
	CONSTRAINT FK_Manufacturer FOREIGN KEY(Manufacturer_id)REFERENCES Manufacturer(Manufacturer_id),
	CONSTRAINT FK_DroneHomeStation FOREIGN KEY (HomeStation) REFERENCES Stations(Stations_id),
	CONSTRAINT FK_DroneCurrentLocation FOREIGN KEY (CurrentLocation) REFERENCES Stations(Stations_id)
	

);

CREATE TABLE AccessoryTypes(

	AccessoryType_id INT IDENTITY(1,1) NOT NULL,
	AccessoryType VARCHAR(100) NOT NULL

	CONSTRAINT PK_AccessoryTypes PRIMARY KEY (AccessoryType_id)
);



CREATE TABLE Model(

	Model_id INT IDENTITY(1,1) NOT NULL,
	Manufacturer_id INT NOT NULL,
	Model_name VARCHAR(50) NOT NULL,
	Type_of VARCHAR(50) NOT NULL
	

	CONSTRAINT PK_Model PRIMARY KEY(Model_id),
	CONSTRAINT FK_Model_Manufacturer FOREIGN KEY (Manufacturer_id) REFERENCES Manufacturer(Manufacturer_id) 


);
CREATE TABLE Accessories(
	
	Accessories_id INT IDENTITY(1,1) NOT NULL,
	AccessoryType INT NOT NULL,
	Manufacturer_id INT NOT NULL,
	ModelName VARCHAR(50) NOT NULL,
	SerialNumber VARCHAR(50) NOT NULL,
	AccessoryWeight INT NOT NULL,
	HomeStation INT NOT NULL,
	CurrentLocation INT NOT NULL,
	ManufactureDate DATE NULL

	CONSTRAINT PK_Accessories PRIMARY KEY (Accessories_id),
	CONSTRAINT FK_AccessoryHomeStation FOREIGN KEY (HomeStation) REFERENCES Stations(Stations_id),
	CONSTRAINT FK_AccessoryCurrentLocation FOREIGN KEY (CurrentLocation) REFERENCES Stations(Stations_id),
	CONSTRAINT FK_AccessoriesType FOREIGN KEY (AccessoryType) REFERENCES AccessoryTypes(AccessoryType_id),
	CONSTRAINT FK_Accessory_Manufacturer FOREIGN KEY (Manufacturer_id) REFERENCES Manufacturer(Manufacturer_id)
);

CREATE TABLE Account(

	Account_id INT IDENTITY(1,1) NOT NULL,
	AccountNumber VARCHAR(20) NOT NULL,
	AccountOpenDate DATE NOT NULL,
	AccountBalance DECIMAL(14,2) NOT NULL

	CONSTRAINT PK_Account PRIMARY KEY (Account_id)
);

CREATE TABLE Pilot(

	Pilot_id INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(50) NOT NULL,
	LastName VARCHAR(50) NOT NULL,
	PilotCertNo VARCHAR(25) NOT NULL,
	SocialInsuranceNo char(9) NOT NULL,
	DateOfBirth DATE NOT NULL

	CONSTRAINT PK_Pilot PRIMARY KEY(Pilot_id)
);

CREATE TABLE PilotAccount(

	PilotAccount_id INT IDENTITY(1,1) NOT NULL,
	Pilot_id INT NOT NULL,
	Account_id INT NOT NULL,
	IsPrimaryHolder BIT NULL,

	CONSTRAINT PK_PilotAccount PRIMARY KEY (PilotAccount_id),
	CONSTRAINT FK_PilotOnAccount FOREIGN KEY (Pilot_id) REFERENCES Pilot(Pilot_id),
	CONSTRAINT FK_AccountIDForAccount FOREIGN KEY (Account_id) REFERENCES Account(Account_id)
);

CREATE TABLE AddressType(

	AddressType_id INT IDENTITY(1,1) NOT NULL,
	AddressTypeDescription VARCHAR(50) NOT NULL

	CONSTRAINT PK_AddressType PRIMARY KEY (AddressType_id)
);
CREATE TABLE Addresses(
	
	Address_id INT IDENTITY(1,1) NOT NULL,
	AddressType INT NOT NULL,
	Pilot_id INT NOT NULL,
	StreetAddress VARCHAR(50) NOT NULL,
	City VARCHAR(50) NOT NULL,
	PostalCode VARCHAR(50) NOT NULL,
	Country VARCHAR(50) NOT NULL

	CONSTRAINT PK_Addresses PRIMARY KEY (Address_id),
	CONSTRAINT FK_PilotAtAddress FOREIGN KEY(Pilot_id) REFERENCES Pilot(Pilot_id),
	CONSTRAINT FK_AddressesType FOREIGN KEY(AddressType) REFERENCES AddressType(AddressType_id)
);

CREATE TABLE PilotAddress(

	PilotAddress_id INT IDENTITY(1,1) NOT NULL,
	Pilot_id INT NOT NULL,
	Address_id INT NOT NULL,

	CONSTRAINT PK_PilotAddress PRIMARY KEY(PilotAddress_id),
	CONSTRAINT FK_PilotAddress_Pilot_id FOREIGN KEY (Pilot_id) REFERENCES Pilot(Pilot_id),
	CONSTRAINT FK_PilotAddress_Address_id FOREIGN KEY (Address_id) REFERENCES Addresses(Address_id)
);
CREATE TABLE Rental(

	Rental_id INT IDENTITY(1,1) NOT NULL,
	Pilot_id INT NOT NULL,
	Drones_id INT NOT NULL,
	Accessory_id INT NOT NULL,
	CheckoutDate DATETIME NOT NULL,
	ReturnDate DATETIME NOT NULL

	CONSTRAINT PK_Rental PRIMARY KEY (Rental_id),
	CONSTRAINT FK_PilotOnRental FOREIGN KEY(Pilot_id) REFERENCES Pilot(Pilot_id),
	CONSTRAINT FK_DroneOnRental FOREIGN KEY(Drones_id) REFERENCES Drones(Drones_id),
	CONSTRAINT FK_AccessoryOnRental FOREIGN KEY(Accessory_id) REFERENCES Accessories(Accessories_id)
);


