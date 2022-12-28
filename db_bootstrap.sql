CREATE DATABASE course_connect;
GRANT ALL PRIVILEGES ON course_connect.* TO 'webapp'@'%';
FLUSH PRIVILEGES;

USE course_connect;


CREATE TABLE GuidanceCounselor(
    facultyID INT AUTO_INCREMENT NOT NULL,
    schoolEmail VARCHAR(50) UNIQUE,
    officeLocation TEXT,
    meetingAvailability TEXT,
    prefix TEXT NOT NULL,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    degrees TEXT,
    personalDescription TEXT NOT NULL,
    PRIMARY KEY (facultyID)
);

CREATE TABLE Student(
    stu_id INTEGER AUTO_INCREMENT NOT NULL,
    firstName TEXT NOT NULL,
    middle TEXT,
    lastName TEXT NOT NULL,
    state TEXT NOT NULL,
    city TEXT NOT NULL,
    street TEXT NOT NULL,
    zip INTEGER NOT NULL,
    stuEmail VARCHAR(50) UNIQUE,
    gradYear INTEGER,
    birthDate DATE,
    counselorID INTEGER,
    PRIMARY KEY(stu_id),
    FOREIGN KEY (counselorID) REFERENCES GuidanceCounselor(facultyID)
                    ON UPDATE cascade ON DELETE restrict

);

