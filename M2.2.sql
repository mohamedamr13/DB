Create Database GUCeraaMS2_2

go
use GUCeraaMS2_2

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
rating int,
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
gpa float,
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
assignmentNumber int ,
assignmentType int ,
grade int ,
PRIMARY KEY(stid,cid)
)
-----------------------------------------------------------------------------------------------------------------------------------

create table Feedback(
cid int,
number int,
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
discount decimal(3,2),
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
rate decimal(10,1),
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

INSERT INTO Student(id,gpa) values ( SCOPE_IDENTITY() ,NULL)

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

INSERT INTO Instructor(id,rating) values (SCOPE_IDENTITY(),NULL)

--exec InstructorRegister 'alia','mohamed','mmm','alia.alia@gmail.com',1,'aaa'



go 
create proc userLogin
@ID int, 
@password varchar(20),
@Success bit output , 
@Type int output
as
DECLARE @variable int,
@pass varchar(20)
SET @variable=-1


SELECT @variable=id , @pass=password
from Users where id=@id and password=@password

IF @variable = @id and @pass =@password
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
set @success =0

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
AS 
INSERT INTO PromoCode values ( @code , @issueDate , @expiryDate , @discount , @adminId )





