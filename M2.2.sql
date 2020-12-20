Create Database GUCeraaMS2_3

go
use GUCeraaMS2_3

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
grade smallint,
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
cid int  REFERENCES Course ON DELETE NO ACTION ON UPDATE NO ACTION,
assignmentNumber int REFERENCES Assignment.number ON DELETE NO ACTION ON UPDATE NO ACTION ,
assignmentType varchar(25) REFERENCES Assignment.Assign_type ON DELETE NO ACTION ON UPDATE NO ACTION  ,
grade int ,
PRIMARY KEY(stid,cid)
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
issueDate int,
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
FOREIGN KEY(id) REFERENCES Instructor.id ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(Super_ID) REFERENCES Instructor.id ON DELETE CASCADE ON UPDATE CASCADE

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

INSERT INTO Student(id,gpa) values ( SCOPE_IDENTITY() ,0.00)

--exec studentRegister 'alia','mohamed','mmm','alia.alia11@gmail.com',1,'aaa'

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

INSERT INTO USERS (firstName,lastName,password,email,gender,address) values (@first_name,@last_name,@password,@email,@gender,@address)
--select @variable=id
--from USERS where USERS.email=@email

INSERT INTO Instructor(id,rating) values (SCOPE_IDENTITY(),0.00)

--exec InstructorRegister 'alia','mohamed','mmm','alia.alia@gmail.com',1,'aaa'



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
@ID varchar(20),
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
IF exists(Select * from PromoCode where code=@pid)
INSERT INTO StudentHasPromocode values (@sid,@pid)

------------------------
go
create Proc InstAddCourse
@Credithours int ,
@name varchar(10),
@price decimal(6,2),
@instructorId int
as
if exists(select * from Instructor where Instructor.id =@instructorId)
Insert Into  Course(creditHours,name,price,instructorId) values (@Credithours,@name,@price,@instructorId)
----------------------------------------
go
create Proc UpdateCourseContent 
@instrId int,
@courseId int ,
@content varchar(20)
as
if exists(select * from Course WHERE id=@courseId and instructorId=@instrId)
Update Course SET content=@content WHERE 
@courseId=Course.id
------------------------------------------
go
create Proc UpdateCourseDescription
@instrId int,
@courseId int ,
@courseDescription varchar(200)
as
if exists(select * from Course WHERE id=@courseId and instructorId=@instrId)
Update Course Set courseDescription=@courseDescription WHERE 
Course.id=@courseId
-----------------------------------------------
go
create Proc AddAnotherInstructorToCourse 
@insid int,
@cid int,
@adderIns int
as
if exists(select * from Course WHERE id=@cid and instructorId=@adderIns) AND  exists(select * from Instructor WHERE id=@insid)
Insert Into addIn values (@insid,@cid,@adderIns)
---------------------------------------------------------
go
create Proc InstructorViewAcceptedCoursesByAdmin
@instrId int
as
select * from Course where instructorId=@instrId and accepted=1
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
 as
 IF exists(SELECT * FROM InstructorTeachCourse where instId=@instId)
 INSERT INTO Assignment VALUES(@cid,@number,@type,@fullGrade,@weight,@deadline,@content)
 ----------------------------------------------------------
 go
create proc updateInstructorRate 
 @insid int 
 as 
 DECLARE @var decimal(3,1)
 SELECT @var= avg(rate)
 from StudentRateInstructor

 update Instructor
 set rating =@var
 where id=@insid
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
if exists(select * from Course WHERE id=@cid and instructorId= @instrId)
select number, comment,numberOfLikes 
from feeddback 
where @cid=cid
----------------------------------------------------------------------------
--K) is still missing 
---------------------------------------------------------------------------------------------------




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
