drop table User;
drop table Portfolio;
drop table RealEstate;
drop table ManagedBy;
drop table Agent;
drop table InvestmentAccount;
drop table General;
drop table RRSP;
drop table TFSA;
drop table Crypto;
drop table Stock;
drop table Company;
drop table StockMarket;

CREATE TABLE User(
SIN_ INT(9),
Name_ CHAR(50),
DOB CHAR(13),
EmailID CHAR(50),
PRIMARY KEY(EmailID, SIN_)
);

grant select on User to public;

CREATE TABLE Portfolio(
ID INT PRIMARY KEY, 
NetWorth INT, 
EmailID CHAR(50), 
FOREIGN KEY(EmailID) REFERENCES User(EmailID),
UNIQUE(EmailID)
);

grant select on Portfolio to public;

CREATE TABLE RealEstate(
Address_ CHAR(50),
BuyPrice INT, 
Value_ INT,
Type_ CHAR(50),
FOREIGN KEY (pID) REFERENCES Portfolio(ID)
);

grant select on RealEstate to public;

CREATE TABLE ManagedBy(
ID INT FOREIGN KEY REFERENCES Agent(ID), 
Address_ CHAR(50) FOREIGN KEY REFERENCES RealEstate(Address_),
PRIMARY KEY (ID, Address_)
);

grant select on ManagedBy to public;

CREATE TABLE Agent(
ID INT PRIMARY KEY, 
Name_ CHAR(50)
);

grant select on Agent to public;

CREATE TABLE InvestmentAccount(
AccountNumber CHAR(14) PRIMARY KEY, 
ID INT NOT NULL,
InvestedAmount INT, 
UnivestedAmount INT,
FOREIGN KEY (ID) REFERENCES Portfolio(ID)
);

grant select on InvestmentAccount to public;

CREATE TABLE General(
AccountNumber CHAR(14) PRIMARY KEY, 
CapitalGainsTax INT
);

grant select on General to public;

CREATE TABLE RRSP(
AccountNumber CHAR(14) PRIMARY KEY,
ContributionRoom INT
);

grant select on RRSP to public;

CREATE TABLE TFSA(
AccountNumber CHAR(14) PRIMARY KEY,
ContributionRoom INT
);

grant select on TFSA to public;

CREATE TABLE Crypto(
Symbol CHAR(10),
AccountNumber INT NOT NULL, 
Price INT,
Holding INT, 
Value_ INT,
Profit INT, 
Name_ CHAR(50),
PRIMARY KEY (Symbol, AccountNumber), 
FOREIGN KEY (AccountNumber) REFERENCES InvestmentAccount (AccountNumber)
);

grant select on Crypto to public;

CREATE TABLE Stock(
Symbol INT,
AccountNumber INT NOT NULL FOREIGN KEY REFERENCES InvestmentAccount(AccountNumber), 
Price INT,
Holding INT, 
Value_ INT,
Profit INT, 
Name_ CHAR(50) FOREIGN KEY REFERENCES Company(Name_),
smSymbol INT FOREIGN KEY REFERENCES StockMarket(smSymbol)
PRIMARY KEY (Symbol, AccountNumber)
);

grant select on Stock to public;

CREATE TABLE Company(
Name_ CHAR(50) PRIMARY KEY,
Type_ CHAR(50),
Industry CHAR(50)
);

grant select on Company to public;

CREATE TABLE StockMarket(
smSymbol INT PRIMARY KEY, 
headquarters CHAR(50),
);

grant select on StockMarket to public;

INSERT INTO User(SIN_, Name_, DOB, EmailID)
VALUES
    (123456789, 'Bruce Wayne', '04/17/1980', 'bq@gmail.com'),
    (987654321, 'Jack Napier', '04/25/1985', 'jn@gmail.com'),
    (135792468, 'Peter Parker', '08/10/2001', 'pp@gmail.com'),
    (246813579, 'Gangandhar Sharstri', '06/19/1970', 'gs@gmail.com'),
    (192837456, 'Barry Allen', '03/14/1996', 'ba@gmail.com');


INSERT INTO Portfolio (ID, NetWorth, EmailID)
VALUES
    (77, 1000, 'bq@gmail.com'),
    (69, 2000, 'jn@gmail.com'),
    (50, 3000, 'pp@gmail.com'),
    (10, 4000, 'gs@gmail.com'),
    (33, 5000, 'ba@gmail.com');


