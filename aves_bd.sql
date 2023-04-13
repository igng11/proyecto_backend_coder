CREATE TABLE aves (
  id INT(11) NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(255),
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE usuarios (
  id INT(11) NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(255),
  color_principal VARCHAR(50) NOT NULL UNIQUE,
  tamaño VARCHAR(50),
  descripcion TEXT,
  id_usuario INT(11),
  PRIMARY KEY (id),
  FOREIGN KEY (id_usuario) REFERENCES aves(id)
);

CREATE TABLE avistamientos (
  id INT(11) NOT NULL AUTO_INCREMENT,
  id_usuario INT(11) NOT NULL,
  id_ave INT(11) NOT NULL,
  fecha DATE NOT NULL,
  hora TIME,
  ubicacion DECIMAL(10,6),
  notas TEXT,
  PRIMARY KEY (id),
  FOREIGN KEY (id_usuario) REFERENCES aves(id),
  FOREIGN KEY (id_ave) REFERENCES usuarios(id)
);
