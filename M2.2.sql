Create Database GUCeraaMS2_6

go
use GUCeraaMS2_6

CREATE TABLE USERS(
id int primary key identity,
firstName VARCHAR(25),
lastName VARCHAR(25),
password VARCHAR(25),
gender bit,
email VARCHAR(50) ,
address VARCHAR(25)
)


-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Instructor (
id int primary key ,
rating decimal(2,1),
FOREIGN KEY(id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
)



-----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE UserMobileNumber(
id int ,
mobileNumber int,
PRIMARY KEY(id,mobileNumber),
FOREIGN KEY(id) REFERENCES USERS ON DELETE CASCADE ON UPDATE CASCADE
)

-----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Student(
id int primary key,
gpa decimal(4,3),
FOREIGN KEY(id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
)



-----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE Admins(
id int primary key,
FOREIGN KEY(id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
)
-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Course(
id int primary key identity,
creditHours int,
name VARCHAR(25),
courseDescription VARCHAR(100),
price int,
content VARCHAR(100),
accepted bit,
adminId INT ,
instructorId INT ,
FOREIGN KEY(adminId) REFERENCES admins ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(instructorId) REFERENCES Instructor ON DELETE NO ACTION ON UPDATE NO ACTION 
)


-----------------------------------------------------------------------------------------------------------------------------------


CREATE TABLE CreditCard( 
number int primary key ,
cardHolderName varchar(50),
expiryDate datetime ,
cvv int 

)
-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE StudentAddCreditCard( 
stid int  REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
creditCardNumber int  REFERENCES CreditCard ON DELETE CASCADE ON UPDATE CASCADE,
primary key ( stid , creditCardNumber )

)
-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE StudentTakeCourse(
stid int REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
cid int REFERENCES Course ON DELETE NO ACTION ON UPDATE NO ACTION,
instId int  REFERENCES Instructor ON DELETE NO ACTION ON UPDATE NO ACTION,
payedfor bit ,
grade decimal (4,2), -- change it to decimal (4,2)
PRIMARY KEY(stid,cid,instId) 
)

-----------------------------------------------------------------------------------------------------------------------------------
 
create table Assignment(
cid int,
number int,
Assign_type varchar(25),
fullGrade int,
Assign_weight decimal(4,2),
deadline datetime,
content text,
Primary Key(cid, number, Assign_type),
Foreign Key(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE
)
-----------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE StudentTakeAssignment(
stid int REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
cid int , assignmentNumber int , assignmentType varchar(25) ,
grade decimal(5,2) ,
PRIMARY KEY(stid,cid , assignmentNumber , assignmentType) ,
FOREIGN KEY ( cid , assignmentNumber , assignmentType ) REFERENCES Assignment ON DELETE NO ACTION ON UPDATE NO ACTION
)
-----------------------------------------------------------------------------------------------------------------------------------

create table Feedback(
cid int,
number int default 0,
comments varchar(60),
numberOfLikes int,
student_id int,
Primary Key(cid, number),
Foreign key(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
Foreign Key(student_id) REFERENCES Student ON DELETE NO ACTION ON UPDATE NO ACTION
)
-----------------------------------------------------------------------------------------------------------------------------------
create table PromoCode(
code varchar(20) Primary Key,
issueDate datetime,
expiryDate datetime, 
discount decimal(4,2),
admin_id int,
Foreign Key(admin_id) REFERENCES Admins ON DELETE CASCADE ON UPDATE CASCADE
)


-----------------------------------------------------------------------------------------------------------------------------------
create table StudentHasPromocode(
student_id int,
code varchar(20),
Primary Key(student_id, code),
Foreign Key(student_id) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
Foreign Key(code) REFERENCES PromoCode ON DELETE NO ACTION ON UPDATE NO ACTION
)
-----------------------------------------------------------------------------------------------------------------------------------
Create Table StudentRateInstructor(
student_id int,
instId int, 
rate decimal(2,1),
PRIMARY KEY(student_id,instId),
FOREIGN KEY(student_id) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(instId) REFERENCES Instructor ON DELETE NO ACTION ON UPDATE NO ACTION)

-----------------------------------------------------------------------------------------------------------------------------------
Create Table StudentCertifyCourse(
student_id int,
cid int,
issueDate datetime,
PRIMARY KEY (student_id,cid),
FOREIGN KEY(student_id) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE, 
FOREIGN KEY (cid) REFERENCES Course ON DELETE NO ACTION ON UPDATE NO ACTION)


-----------------------------------------------------------------------------------------------------------------------------------

Create Table CoursePrerequisiteCourse(
cid int,
prerequisiteId int,
PRIMARY KEY(cid,prerequisiteId),
FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(prerequisiteId) REFERENCES Course ON DELETE NO ACTION ON UPDATE NO ACTION)

-----------------------------------------------------------------------------------------------------------------------------------

Create Table InstructorTeachCourse(
instId int,
cid int,
PRIMARY KEY(instId,cid),
FOREIGN KEY(instId) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES Course ON DELETE NO ACTION ON UPDATE NO ACTION)

-----------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE addIn(
id int,
cid int,
Super_ID int,
primary key(cid,Super_ID),
FOREIGN KEY(id) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES Course ON DELETE NO ACTION ON UPDATE NO ACTION,
FOREIGN KEY(Super_ID) REFERENCES Instructor ON DELETE NO ACTION ON UPDATE NO ACTION )

-----------------------------------------------------------------------------------------------------------------------------------

go 

create proc studentRegister
@first_name varchar(20), 
@last_name varchar(20), 
@password varchar(20), 
@email varchar(50),
@gender bit, 
@address varchar(10)
as
--DECLARE @variable int

INSERT INTO USERS (firstName,lastName,password,email,gender,address) values (@first_name,@last_name,@password,@email,@gender,@address)
--select @variable=id
--from USERS where USERS.email=@email

DECLARE @var int
Set @var = SCOPE_IDENTITY()

INSERT INTO UserMobileNumber VALUES ( @var , 'NULL' ) 

INSERT INTO Student(id,gpa) values ( @var  ,0.00)

--exec studentRegister 'alia','mohamed','mmm','alia.alia11@gmail.com',1,'aaa'
--drop PROC studentRegister
--SELECT * FROM USERS

go 

create proc InstructorRegister
@first_name varchar(20), 
@last_name varchar(20), 
@password varchar(20), 
@email varchar(50),
@gender bit, 
@address varchar(10)
as
--DECLARE @variable int

DECLARE @var int
Set @var = SCOPE_IDENTITY()

INSERT INTO USERS (firstName,lastName,password,email,gender,address) values (@first_name,@last_name,@password,@email,@gender,@address)
--select @variable=id
--from USERS where USERS.email=@email
INSERT INTO UserMobileNumber VALUES ( @var , 'NULL' ) 

INSERT INTO Instructor(id,rating) values (@var,0.00)

--exec InstructorRegister 'alia','mohamed','mmm','alia.alia@gmail.com',1,'aaa'
DROP PROC InstructorRegister


go 
create proc userLogin
@ID int, 
@password varchar(20),
@Success bit output , 
@Type int output
as
--DECLARE @variable int,
--@pass varchar(20)
--SET @variable=-1


--SELECT @variable=id , @pass=password
--from Users where id=@id and password=@password

IF exists(SELECT * FROM USERS where USERS.id=@id and Users.password =@password)
BEGIN
set @success=1

IF exists ( SELECT * FROM Student where Student.id = @id )
set @type = 2

IF exists ( SELECT * FROM Instructor where Instructor.id = @id )
set @type =1

IF EXISTS ( SELECT * FROM Admins where Admins.id = @id )
set @type = 0


END
ELSE 
BEGIN
set @success =0
set @type=-1
END

--declare @success int, @type int 
--exec userLogin 1,'mmm' ,@success output , @type output 
--print @success 
--PRINT @type

--declare @success int, @type int 
--exec userLogin 2,'aaa' ,@success output , @type output 
--print @success

go
create proc addMobile
@ID int ,
--answered on piazza int not varchar
@mobile_number varchar(20)
as
DECLARE @variable int
SET @variable=-1

SELECT @variable=id 
from Users where id=@id 

IF @variable=@id 
INSERT INTO UserMobileNumber Values (@id,@mobile_number)


-------------------------------------------------------------
go
create Proc AdminListInstr
as
select * 
from Instructor I INNER JOIN USERS U ON I.id=U.id

-----------------------------------------------------------

-- ) view the profile of any instructor that contains all his/her information. 
go 
CREATE PROC AdminViewInstructorProfile
@instrID int
AS
SELECT * FROM Instructor i inner join USERS u 
              on i.id = u.id where i.id = @instrID


--exec studentRegister 'alia','mohamed','mmm','alia@gmail.com',1,'aaa'

--EXEC AdminViewInstructorProfile 1


---------------------
-- c) List all courses in the system. 
go 
CREATE PROC AdminViewAllCourses
AS 
select * from Course


--------------------------
-- d) List all the courses added by instructors not yet accepted. 
GO 
CREATE PROC AdminViewNonAcceptedCourses 
AS
SELECT * FROM Course where Course.accepted = 0 

----------------------------

-- e) View any course details such as course description and content. 

go
CREATE PROC AdminViewCourseDetails
@courseId int
as 
SELECT * FROM Course where Course.id = @courseId

--INSERT INTO COURSE ( name ) VALUES ( 'databases') 

---------------------------------


-- f) Accept/Reject any of the requested courses that are added by instructors. 
GO 
Create PROC AdminAcceptRejectCourse 
@adminID int ,
@courseID int 
AS
UPDATE Course
SET accepted = 1 , adminId = @adminID where Course.id= @courseID