CREATE TABLE Transcript(
    transcriptID INTEGER AUTO_INCREMENT NOT NULL,
    letterGrade TEXT NOT NULL,
    numGrade TEXT NOT NULL,
    gpaOutOf4 FLOAT NOT NULL,
    gpaOutOf100 FLOAT NULL,
    stu_id INTEGER,
    PRIMARY KEY (transcriptID),
    FOREIGN KEY (stu_id) REFERENCES Student(stu_id)
                       ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Course(
    courseID INTEGER NOT NULL,
    name TEXT,
    difficultyLevel TEXT,
    description TEXT,
    transcriptID INTEGER,
    PRIMARY KEY (courseID),
    FOREIGN KEY (transcriptID) REFERENCES Transcript(transcriptID)
                   ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Section(
    sectionID INTEGER AUTO_INCREMENT NOT NULL,
    roomNum INTEGER,
    startTime VARCHAR(10),
    endTime VARCHAR(10),
    classSize INTEGER,
    courseID INTEGER,
    PRIMARY KEY (sectionID),
    FOREIGN KEY (courseID) REFERENCES Course(courseID)
                    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Administration(
    facultyID INTEGER,
    schoolEmail VARCHAR(50) UNIQUE,
    officeLocation TEXT,
    meetingAvailability TEXT,
    prefix TEXT NOT NULL,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    degrees TEXT,
    personalDescription TEXT NOT NULL,
    position TEXT NOT NULL,
    PRIMARY KEY (facultyID)
);

CREATE TABLE Teacher(
    facultyID INTEGER,
    zoomLink VARCHAR(200) UNIQUE ,
    officeHours TEXT,
    prefix TEXT NOT NULL,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    degrees TEXT,
    personalDescription TEXT NOT NULL,
    schoolEmail VARCHAR(50) UNIQUE ,
    bossID INTEGER,
    PRIMARY KEY (facultyID),
    FOREIGN KEY (bossID) REFERENCES Administration(facultyID)
                    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Nurse(
    facultyID INTEGER,
    RoomLocation TEXT NOT NULL,
    prefix TEXT NOT NULL,
    firstName TEXT NOT NULL,
    lastName TEXT NOT NULL,
    schoolEmail VARCHAR(50) UNIQUE,
    degrees TEXT,
    personalDescription TEXT NOT NULL,
    walkInHours TEXT,
    PRIMARY KEY (facultyID)
);


CREATE TABLE Assignment(
    name VARCHAR(50),
    grade INTEGER,
    comment TEXT,
    weight FLOAT,
    courseID INTEGER,
    PRIMARY KEY (name),
    FOREIGN KEY (courseID) REFERENCES Course(courseID)
                       ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE LetterGrades(
    transcriptID INTEGER,
    letterGrade VARCHAR(4),
    PRIMARY KEY (letterGrade),
    FOREIGN KEY (transcriptID) REFERENCES Transcript(transcriptID)
                         ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE NumberGrades(
    transcriptID INTEGER,
    numberGrade FLOAT,
    PRIMARY KEY (numberGrade),
    FOREIGN KEY (transcriptID) REFERENCES Transcript(transcriptID)
                         ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Guardian(
    guardID INTEGER AUTO_INCREMENT NOT NULL,
    firstName VARCHAR(20) NOT NULL,
    middle VARCHAR(20),
    lastName VARCHAR(20) NOT NULL,
    phone VARCHAR(18) UNIQUE ,
    email VARCHAR(50) UNIQUE ,
    relationship TEXT,
    state TEXT NOT NULL,
    city TEXT NOT NULL,
    street TEXT NOT NULL,
    zip INTEGER NOT NULL,
    stu_id INTEGER,
    PRIMARY KEY (guardID),
    FOREIGN KEY (stu_id) REFERENCES Student(stu_id)
                     ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Student_Guardian(
    stu_id INTEGER,
    guardID INTEGER,
    FOREIGN KEY (stu_id) REFERENCES Student(stu_id),
    FOREIGN KEY (guardID) REFERENCES Guardian(guardID)
                             ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE NurseDegrees(
    nurseID INTEGER,
    nDegrees VARCHAR(70),
    PRIMARY KEY (nDegrees),
    FOREIGN KEY (nurseID) REFERENCES Nurse(facultyID)
                         ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE TeacherDegrees(
    teacherID INTEGER,
    tDegrees VARCHAR(70),
    PRIMARY KEY (tDegrees),
    FOREIGN KEY (teacherID) REFERENCES Teacher(facultyID)
                           ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE gcDegrees(
    counselorID INTEGER,
    gDegrees VARCHAR(70),
    PRIMARY KEY (gDegrees),
    FOREIGN KEY (counselorID) REFERENCES GuidanceCounselor(facultyID)
                      ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE AdminDegrees(
    adminID INTEGER,
    aDegree VARCHAR(70),
    PRIMARY KEY (aDegree),
    FOREIGN KEY (adminID) REFERENCES Administration(facultyID)
                         ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Extracurricular(
    clubName VARCHAR(10),
    numMembers INTEGER,
    meetTimes DATETIME,
    supervisor INTEGER,
    PRIMARY KEY (clubName),
    FOREIGN KEY (supervisor) REFERENCES Teacher(facultyID)
                            ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE MeetTimes(
    clubName VARCHAR(10),
    meetTimes DATETIME,
    PRIMARY KEY (meetTimes),
    FOREIGN KEY (clubName) REFERENCES Extracurricular(clubName)
                      ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Student_Extracurricular(
    stu_id INTEGER,
    clubName VARCHAR(10),
    FOREIGN KEY (stu_id) REFERENCES Student(stu_id)
                                    ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (clubName) REFERENCES Extracurricular(clubName)
                                    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Admin_Student(
    adminID INTEGER,
    stu_id INTEGER,
    FOREIGN KEY (adminID) REFERENCES Administration(facultyID)
                          ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (stu_id) REFERENCES Student(stu_id)
                          ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Student_Course(
    stu_id INTEGER,
    courseID INTEGER,
    numberGrade FLOAT NOT NULL,
    letterGrade TEXT NOT NULL,
    FOREIGN KEY (stu_id) REFERENCES Student(stu_id)
                           ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (courseID) REFERENCES Course(courseID)
                           ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Teacher_Course(
    teacherID INTEGER,
    courseID INTEGER,
    FOREIGN KEY (teacherID) REFERENCES Teacher(facultyID)
                           ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (courseID) REFERENCES Course(courseID)
                           ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Teacher_Extracurricular(
    teacherID INTEGER,
    clubName VARCHAR(10),
    FOREIGN KEY (teacherID) REFERENCES Teacher(facultyID)
                                    ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (clubName) REFERENCES Extracurricular(clubName)
                                    ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Student_Nurse(
    stu_id INTEGER,
    nurseID INTEGER,
    equipMed VARCHAR(70),
    conditions VARCHAR(70),
    FOREIGN KEY (stu_id) REFERENCES Student(stu_id)
                          ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (nurseID) REFERENCES Nurse(facultyID)
                          ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE EquipMed(
    equipMed VARCHAR(70),
    stu_id INTEGER,
    nurseID INTEGER,
    PRIMARY KEY (equipMed),
    FOREIGN KEY (stu_id) REFERENCES Student_Nurse(stu_id)
                     ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (nurseID) REFERENCES Student_Nurse(nurseID)
                     ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Conditions(
    conditions VARCHAR(70),
    stu_id INTEGER,
    nurseID INTEGER,
    PRIMARY KEY (conditions),
    FOREIGN KEY (stu_id) REFERENCES Student_Nurse(stu_id)
                       ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (nurseID) REFERENCES Student_Nurse(nurseID)
                       ON UPDATE cascade ON DELETE restrict
);

CREATE TABLE Course_wishlist(
    stu_id INTEGER,
    courseid INTEGER,
    FOREIGN KEY (stu_id) REFERENCES Student(stu_id)
                            ON UPDATE cascade ON DELETE restrict,
    FOREIGN KEY (courseid) REFERENCES Course(courseID)
                            ON UPDATE cascade ON DELETE restrict
);

insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Dr', 'Fanechka', 'Swindin', 'fswindin0@soundcloud.com', 65, 'Etiam pretium iaculis justo.', 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 'Sales');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Mr', 'Agatha', 'Georgeau', 'ageorgeau1@ucoz.com', 108, 'Nunc rhoncus dui vel sem. Sed sagittis.', 'Suspendisse potenti.', 'Legal');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Dr', 'Agnes', 'Worters', 'aworters2@discovery.com', 103, 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus.', 'Support');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Mr', 'Brooks', 'McKibbin', 'bmckibbin3@mayoclinic.com', 98, 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', 'Morbi porttitor lorem id ligula.', 'Engineering');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Rev', 'Krystalle', 'Boness', 'kboness4@technorati.com', 112, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'In hac habitasse platea dictumst.', 'Sales');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Rev', 'Winthrop', 'Pattingson', 'wpattingson5@tamu.edu', 248, 'Duis at velit eu est congue elementum.', 'Sed ante. Vivamus tortor.', 'Business Development');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Ms', 'Charis', 'Fredi', 'cfredi6@blinklist.com', 251, 'In congue.', 'In quis justo.', 'Sales');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Rev', 'Rhodia', 'Fleisch', 'rfleisch7@myspace.com', 120, 'Proin interdum mauris non ligula pellentesque ultrices.', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'Services');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Mrs', 'Jackelyn', 'Armitt', 'jarmitt8@constantcontact.com', 101, 'Curabitur at ipsum ac tellus semper interdum.', 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Human Resources');
insert into GuidanceCounselor (prefix, firstname, lastname, schoolEmail, officeLocation, meetingAvailability, personalDescription, degrees) values ('Ms', 'Jarad', 'Wincer', 'jwincer9@jiathis.com', 110, 'Integer ac neque. Duis bibendum.', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', 'Marketing');

insert into Administration (facultyID, prefix, firstName, lastName, schoolEmail, position, officeLocation, meetingAvailability, degrees, personaldescription) values (11, 'Rev', 'Auria', 'Pennicard', 'apennicard0@biglobe.ne.jp', 'Environmental Specialist', 270, 'Praesent id massa id nisl venenatis lacinia.', 'Support', 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.');
insert into Administration (facultyID, prefix, firstName, lastName, schoolEmail, position, officeLocation, meetingAvailability, degrees, personaldescription) values (12, 'Rev', 'Karissa', 'Lamb-shine', 'klambshine1@blogtalkradio.com', 'Tax Accountant', 241, 'Morbi a ipsum. Integer a nibh.', 'Sales', 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.');
insert into Administration (facultyID, prefix, firstName, lastName, schoolEmail, position, officeLocation, meetingAvailability, degrees, personaldescription) values (13, 'Mrs', 'Baxter', 'Rosborough', 'brosborough2@gravatar.com', 'Recruiter', 93, 'In quis justo. Maecenas rhoncus aliquam lacus.', 'Training', 'Proin at turpis a pede posuere nonummy.');

insert into Assignment (name, grade, comment, weight) values ('nonummy integer non velit donec', 38.56, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', 24);
insert into Assignment (name, grade, comment, weight) values ('pede', 36.76, 'In quis justo. Maecenas rhoncus aliquam lacus.', 39);
insert into Assignment (name, grade, comment, weight) values ('fermentum justo nec condimentum neque sapien', 30.21, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 91);
insert into Assignment (name, grade, comment, weight) values ('eget vulputate ut', 87.93, 'Phasellus id sapien in sapien iaculis congue.', 7);
insert into Assignment (name, grade, comment, weight) values ('praesent blandit lacinia erat', 16.88, 'In sagittis dui vel nisl.', 75);
insert into Assignment (name, grade, comment, weight) values ('tincidunt eget tempus vel', 68.56, 'Etiam vel augue.', 88);
insert into Assignment (name, grade, comment, weight) values ('ac consequat metus sapien ut', 75.86, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 89);
insert into Assignment (name, grade, comment, weight) values ('dapibus at diam nam tristique tortor', 89.5, 'Nam nulla.', 42);
insert into Assignment (name, grade, comment, weight) values ('urna ut tellus nulla ut erat', 53.06, 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', 36);
insert into Assignment (name, grade, comment, weight) values ('bibendum morbi non quam nec', 60.76, 'Duis at velit eu est congue elementum.', 55);

insert into Course (courseID, name, difficultyLevel, description) values (1, 'Accounting', 'AP', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (2, 'Word processing', 'Standard', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (3, 'Italian', 'Standard', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (4, 'Entrepreneurial skills', 'Standard', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (5, 'Communication skills', 'Honors', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (6, 'Computer programming', 'Honors', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (7, 'American literature', 'AP', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (8, 'United States History', 'Standard', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (9, 'English language and composition', 'Standard', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (10, 'Music production', 'Honors', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (11, 'Web design', 'AP', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (12, 'Italian', 'Standard', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (13, 'Debate', 'AP', 'here is a description of this course.');
insert into Course (courseID, name, difficultyLevel, description) values (14, 'Contemporary literature', 'Honors', 'here is a description of this course.');

insert into Extracurricular (clubName, numMembers, meetTimes) values ('maecenas', 77, '2022-03-30 23:32:43');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('est', 17, '2021-11-10 23:15:57');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('pulvinar', 75, '2021-12-30 08:38:24');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('nullam', 53, '2022-05-29 07:17:07');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('nibh', 47, '2022-06-09 04:55:08');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('eros', 97, '2022-04-29 05:39:13');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('tortor', 13, '2021-11-10 11:08:43');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('dui', 28, '2021-11-07 17:39:05');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('pede', 91, '2021-09-18 09:43:07');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('ut', 25, '2022-01-19 01:28:51');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('ni', 31, '2022-04-18 16:45:39');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('ligula', 7, '2022-04-22 09:45:59');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('sociis', 27, '2022-06-14 05:02:12');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('blandit', 19, '2021-11-29 16:05:52');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('vestibulum', 25, '2021-10-03 05:20:56');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('odio', 27, '2021-11-17 09:06:10');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('diam', 11, '2021-09-20 09:22:27');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('feugiat', 92, '2022-04-09 09:07:51');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('nul', 7, '2022-03-09 12:07:33');
insert into Extracurricular (clubName, numMembers, meetTimes) values ('platea', 33, '2022-03-26 17:04:12');

insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Mariann', 'Ira', 'Frogley', 'ifrogley0@umich.edu', '317-301-7171', 'cousin', 'Indiana', '385 Hayes Plaza', 'Indianapolis', '46295');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Hillard', 'Ysabel', 'Turbefield', 'yturbefield1@jalbum.net', '510-558-6367', 'brother', 'California', '3360 Tennessee Trail', 'Berkeley', '94705');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Napoleon', 'Hagan', 'Linkie', 'hlinkie2@wisc.edu', '563-514-6945', 'father', 'Iowa', '9 Lien Circle', 'Davenport', '52809');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Selena', 'Jody', 'Castree', 'jcastree3@fotki.com', '202-749-1957', 'grandmother', 'District of Columbia', '09 Meadow Ridge Road', 'Washington', '20546');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Georgy', 'Melania', 'Negal', 'mnegal4@hexun.com', '251-637-0785', 'family friend', 'Alabama', '724 Russell Plaza', 'Mobile', '36689');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Jaine', 'Lindon', 'McColm', 'lmccolm5@google.es', '706-888-9539', 'grandfather', 'Georgia', '56310 Johnson Way', 'Augusta', '30919');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Pammy', 'Kristel', 'Swendell', 'kswendell6@jiathis.com', '806-957-2642', 'uncle', 'Texas', '4431 Golf Hill', 'Amarillo', '79171');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Melonie', 'Bondy', 'Colbran', 'bcolbran7@ow.ly', '760-659-4301', 'uncle', 'California', '85094 Haas Street', 'Carlsbad', '92013');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Brandyn', 'Matthieu', 'Belward', 'mbelward8@sciencedaily.com', '205-232-8862', 'sister', 'Alabama', '8381 Stoughton Street', 'Birmingham', '35236');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Ross', 'Gratiana', 'Riddick', 'griddick9@sohu.com', '561-809-3614', 'grandmother', 'Florida', '26 Eagle Crest Avenue', 'West Palm Beach', '33421');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Colin', 'Ealasaid', 'Muxworthy', 'emuxworthya@google.com.hk', '503-230-8669', 'sister', 'Oregon', '477 Hallows Parkway', 'Beaverton', '97075');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Fitzgerald', 'Laurie', 'Gisburn', 'lgisburnb@mapquest.com', '530-223-0615', 'cousin', 'California', '7348 Kipling Court', 'South Lake Tahoe', '96154');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Elayne', 'Curran', 'Eaglen', 'ceaglenc@google.pl', '937-251-8002', 'brother', 'Ohio', '2224 Killdeer Plaza', 'Dayton', '45419');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Shena', 'Claire', 'Rimmer', 'crimmerd@businesswire.com', '408-205-5675', 'cousin', 'California', '724 Sutteridge Park', 'San Jose', '95113');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Mack', 'Verina', 'Keymer', 'vkeymere@live.com', '704-428-9118', 'uncle', 'North Carolina', '03 Evergreen Way', 'Charlotte', '28256');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Hewet', 'Idelle', 'Strowther', 'istrowtherf@netscape.com', '314-893-0286', 'mother', 'Missouri', '923 Anniversary Junction', 'Saint Louis', '63104');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Fawne', 'Tersina', 'Serchwell', 'tserchwellg@eepurl.com', '218-674-2680', 'mother', 'Minnesota', '791 Memorial Road', 'Duluth', '55805');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Isidora', 'Chloris', 'Creebo', 'ccreeboh@guardian.co.uk', '757-965-4772', 'uncle', 'Virginia', '570 Pawling Crossing', 'Norfolk', '23514');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Gardie', 'Borg', 'MacAvaddy', 'bmacavaddyi@howstuffworks.com', '701-142-9361', 'family friend', 'North Dakota', '42545 Magdeline Center', 'Grand Forks', '58207');
insert into Guardian (firstName, middle, lastName, email, phone, relationship, state, street, city, zip) values ('Elisa', 'Dorolice', 'Backe', 'dbackej@marketwatch.com', '979-905-5782', 'grandfather', 'Texas', '9388 Bartillon Parkway', 'College Station', '77844');

insert into Nurse (facultyID, firstName, lastName, schoolEmail, roomLocation, prefix, degrees, walkInHours, PersonalDescription) values (14, 'Giulia', 'Feltham', 'gfeltham0@sfgate.com', 283, 'Mr', 'Integer a nibh. In quis justo.', 'Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Ut at dolor quis odio consequat varius.');
insert into Nurse (facultyID, firstName, lastName, schoolEmail, roomLocation, prefix, degrees, walkInHours, PersonalDescription) values (15, 'Anna-maria', 'Horry', 'ahorry1@tripadvisor.com', 23, 'Honorable', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam.', 'Aliquam erat volutpat.');

insert into Section (roomNum, startTime, endTime, classSize) values (2, '11:49 AM', '11:30 AM', 19);
insert into Section (roomNum, startTime, endTime, classSize) values (72, '10:07 AM', '10:24 AM', 21);
insert into Section (roomNum, startTime, endTime, classSize) values (217, '9:14 AM', '11:41 AM', 37);
insert into Section (roomNum, startTime, endTime, classSize) values (295, '1:02 PM', '9:06 AM', 29);
insert into Section (roomNum, startTime, endTime, classSize) values (78, '1:06 PM', '12:44 PM', 13);
insert into Section (roomNum, startTime, endTime, classSize) values (115, '11:46 AM', '9:49 AM', 12);
insert into Section (roomNum, startTime, endTime, classSize) values (241, '1:01 PM', '2:04 PM', 17);
insert into Section (roomNum, startTime, endTime, classSize) values (98, '12:11 PM', '2:18 PM', 24);
insert into Section (roomNum, startTime, endTime, classSize) values (194, '12:39 PM', '1:23 PM', 23);
insert into Section (roomNum, startTime, endTime, classSize) values (2, '10:52 AM', '12:08 PM', 33);
insert into Section (roomNum, startTime, endTime, classSize) values (28, '10:55 AM', '1:10 PM', 10);
insert into Section (roomNum, startTime, endTime, classSize) values (289, '1:22 PM', '1:17 PM', 25);
insert into Section (roomNum, startTime, endTime, classSize) values (122, '12:56 PM', '9:43 AM', 31);
insert into Section (roomNum, startTime, endTime, classSize) values (194, '11:13 AM', '9:58 AM', 28);
insert into Section (roomNum, startTime, endTime, classSize) values (70, '1:13 PM', '2:39 PM', 39);
insert into Section (roomNum, startTime, endTime, classSize) values (175, '9:02 AM', '9:56 AM', 19);
insert into Section (roomNum, startTime, endTime, classSize) values (186, '12:46 PM', '10:19 AM', 10);
insert into Section (roomNum, startTime, endTime, classSize) values (155, '10:53 AM', '9:03 AM', 17);
insert into Section (roomNum, startTime, endTime, classSize) values (240, '1:58 PM', '12:49 PM', 35);
insert into Section (roomNum, startTime, endTime, classSize) values (33, '1:37 PM', '2:31 PM', 25);

insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Torr', 'Colline', 'Pryke', 'Colorado', '6 Shelley Drive', 'Greeley', '914214', 'cpryke0@twitpic.com', 2024, '2015-06-10 01:57:12');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Doralynn', 'Gunilla', 'Cubbino', 'Michigan', '6 Hagan Avenue', 'Detroit', '948830', 'gcubbino1@mozilla.org', 2028, '2010-02-10 19:11:12');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Silvain', 'Corty', 'Duff', 'Oklahoma', '66074 Arapahoe Point', 'Oklahoma City', '725525', 'cduff2@usatoday.com', 2037, '2015-12-30 23:15:21');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Janeczka', 'Cozmo', 'Garrood', 'Kentucky', '8251 Loftsgordon Avenue', 'Louisville', '399752', 'cgarrood3@cdbaby.com', 2028, '2013-02-17 00:46:59');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Amos', 'Celinka', 'Accum', 'Florida', '3240 Kropf Avenue', 'Miami', '690618', 'caccum4@state.gov', 2023, '2006-09-15 06:45:26');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Monty', 'Darryl', 'Ruselin', 'Georgia', '23 Straubel Crossing', 'Atlanta', '086304', 'druselin5@godaddy.com', 2033, '2004-08-14 16:13:44');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Mable', 'Kyrstin', 'Kobu', 'South Carolina', '2 Roxbury Junction', 'Greenville', '321556', 'kkobu6@msu.edu', 2036, '2004-02-13 00:56:40');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Kerri', 'Pennie', 'Casel', 'Louisiana', '874 Morningstar Terrace', 'Alexandria', '397717', 'pcasel7@icio.us', 2028, '2012-01-14 03:12:15');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Collete', 'Abrahan', 'Rixon', 'Kentucky', '1633 Sunbrook Avenue', 'Louisville', '201662', 'arixon8@google.co.jp', 2029, '2008-07-30 12:17:55');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Carmen', 'Miner', 'Brychan', 'California', '59 Nelson Crossing', 'San Luis Obispo', '954021', 'mbrychan9@dion.ne.jp', 2038, '2013-05-06 11:09:21');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Gwennie', 'Elga', 'Potkin', 'Georgia', '92 Maple Plaza', 'Atlanta', '650319', 'epotkina@storify.com', 2040, '2009-10-14 05:17:37');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Valaree', 'Willyt', 'Conibere', 'Arizona', '341 Colorado Court', 'Phoenix', '323940', 'wconibereb@cdbaby.com', 2037, '2013-09-30 22:44:13');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Gordan', 'Geoffrey', 'Foston', 'California', '4608 Annamark Center', 'Northridge', '409581', 'gfostonc@ihg.com', 2034, '2009-12-10 22:05:55');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Andy', 'Thebault', 'Cheale', 'Michigan', '642 Straubel Parkway', 'Lansing', '315927', 'tchealed@netlog.com', 2033, '2007-11-01 21:34:34');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Jeremie', 'Anetta', 'McGann', 'District of Columbia', '47176 Kipling Point', 'Washington', '896484', 'amcganne@irs.gov', 2029, '2005-11-29 08:56:50');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Friedrick', 'Stefania', 'Bradbeer', 'Maryland', '1728 Jenifer Point', 'Baltimore', '747019', 'sbradbeerf@canalblog.com', 2039, '2015-02-13 20:45:52');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Kate', 'Beatrisa', 'Le Friec', 'Georgia', '343 Lyons Parkway', 'Atlanta', '974490', 'blefriecg@blinklist.com', 2027, '2011-04-15 17:39:17');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Clarice', 'Mordecai', 'Kerwood', 'Texas', '03 Eagan Center', 'Houston', '489047', 'mkerwoodh@tuttocitta.it', 2029, '2013-05-20 14:57:33');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Martynne', 'Fran', 'Tudge', 'Texas', '52391 Haas Court', 'Houston', '392081', 'ftudgei@amazon.co.uk', 2025, '2008-08-17 18:59:46');
insert into Student (firstName, middle, lastName, state, street, city, zip, stuEmail, gradYear, birthDate) values ('Alexandro', 'Denny', 'Blanchflower', 'Montana', '1064 Hintze Plaza', 'Billings', '289394', 'dblanchflowerj@miibeian.gov.cn', 2024, '2004-02-01 12:15:49');

insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (16, 'Zebulen', 'Valentim', 'zvalentim0@cornell.edu', 'Dr', 'Aliquam erat volutpat. In congue. Etiam justo.', 'In eleifend quam a odio.', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (17, 'Winona', 'Brosini', 'wbrosini1@skyrock.com', 'Rev', 'Aenean auctor gravida sem.', 'Pellentesque at nulla. Suspendisse potenti.', 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (18, 'Genny', 'Robardet', 'grobardet2@gmpg.org', 'Honorable', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (19, 'Lambert', 'Domingues', 'ldomingues3@studiopress.com', 'Ms', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Suspendisse potenti.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (20, 'Phaidra', 'Pele', 'ppele4@businessweek.com', 'Dr', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum.', 'In congue.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (21, 'Boyd', 'Finder', 'bfinder5@usa.gov', 'Honorable', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst.', 'Proin eu mi. Nulla ac enim.', 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (22, 'Katrinka', 'Moth', 'kmoth6@smugmug.com', 'Mr', 'Aliquam non mauris. Morbi non lectus.', 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (23, 'Kain', 'Attenbrough', 'kattenbrough7@utexas.edu', 'Mrs', 'Aenean lectus.', 'Maecenas pulvinar lobortis est. Phasellus sit amet erat.', 'Sed ante. Vivamus tortor.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (24, 'Ransell', 'MacSherry', 'rmacsherry8@patch.com', 'Dr', 'Morbi a ipsum. Integer a nibh. In quis justo.', 'Aenean sit amet justo. Morbi ut odio.', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (25, 'Jillene', 'Ohms', 'johms9@dagondesign.com', 'Dr', 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'Suspendisse accumsan tortor quis turpis. Sed ante.', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (26, 'Tansy', 'von Nassau', 'tvonnassaua@wufoo.com', 'Mrs', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Aliquam erat volutpat.', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (27, 'Mart', 'McShane', 'mmcshaneb@wp.com', 'Ms', 'Nulla ac enim.', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (28, 'Putnam', 'Dohmer', 'pdohmerc@dagondesign.com', 'Honorable', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (29, 'Elyn', 'MacAree', 'emacareed@wsj.com', 'Rev', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (30, 'Willyt', 'Goulbourne', 'wgoulbournee@ucoz.com', 'Mr', 'Cras non velit nec nisi vulputate nonummy.', 'In eleifend quam a odio. In hac habitasse platea dictumst.', 'Curabitur convallis.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (31, 'Eldin', 'Dumbleton', 'edumbletonf@msu.edu', 'Ms', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'Proin risus.', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (32, 'Adrea', 'Wortman', 'awortmang@nifty.com', 'Mrs', 'Nulla tempus.', 'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', 'Morbi quis tortor id nulla ultrices aliquet.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (33, 'Darb', 'Beau', 'dbeauh@cocolog-nifty.com', 'Mrs', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis.', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (34, 'Nettie', 'Garmanson', 'ngarmansoni@senate.gov', 'Ms', 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.');
insert into Teacher (facultyID, firstName, lastName, Schoolemail, prefix, officeHours, degrees, personalDescription) values (35, 'Robby', 'Ragless', 'rraglessj@angelfire.com', 'Honorable', 'Nam nulla.', 'Suspendisse accumsan tortor quis turpis.', 'Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.');


insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('F, A, B, A, B, C, A', '55, 94, 82, 95, 88, 78, 90', 2.934, 83.912);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, C, B, D, B, A, B', '92, 76, 83, 67, 89, 90, 83', 2.068, 78.546);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, A, A, B, A, A, A', '99, 92, 94, 84, 90, 90, 91', 3.877, 90.524);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('B, B, C, A, A, A, B', '83, 84, 77, 90, 99, 95, 85', 2.757, 85.039);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('B, C, C, C, A, D, C', '88, 74, 73, 77, 98, 66, 72', 1.262, 68.37);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, B, A, B, A, A, A', '90, 84, 94, 89, 94, 100, 99', 3.977, 94.788);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, B, C, C, C, B, C', '99, 84, 72, 77, 74, 87, 79', 2.524, 77.644);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('F, A, A, A, A, B, A', '52, 99, 93, 95, 96, 87, 91', 2.727, 82.663);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, F, D, C, B, C, D', '97, 44, 68, 72, 89, 70, 60', 1.956, 66.019);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, B, C, B, B, B, B', '94, 87, 72, 80, 89, 83, 84', 3.219, 85.987);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('F, D, C, B, B, C, D', '49, 67, 74, 89, 84, 76, 62', 1.974, 67.581);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('C, C, C, B, D, C, A', '73, 78, 79, 87, 64, 71, 90', 2.465, 75.634);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, A, A, A, A, A, A', '100, 98, 97, 99, 96, 100, 99', 3.918, 98.46);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, D, C, B, A, C, B', '98, 63, 78, 89, 92, 77, 83', 2.343, 76.725);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, A, C, C, D, C, C', '94, 98, 77, 72, 65, 77, 70', 2.308, 74.216);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('D, A, D, F, D, C, C', '66, 90, 67, 48, 65, 71, 73', 1.334, 66.029);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('C, B, B, B, B, A, B', '78, 88, 88, 88, 89, 90, 84', 3.009, 84.075);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('F, A, A, C, A, A, A', '59, 99, 100, 71, 94, 95, 90', 2.856, 82.946);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('A, A, A, A, A, A, A', '100, 100, 99, 99, 98, 100, 100', 3.998, 99.278);
insert into Transcript (letterGrade, numGrade, gpaOutOf4, gpaOutOf100) values ('C, F, F, B, A, C, C', '77, 58, 50, 88, 96, 77, 74', 2.145, 70.657);