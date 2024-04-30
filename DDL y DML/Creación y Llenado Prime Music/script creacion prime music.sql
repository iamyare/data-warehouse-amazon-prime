
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema prime_music
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema prime_music
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `prime_music` DEFAULT CHARACTER SET utf8 ;
USE `prime_music` ;

-- -----------------------------------------------------
-- Table `prime_music`.`TBL_ALBUMES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_ALBUMES` (
  `ID_album` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL,
  `fecha_lanzamiento` DATE NOT NULL,
  `discografia` VARCHAR(45) NULL,
  `url_caratula` VARCHAR(150) NULL,
  PRIMARY KEY (`ID_album`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_CONTENIDO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_CONTENIDO` (
  `ID_contenido` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL COMMENT 'Título de la canción',
  `fecha_lanzamiento` DATE NOT NULL COMMENT 'Fecha de lanzamiento de la canción',
  `duracion` TIME NOT NULL COMMENT 'Duración de la canción',
  `idioma` VARCHAR(20) NOT NULL COMMENT 'Idioma de la canción',
  `valoracion` DOUBLE NOT NULL DEFAULT 0 COMMENT 'Valoración de la canción, por defecto se asigna 0',
  `formato` VARCHAR(5) NOT NULL COMMENT 'Formato del archivo (MP3 o WAV)',
  `caratula` VARCHAR(150) NULL COMMENT 'URL de la caratulade la canción',
  `TBL_ALBUMES_ID_album` INT NOT NULL,
  PRIMARY KEY (`ID_contenido`, `TBL_ALBUMES_ID_album`),
  INDEX `fk_TBL_CANCIONES_TBL_ALBUMES_idx` (`TBL_ALBUMES_ID_album` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_CANCIONES_TBL_ALBUMES`
    FOREIGN KEY (`TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_ALBUMES` (`ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_INTERPRETES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_INTERPRETES` (
  `ID_interprete` INT NOT NULL AUTO_INCREMENT COMMENT 'ID del interprete de una canción o de un podcast',
  `nombre` VARCHAR(50) NOT NULL,
  `fecha_nacimiento` DATE NOT NULL,
  `nacionalidad` VARCHAR(50) NOT NULL,
  `biografia` VARCHAR(100) NULL,
  `url_foto` VARCHAR(150) NULL,
  `compositor` INT NOT NULL DEFAULT 0 COMMENT '1 para indicar que el interprete de la canción o podcast también es el creador de la misma. 0 para indicar que solo la interpreta',
  PRIMARY KEY (`ID_interprete`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_CATEGORIAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_CATEGORIAS` (
  `ID_categoria` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `fecha_creacion` DATE NOT NULL,
  PRIMARY KEY (`ID_categoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_USUARIOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_USUARIOS` (
  `ID_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  `contrasenia` VARCHAR(150) NOT NULL COMMENT 'Contraseña encriptada',
  `genero` VARCHAR(1) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ID_usuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_BIBLIOTECAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_BIBLIOTECAS` (
  `ID_biblioteca` INT NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`ID_biblioteca`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_BIBLIOTECAS_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_BIBLIOTECAS_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_INVITADOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_INVITADOS` (
  `ID_invitado` INT NOT NULL AUTO_INCREMENT COMMENT 'Identificador del invitado',
  `nombre` VARCHAR(100) NOT NULL COMMENT 'Nombre del invitado',
  `profesion` VARCHAR(80) NOT NULL COMMENT 'Profesión del invitado del podcas',
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_CONTENIDO_TBL_ALBUMES_ID_album` INT NOT NULL,
  PRIMARY KEY (`ID_invitado`),
  INDEX `fk_TBL_INVITADOS_TBL_CONTENIDO1_idx` (`TBL_CONTENIDO_ID_contenido` ASC, `TBL_CONTENIDO_TBL_ALBUMES_ID_album` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_INVITADOS_TBL_CONTENIDO1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido` , `TBL_CONTENIDO_TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido` , `TBL_ALBUMES_ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_HISTORIAL_REPRODUCCIONES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_HISTORIAL_REPRODUCCIONES` (
  `ID_historial` INT NOT NULL AUTO_INCREMENT,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`ID_historial`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_HISTORIAL_REPRODUCCIONES_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_HISTORIAL_REPRODUCCIONES_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_TARJETA`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_TARJETA` (
  `ID_tarjeta` INT NOT NULL AUTO_INCREMENT,
  `num_tarjeta` VARCHAR(150) NOT NULL COMMENT 'Número de tarjeta encriptada',
  `fecha_vencimiento` DATE NOT NULL,
  `titular` VARCHAR(50) NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  `pin` VARCHAR(100) NOT NULL COMMENT 'PIN encriptado',
  PRIMARY KEY (`ID_tarjeta`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_PAGOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_PAGOS` (
  `ID_pago` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `monto` FLOAT NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`ID_pago`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_PAGOS_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_PAGOS_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_SUSCRIPCIONES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_SUSCRIPCIONES` (
  `ID_suscripcion` INT NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(50) NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NULL,
  `tipo` VARCHAR(20) NOT NULL,
  `precio` DOUBLE NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`ID_suscripcion`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_SUSCRIPCIONES_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_SUSCRIPCIONES_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_TARJETA_has_TBL_USUARIOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_TARJETA_has_TBL_USUARIOS` (
  `TBL_TARJETA_ID_tarjeta` INT NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  `fecha_vinculacion` DATE NOT NULL,
  `fecha_desvinculacion` DATE NULL,
  PRIMARY KEY (`TBL_TARJETA_ID_tarjeta`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_TARJETA_has_TBL_USUARIOS_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  INDEX `fk_TBL_TARJETA_has_TBL_USUARIOS_TBL_TARJETA1_idx` (`TBL_TARJETA_ID_tarjeta` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_TARJETA_has_TBL_USUARIOS_TBL_TARJETA1`
    FOREIGN KEY (`TBL_TARJETA_ID_tarjeta`)
    REFERENCES `prime_music`.`TBL_TARJETA` (`ID_tarjeta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_TARJETA_has_TBL_USUARIOS_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_BIBLIOTECAS_has_TBL_CONTENIDO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_BIBLIOTECAS_has_TBL_CONTENIDO` (
  `TBL_BIBLIOTECAS_ID_biblioteca` INT NOT NULL,
  `TBL_BIBLIOTECAS_TBL_USUARIOS_ID_usuario` INT NOT NULL,
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_CONTENIDO_TBL_ALBUMES_ID_album` INT NOT NULL,
  PRIMARY KEY (`TBL_BIBLIOTECAS_ID_biblioteca`, `TBL_BIBLIOTECAS_TBL_USUARIOS_ID_usuario`, `TBL_CONTENIDO_ID_contenido`, `TBL_CONTENIDO_TBL_ALBUMES_ID_album`),
  INDEX `fk_TBL_BIBLIOTECAS_has_TBL_CONTENIDO_TBL_CONTENIDO1_idx` (`TBL_CONTENIDO_ID_contenido` ASC, `TBL_CONTENIDO_TBL_ALBUMES_ID_album` ASC) VISIBLE,
  INDEX `fk_TBL_BIBLIOTECAS_has_TBL_CONTENIDO_TBL_BIBLIOTECAS1_idx` (`TBL_BIBLIOTECAS_ID_biblioteca` ASC, `TBL_BIBLIOTECAS_TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_BIBLIOTECAS_has_TBL_CONTENIDO_TBL_BIBLIOTECAS1`
    FOREIGN KEY (`TBL_BIBLIOTECAS_ID_biblioteca` , `TBL_BIBLIOTECAS_TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_BIBLIOTECAS` (`ID_biblioteca` , `TBL_USUARIOS_ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_BIBLIOTECAS_has_TBL_CONTENIDO_TBL_CONTENIDO1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido` , `TBL_CONTENIDO_TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido` , `TBL_ALBUMES_ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_CONTENIDO_has_TBL_HISTORIAL_REPRODUCCIONES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_CONTENIDO_has_TBL_HISTORIAL_REPRODUCCIONES` (
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_CONTENIDO_TBL_ALBUMES_ID_album` INT NOT NULL,
  `TBL_HISTORIAL_REPRODUCCIONES_ID_historial` INT NOT NULL,
  `TBL_HISTORIAL_REPRODUCCIONES_TBL_USUARIOS_ID_usuario` INT NOT NULL,
  `fecha_reproduccion` DATE NOT NULL,
  PRIMARY KEY (`TBL_CONTENIDO_ID_contenido`, `TBL_CONTENIDO_TBL_ALBUMES_ID_album`, `TBL_HISTORIAL_REPRODUCCIONES_ID_historial`, `TBL_HISTORIAL_REPRODUCCIONES_TBL_USUARIOS_ID_usuario`, `fecha_reproduccion`),
  INDEX `fk_TBL_CONTENIDO_has_TBL_HISTORIAL_REPRODUCCIONES_TBL_HISTO_idx` (`TBL_HISTORIAL_REPRODUCCIONES_ID_historial` ASC, `TBL_HISTORIAL_REPRODUCCIONES_TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  INDEX `fk_TBL_CONTENIDO_has_TBL_HISTORIAL_REPRODUCCIONES_TBL_CONTE_idx` (`TBL_CONTENIDO_ID_contenido` ASC, `TBL_CONTENIDO_TBL_ALBUMES_ID_album` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_CONTENIDO_has_TBL_HISTORIAL_REPRODUCCIONES_TBL_CONTENI1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido` , `TBL_CONTENIDO_TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido` , `TBL_ALBUMES_ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_CONTENIDO_has_TBL_HISTORIAL_REPRODUCCIONES_TBL_HISTORI1`
    FOREIGN KEY (`TBL_HISTORIAL_REPRODUCCIONES_ID_historial` , `TBL_HISTORIAL_REPRODUCCIONES_TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_HISTORIAL_REPRODUCCIONES` (`ID_historial` , `TBL_USUARIOS_ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_CONTENIDO_has_TBL_CATEGORIAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_CONTENIDO_has_TBL_CATEGORIAS` (
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_CONTENIDO_TBL_ALBUMES_ID_album` INT NOT NULL,
  `TBL_CATEGORIAS_ID_categoria` INT NOT NULL,
  PRIMARY KEY (`TBL_CONTENIDO_ID_contenido`, `TBL_CONTENIDO_TBL_ALBUMES_ID_album`, `TBL_CATEGORIAS_ID_categoria`),
  INDEX `fk_TBL_CONTENIDO_has_TBL_CATEGORIAS_TBL_CATEGORIAS1_idx` (`TBL_CATEGORIAS_ID_categoria` ASC) VISIBLE,
  INDEX `fk_TBL_CONTENIDO_has_TBL_CATEGORIAS_TBL_CONTENIDO1_idx` (`TBL_CONTENIDO_ID_contenido` ASC, `TBL_CONTENIDO_TBL_ALBUMES_ID_album` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_CONTENIDO_has_TBL_CATEGORIAS_TBL_CONTENIDO1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido` , `TBL_CONTENIDO_TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido` , `TBL_ALBUMES_ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_CONTENIDO_has_TBL_CATEGORIAS_TBL_CATEGORIAS1`
    FOREIGN KEY (`TBL_CATEGORIAS_ID_categoria`)
    REFERENCES `prime_music`.`TBL_CATEGORIAS` (`ID_categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_DERECHOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_DERECHOS` (
  `ID_derecho` INT NOT NULL AUTO_INCREMENT,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NULL,
  `descripcion` VARCHAR(150) NULL,
  `tipo_licencia` VARCHAR(45) NOT NULL,
  `titular` VARCHAR(100) NOT NULL,
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_CONTENIDO_TBL_ALBUMES_ID_album` INT NOT NULL,
  PRIMARY KEY (`ID_derecho`),
  INDEX `fk_TBL_DERECHOS_TBL_CONTENIDO1_idx` (`TBL_CONTENIDO_ID_contenido` ASC, `TBL_CONTENIDO_TBL_ALBUMES_ID_album` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_DERECHOS_TBL_CONTENIDO1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido` , `TBL_CONTENIDO_TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido` , `TBL_ALBUMES_ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_EMPLEADOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_EMPLEADOS` (
  `ID_empleado` INT NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(50) NOT NULL,
  `apellidos` VARCHAR(50) NOT NULL,
  `genero` VARCHAR(1) NOT NULL COMMENT 'F o M',
  `fecha_nacimiento` DATE NOT NULL,
  `telefono` VARCHAR(15) NOT NULL,
  `correo` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`ID_empleado`),
  UNIQUE INDEX `correo_UNIQUE` (`correo` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_SALARIOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_SALARIOS` (
  `fecha_inicio` DATE NOT NULL,
  `fecha_final` DATE NULL,
  `monto` FLOAT NOT NULL,
  `TBL_EMPLEADOS_ID_empleado` INT NOT NULL,
  PRIMARY KEY (`fecha_inicio`, `TBL_EMPLEADOS_ID_empleado`),
  INDEX `fk_TBL_SALARIOS_TBL_EMPLEADOS1_idx` (`TBL_EMPLEADOS_ID_empleado` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_SALARIOS_TBL_EMPLEADOS1`
    FOREIGN KEY (`TBL_EMPLEADOS_ID_empleado`)
    REFERENCES `prime_music`.`TBL_EMPLEADOS` (`ID_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_CARGOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_CARGOS` (
  `ID_cargo` INT NOT NULL AUTO_INCREMENT,
  `cargo` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`ID_cargo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_TICKETS_SOPORTE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_TICKETS_SOPORTE` (
  `ID_suscriptor` INT NOT NULL AUTO_INCREMENT,
  `fecha_creacion` DATE NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `prioridad` INT NOT NULL,
  `estado` VARCHAR(50) NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  `TBL_EMPLEADOS_ID_empleado` INT NOT NULL,
  PRIMARY KEY (`ID_suscriptor`, `TBL_USUARIOS_ID_usuario`, `TBL_EMPLEADOS_ID_empleado`),
  INDEX `fk_TBL_TICKETS_SOPORTE_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  INDEX `fk_TBL_TICKETS_SOPORTE_TBL_EMPLEADOS1_idx` (`TBL_EMPLEADOS_ID_empleado` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_TICKETS_SOPORTE_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_TICKETS_SOPORTE_TBL_EMPLEADOS1`
    FOREIGN KEY (`TBL_EMPLEADOS_ID_empleado`)
    REFERENCES `prime_music`.`TBL_EMPLEADOS` (`ID_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_EMPLEADOS_has_TBL_CARGOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_EMPLEADOS_has_TBL_CARGOS` (
  `TBL_EMPLEADOS_ID_empleado` INT NOT NULL,
  `TBL_CARGOS_ID_cargo` INT NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NULL,
  PRIMARY KEY (`TBL_EMPLEADOS_ID_empleado`, `TBL_CARGOS_ID_cargo`, `fecha_inicio`),
  INDEX `fk_TBL_EMPLEADOS_has_TBL_CARGOS_TBL_CARGOS1_idx` (`TBL_CARGOS_ID_cargo` ASC) VISIBLE,
  INDEX `fk_TBL_EMPLEADOS_has_TBL_CARGOS_TBL_EMPLEADOS1_idx` (`TBL_EMPLEADOS_ID_empleado` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_EMPLEADOS_has_TBL_CARGOS_TBL_EMPLEADOS1`
    FOREIGN KEY (`TBL_EMPLEADOS_ID_empleado`)
    REFERENCES `prime_music`.`TBL_EMPLEADOS` (`ID_empleado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_EMPLEADOS_has_TBL_CARGOS_TBL_CARGOS1`
    FOREIGN KEY (`TBL_CARGOS_ID_cargo`)
    REFERENCES `prime_music`.`TBL_CARGOS` (`ID_cargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_VALORACIONES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_VALORACIONES` (
  `puntaje` INT NOT NULL,
  `fecha` DATE NOT NULL,
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`TBL_CONTENIDO_ID_contenido`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_VALORACIONES_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_VALORACIONES_TBL_CONTENIDO1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_VALORACIONES_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`comentarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`comentarios` (
  `ID_comentarios` INT NOT NULL AUTO_INCREMENT,
  `comentario` VARCHAR(150) NOT NULL,
  `fecha` DATE NOT NULL,
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_CONTENIDO_TBL_ALBUMES_ID_album` INT NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`ID_comentarios`, `TBL_CONTENIDO_ID_contenido`, `TBL_CONTENIDO_TBL_ALBUMES_ID_album`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_comentarios_TBL_CONTENIDO1_idx` (`TBL_CONTENIDO_ID_contenido` ASC, `TBL_CONTENIDO_TBL_ALBUMES_ID_album` ASC) VISIBLE,
  INDEX `fk_comentarios_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_comentarios_TBL_CONTENIDO1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido` , `TBL_CONTENIDO_TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido` , `TBL_ALBUMES_ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comentarios_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_INTERPRETES_has_TBL_CONTENIDO`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_INTERPRETES_has_TBL_CONTENIDO` (
  `TBL_INTERPRETES_ID_interprete` INT NOT NULL,
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_CONTENIDO_TBL_ALBUMES_ID_album` INT NOT NULL,
  PRIMARY KEY (`TBL_INTERPRETES_ID_interprete`, `TBL_CONTENIDO_ID_contenido`, `TBL_CONTENIDO_TBL_ALBUMES_ID_album`),
  INDEX `fk_TBL_INTERPRETES_has_TBL_CONTENIDO_TBL_CONTENIDO1_idx` (`TBL_CONTENIDO_ID_contenido` ASC, `TBL_CONTENIDO_TBL_ALBUMES_ID_album` ASC) VISIBLE,
  INDEX `fk_TBL_INTERPRETES_has_TBL_CONTENIDO_TBL_INTERPRETES1_idx` (`TBL_INTERPRETES_ID_interprete` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_INTERPRETES_has_TBL_CONTENIDO_TBL_INTERPRETES1`
    FOREIGN KEY (`TBL_INTERPRETES_ID_interprete`)
    REFERENCES `prime_music`.`TBL_INTERPRETES` (`ID_interprete`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_INTERPRETES_has_TBL_CONTENIDO_TBL_CONTENIDO1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido` , `TBL_CONTENIDO_TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido` , `TBL_ALBUMES_ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_GRUPOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_GRUPOS` (
  `id_grupo` INT NOT NULL,
  `nombre` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id_grupo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_INTERPRETES_has_TBL_GRUPOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_INTERPRETES_has_TBL_GRUPOS` (
  `TBL_INTERPRETES_ID_interprete` INT NOT NULL,
  `TBL_GRUPOS_id_grupo` INT NOT NULL,
  `fecha` DATE NULL COMMENT 'Fecha apartir de la cual forma parte del grupo',
  PRIMARY KEY (`TBL_INTERPRETES_ID_interprete`, `TBL_GRUPOS_id_grupo`),
  INDEX `fk_TBL_INTERPRETES_has_TBL_GRUPOS_TBL_GRUPOS1_idx` (`TBL_GRUPOS_id_grupo` ASC) VISIBLE,
  INDEX `fk_TBL_INTERPRETES_has_TBL_GRUPOS_TBL_INTERPRETES1_idx` (`TBL_INTERPRETES_ID_interprete` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_INTERPRETES_has_TBL_GRUPOS_TBL_INTERPRETES1`
    FOREIGN KEY (`TBL_INTERPRETES_ID_interprete`)
    REFERENCES `prime_music`.`TBL_INTERPRETES` (`ID_interprete`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_INTERPRETES_has_TBL_GRUPOS_TBL_GRUPOS1`
    FOREIGN KEY (`TBL_GRUPOS_id_grupo`)
    REFERENCES `prime_music`.`TBL_GRUPOS` (`id_grupo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_SEGUIDORES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_SEGUIDORES` (
  `fecha_inicio` DATE NOT NULL COMMENT 'Fecha desde la cual comenzó a seguir al interprete de podcast o artista',
  `fecha_final` DATE NULL,
  `TBL_INTERPRETES_ID_interprete` INT NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`fecha_inicio`, `TBL_INTERPRETES_ID_interprete`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_SEGUIDORES_TBL_INTERPRETES1_idx` (`TBL_INTERPRETES_ID_interprete` ASC) VISIBLE,
  INDEX `fk_TBL_SEGUIDORES_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_SEGUIDORES_TBL_INTERPRETES1`
    FOREIGN KEY (`TBL_INTERPRETES_ID_interprete`)
    REFERENCES `prime_music`.`TBL_INTERPRETES` (`ID_interprete`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_TBL_SEGUIDORES_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_HISTORIAL_ACCESOS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_HISTORIAL_ACCESOS` (
  `fecha_acceso` DATE NOT NULL,
  `fecha_cierre_sesion` DATE NULL,
  `dispositivo` VARCHAR(50) NOT NULL,
  `ubicacion` VARCHAR(150) NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`fecha_acceso`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_HISTORIAL_ACCESOS_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_HISTORIAL_ACCESOS_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_LETRAS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_LETRAS` (
  `letra` BLOB NULL,
  `TBL_CONTENIDO_ID_contenido` INT NOT NULL,
  `TBL_CONTENIDO_TBL_ALBUMES_ID_album` INT NOT NULL,
  PRIMARY KEY (`TBL_CONTENIDO_ID_contenido`, `TBL_CONTENIDO_TBL_ALBUMES_ID_album`),
  CONSTRAINT `fk_TBL_LETRAS_TBL_CONTENIDO1`
    FOREIGN KEY (`TBL_CONTENIDO_ID_contenido` , `TBL_CONTENIDO_TBL_ALBUMES_ID_album`)
    REFERENCES `prime_music`.`TBL_CONTENIDO` (`ID_contenido` , `TBL_ALBUMES_ID_album`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `prime_music`.`TBL_NOTIFICACIONES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prime_music`.`TBL_NOTIFICACIONES` (
  `ID_notificacion` INT NOT NULL AUTO_INCREMENT,
  `mensaje` VARCHAR(45) NOT NULL,
  `fecha` DATE NOT NULL,
  `TBL_USUARIOS_ID_usuario` INT NOT NULL,
  PRIMARY KEY (`ID_notificacion`, `TBL_USUARIOS_ID_usuario`),
  INDEX `fk_TBL_NOTIFICACIONES_TBL_USUARIOS1_idx` (`TBL_USUARIOS_ID_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_TBL_NOTIFICACIONES_TBL_USUARIOS1`
    FOREIGN KEY (`TBL_USUARIOS_ID_usuario`)
    REFERENCES `prime_music`.`TBL_USUARIOS` (`ID_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
