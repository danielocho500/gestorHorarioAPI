DROP database IF exists gestorhorario;
create database gestorHorario;
use gestorHorario;

CREATE TABLE Rol (
	id int NOT NULL auto_increment,
	nombre varchar(50) NOT NULL,
    primary key(id)
);

insert into ROL (nombre) values ('Estudiante');
insert into ROL (nombre) values ('Profesor');
insert into ROL (nombre) value ('Secretario');
insert into ROL (nombre) values ('Administrador');

CREATE TABLE Usuario (
	uid int NOT NULL auto_increment,
    correo varchar(100) NOT NULL,
    password varchar(200) NOT NULL,
    isActivo tinyint NOT NULL,
    primerNombre varchar(100)  NOT NULL,
	segundoNombre varchar(100),
    primerApellido varchar(100)  NOT NULL,
	segundoApellido varchar(100),
    rol int NOT NULL,
    fechaNacimiento datetime NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    claveEmpleado varchar(100) NULL,
    matricula varchar(100) NULL,
    PRIMARY KEY (uid),
    FOREIGN KEY (rol) REFERENCES Rol(id)
);

CREATE TABLE Periodo (
	id int NOT NULL auto_increment,
    fechaInicio date NOT NULL,
    fechaFin date,
    fechaOrdinario date,
    fechaExtra date,
    activo tinyint NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id)
);

create table area(
	id int NOT NULL auto_increment,
    nombre varchar(100),
    semestre tinyint NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id)
);

create table Grupo (
	id int NOT NULL auto_increment,
    idPeriodo int NOT NULL,
    idArea int NOT NULL,
    semestre tinyint NOT NULL,
    bloque varchar(25) NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id),
	foreign key(idPeriodo) references Periodo(id) ON DELETE CASCADE,
    foreign key(idArea) references area(id) ON DELETE CASCADE
);

create table estudianteGrupo (
	id int NOT NULL auto_increment,
    idEstudiante int NOT NULL,
	idGrupo int NOT NULL,
    isRepite tinyint NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id),
    foreign key(idEstudiante) references Usuario(uid) ON DELETE CASCADE,
	foreign key(idGrupo) references Grupo(id) ON DELETE CASCADE
);

create table Edificio (
	id int NOT NULL auto_increment,
    nombre varchar(100) NOT NULL,
    pisos int NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id)
);

create table Salon (
	id int NOT NULL auto_increment,
    idEdificio int NOT NULL,
    nombre varchar(100) NOT NULL,
    proyector tinyint NOT NULL,
    totalCupo int NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id),
    foreign key(idEdificio) references Edificio(id) ON DELETE CASCADE
);

create table diaSemana(
	id int NOT NULL auto_increment,
    nombre varchar(50) NOT NULL,
    primary key(id)
);

Insert into diaSemana(nombre) values('Lunes');
Insert into diaSemana(nombre) values('Martes');
Insert into diaSemana(nombre) values('Miercoles');
Insert into diaSemana(nombre) values('Jueves');
Insert into diaSemana(nombre) values('Viernes');
Insert into diaSemana(nombre) values('Sabado');
Insert into diaSemana(nombre) values('Domingo');

create table Materia (
	id int NOT NULL auto_increment,
    idArea int NOT NULL,
    nombre varchar(200) NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id),
    foreign key(idArea) references area(id) ON DELETE CASCADE
);

create table Clase (
	nrc varchar(20) NOT NULL,
    idProfesor int NOT NULL,
    idMateria int NOT NULL,
    idGrupo int NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(nrc),
    foreign key(idProfesor) references Usuario(uid) ON DELETE CASCADE,
    foreign key(idMateria) references materia(id) ON DELETE CASCADE,
    foreign key(idGrupo) references Grupo(id) ON DELETE CASCADE  
);

create table horario(
	id int NOT NULL auto_increment,
    idSemana int NOT NULL,
    idSalon int NOT NULL,
    idClase varchar(20) NOT NULL,
    horaInicio time NOT NULL,
    horaFin time NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id),
    foreign key(idSemana) references diaSemana(id) ON DELETE CASCADE,
    foreign key(idSalon) references Salon(id) ON DELETE CASCADE,
    foreign key(idClase) references Clase(nrc) ON DELETE CASCADE
);