INSERT INTO RealEstate (ID, Address_, BuyPrice, Value_, Type_)
VALUES
    (77, '1 Gotham, NY', 1000, 'Residential'),
    (69, '2 Gotham, NY', 2000, 'Residential'),
    (50, '3 Gotham, NY', 3000, 'Residential'),
    (10, '4 Gotham, NY', 4000, 'Residential'),
    (33, '5 Gotham, NY', 5000, 'Commercial');

INSERT INTO ManagedBy (ID, Address_)
VALUES 
    (1, '1 Gotham, NY'),
    (2, '2 Gotham, NY'),
    (3, '3 Gotham, NY'),
    (4, '4 Gotham, NY'),
    (5, '5 Gotham, NY');


INSERT INTO Agent (ID, Name_)
VALUES
    (1, 'Kris Elliot'),
    (2, 'Kris Ellen'),
    (3, 'Kris Ellie'),
    (4, 'Kris Elves'),
    (5, 'Kris Elsa');


INSERT INTO InvestmentAccount (AccountNumber, ID, InvestedAmount, UnivestedAmount)
VALUES
    ('QWER1234567890', 77, 500, 1000),
    ('WWER1234567890', 69, 400, 2000),
    ('EWER1234567890', 50, 300, 5000),
    ('RWER1234567890', 10, 200, 5000),
    ('TWER1234567890', 33, 100, 5000);

INSERT INTO General(AccountNumber, CapitalGainsTax)
VALUES
    ('QWER1234567890', 770),
    ('WWER1234567890', 690),
    ('EWER1234567890', 500),
    ('RWER1234567890', 100),
    ('TWER1234567890', 330);

INSERT INTO RRSP (AccountNumber, ContributionRoom)
VALUES
    ('QWER1234567890', 7700),
    ('WWER1234567890', 6900),
    ('EWER1234567890', 5000),
    ('RWER1234567890', 1000),
    ('TWER1234567890', 3300);

INSERT INTO TFSA (AccountNumber, ContributionRoom)
VALUES
    ('QWER1234567890', 77000),
    ('WWER1234567890', 69000),
    ('EWER1234567890', 50000),
    ('RWER1234567890', 10000),
    ('TWER1234567890', 33000);

INSERT INTO Crypto (Symbol, AccountNumber, Price, Holding, Value_, Profit, Name_)
VALUES
    ('BTC' , 'QWER1234567890', 77000, 500, 7500, 7000, 'Bitcoin'),
    ('ETH' , 'WWER1234567890', 69000, 400, 7400, 7000, 'Ethereum'),
    ('APE' , 'EWER1234567890', 50000, 300, 7300, 7000, 'ApeCoin'),
    ('ETH' , 'RWER1234567890', 10000, 200, 7200, 7000, 'Ethereum'),
    ('BTC' , 'TWER1234567890', 33000, 100, 7100, 7000, 'Bitcoin');

INSERT INTO Stock (Symbol, AccountNumber, Price, Holding, Value_, Profit, Name_, smSymbol)
VALUES
    ('WAYNE' , 'QWER1234567890', 77000, 500, 7500, 7000, 'Bitcoin' , 'NYSEFO'),
    ('STAR' , 'WWER1234567890', 69000, 400, 7400, 7000, 'Ethereum' , 'TSXUOL'),
    ('GOOGL' , 'EWER1234567890', 50000, 300, 7300, 7000, 'ApeCoin' , 'NASDAQ'),
    ('APL' , 'RWER1234567890', 10000, 200, 7200, 7000, 'Ethereum'  , 'NASDAQ'),
    ('MSFT' , 'TWER1234567890', 33000, 100, 7100, 7000, 'Bitcoin'  , 'NASDAQ');
INSERT INTO StockMarket (smSymbol, Headquarters)
VALUES
    ('NYSEFO', 'NY USA'),
    ('TSXUOL', 'NY USA'),
    ('NASDAQ', 'ON Canada'),
    ('FASDAQ', 'BC Canada'),
    ('TASDAQ', 'ML Italy');

INSERT INTO Company (Name_, Type_, Industry)
VALUES
    ('Gucci', 'Public', 'Fashion'),
    ('Sofie', 'Public', 'Conglomerate'),
    ('Apple', 'Public', 'Tech'),
    ('Microsoft', 'Public', 'Tech'),
    ('Alpha', 'Public', 'Cosmetics');