------------------------------
GO
CREATE PROC AdminCreatePromocode 
@code varchar(6), @issueDate datetime, @expiryDate datetime, @discount decimal(4,2), @adminId int 
AS --if exists
INSERT INTO PromoCode values ( @code , @issueDate , @expiryDate , @discount , @adminId )

----------------------------------
go
create proc AdminListAllStudents 
as
select firstName,lastName
from Student S INNER JOIN USERS U ON S.id=U.id

go
create Proc AdminListInstr
as
select * 
from Instructor I INNER JOIN USERS U ON I.id=U.id

-----------------------------------------------------------------------------------------
go
create proc AdminViewStudentProfile
@sid int
as
SELECT* 
FROM USERS U INNER JOIN Student S ON U.id=S.id
where S.id=@sid

----------------------------
go 
create proc AdminIssuePromocodeToStudent 
@sid int, 
@pid varchar(6) 
as
IF exists(Select * from PromoCode where code=@pid) AND EXISTS ( SELECT * FROM Student where id= @sid )
INSERT INTO StudentHasPromocode values (@sid,@pid)

drop proc AdminIssuePromocodeToStudent

------------------------


-------------------------------------------- INSTRUCTOR -------------------------------------------------------------- 

go
create Proc InstAddCourse
@Credithours int ,
@name varchar(10),
@price decimal(6,2),
@instructorId int
as
if exists(select * from Instructor where Instructor.id =@instructorId)
BEGIN 
Insert Into  Course(creditHours,name,price,instructorId) values (@Credithours,@name,@price,@instructorId)
INSERT INTO InstructorTeachCourse ( instId , cid  ) VALUES ( @instructorId , SCOPE_IDENTITY() ) 
END
----------------------------------------
go
create Proc UpdateCourseContent 
@instrId int,
@courseId int ,
@content varchar(20)
as
if exists(select * from InstructorTeachCourse WHERE cid=@courseId and instId=@instrId)
Update Course SET content=@content WHERE 
@courseId=id