create table Acta (
	id int NOT NULL auto_increment,
    idEstGrupo int NOT NULL,
    nrc varchar(20) NOT NULL,
    esFinal tinyint NOT NULL,
    calificacion int NOT NULL,
    esOrdinario tinyint NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
	primary key(id),
    foreign key(idEstGrupo) references estudianteGrupo(id) ON DELETE CASCADE,
    foreign key(nrc) references Clase(nrc) ON DELETE CASCADE
);

#Edificios
INSERT into Edificio (nombre, pisos, createdAt, updatedAt) Values ('A', 3, NOW(), NOW());
INSERT into Edificio (nombre, pisos, createdAt, updatedAt) Values ('B', 2, NOW(), NOW());

#Salones Edificio A
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '101', 1, 30, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '102', 1, 30, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '103', 0, 30, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '111', 1, 25, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '112', 0, 22, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '113', 1, 26, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '121', 0, 20, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '122', 1, 20, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(1, '123', 1, 20, NOW(), NOW());

#Salones Edificio B
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(2, '201', 1, 30, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(2, '202', 1, 30, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(2, '203', 0, 30, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(2, '211', 1, 25, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(2, '212', 0, 22, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(2, '213', 1, 26, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(2, 'Laboratorio', 0, 20, NOW(), NOW());
INSERT into Salon (idEdificio, nombre, proyector, totalCupo, createdAt, updatedAt) VALUES(2, 'Centro de computo', 1, 30, NOW(), NOW());

#Areas 
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('General', 1 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('General', 2 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('General', 3 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('General', 4 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('Humanidades', 5 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('Biológicas', 5 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('Económicas', 5 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('Exactas', 5 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('Humanidades', 6 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('Biológicas', 6 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('Económicas', 6 , NOW(), NOW());
Insert INTO area (nombre, semestre, createdAt, updatedAt) VALUES ('Exactas', 6 , NOW(), NOW());

#Materias 
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (1, 'Español 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (1, 'Matemáticas 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (1, 'Geografía 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (1, 'Filosofía 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (1, 'Informática 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (1, 'Biología 1', NOW(), NOW());


Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (2, 'Español 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (2, 'Matemáticas 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (2, 'Lógica', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (2, 'Ciencias sociales', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (2, 'Informática 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (2, 'Biología 2', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (3, 'Español 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (3, 'Matemáticas 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (3, 'Química 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (3, 'Historia 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (3, 'Física 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (3, 'Finanazas', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (4, 'Español 4', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (4, 'Matemáticas 4', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (4, 'Química 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (4, 'Historia 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (4, 'Física 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (4, 'Económia', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (5, 'Español 5', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (5, 'Filosofía 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (5, 'Historia 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (5, 'Arte', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (5, 'Derecho 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (5, 'Antroplogía', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (6, 'Ciencias de la salud 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (6, 'Bioquímica 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (6, 'Botánica 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (6, 'Zoología 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (6, 'Química 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (6, 'Biología 3', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (7, 'Ecónomia 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (7, 'Contabilidad 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (7, 'Derecho 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (7, 'Estádistica 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (7, 'Finanzas 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (7, 'Probabilidad 1', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (8, 'Fisíca 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (8, 'Cálculo Diferencial', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (8, 'Geografía 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (8, 'Química 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (8, 'Estádistica 1', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (8, 'Electricidad 1', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (9, 'Español 6', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (9, 'Teatro', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (9, 'Cine', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (9, 'Derecho 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (9, 'Historia 4', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (9, 'Filosofía 2', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (10, 'Ciencias de la salud 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (10, 'Bioquímica 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (10, 'Botánica 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (10, 'Zoología 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (10, 'Química 4', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (10, 'Biología 4', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (11, 'Ecónomia 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (11, 'Contabilidad 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (11, 'Derecho 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (11, 'Estádistica 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (11, 'Finanzas 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (11, 'Probabilidad 2', NOW(), NOW());

Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (12, 'Fisíca 4', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (12, 'Cálculo Integral', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (12, 'Geografía 3', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (12, 'Química 4', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (12, 'Estádistica 2', NOW(), NOW());
Insert INTO materia (idArea, nombre, createdAt, updatedAt) VALUES (12, 'Electricidad 2', NOW(), NOW());

#Estudiantes primer semestre
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014010@estudiantes.com', 's19014010', 1, 'Aldo', 'Rico', 'Canseco', 1 ,"2000-01-1 00:00:00",NOW(),NOW(),'s19014010');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014011@estudiantes.com', 's19014011', 1, 'Alan', 'D.' ,'Pinto', 'Magallanes', 1 ,"2000-02-2 00:00:00",NOW(),NOW(),'s19014011');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014012@estudiantes.com', 's19014012', 1, 'Haisahar', 'Hadad' ,'Perez', 'Cruz', 1 ,"2000-03-3 00:00:00",NOW(),NOW(),'s19014012');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014013@estudiantes.com', 's19014013', 1, 'Oscar', 'Alejandro' ,'Robledo', 'Jimenez', 1 ,"2000-04-4 00:00:00",NOW(),NOW(),'s19014013');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014014@estudiantes.com', 's19014014', 1, 'Alfredo', 'Guadalupe' ,'Sanchez', 'Ortiz', 1 ,"2000-05-5 00:00:00",NOW(),NOW(),'s19014014');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014015@estudiantes.com', 's19014015', 1, 'Clark', 'Collins' ,'Campbell', 1 ,"2000-06-6 00:00:00",NOW(),NOW(),'s19014015');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014016@estudiantes.com', 's19014016', 1, 'Jose', 'Cordero', 'Cotera', 1 ,"2000-07-7 00:00:00",NOW(),NOW(),'s19014016');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014017@estudiantes.com', 's19014017', 1, 'Alfonso', 'Andres' ,'Rodriguez', 'Otalora', 1 ,"2000-08-8 00:00:00",NOW(),NOW(),'s19014017');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014018@estudiantes.com', 's19014018', 1, 'Vladimir','Marcelo', 'Vazquez', 1 ,"2000-09-9 00:00:00",NOW(),NOW(),'s19014018');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014019@estudiantes.com', 's19014019', 1, 'Santiago','Ruiz', 'Gutierrez', 1 ,"2000-10-10 00:00:00",NOW(),NOW(),'s19014019');

#Estudiantes tercer semestre
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014050@estudiantes.com', 's19014050', 1, 'Yuriana','Lopez', 'Vasquez', 1 ,"2000-12-29 00:00:00",NOW(),NOW(),'s19014050');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014051@estudiantes.com', 's19014051', 1, 'Hugo','Aguilar', 'Luna', 1 ,"2000-11-29 00:00:00",NOW(),NOW(),'s19014051');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014052@estudiantes.com', 's19014052', 1, 'Armando','Gomez', 'Santiago', 1 ,"2000-6-12 00:00:00",NOW(),NOW(),'s19014052');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014053@estudiantes.com', 's19014053', 1, 'Andres','Blancas', 'Oca', 1 ,"2000-5-21 00:00:00",NOW(),NOW(),'s19014053');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014054@estudiantes.com', 's19014054', 1, 'Adriel','Perez', 'Martinez', 1 ,"2000-9-10 00:00:00",NOW(),NOW(),'s19014054');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014055@estudiantes.com', 's19014055', 1, 'Michelle','Pot', 'Cabrera', 1 ,"2000-1-15 00:00:00",NOW(),NOW(),'s19014055');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014056@estudiantes.com', 's19014056', 1, 'Diana','Aburto', 'Martinez', 1 ,"2000-4-28 00:00:00",NOW(),NOW(),'s19014056');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014057@estudiantes.com', 's19014057', 1, 'Alex','Villa', 'Lara', 1 ,"2000-5-5 00:00:00",NOW(),NOW(),'s19014057');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014058@estudiantes.com', 's19014058', 1, 'Adelaida','Meneses', 'Maya', 1 ,"2000-6-7 00:00:00",NOW(),NOW(),'s19014058');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014059@estudiantes.com', 's19014059', 1, 'Naad','Mendoza', 'Ponce', 1 ,"2000-11-15 00:00:00",NOW(),NOW(),'s19014059');

#Estudiante quinto semestre
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014000@estudiantes.com', 's19014000', 1, 'Daniel', 'Diaz', 'Rossell', 1 ,"2000-11-3 00:00:00",NOW(),NOW(),'s19014000');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014001@estudiantes.com', 's19014001', 1, 'Raúl', 'Arturo' ,'Peredo', 'Estudillo', 1 ,"2000-11-19 00:00:00",NOW(),NOW(),'s19014001');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014002@estudiantes.com', 's19014002', 1, 'Eder', 'Iván' ,'Negrete', 'Cacahuate', 1 ,"2000-10-26 00:00:00",NOW(),NOW(),'s19014002');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014003@estudiantes.com', 's19014003', 1, 'Karla', 'Maria' ,'Fernández', 'Castillo', 1 ,"2000-03-6 00:00:00",NOW(),NOW(),'s19014003');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014004@estudiantes.com', 's19014004', 1, 'Alex', 'Jordan' ,'Pastel', 'Mani', 1 ,"2000-08-20 00:00:00",NOW(),NOW(),'s19014003');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014005@estudiantes.com', 's19014005', 1, 'Antonio', 'Dominguez' ,'Galleta', 1 ,"2000-12-7 00:00:00",NOW(),NOW(),'s19014005');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014006@estudiantes.com', 's19014006', 1, 'David', 'Mijangos', 'paleta', 1 ,"2000-5-29 00:00:00",NOW(),NOW(),'s19014006');
Insert INTO Usuario (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014007@estudiantes.com', 's19014007', 1, 'Johan', 'Alexis' ,'Olivares', 'Galindo', 1 ,"2000-11-19 00:00:00",NOW(),NOW(),'s19014007');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014008@estudiantes.com', 's19014008', 1, 'Josúe','Alarcón', 'taco', 1 ,"2000-12-2 00:00:00",NOW(),NOW(),'s19014008');
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,matricula) VALUES ('s19014009@estudiantes.com', 's19014009', 1, 'Mariana','Flores', 'Flan', 1 ,"2000-2-28 00:00:00",NOW(),NOW(),'s19014009');



#Maestros 
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234019@profesor.com', 'p1234019', 1, 'Jorge','Octavio','Ocharan', 'Hérnandez', 2 ,"1970-4-12 00:00:00",NOW(),NOW(),'p123401');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234020@profesor.com', 'p1234020', 1, 'Sergio','Pedro','Garcia', 'Peña', 2 ,"1980-5-2 00:00:00",NOW(),NOW(),'p1234020');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234021@profesor.com', 'p1234021', 1, 'Angel','Juan','Sanchez', 'Garcia', 2 ,"1975-11-15 00:00:00",NOW(),NOW(),'p1234021');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234022@profesor.com', 'p1234022', 1, 'Maria','Karen','Cortes', 'Verdin', 2 ,"1969-7-8 00:00:00",NOW(),NOW(),'p1234022');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234023@profesor.com', 'p1234023', 1, 'Oscar','Carlos','Alonso', 'Ramirez', 2 ,"1977-2-10 00:00:00",NOW(),NOW(),'p1234023');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234024@profesor.com', 'p1234024', 1, 'Fredy','P','Castañeda', 'Sanchez', 2 ,"1974-4-23 00:00:00",NOW(),NOW(),'p1234024');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234025@profesor.com', 'p1234025', 1, 'Andres','','Blancas', 'Gonzalez', 2 ,"1968-9-22 00:00:00",NOW(),NOW(),'p1234025');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234026@profesor.com', 'p1234026', 1, 'Juan','','Sonderegger', 'Arreola', 2 ,"1981-7-7 00:00:00",NOW(),NOW(),'p1234026');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234027@profesor.com', 'p1234027', 1, 'Rosa','Maribel','Barradas', 'Landa', 2 ,"1976-8-7 00:00:00",NOW(),NOW(),'p1234027');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234028@profesor.com', 'p1234028', 1, 'Diego','Eliceo','Valerio', 'Cardenas', 2 ,"1965-6-15 00:00:00",NOW(),NOW(),'p1234028');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234031@profesor.com', 'p1234031', 1, 'Maria','Angeles','Arenas', 'Valdez', 2 ,"1981-7-7 00:00:00",NOW(),NOW(),'p1234031');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234032@profesor.com', 'p1234032', 1, 'Erika','','Meneses', 'Rico', 2 ,"1976-8-7 00:00:00",NOW(),NOW(),'p1234032');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234033@profesor.com', 'p1234033', 1, 'Gabriela','Daili','Gonzáles', 'Cardenas', 2 ,"1996-6-29 00:00:00",NOW(),NOW(),'p1234033');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234030@profesor.com', 'p1234030', 1, 'Juan','Carlos','Pérez', 'Arriaga', 2 ,"1989-4-1 00:00:00",NOW(),NOW(),'p1234030');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, segundoNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('p1234034@profesor.com', 'p1234034', 1, 'Stephen','Andres','Curry', 'Arriaga', 2 ,"1990-4-1 00:00:00",NOW(),NOW(),'p1234034');

#Secretarios
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('s123401@secretario.com', 's123401', 1, 'Karla','Mongue','Hérnandez', 3 ,"1980-5-21 00:00:00",NOW(),NOW(),'s123401');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('s123401@secretario.com', 's123401', 1, 'Carlos','Pasteur','Hérnandez', 3 ,"1970-5-21 00:00:00",NOW(),NOW(),'s123401');
INSERT INTO USUARIO (correo, password, isActivo, primerNombre, primerApellido, segundoApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('s123401@secretario.com', 's123401', 1, 'Tae','cook','Hérnandez', 3 ,"1991-1-28 00:00:00",NOW(),NOW(),'s123401');

#Administrador
Insert INTO Usuario (correo, password, isActivo, primerNombre, primerApellido, rol,fechaNacimiento,createdAt,updatedAt,claveEmpleado) VALUES ('admin@admin.com', 'admin', 1, 'admin', 'admin', 4,NOW(),NOW(),NOW(),'admin');

	#Periodo feb2020-julio2020
INSERT INTO Periodo (fechaInicio, fechaFin, fechaOrdinario, fechaExtra, activo, createdAt, updatedAt) Values ("2020-2-01 00:00:00", "2020-7-30 00:00:00", "2020-6-15 00:00:00", "2020-7-15 00:00:00", 1, NOW(),NOW());

	#Primero feb2020-julio2020
# primero 
INSERT INTO Grupo (idPeriodo, idArea, semestre, bloque, createdAt, updatedAt) VALUES (1, 1, 1, 'A', NOW(), NOW());
INSERT INTO Grupo (idPeriodo, idArea, semestre, bloque, createdAt, updatedAt) VALUES (1, 1, 1, 'B', NOW(), NOW());

# tercero
INSERT INTO Grupo (idPeriodo, idArea, semestre, bloque, createdAt, updatedAt) VALUES (1, 3, 3, 'A', NOW(), NOW());
INSERT INTO Grupo (idPeriodo, idArea, semestre, bloque, createdAt, updatedAt) VALUES (1, 3, 3, 'B', NOW(), NOW());

#Quinto
INSERT INTO Grupo (idPeriodo, idArea, semestre, bloque, createdAt, updatedAt) VALUES (1, 5, 5, 'Humanidades', NOW(), NOW());
INSERT INTO Grupo (idPeriodo, idArea, semestre, bloque, createdAt, updatedAt) VALUES (1, 6, 5, 'Biologicas', NOW(), NOW());
INSERT INTO Grupo (idPeriodo, idArea, semestre, bloque, createdAt, updatedAt) VALUES (1, 7, 5, 'Economica', NOW(), NOW());
INSERT INTO Grupo (idPeriodo, idArea, semestre, bloque, createdAt, updatedAt) VALUES (1, 8, 5, 'Exactas', NOW(), NOW());

# primero
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (1, 1, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (2, 1, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (3, 1, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (4, 1, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (5, 1, 0, NOW(), NOW());

INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (6, 2, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (7, 2, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (8, 2, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (9, 2, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (10, 2, 0, NOW(), NOW());

#tercero
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (11, 3, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (12, 3, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (13, 3, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (14, 3, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (15, 3, 0, NOW(), NOW());

INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (16, 4, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (17, 4, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (18, 4, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (19, 4, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (20, 4, 0, NOW(), NOW());

#Quinto
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (21, 5, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (22, 5, 0, NOW(), NOW());

INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (23, 6, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (24, 6, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (25, 6, 0, NOW(), NOW());

INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (26, 7, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (27, 7, 0, NOW(), NOW());

INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (28, 8, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (29, 8, 0, NOW(), NOW());
INSERT INTO estudianteGrupo (idEstudiante,idGrupo,isRepite, createdAt, updatedAt) VALUES (30, 8, 0, NOW(), NOW());

#clases 1a 
# A
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201001', 31, 1,1 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 1, '201001', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 1, '201001', '09:00', '10:59', now(), NOW());

# B
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201002', 32, 2,1 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 2, '201002', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 2, '201002', '07:00', '8:59', now(), NOW());

# C
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201003', 33, 3,1 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 3, '201003', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 1, '201003', '09:00', '10:59', now(), NOW());

# D
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201004', 31, 4,1 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 1, '201004', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 1, '201004', '11:00', '12:59', now(), NOW());

#E
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201005', 32, 5,1 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 2, '201005', '11:00', '12:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 2, '201005', '07:00', '8:59', now(), NOW());

#F
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201006', 33, 6,1 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 3, '201006', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 3, '201006', '09:00', '10:59', now(), NOW());

#clases 1b
# A
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201007', 31, 1,2 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 1, '201007', '11:00', '12:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 3, '201007', '07:00', '8:59', now(), NOW());

# B
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201008', 32, 2,2 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 2, '201008', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 1, '201008', '09:00', '10:59', now(), NOW());

# C
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201009', 33, 3,2 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 2, '201009', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 2, '201009', '09:00', '10:59', now(), NOW());

# D
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201010', 31, 4,2 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 3, '201010', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 3, '201010', '7:00', '8:59', now(), NOW());

#E
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201011', 32, 5,2 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 1, '201011', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 1, '201011', '09:00', '10:59', now(), NOW());

#F
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201012', 33, 6,2 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 2, '201012', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 2, '201012', '11:00', '12:59', now(), NOW());

#clases 3a 
# A
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201013', 34, 13,3 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 4, '201013', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 4, '201013', '09:00', '10:59', now(), NOW());

# B
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201014', 35, 14,3 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 5, '201014', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 5, '201014', '07:00', '8:59', now(), NOW());

# C
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201015', 36, 15,3 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 6, '201015', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 6, '201015', '09:00', '10:59', now(), NOW());

# D
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201016', 34, 16,3 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 4, '201016', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 4, '201016', '11:00', '12:59', now(), NOW());

#E
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201017', 35, 17,3 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 5, '201017', '11:00', '12:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 5, '201017', '07:00', '8:59', now(), NOW());

#F
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201018', 36, 18, 3,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 6, '201018', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 6, '201018', '09:00', '10:59', now(), NOW());

#clases 3b
# A
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201019', 34, 13,4 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 6, '201019', '11:00', '12:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 6, '201019', '07:00', '8:59', now(), NOW());

# B
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201020', 35, 14,4 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 4, '201020', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 4, '201020', '09:00', '10:59', now(), NOW());

# C
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201021', 36, 15,4 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 5, '201021', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 5, '201021', '09:00', '10:59', now(), NOW());

# D
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201022', 34, 16,4 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 6, '201022', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 6, '201022', '7:00', '8:59', now(), NOW());

#E
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201023', 35, 17,4 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 4, '201023', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 4, '201023', '09:00', '10:59', now(), NOW());

#F
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201024', 36, 18,4 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 5, '201024', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 5, '201024', '11:00', '12:59', now(), NOW());

#clases humanidades
# A
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201025', 37, 25,5 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 7, '201025', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 7, '201025', '09:00', '10:59', now(), NOW());

# B
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201026', 35, 26,5 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 8, '201026', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 8, '201026', '07:00', '8:59', now(), NOW());

# C
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201027', 36, 27,5 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 9, '201027', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 9, '201027', '09:00', '10:59', now(), NOW());

# D
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201028', 34, 28,5 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 7, '201028', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 7, '201028', '11:00', '12:59', now(), NOW());

#E
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201029', 35, 29,5 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 8, '201029', '11:00', '12:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 8, '201029', '07:00', '8:59', now(), NOW());

#F
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201030', 36, 30, 5,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 9, '201030', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 9, '201030', '09:00', '10:59', now(), NOW());

#clases económico
# A
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201031', 38, 25,6 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 10, '201031', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 10, '201031', '09:00', '10:59', now(), NOW());

# B
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201032', 41, 26,6 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 11, '201032', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 11, '201032', '07:00', '8:59', now(), NOW());

# C
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201033', 45, 27,6 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 12, '201033', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 12, '201033', '09:00', '10:59', now(), NOW());

# D
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201034', 42, 28,6 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 10, '201034', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 10, '201034', '11:00', '12:59', now(), NOW());

#E
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201035', 48, 29,6 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 11, '201035', '11:00', '12:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 11, '201035', '07:00', '8:59', now(), NOW());

#F
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201036', 42, 30, 6,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 12, '201036', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 12, '201036', '09:00', '10:59', now(), NOW());

#clases biologicas
# A
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201037', 49, 25,7 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 13, '201037', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 13, '201037', '09:00', '10:59', now(), NOW());

# B
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201038', 43, 26,7 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 14, '201038', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 14, '201038', '07:00', '8:59', now(), NOW());

# C
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201039', 49, 27,7 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 15, '201039', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 15, '201039', '09:00', '10:59', now(), NOW());

# D
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201040', 43, 28,7 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 15, '201040', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 15, '201040', '11:00', '12:59', now(), NOW());

#E
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201041', 46, 29,7 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 14, '201041', '11:00', '12:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 14, '201041', '07:00', '8:59', now(), NOW());

#F
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201042', 43, 30, 7,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 15, '201042', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 15, '201042', '09:00', '10:59', now(), NOW());

#clases Exactas
# A
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201043', 42, 25,8 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 12, '201043', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 12, '201043', '09:00', '10:59', now(), NOW());

# B
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201044', 44, 26,8 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (1, 10, '201044', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 10, '201044', '07:00', '8:59', now(), NOW());

# C
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201045', 40, 27,8 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 11, '201045', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 11, '201045', '09:00', '10:59', now(), NOW());

# D
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201046', 35, 28,8 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 12, '201046', '09:00', '10:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (4, 12, '201046', '11:00', '12:59', now(), NOW());

#E
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201047', 44, 29,8 ,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (2, 10, '201047', '11:00', '12:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 10, '201047', '07:00', '8:59', now(), NOW());

#F
INSERT INTO Clase (nrc, idProfesor, idMateria, idGrupo, createdAt, updatedAt) VALUES ('201048', 40, 30, 8,NOW(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (3, 11, '201048', '07:00', '8:59', now(), NOW());
INSERT INTO horario (idSemana,idSalon,idClase,horaInicio, horaFin, createdAt, updatedAt) VALUES (5, 11, '201048', '09:00', '10:59', now(), NOW());

#Calificaciones
#1A
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (1, '201001', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (1, '201002', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (1, '201003', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (1, '201004', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (1, '201005', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (1, '201006', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (2, '201001', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (2, '201002', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (2, '201003', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (2, '201004', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (2, '201005', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (2, '201006', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (3, '201001', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (3, '201002', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (3, '201003', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (3, '201004', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (3, '201005', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (3, '201006', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (4, '201001', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (4, '201002', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (4, '201003', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (4, '201004', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (4, '201005', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (4, '201006', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (5, '201001', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (5, '201002', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (5, '201003', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (5, '201004', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (5, '201005', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (5, '201006', 1, 9, 0, NOW(), NOW());


#1B
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (6, '201007', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (6, '201009', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (6, '201009', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (6, '201010', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (6, '201011', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (6, '201012', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (7, '201007', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (7, '201009', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (7, '201009', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (7, '201010', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (7, '201011', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (7, '201012', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (8, '201007', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (8, '201009', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (8, '201009', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (8, '201010', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (8, '201011', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (8, '201012', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (9, '201007', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (9, '201009', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (9, '201009', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (9, '201010', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (9, '201011', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (9, '201012', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (10, '201007', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (10, '201009', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (10, '201009', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (10, '201010', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (10, '201011', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (10, '201012', 1, 9, 0, NOW(), NOW());

#3A
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (11, '201013', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (11, '201014', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (11, '201015', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (11, '201016', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (11, '201017', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (11, '201018', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (12, '201013', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (12, '201014', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (12, '201015', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (12, '201016', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (12, '201017', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (12, '201018', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (13, '201013', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (13, '201014', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (13, '201015', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (13, '201016', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (13, '201017', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (13, '201018', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (14, '201013', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (14, '201014', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (14, '201015', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (14, '201016', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (14, '201017', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (14, '201018', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (15, '201013', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (15, '201014', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (15, '201015', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (15, '201016', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (15, '201017', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (15, '201018', 1, 9, 0, NOW(), NOW());

#3B
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (16, '201019', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (16, '201020', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (16, '201021', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (16, '201022', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (16, '201023', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (16, '201024', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (17, '201019', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (17, '201020', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (17, '201021', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (17, '201022', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (17, '201023', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (17, '201024', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (18, '201019', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (18, '201020', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (18, '201021', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (18, '201022', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (18, '201023', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (18, '201024', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (19, '201019', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (19, '201020', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (19, '201021', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (19, '201022', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (19, '201023', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (19, '201024', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (20, '201019', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (20, '201020', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (20, '201021', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (20, '201022', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (20, '201023', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (20, '201024', 1, 9, 0, NOW(), NOW());

#Humanidades
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (21, '201025', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (21, '201026', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (21, '201027', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (21, '201028', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (21, '201029', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (21, '201030', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (22, '201025', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (22, '201026', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (22, '201027', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (22, '201028', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (22, '201029', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (22, '201030', 1, 9, 0, NOW(), NOW());

#Biologicas
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (23, '201031', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (23, '201032', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (23, '201033', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (23, '201034', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (23, '201035', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (23, '201036', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (24, '201031', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (24, '201032', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (24, '201033', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (24, '201034', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (24, '201035', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (24, '201036', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (25, '201031', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (25, '201032', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (25, '201033', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (25, '201034', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (25, '201035', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (25, '201036', 1, 9, 0, NOW(), NOW());

#Económico
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (26, '201037', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (26, '201038', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (26, '201039', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (26, '201040', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (26, '201041', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (26, '201042', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (27, '201037', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (27, '201038', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (27, '201039', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (27, '201040', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (27, '201041', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (27, '201042', 1, 9, 0, NOW(), NOW());

#Exactas
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (28, '201043', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (28, '201044', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (28, '201045', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (28, '201046', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (28, '201047', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (28, '201048', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (29, '201043', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (29, '201044', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (29, '201045', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (29, '201046', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (29, '201047', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (29, '201048', 1, 9, 0, NOW(), NOW());

INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (30, '201043', 1, 9, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (30, '201044', 1, 10, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (30, '201045', 1, 8, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (30, '201046', 1, 7, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (30, '201047', 1, 6, 0, NOW(), NOW());
INSERT INTO Acta (idEstGrupo, nrc, esFinal, calificacion,esOrdinario, createdAt, updatedAt) VALUES (30, '201048', 1, 9, 0, NOW(), NOW());

#vistas

create view estudiantes_libres_periodo AS
SELECT us.uid, us.correo, us.primerNombre, us.segundoNombre, us.primerApellido, us.segundoApellido, us.matricula, coalesce(MAX(gru.semestre), 0) AS semestre
FROM usuario as us
left JOIN estudiantegrupo as estgru
ON estgru.idEstudiante = us.uid
left join grupo as gru
ON estgru.idGrupo = gru.id
WHERE us.isActivo = 1
AND us.rol = 1
AND us.uid NOT IN
(SELECT us.uid 
FROM Usuario as us 
INNER JOIN estudiantegrupo as estgru
INNER JOIN grupo as gru
INNER JOIN periodo as per
where us.uid = estgru.idEstudiante
AND gru.id = estgru.idGrupo
AND per.id = gru.idPeriodo
AND per.activo = 1)
GROUP BY us.uid
ORDER BY semestre DESC;