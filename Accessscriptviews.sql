
--Use JobSearch2010
--Go
--Create View LeadsperDay
--as 
--(Select count(LeadID) as [NumberofLeads]
-- From Leads
-- Where RecordDate = GETDATE());


--Go
--CREATE VIEW Jobleadsperweek
--as
--(Select DATENAME(DW,-7)[First day of Week],Count(leadID) as [Leadsperweek]
--from Leads
--Where RecordDate > = DATEADD(wk,0,GETDATE()-1))

GO 
CREATE VIEW Weekinactivelead
As
(Select		l.JobTitle,c.CompanyName,CONCAT(ct.ContactFirstName,'',ct.ContactLastName) as [Contact Name], ct.Phone,ct.EMail
from		Leads l
inner join  Companies c
on			c.CompanyID = l.CompanyID
inner join	Contacts ct
on			ct.ContactID = l.ContactID
Where		l.RecordDate < DATEADD(dd,DATEDIFF(dd,0,GETDATE()),-7))               