------------------------------------------
go
create Proc UpdateCourseDescription
@instrId int,
@courseId int ,
@courseDescription varchar(200)
as
if exists(select * from InstructorTeachCourse WHERE cid=@courseId and instId=@instrId)
Update Course Set courseDescription=@courseDescription WHERE 
@courseId=id

--drop PROC UpdateCourseDescription
-----------------------------------------------
go
create Proc AddAnotherInstructorToCourse 
@insid int,
@cid int,
@adderIns int
as
if exists(select * from Course WHERE id=@cid and instructorId=@adderIns) AND  exists(select * from Instructor WHERE id=@insid)
BEGIN 
Insert Into addIn values (@insid,@cid,@adderIns)
INSERT INTO InstructorTeachCourse VALUES ( @insid , @cid)
END
--drop PROC AddAnotherInstructorToCourse

---------------------------------------------------------
go
create Proc InstructorViewAcceptedCoursesByAdmin
@instrId int
as
IF EXISTS ( SELECT * FROM InstructorTeachCourse WHERE instId = @instrId ) 
SELECT * FROM Course inner join InstructorTeachCourse on instructorId = instId WHERE instId=@instrId and accepted=1

--drop PROC AddAnotherInstructorToCourse

----------------------
go
create Proc DefineCoursePrerequisits
@cid int,
@prerequisiteId int 
as 
if exists(select * from Course WHERE @cid=id)  AND exists (select * from Course WHERE @prerequisiteId = id)
Insert Into CoursePrerequisiteCourse values (@cid,@prerequisiteId)
--------------------------
go
create proc  DefineAssignmentOfCourseOfCertianType 
 @instId int, @cid int , @number int, @type varchar(10), @fullGrade int, @weight decimal(4,1), @deadline datetime, @content varchar(200)
 AS
 IF exists(SELECT * FROM InstructorTeachCourse where instId=@instId)
 INSERT INTO Assignment VALUES(@cid,@number,@type,@fullGrade,@weight,@deadline,@content)
 ----------------------------------------------------------
 go
