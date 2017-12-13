USE MASTER;
if (select count(*) 
    from sys.databases where name = 'JobSearch2010') > 0
BEGIN
    DROP DATABASE JobSearch2010;
END

CREATE DATABASE JobSearch2010;
GO

USE JobSearch2010;

CREATE TABLE BusinessType
(
	BusinessType varchar(100) NOT NULL,

	PRIMARY KEY(BusinessType),
)
CREATE TABLE Companies
(
	CompanyID INT NOT NULL IDENTITY(1,1),
	CompanyName varchar(100) NOT NULL,
	Address1 varchar(100)  NOT NULL,
	Address2 varchar(100)  NULL,
	City varchar(50) NOT NULL,
	State varchar(50) NOT NULL,
	ZIP varchar(12) NOT NULL,
	Phone varchar(20) NOT NULL,
	Fax	varchar(20) NULL,
	Email varchar(80) NOT NULL,
	Website varchar(80) NULL,
	Description varchar(255) NULL,
	BusinessType Varchar(100) NOT NULL,
	Agency BIT  NOT NULL

	PRIMARY KEY(CompanyID)
)

CREATE TABLE Contacts
(
	ContactID INT NOT NULL IDENTITY(1,1),
	CompanyID INT NOT NULL,
	CourtesyTitle varchar(25) NULL,
	ContactFirstName varchar(50) NULL,
	ContactLastName varchar(50) NULL,
	Title varchar(50) NULL,
	Phone varchar(14) NULL,
	Extension varchar(10) NULL,
	Fax varchar(14) NULL,
	EMail varchar(50) NULL,
	Comments varchar(255) NULL,
	Active Bit NOT NULL,

	PRIMARY KEY(ContactID)
)
CREATE TABLE Sources
(
	SourceID INT NOT NULL,
	SourceName varchar(75) NOT NULL,
	SourceType varchar(35) NULL,
	SourceLink varchar(255) NULL,
	Description varchar(255) NULL,

	PRIMARY KEY(SourceID)
)

CREATE TABLE Leads
(
	LeadID INT NOT NULL IDENTITY(1,1),
	RecordDate Date NOT NULL,
	JobTitle varchar(100) NOT NULL,
	Description varchar(255)  NULL,
	EmploymentType varchar(25) NULL,
	Location varchar(50) NULL,
	Active Bit NOT NULL,
	CompanyID INT NULL,
	AgencyID INT NULL,
	ContactID INT NULL,
	DocAttachment XML NULL,
	SourceID INT NULL,
	Selected BIT NULL,

	PRIMARY KEY(LeadID)
	
)
CREATE TABLE Activities
(
	ActivityID INT NOT NULL IDENTITY (1,1),
	LeadID INT NOT NULL,
	ActivityDate date NOT NULL,
	ActivityType varchar(25) NOT NULL,
	ActivityDetails varchar(255) Null,
	Complete BIT NOT NULL,
	ReferenceLink varchar(255) NULL,

	PRIMARY KEY (ActivityID)
	
)

GO
CREATE TRIGGER tgrleadcomp
on	Leads
after insert,update
as
IF Exists
	(Select *
		From inserted i
		 Where i.CompanyID not in (Select companyID from Companies)
		 )
Begin 
	RAISERROR('Not a valid CompanyID -tgrleadcomp',16,1)
END;



GO
CREATE TRIGGER tgrleadagen
on	Leads
after insert,update
as
IF Exists
	(Select *
		From inserted i
		 Where i.AgencyID not in (Select AgencyID from Companies)
		 )
Begin 
	RAISERROR('Not a valid Agency -tgrleadagen',16,1)
END;

GO
CREATE TRIGGER tgrleadcon
on	Leads
after insert,update
as
IF Exists
	(Select *
		From inserted i
		 Where i.ContactID not in (Select ContactID from Contacts)
		 )
Begin 
	RAISERROR('Not a valid contact -tgrleadcon',16,1)
END;

GO
CREATE TRIGGER trgContractsDel
ON Contacts
After Delete
as 
BEGIN
IF Exists
	(Select *
		From deleted i
		where i.ContactID not in (Select ContactID from Leads))
		BEGIN
			Raiserror ('Specifed ContactID referenced by Contacts records. Record not deleted.-trgContractsDel',16,1)
			Rollback Transaction
		END
END;

GO
CREATE TRIGGER trgleadsrc
on	Leads
after insert,update
as
IF Exists
	(Select *
		From inserted i
		 Where i.SourceID not in (Select SourceID from Sources)
		 )
Begin 
	RAISERROR('Not a valid Source -trgleadsrc',16,1)
END;

GO
CREATE TRIGGER trgSourceIDDel
ON Sources
After Delete
as 
BEGIN
IF Exists
	(Select *
		From deleted i
		where i.SourceID not in (Select SourceID from Leads))
		BEGIN
			Raiserror ('Specifed SourceID referenced by Sources records. Record not deleted.-trgSourceIDDel ',16,1)
			Rollback Transaction
		END
END;


GO
CREATE TRIGGER trgconcom
on Contacts
After insert,update
as 
IF Exists 
	(Select *
		From inserted i
		 Where i.CompanyID not in (Select CompanyID from Companies)
		 )
