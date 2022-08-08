drop table User_ CASCADE CONSTRAINTS;
drop table Portfolio CASCADE CONSTRAINTS;
drop table RealEstate CASCADE CONSTRAINTS;
drop table ManagedBy CASCADE CONSTRAINTS;
drop table Agent CASCADE CONSTRAINTS;
drop table InvestmentAccount CASCADE CONSTRAINTS;
drop table General CASCADE CONSTRAINTS;
drop table RRSP CASCADE CONSTRAINTS;
drop table TFSA CASCADE CONSTRAINTS;
drop table Crypto CASCADE CONSTRAINTS;
drop table Stock CASCADE CONSTRAINTS;
drop table Company CASCADE CONSTRAINTS;
drop table StockMarket CASCADE CONSTRAINTS;

CREATE TABLE User_(
SIN_ INT,
Name_ CHAR(50),
DOB DATE,
EmailID CHAR(50),
PRIMARY KEY(EmailID)
);


CREATE TABLE Portfolio(
ID INT PRIMARY KEY, 
NetWorth INT, 
EmailID CHAR(50), 
UNIQUE (EmailID),
FOREIGN KEY (EmailID) REFERENCES User_(EmailID) ON DELETE CASCADE
);

CREATE TABLE RealEstate(
Address_ CHAR(50) PRIMARY KEY,
BuyPrice INT, 
Value_ INT,
Type_ CHAR(50),
ID INT,
FOREIGN KEY (ID) REFERENCES Portfolio(ID) ON DELETE CASCADE
);

CREATE TABLE Agent(
ID INT PRIMARY KEY, 
Name_ CHAR(50)
);

CREATE TABLE ManagedBy(
ID INT, 
Address_ CHAR(50),
PRIMARY KEY (ID, Address_),
FOREIGN KEY (ID) REFERENCES Agent(ID),
FOREIGN KEY (Address_) REFERENCES RealEstate(Address_)
);


CREATE TABLE InvestmentAccount(
AccountNumber CHAR(14) PRIMARY KEY, 
ID INT NOT NULL,
InvestedAmount INT, 
UnivestedAmount INT,
FOREIGN KEY (ID) REFERENCES Portfolio(ID) ON DELETE CASCADE
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
Symbol CHAR(50),
AccountNumber CHAR(14) NOT NULL, 
Price INT,
Holding INT, 
Value_ INT,
Profit INT, 
Name_ CHAR(50),
FOREIGN KEY (AccountNumber) REFERENCES InvestmentAccount (AccountNumber),
PRIMARY KEY (Symbol, AccountNumber)
);




CREATE TABLE Company(
Name_ CHAR(50) PRIMARY KEY,
Type_ CHAR(50),
Industry CHAR(50)
);

CREATE TABLE StockMarket(
smSymbol CHAR(50) PRIMARY KEY, 
headquarters CHAR(50)
);

CREATE TABLE Stock(
Symbol CHAR(50),
AccountNumber CHAR(14) NOT NULL, 
Price INT,
Holding INT, 
Value_ INT,
Profit INT, 
Name_ CHAR(50),
smSymbol CHAR(50),
FOREIGN KEY (Name_) REFERENCES Company(Name_),
FOREIGN KEY (smSymbol) REFERENCES StockMarket(smSymbol),
FOREIGN KEY (AccountNumber) REFERENCES InvestmentAccount(AccountNumber),
PRIMARY KEY (Symbol, AccountNumber)
);

INSERT INTO User_(SIN_, Name_, DOB, EmailID)
VALUES
    (123456789, 'Bruce Wayne', to_date('2000-01-01', 'yyyy-mm-dd'), 'bq@gmail.com');
INSERT INTO User_(SIN_, Name_, DOB, EmailID)
VALUES
    (987654321, 'Jack Napier', to_date('2000-02-01', 'yyyy-mm-dd'), 'jn@gmail.com');
INSERT INTO User_(SIN_, Name_, DOB, EmailID)
VALUES
    (135792468, 'Peter Parker', to_date('2000-03-01', 'yyyy-mm-dd'), 'pp@gmail.com');
INSERT INTO User_(SIN_, Name_, DOB, EmailID)
VALUES
    (246813579, 'Gangandhar Sharstri', to_date('2000-04-01', 'yyyy-mm-dd'), 'gs@gmail.com');
INSERT INTO User_(SIN_, Name_, DOB, EmailID)
VALUES
    (192837456, 'Barry Allen', to_date('2000-05-01', 'yyyy-mm-dd'), 'ba@gmail.com');