create proc updateInstructorRate 
 @insid int 
 as 
 DECLARE @var decimal(3,1)
 SELECT @var= avg(rate)
 from StudentRateInstructor where instId = @insid

 update Instructor
 set rating =@var
 where id=@insid

 --drop PROC updateInstructorRate

 -----------------------
 go
 create proc ViewInstructorProfile 
@instrId int
as
SELECT * FROM USERS U INNER JOIN Instructor I ON U.id=I.id
                      INNER JOIN UserMobileNumber M ON I.id=m.id
------------------------------------------------------------------------------------
go
create proc InstructorViewAssignmentsStudents
@instrId int, 
@cid int
as
if exists(select * from InstructorTeachCourse where instId=@InstrId and cid=@cid) 
select * from StudentTakeAssignment

---------------------------------------------------------------------------------
go
create proc InstructorgradeAssignmentOfAStudent 
@instrId int, 
@sid int , 
@cid int, 
@assignmentNumber int, 
@type varchar(10), 
@grade decimal(5,2)
as
declare @variable int 
if exists(select * from InstructorTeachCourse where @instrId=instId and @cid=cid)
update StudentTakeAssignment 
set grade=@grade 
where stid=@sid and cid=@cid and assignmentNumber=@assignmentNumber and assignmentType=@type
---------------------------------------------
go 
create proc ViewFeedbacksAddedByStudentsOnMyCourse 
@instrId int,
@cid int 
as
if exists(select * from InstructorTeachCourse WHERE cid=@cid and instId= @instrId)
select number , comments , numberOfLikes 
from Feedback 
where @cid=cid

 drop PROC ViewFeedbacksAddedByStudentsOnMyCourse

----------------------------------------------------------------------------
----revise because in test cases they didn't divide by the final grade
 go 
