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
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id)
);

create table Grupo (
	id int NOT NULL auto_increment,
    grado tinyint NOT NULL,
    bloque char NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id)
);

create table estudiantePeriodo (
	id int NOT NULL auto_increment,
    idEstudiante int NOT NULL,
	idGrupo int NOT NULL,
    idPeriodo int NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id),
    foreign key(idEstudiante) references Usuario(uid),
	foreign key(idGrupo) references Grupo(id),
	foreign key(idPeriodo) references Periodo(id)
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
    foreign key(idEdificio) references Edificio(id)
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

create table horario(
	id int NOT NULL auto_increment,
    idSemana int NOT NULL,
    idSalon int NOT NULL,
    horaInicio time NOT NULL,
    horaFin time NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id),
    foreign key(idSemana) references diaSemana(id),
    foreign key(idSalon) references Salon(id)
);

create table area(
	id int NOT NULL auto_increment,
    nombre varchar(100),
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id)
);

create table Materia (
	id int NOT NULL auto_increment,
    nombre varchar(200) NOT NULL,
    semestre int NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(id)
);

create table materiaArea (
	idMateria int NOT NULL,
    idArea int NOT NULL,
    foreign key(idMateria) references Materia(id),
    foreign key(idArea) references area(id)
);

create table Clase (
	nrc varchar(20) NOT NULL,
    idProfesor int NOT NULL,
    idMateria int NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
    primary key(nrc),
    foreign key(idProfesor) references Usuario(uid),
    foreign key(idMateria) references materia(id)  
);

create table Acta (
	id int NOT NULL auto_increment,
    idEstPeriodo int NOT NULL,
    nrc varchar(20) NOT NULL,
    esFinal tinyint NOT NULL,
    calificacion int NOT NULL,
    esOrdinario tinyint NOT NULL,
    createdAt datetime NOT NULL,
    updatedAt datetime NOT NULL,
	primary key(id),
    foreign key(idEstPeriodo) references estudiantePeriodo(id),
    foreign key(nrc) references Clase(nrc)
);

create table token (
	value varchar(200) NOT NULL 
);