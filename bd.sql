DROP DATABASE IF EXISTS reforma360;
CREATE DATABASE reforma360;
USE reforma360;

CREATE TABLE Usuaris (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    cognoms VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    contrasenya VARCHAR(255) NOT NULL,
    telefon VARCHAR(255) NOT NULL,
    tipus BOOLEAN NOT NULL,
    foto VARCHAR(255) NOT NULL,
    bio TEXT NULL
) ENGINE=InnoDB;

CREATE TABLE Profesionals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuari INT NOT NULL,
    categoria VARCHAR(255) NOT NULL,
    experiencia INT NOT NULL,
    descripcio TEXT NOT NULL,
    FOREIGN KEY (id_usuari) REFERENCES Usuaris(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Publicacions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuari INT NOT NULL,
    data_publicacio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcio TEXT NOT NULL,
    contingut TEXT NOT NULL,
    FOREIGN KEY (id_usuari) REFERENCES Usuaris(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Missatges (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_remitent INT NOT NULL,
    id_destinatari INT NOT NULL,
    data_missatge DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    contingut TEXT NOT NULL,
    llegit BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_remitent) REFERENCES Usuaris(id) ON DELETE CASCADE,
    FOREIGN KEY (id_destinatari) REFERENCES Usuaris(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Valoracions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_professional INT NOT NULL,
    id_usuari INT NOT NULL,
    data_valoracio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valoracio INT CHECK (valoracio BETWEEN 1 AND 5),
    comentari TEXT NOT NULL,
    FOREIGN KEY (id_professional) REFERENCES Profesionals(id) ON DELETE CASCADE,
    FOREIGN KEY (id_usuari) REFERENCES Usuaris(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Presupost (
    id INT AUTO_INCREMENT PRIMARY KEY,
    preu DECIMAL(10,2) NOT NULL,
    acceptat BOOLEAN NOT NULL DEFAULT FALSE,
    adjunt VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE Projectes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuari INT NOT NULL,
    id_professional INT NOT NULL,
    id_presupost INT NULL,
    data_inici DATETIME NOT NULL,x
    data_fi DATETIME NOT NULL,
    titol VARCHAR(255) NOT NULL,
    descripcio TEXT NOT NULL,
    estat ENUM('pendent', 'en curs', 'completat', 'cancel·lat') NOT NULL,
    FOREIGN KEY (id_usuari) REFERENCES Usuaris(id) ON DELETE CASCADE,
    FOREIGN KEY (id_professional) REFERENCES Profesionals(id) ON DELETE CASCADE,
    FOREIGN KEY (id_presupost) REFERENCES Presupost(id) ON DELETE SET NULL
) ENGINE=InnoDB;