create proc calculateFinalGrade
@cid int , 
@sid int , 
@insId int
as 
DECLARE @variable  decimal(4,2) 
if exists(Select * from InstructorTeachCourse where instId=@insId and @cid=cid)
BEGIN
 select @variable= Sum (Grade)
 from ( select s.grade*a.Assign_weight as Grade,a.cid,a.Assign_type,a.number
  from Assignment a INNER JOIN StudentTakeAssignment s on (a.Assign_type = s.assignmentType AND a.number = s.assignmentNumber AND 
  a.cid = s.cid ) where s.stid=@sid and a.cid=@cid ) AS Total
END

 Update  StudentTakeCourse 
  Set grade=@variable
  Where cid=@cid and stid=@sid and instId=@insId
---------------------------------------------------------------------------------------------------

go

create proc InstructorIssueCertificateToStudent 
@cid int , @sid int , @insId int, @issueDate datetime 
As
declare @variable decimal (4,2)
if exists(Select * from StudentTakeCourse where cid=@cid and stid=@sid ) AND EXISTS ( SELECT * FROM InstructorTeachCourse where instId=@insId) 
BEGIN 
Select @variable=grade
from StudentTakeCourse
If(@variable >=50)
    Insert into StudentCertifyCourse values (@sid,@cid,@issueDate)
    END

    

--------------------------------- STUDENT -----------------------------


-- a) View my profile that contains all my information. Signature: 

GO 
CREATE PROC viewMyProfile
@id INT 
AS
SELECT * FROM Users u inner join Student s on u.id = s.id 
               where u.id = @id


-------------------------- 
--b) Edit my profile (change any of my personal information). 

GO 
CREATE PROC editMyProfile 
@id int, 
@firstName varchar(10), @lastName varchar(10), 
@password varchar(10), @gender binary, 
@email varchar(10), @address varchar(10) 
AS 
UPDATE Users 
SET firstName = CASE WHEN @firstName IS NULL THEN firstName
ELSE @firstName END;

UPDATE USERS
SET lastName = CASE WHEN @lastName IS NULL THEN lastName
ELSE @lastName END WHERE id =@id ;

UPDATE USERS
SET password = CASE WHEN @password IS NULL THEN password
ELSE @password END WHERE id =@id ;

UPDATE USERS
SET gender = CASE WHEN @gender IS NULL THEN gender
ELSE @gender END WHERE id =@id ;

UPDATE USERS
SET email = CASE WHEN @email IS NULL THEN email
ELSE @email END WHERE id =@id;

UPDATE USERS
SET address = CASE WHEN @address IS NULL THEN address
ELSE @address END WHERE id =@id;