INSERT INTO Portfolio (ID, NetWorth, EmailID)
VALUES
    (77, 1000, 'bq@gmail.com');
INSERT INTO Portfolio (ID, NetWorth, EmailID)
VALUES
    (69, 2000, 'jn@gmail.com');
INSERT INTO Portfolio (ID, NetWorth, EmailID)
VALUES
    (50, 3000, 'pp@gmail.com');
INSERT INTO Portfolio (ID, NetWorth, EmailID)
VALUES
    (10, 4000, 'gs@gmail.com');
INSERT INTO Portfolio (ID, NetWorth, EmailID)
VALUES
    (33, 5000, 'ba@gmail.com');


INSERT INTO RealEstate (ID, Address_, BuyPrice, Value_, Type_)
VALUES
    (77, '1 Gotham, NY', 1000, 32000000, 'Residential');
INSERT INTO RealEstate (ID, Address_, BuyPrice, Value_, Type_)
VALUES
    (69, '2 Gotham, NY', 2000, 5000000, 'Residential');
INSERT INTO RealEstate (ID, Address_, BuyPrice, Value_, Type_)
VALUES
    (50, '3 Gotham, NY', 3000, 5000000, 'Residential');
INSERT INTO RealEstate (ID, Address_, BuyPrice, Value_, Type_)
VALUES
    (10, '4 Gotham, NY', 4000, 2000000, 'Residential');
INSERT INTO RealEstate (ID, Address_, BuyPrice, Value_, Type_)
VALUES
    (33, '5 Gotham, NY', 5000, 3000000, 'Commercial');

INSERT INTO Agent (ID, Name_)
VALUES
    (1, 'Kris Ellio');
INSERT INTO Agent (ID, Name_)
VALUES
    (2, 'Kris Ellen');
INSERT INTO Agent (ID, Name_)
VALUES
    (3, 'Kris Ellie');
INSERT INTO Agent (ID, Name_)
VALUES
    (4, 'Kris Elves');
INSERT INTO Agent (ID, Name_)
VALUES
    (5, 'Kris Elsal');

INSERT INTO ManagedBy (ID, Address_)
VALUES 
    (1, '1 Gotham, NY');
INSERT INTO ManagedBy (ID, Address_)
VALUES 
    (2, '2 Gotham, NY');
INSERT INTO ManagedBy (ID, Address_)
VALUES 
    (3, '3 Gotham, NY');
INSERT INTO ManagedBy (ID, Address_)
VALUES 
    (4, '4 Gotham, NY');
INSERT INTO ManagedBy (ID, Address_)
VALUES 
    (5, '5 Gotham, NY');


INSERT INTO InvestmentAccount (AccountNumber, ID, InvestedAmount, UnivestedAmount)
VALUES
    ('QWER1234567890', 77, 500, 1000);
INSERT INTO InvestmentAccount (AccountNumber, ID, InvestedAmount, UnivestedAmount)
VALUES
    ('WWER1234567890', 69, 400, 2000);
INSERT INTO InvestmentAccount (AccountNumber, ID, InvestedAmount, UnivestedAmount)
VALUES
    ('EWER1234567890', 50, 300, 5000);
INSERT INTO InvestmentAccount (AccountNumber, ID, InvestedAmount, UnivestedAmount)
VALUES
    ('RWER1234567890', 10, 200, 5000);
INSERT INTO InvestmentAccount (AccountNumber, ID, InvestedAmount, UnivestedAmount)
VALUES
    ('TWER1234567890', 33, 100, 5000);

INSERT INTO General(AccountNumber, CapitalGainsTax)
VALUES
    ('QWER1234567890', 77);
INSERT INTO General(AccountNumber, CapitalGainsTax)
VALUES
    ('WWER1234567890', 69);
INSERT INTO General(AccountNumber, CapitalGainsTax)
VALUES
    ('EWER1234567890', 50);
INSERT INTO General(AccountNumber, CapitalGainsTax)
VALUES
    ('RWER1234567890', 10);
INSERT INTO General(AccountNumber, CapitalGainsTax)
VALUES
    ('TWER1234567890', 33);

INSERT INTO RRSP (AccountNumber, ContributionRoom)
VALUES
    ('QWER1234567890', 7700);
INSERT INTO RRSP (AccountNumber, ContributionRoom)
VALUES
    ('WWER1234567890', 6900);