Begin 
	RAISERROR('Not a valid CompanyID -trgconcom',16,1)
END;

GO
CREATE TRIGGER trgComcondel
ON Companies
After Delete
as 
BEGIN
IF Exists
	(Select *
		From deleted i
		where i.CompanyID not in (Select CompanyID from Contacts))
		BEGIN
			Raiserror ('Specifed CompanyID referenced by Companies records. Record not deleted. - trgComcondel',16,1)
			Rollback Transaction
		END
END;


GO
CREATE TRIGGER trgcompbtype
ON Companies
after insert,update
as
IF Exists
   (select *
	  from inserted i
		Where i.BusinessType not in (select BusinessType from Companies)
		)
Begin 
	RAISERROR('Not a valid BusinessType -trgcompbtype ',16,1)
END;

GO
CREATE TRIGGER trgBtypeDel
ON BusinessType
After Delete
as 
BEGIN
IF Exists
	(Select *
		From deleted i
		where i.BusinessType not in (Select BusinessType from Companies))
		BEGIN
			Raiserror ('Specifed BusinessType referenced by Companies records. Record not deleted.-trgBtypeDel',16,1)
			Rollback Transaction
		END
END;


GO
CREATE TRIGGER tgrcompIDdelete
ON Companies
after Delete
as
BEGIN
if exists
	(select *
		From deleted i
		where i.CompanyID not in (Select distinct CompanyID from Leads)
		)
	BEGIN 
		Raiserror('Specifed CompanyID referenced by Companies records. Record not deleted.-tgrcompIDdelete',16,1)
		Rollback Transaction
	END
END;


INSERT INTO BusinessType
(BusinessType)
Values
('Accounting'),
('Advertising/Marketing'),
('Agriculture'),
('Architecture'),
('Arts/Entertainment'),
('Aviation'),
('Beauty/Fitness'),
('Business Services'),
('Communications'),
('Computer/Hardware'),
('Computer/Services'),
('Computer/Software'),
('Computer/Training'),
('Construction'),
('Consulting'),
('Crafts/Hobbies'),
('Education'),
('Electrical'),
('Electronics'),
('Employment'),
('Engineering'),
('Environmental'),
('Fashion'),
('Financial'),
('Food/Beverage'),
('Government'),
('Health/Medicine'),
('Home & Garden'),
('Immigration'),
('Import/Export'),
('Industrial'),
('Industrial Medicine'),
('Information Services'),
('Insurance'),
('Internet'),
('Legal & Law'),
('Logistics'),
('Manufacturing'),
('Mapping/Surveying'),
('Marine/Maritime'),
('Motor Vehicle'),
('Multimedia'),
('Network Marketing'),
('News & Weather'),
('Non-Profit'),
('Petrochemical'),
('Pharmaceutical'),
('Printing/Publishing'),
('Real Estate'),
('Restaurants'),
('Restaurants Services'),
('Service Clubs'),
('Service Industry'),
('Shopping/Retail'),
('Spiritual/Religious'),
('Sports/Recreation'),
('Storage/Warehousing'),
('Technologies'),
('Transportation'),
('Travel'),
('Utilities'),
('Venture Capital'),
('Wholesale');

insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Mybuzz', '087 Union Circle', 'Los Angeles', 'California', '90005', '310-760-2772', '323-473-3868', 'sskerritt0@blog.com', 'BuzzMe.com', 'Advertising/Marketing',0 );
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Gabvine', '90 Roth Way', 'Independence', 'Missouri', '64054', '816-289-6342', '520-156-3402', 'krodolf1@si.edu', 'GabVine.com', 'Electrical',0 );
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Ooba', '18 Loftsgordon Junction', 'Annapolis', 'Maryland', '21405', '301-464-4085', '435-436-9625', 'ngrimestone2@a8.net', 'ooba.com', 'Food/Beverage',0 );
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Shufflester', '533 Messerschmidt Circle', 'Colorado Springs', 'Colorado', '80915', '719-817-5926', '513-312-9521', 'ndunnico3@skyrock.com', 'blogs.com', 'Crafts/Hobbies',0 );
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Youopia', '827 Rockefeller Terrace', 'Pittsburgh', 'Pennsylvania', '15250', '412-302-8007', '850-403-3327', 'sgiorgi4@bigcartel.com', 'Youopia.net', 'Internet',0 );
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Jazzy', '723 Brown Crossing', 'Northridge', 'California', '91328', '818-550-4206', '318-940-1482', 'kleap5@nytimes.com', 'TheJazzy.com', 'Environmental',0 );
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Devpoint', '09 Anthes Drive', 'Tampa', 'Florida', '33620', '813-229-2352', '302-835-3562', 'broyans6@zimbio.com', 'issuu.com', 'Information Services', 0);
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Dynabox', '06 Heath Circle', 'Lehigh Acres', 'Florida', '33972', '863-892-9943', '901-690-6862', 'cspennock7@marriott.com', 'DevCent.com', 'Marine/Maritime',0);
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Topicware', '79492 Myrtle Circle', 'Anchorage', 'Alaska', '99507', '907-977-9749', '801-385-4053', 'etunney8@nasa.gov', 'rakuten.co.jp', 'Petrochemical', 0);
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone, Fax, Email, Website, BusinessType, Agency) values ( 'Yodoo', '15562 David Park', 'Atlanta', 'Georgia', '31119', '770-243-5852', '509-104-5336', 'lbeeres9@diigo.com', 'Yoodoo.com', 'Transportation', 0);
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone,Email, Website, BusinessType,Agency) values('Spherion','500 SW 10th St Suite 309','Ocala','Florida','34471','352-622-5273','Spherion@gmail.com','https://www.spherion.com','Employment',1);
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone,Email, Website, BusinessType,Agency) values('Express Employment Professionals','1005 SW 10th St','Ocala','FLorida','34474','352-867-8055',' jobs.ocalafl@expresspros.com','https://www.expresspros.com','Employment',1);
insert into Companies ( CompanyName, Address1, City, State, ZIP, Phone,Email, Website, BusinessType,Agency) values('Wal-Staf Temporary Services Inc','4140 NW 27 Ln','Gainesville','Florida','32606','352-378-8367 ','Gainesville@wal-staf.com','http://www.wal-staf.com','Employment',1);

insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (1,'Mr', 'Thorin', 'Seawell','Owner','310-760-2772','8451','tseawelle@hugedomains.com',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (2,'Mr', 'Lincoln', 'Thredder','HR Generalist','816-289-6342',NULL,'lthredder2@home.pl',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (3,'Mrs', 'Quinn', 'Iacoboni','Manager','301-464-4085','12','qiacoboni3@xinhuanet.com',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (4,'Mrs', 'Madelina', 'Goldhill', 'HR Manager','719-817-5926',NULL,'mgoldhillj@wordpress.org',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (5,'Ms', 'Peggie', 'Fritz','Owner', '719-817-5926',NULL,'pfritz4@loc.gov',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (6,'Mr', 'Reagen', 'Proske', 'Technical Affairs Coordinator','818-550-4206','18','rproske3@geocities.jp',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (7,'Mr', 'Homere', 'Hankins','Owner/Manager','813-229-2352',NULL,'hhankins9@fc2.com',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (8,'Mr', 'Dud', 'Rate','Supervisor','863-892-9943',NULL,'drate7@dell.com',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Fax,Email,Active) Values (9, 'Ms', 'Eimile', 'Embleton','Staffing Coordinator','907-977-9749','1212','801-385-4053','eembleton8@jigsy.com',1);
insert into Contacts (CompanyID,CourtesyTitle,ContactFirstName,ContactLastName,Title,Phone,Extension,Email,Active) Values (10,'Ms', 'Winni', 'Daulby','Manager','770-243-5852',NULL,'wdaulby2@yoodoo.com',1);

insert into Sources (SourceID,SourceName, SourceType, SourceLink,Description) values (1,'stackoverflow.com','Online','https://stackoverflow.com/jobs/146369/entry-level-sql-server-developer-advise-technologies','Sql Dev job');
insert into Sources (SourceID,SourceName, SourceType, SourceLink,Description) values (2,'Indeed.com','Online','https://www.indeed.com/viewjob?jk=e8f7529ee2070da9&q=Entry+Level+Developer&l=Raleigh%2C+NC&tk=1c0n0fs19549be0k&from=web','Sql Dev job');
insert into Sources (SourceID,SourceName, SourceType, SourceLink,Description) values (3,'monster.com','Online','https://job-openings.monster.com/Desk-Side-Technician-A-Certification-Beneficial-Research-Triangle-Park-NC-US-eXcell/11/191046965','Desk-Side Tech position');
insert into Sources (SourceID,SourceName, SourceType, SourceLink,Description) values (4,'stackoverflow.com','Online','https://stackoverflow.com/jobs/155686/junior-software-engineer-lsq?so=i&pg=1&offset=0&q=Junior+developer','Junior C# Developer');

insert into Leads (RecordDate, JobTitle, EmploymentType, Location, Active, CompanyID, AgencyID, ContactID, SourceID, Selected) values ('12/02/2017', 'Sql Server Developer', 'Contract', 'Ocala,FL', 1, 7, 12, 3, 1, 0);
insert into Leads (RecordDate, JobTitle, EmploymentType, Location, Active, CompanyID, AgencyID, ContactID, SourceID, Selected) values ('12/04/2017', 'Sql Server Developer', 'Contract', 'Ocala,FL', 1, 1, 11, 6, 2, 1);
insert into Leads (RecordDate, JobTitle, EmploymentType, Location, Active, CompanyID, AgencyID, ContactID, SourceID, Selected) values ('12/05/2017', 'DeskSide Technician', 'Full-Time', 'Ocala,FL', 1, 5, 12, 7, 3, 1);
insert into Leads (RecordDate, JobTitle, EmploymentType, Location, Active, CompanyID, AgencyID, ContactID, SourceID, Selected) values ('12/05/2017', 'Junior Software Engineer', 'Contract-Fulltime', 'Ocala,FL', 1, 6, 13, 10, 4, 0);