-----------------------------------------
-- c) List all courses in the system accepted by the admin so I can choose one to enroll( I can not view the course content (URLs to materials unless I enroll in the course). 
GO 
CREATE PROC availableCourses
AS 
SELECT c.name   FROM Course c where c.accepted = 1


--------------------------------------------------------
go 
create Proc courseInformation 
@id int 
as
select C.*,U.firstName , U.lastName
From InstructorTeachCourse ITC inner join Users U On ITC.instId =U.id inner join Course c on ITC.cid = c.id
where instructorId=@id

--drop proc courseInformation

--------------------------------------------------------
go 
create Proc enrollInCourse
@sid INT, @cid INT, @instr int 
as
if exists(select* from InstructorTeachCourse i where i.cid =@cid and i.instId =@instr) AND exists ( select * from Student where id = @sid  )
Insert into StudentTakeCourse(stid,cid,instId) values (@sid ,@cid,@instr)

--drop proc enrollInCourse
---------------------------------------------------------------------------
go
create Proc addCreditCard 
@sid int, @number varchar(15), @cardHolderName varchar(16), @expiryDate datetime, @cvv varchar(3) 
as
Insert into CreditCard values(@number,@cardHolderName,@expiryDate,@cvv)
if exists ( select * from Student where id = @sid  )
Insert into StudentAddCreditCard values(@sid,@number)

--drop proc addCreditCard
-----------------------------------------------------------------

go 
create Proc  viewPromocode 
@sid int 
as
select p.* from
PromoCode p inner join StudentHasPromocode c ON p.code=c.code
WHERE c.student_id=@sid
--------------------------------------------------------------------------
go
create proc payCourse
@cid int,
@sid int
as 
if exists(select * from StudentAddCreditCard where @sid=stid) and exists(select * from StudentTakeCourse where @cid=cid and @sid=stid) 
        and exists(select * from StudentHasPromocode where @sid=student_id)
insert into StudentTakeCourse (stid, cid, payedfor) values (@sid, @cid, 1)
-------------------------------------------------------------------------------------------------
go 
create proc enrollInCourseViewContent
@id int, 
@cid int
as
if exists(select * from StudentTakeCourse where @id=stid and @cid=cid)
select id, creditHours, name, courseDescription, price, content from Course
------------------------------------------------------------------------
go
create proc viewAssign
@courseId int, 
@Sid int
as
if exists ( select * from StudentTakeAssignment where @Sid=stid and @courseId=cid)
select * from Assignment
--------------------------------------------------------------------------
go
create proc submitAssign 
@assignType VARCHAR(10), 
@assignnumber int, 
@sid INT, 
@cid INT 
as
if exists(select * from StudentTakeAssignment where @sid=stid and @cid=cid)
insert into StudentTakeAssignment (stid, cid, assignmentNumber, assignmentType) values (@sid, @cid, @assignnumber, @assignType)
-------------------------------------------------------------------------------------------------------------------
   go
create proc viewAssignGrades
@assignnumber int, 
@assignType VARCHAR(10), 
@cid INT, 
@sid INT,
@assignGrade int output
as

if exists(select * from StudentTakeAssignment STA where @sid=stid and @cid=cid and @assignnumber=assignmentNumber and @assignType=assignmentType)
 
 select @assignGrade=grade from StudentTakeAssignment where @sid=stid and @cid=cid and @assignnumber=assignmentNumber and @assignType=assignmentType

 --drop proc viewAssignGrades

 --declare @assignGrade int 
 --exec viewAssignGrades 1,'quiz',1,7 ,@assignGrade output
 --print @assignGrade
--------------------------------------------------------
go 
create proc viewFinalGrade
@cid INT, 
@sid INT,
@finalgrade decimal(10,2) output
as
if exists(select * from StudentTakeCourse STA where @cid=cid and @sid=stid)
select @finalgrade=grade from StudentTakeCourse where @cid=cid and @sid=stid

-----------------------------------------------------------------------

-- n) I can add feedback for the course I am enrolled in. Signature: Name: addFeedback 
GO 
CREATE PROC addFeedback
@comment VARCHAR(100), @cid INT, @sid INT 
AS
declare @var int 
SELECT @var = max(number) from Feedback where Feedback.cid = @cid
IF EXISTS (  SELECT * FROM  StudentTakeCourse where cid = @cid AND stid  = @sid ) 
BEGIN 

IF EXISTS ( SELECT * FROM Feedback where cid = @cid )
INSERT INTO Feedback ( number ,   student_id , cid , comments ) VALUES (@var + 1, @sid , @cid , @comment ) 
ELSE
INSERT INTO Feedback ( number ,   student_id , cid , comments ) VALUES ( 1, @sid , @cid , @comment ) 


END 


--------------------------------- 
-- o) Rate the instructors of the course I am enrolled in. 
 GO
  CREATE PROC  rateInstructor 
@rate DECIMAL (2,1), @sid INT, @insid INT
AS
if exists ( SELECT * FROM StudentTakeCourse s where s.instId =@insid AND s.stid = @sid )
INSERT INTO StudentRateInstructor VALUES ( @sid , @insid , @rate ) 


-------------------------------------------------------- 

-- L )  List certificates (with all its information )issued to me for a course I had finished. 
GO
CREATE PROC viewCertificate
@cid int , @sid int 
AS
SELECT * FROM StudentCertifyCourse WHERE cid = @cid AND sid = @sid

----------------------------- 