INSERT INTO RRSP (AccountNumber, ContributionRoom)
VALUES
    ('EWER1234567890', 5000);
INSERT INTO RRSP (AccountNumber, ContributionRoom)
VALUES
    ('RWER1234567890', 1000);
INSERT INTO RRSP (AccountNumber, ContributionRoom)
VALUES
    ('TWER1234567890', 3300);

INSERT INTO TFSA (AccountNumber, ContributionRoom)
VALUES
    ('QWER1234567890', 77000);
INSERT INTO TFSA (AccountNumber, ContributionRoom)
VALUES
    ('WWER1234567890', 69000);
INSERT INTO TFSA (AccountNumber, ContributionRoom)
VALUES
    ('EWER1234567890', 50000);
INSERT INTO TFSA (AccountNumber, ContributionRoom)
VALUES
    ('RWER1234567890', 10000);
INSERT INTO TFSA (AccountNumber, ContributionRoom)
VALUES
    ('TWER1234567890', 33000);

INSERT INTO Crypto (Symbol, AccountNumber, Price, Holding, Value_, Profit, Name_)
VALUES
    ('BTC' , 'QWER1234567890', 3000000, 500, 5000000, 2000000, 'Bitcoin');
INSERT INTO Crypto (Symbol, AccountNumber, Price, Holding, Value_, Profit, Name_)
VALUES
    ('ETH' , 'WWER1234567890', 75000, 400, 200000, 125000, 'Ethereum');
INSERT INTO Crypto (Symbol, AccountNumber, Price, Holding, Value_, Profit, Name_)
VALUES
    ('APE' , 'EWER1234567890', 7000, 300, 20000, 13000, 'ApeCoin');
INSERT INTO Crypto (Symbol, AccountNumber, Price, Holding, Value_, Profit, Name_)
VALUES
    ('ETH' , 'RWER1234567890', 60000, 200, 160000, 100000, 'Ethereum');
INSERT INTO Crypto (Symbol, AccountNumber, Price, Holding, Value_, Profit, Name_)
VALUES
    ('BTC' , 'TWER1234567890', 3000000, 100, 500000, 200000, 'Bitcoin');

INSERT INTO StockMarket (smSymbol, Headquarters)
VALUES
    ('NYSE', 'NY USA');
INSERT INTO StockMarket (smSymbol, Headquarters)
VALUES
    ('NASDAQ', 'NY USA');
INSERT INTO StockMarket (smSymbol, Headquarters)
VALUES
    ('TSX', 'ON Canada');
INSERT INTO StockMarket (smSymbol, Headquarters)
VALUES
    ('NSE', 'MH India');
INSERT INTO StockMarket (smSymbol, Headquarters)
VALUES
    ('LSE', 'LD UK');

INSERT INTO Company (Name_, Type_, Industry)
VALUES
    ('Gucci', 'Public', 'Fashion');
INSERT INTO Company (Name_, Type_, Industry)
VALUES
    ('Sofie', 'Public', 'Conglomerate');
INSERT INTO Company (Name_, Type_, Industry)
VALUES
    ('Apple', 'Public', 'Tech');
INSERT INTO Company (Name_, Type_, Industry)
VALUES
    ('Microsoft', 'Public', 'Tech');
INSERT INTO Company (Name_, Type_, Industry)
VALUES
    ('Alpha', 'Public', 'Cosmetics');

INSERT INTO Stock (Symbol, AccountNumber, Price, Holding, Value_, Profit, smSymbol)
VALUES
    ('WAYNE' , 'QWER1234567890', 10000, 500, 200000, 190000, 'NYSE');
INSERT INTO Stock (Symbol, AccountNumber, Price, Holding, Value_, Profit, smSymbol)
VALUES
    ('STAR' , 'WWER1234567890', 2750, 400, 7500, 4750, 'NYSE');
INSERT INTO Stock (Symbol, AccountNumber, Price, Holding, Value_, Profit, smSymbol)
VALUES
    ('GOOGL' , 'EWER1234567890', 1800, 300, 4800, 3000, 'NASDAQ');
INSERT INTO Stock (Symbol, AccountNumber, Price, Holding, Value_, Profit, smSymbol)
VALUES
    ('APL' , 'RWER1234567890', 4000, 200, 6400, 2400, 'NASDAQ');
INSERT INTO Stock (Symbol, AccountNumber, Price, Holding, Value_, Profit, smSymbol)
VALUES
    ('MSFT' , 'TWER1234567890', 4500, 100, 8100, 3600, 'NASDAQ');

