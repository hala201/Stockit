CREATE TABLE User(
SIN_ INT(9),
Name_ CHAR(50),
DOB CHAR(13),
EmailID CHAR(50),
PRIMARY KEY(EmailID, SIN_)
);

CREATE TABLE Portfolio(
ID INT PRIMARY KEY, 
NetWorth INT, 
EmailID CHAR(50), 
FOREIGN KEY(EmailID) REFERENCES User(EmailID),
UNIQUE(EmailID)
);

CREATE TABLE RealEstate(
Address_ CHAR(50),
BuyPrice INT, 
Value_ INT,
Type_ CHAR(50),
FOREIGN KEY (pID) REFERENCES Portfolio(ID)
);

CREATE TABLE ManagedBy(
ID INT FOREIGN KEY REFERENCES Agent(ID), 
Address_ CHAR(50) FOREIGN KEY REFERENCES RealEstate(Address_),
PRIMARY KEY (ID, Address_)
);

CREATE TABLE Agent(
ID INT PRIMARY KEY, 
Name_ CHAR(50)
);

CREATE TABLE InvestmentAccount(
AccountNumber CHAR(14) PRIMARY KEY, 
ID INT NOT NULL,
InvestedAmount INT, 
UnivestedAmount INT,
FOREIGN KEY (ID) REFERENCES Portfolio(ID)
);

CREATE TABLE General(
AccountNumber CHAR(14) PRIMARY KEY, 
CapitalGainsTax INT
);

CREATE TABLE RRSP(
AccountNumber CHAR(14) PRIMARY KEY,
ContributionRoom INT
);

CREATE TABLE TFSA(
AccountNumber CHAR(14) PRIMARY KEY,
ContributionRoom INT
);


CREATE TABLE Crypto(
Symbol CHAR(10),
AccountNumber INT NOT NULL, 
BuyPrice INT,
CurrentPrice INT, 
Holding INT, 
BuyValue INT,
CurrentValue INT,
Profit INT, 
Name_ CHAR(50),
PRIMARY KEY (Symbol, AccountNumber), 
FOREIGN KEY (AccountNumber) REFERENCES InvestmentAccount (AccountNumber)
)

CREATE TABLE Stock(
Symbol INT,
AccountNumber INT NOT NULL FOREIGN KEY REFERENCES InvestmentAccount(AccountNumber), 
BuyPrice INT,
CurrentPrice INT, 
Holding INT, 
BuyValue INT,
CurrentValue INT,
Profit INT, 
Name_ CHAR(50) FOREIGN KEY REFERENCES Company(Name_),
smSymbol INT FOREIGN KEY REFERENCES StockMarket(smSymbol)
PRIMARY KEY (Symbol, AccountNumber)

)

CREATE TABLE StockMarket(
smSymbol INT PRIMARY KEY, 
headquarters CHAR(50),
)

CREATE TABLE Company(
Name_ CHAR(50) PRIMARY KEY,
Type_ CHAR(50),
Industry CHAR(50)
)

INSERT INTO User(SIN_, Name_, EmailID, DOB)
VALUES
    ('123456789', 'Bruce Wayne', '04/17/1980'),
    ('987654321', 'Jack Napier', '04/25/1985'),
    ('135792468', 'Peter Parker', '08/10/2001'),
    ('246813579', 'Gangandhar Sharstri', '06/19/1970'),
    ('192837456', 'Barry Allen', '03/14/1996');

Portfolio (ID, NetWorth, EmailID)


RealEstate (ID, Address_, BuyPrice, Value_, Type_)

ManagedBy (ID, Address_)

Agent (ID, Name_)

Investment Account (AccountNumber, ID, InvestedAmount, UnivestedAmount)


General(AccountNumber, CapitalGainsTax)

RRSP (AccountNumber, ContributionRoom)

TFSA (AccountNumber, ContributionRoom)

Crypto (Symbol, Holding, AccountNumber, BuyPrice, CurrentPrice, 
BuyValue, CurrentValue, Profit, Name_)

Stock (Symbol, Holding, AccountNumber, BuyPrice, CurrentPrice, 
BuyValue, CurrentValue, Profit, CompanyName, smSymbol)

Stock Market (smSymbol, Headquarters)

Company (Name_, Type_, Industry)
