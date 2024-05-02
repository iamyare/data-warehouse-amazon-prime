
----------------Conexión a Oracle----------------------------------
CREATE DATABASE LINK link_video CONNECT TO  USERTEST IDENTIFIED BY USERTEST USING '//localhost:1521/xe';
SELECT * FROM tbl_actores@link_video;

----------------Conexión a MYSQL Workbrench----------------------------------
CREATE DATABASE LINK link_music CONNECT TO  "root" IDENTIFIED BY "E7tdMm0lq$fh@" USING 'jemysql';
SELECT * FROM tbl_albumes@link_music;

----------------Conexión a MongoDB ----------------------------------
CREATE DATABASE LINK link_photo CONNECT TO  "user1" IDENTIFIED BY "pass1234" USING 'MongoDB';
SELECT * FROM fotos@link_photo;





--Procedimiento para limpiar el datawarehouse
CREATE OR REPLACE PROCEDURE limpieza_datawarehouse
IS
BEGIN
    -- Borrar datos antiguos 
    DELETE FROM dim_suscripcion;
    DELETE FROM dim_acceso;
    DELETE FROM dim_tiempo;
    DELETE FROM dim_suscriptor;
    DELETE FROM Fact_ingresos;
    
END;


CREATE OR REPLACE PROCEDURE etl_tipo_suscripciones
IS
BEGIN
    -- Insertar datos nuevos
    INSERT INTO dim_suscripcion (SuscripcionID, Tipo_suscripcion, Fecha_suscripcion)
    SELECT ID_SUSCRIPCION, TIPO, FECHA_INICIO FROM tbl_suscripciones@link_video;
END;


CREATE OR REPLACE PROCEDURE etl_accesos
IS
BEGIN
    INSERT INTO dim_acceso (AccesoID,DISPOSITIVO,Ubicacion)
    SELECT DISTINCT FECHA_ACCESO,DISPOSITIVO,Ubicacion FROM tbl_historial_accesos@link_video;
END;



CREATE OR REPLACE PROCEDURE etl_dimension_tiempo
IS
BEGIN
    INSERT INTO dim_tiempo (TiempoID, Anio, Trimestre, Mes)
    SELECT Distinct FECHA as TimeID,
        EXTRACT(YEAR FROM FECHA) AS Anio,
        CEIL(EXTRACT(MONTH FROM FECHA)/3) AS Trimestre,
        EXTRACT(MONTH FROM FECHA) as Mes
    FROM tbl_pagos@link_video;
END;



CREATE OR REPLACE PROCEDURE etl_dimension_suscriptor
IS
BEGIN 
    INSERT INTO dim_suscriptor (SuscriptorID, GENERO, FECHA_NACIMIENTO)
    SELECT ID_SUSCRIPTOR, GENERO, FECHA_NACIMIENTO FROM tbl_suscriptores@link_video;
END;



CREATE OR REPLACE PROCEDURE etl_tabla_hechos_ingresos
IS
BEGIN
    INSERT INTO Fact_ingresos (SuscripcionID, SuscriptorID, AccesoID, Dispositivo, Ubicacion, TiempoID, TotalIngresosSuscripcion)
    SELECT SUS.ID_SUSCRIPCION,SUSCRI.ID_SUSCRIPTOR ,HI.FECHA_ACCESO, HI.Dispositivo,HI.Ubicacion, P.FECHA,
    SUM (P.MONTO) as total_ingresos_x_suscripcion
    FROM tbl_suscripciones@link_video SUS
    INNER JOIN tbl_historial_accesos@link_video HI
    ON SUS.ID_SUSCRIPTOR = HI.ID_SUSCRIPTOR
    INNER JOIN tbl_suscriptores@link_video SUSCRI
    ON SUSCRI.ID_SUSCRIPTOR=SUS.ID_SUSCRIPTOR
    INNER JOIN tbl_pagos@link_video P
    ON SUSCRI.ID_SUSCRIPTOR=P.ID_SUSCRIPTOR
    GROUP BY SUS.ID_SUSCRIPCION,SUSCRI.ID_SUSCRIPTOR ,HI.FECHA_ACCESO, HI.Dispositivo,HI.Ubicacion, P.FECHA;
END;


-------------------------------- EJECUCIÓN DE LOS PROCEDIMIENTOS ALMACENADOS ---------------------------------------

BEGIN
limpieza_datawarehouse;
END;

BEGIN
etl_tipo_suscripciones;
etl_accesos;
etl_dimension_tiempo;
etl_dimension_suscriptor;
etl_tabla_hechos_ingresos;
END;





-----------------------------------------PROCEDIMIENTOS ETL PARA BASE DE MYSQL--------------------------------------------  
CREATE OR REPLACE PROCEDURE etl_tipo_suscripciones_music
IS
BEGIN
     -- Insertar datos nuevos
    INSERT INTO dim_suscripcion (SuscripcionID, Tipo_suscripcion, Fecha_suscripcion)
    SELECT "ID_suscripcion"+1000,"tipo","fecha_inicio" FROM tbl_suscripciones@link_music;
END;


CREATE OR REPLACE PROCEDURE etl_accesos_music
IS
BEGIN
    INSERT INTO dim_acceso (AccesoID,DISPOSITIVO,Ubicacion)
    SELECT DISTINCT "fecha_acceso","dispositivo","ubicacion" FROM tbl_historial_accesos@link_music;
END;



CREATE OR REPLACE PROCEDURE etl_dimension_tiempo_music
IS
BEGIN
    INSERT INTO dim_tiempo (TiempoID, Anio, Trimestre, Mes)
    SELECT Distinct "fecha" as TimeID,
        EXTRACT(YEAR FROM "fecha") AS Anio,
        CEIL(EXTRACT(MONTH FROM "fecha")/3) AS Trimestre,
        EXTRACT(MONTH FROM "fecha") as Mes
    FROM tbl_pagos@link_music;
END;



CREATE OR REPLACE PROCEDURE etl_dimension_suscriptor_music
IS
BEGIN 
    INSERT INTO dim_suscriptor (SuscriptorID, GENERO, FECHA_NACIMIENTO)
    SELECT "ID_usuario"+1000, "genero", "fecha_nacimiento" FROM tbl_usuarios@link_music;
END;




CREATE OR REPLACE PROCEDURE etl_tabla_hechos_ingresos_music
IS
BEGIN
    INSERT INTO Fact_ingresos (SuscripcionID, SuscriptorID, AccesoID, Dispositivo, Ubicacion, TiempoID, TotalIngresosSuscripcion)
    SELECT tbl_suscripciones."ID_suscripcion"+1000, tbl_usuarios."ID_usuario"+1000, tbl_historial_accesos."fecha_acceso", 
    tbl_historial_accesos."dispositivo", tbl_historial_accesos."ubicacion", tbl_pagos."fecha", 
    SUM (tbl_pagos."monto") 
    FROM tbl_suscripciones@link_music 
    INNER JOIN tbl_historial_accesos@link_music 
    ON tbl_suscripciones."TBL_USUARIOS_ID_usuario" = tbl_historial_accesos."TBL_USUARIOS_ID_usuario"
    INNER JOIN tbl_usuarios@link_music 
    ON tbl_usuarios."ID_usuario"=tbl_suscripciones."TBL_USUARIOS_ID_usuario"
    INNER JOIN tbl_pagos@link_music 
    ON tbl_usuarios."ID_usuario"=tbl_pagos."TBL_USUARIOS_ID_usuario"
    GROUP BY tbl_suscripciones."ID_suscripcion"+1000, tbl_usuarios."ID_usuario"+1000, tbl_historial_accesos."fecha_acceso", 
    tbl_historial_accesos."dispositivo", tbl_historial_accesos."ubicacion", tbl_pagos."fecha"; 
END;









-------------------------------- EJECUCIÓN DE LOS PROCEDIMIENTOS ALMACENADOS PARA LA BASE DE DATOS MYSQL ---------------------------------------


BEGIN
etl_tipo_suscripciones_music;
etl_accesos_music;
etl_dimension_tiempo_music;
etl_dimension_suscriptor_music;
etl_tabla_hechos_ingresos_music;
END;








-----------------------------------------PROCEDIMIENTOS ETL PARA BASE DE MONGODB--------------------------------------------  
CREATE OR REPLACE PROCEDURE etl_tipo_suscripciones_photo
IS
BEGIN
     -- Insertar datos nuevos
    INSERT INTO dim_suscripcion (SuscripcionID, Tipo_suscripcion, Fecha_suscripcion)
    SELECT to_number(usuarios."id_usuario")+3000,usuarios."almacenamiento", suscripciones."fecha_suscripcion"
    FROM usuarios@link_photo
    INNER JOIN suscripciones@link_photo
    ON usuarios."id_usuario"=suscripciones."id_usuario";
END;



CREATE OR REPLACE PROCEDURE etl_accesos_photo
IS
BEGIN
    INSERT INTO dim_acceso (AccesoID,DISPOSITIVO,Ubicacion)
    SELECT DISTINCT TO_DATE("fecha_suscripcion"),"dispositivo","ubicacion" FROM suscripciones@link_photo;
END;



CREATE OR REPLACE PROCEDURE etl_dimension_tiempo_photo
IS
BEGIN
    INSERT INTO dim_tiempo (TiempoID, Anio, Trimestre, Mes)
    SELECT Distinct TO_DATE("fecha"), EXTRACT(YEAR FROM TO_DATE("fecha")), CEIL(EXTRACT(MONTH FROM TO_DATE("fecha"))/3),  EXTRACT(MONTH FROM TO_DATE("fecha"))
    FROM pagos@link_photo;
    
    
END;



CREATE OR REPLACE PROCEDURE etl_dimension_suscriptor_photo
IS
BEGIN 
    INSERT INTO dim_suscriptor (SuscriptorID, GENERO, FECHA_NACIMIENTO)
    SELECT to_number("id_usuario")+3000, "genero", to_date("fecha_nacimiento") FROM usuarios@link_photo;
END;




CREATE OR REPLACE PROCEDURE etl_tabla_hechos_ingresos_photo
IS
BEGIN
    INSERT INTO Fact_ingresos (SuscripcionID, SuscriptorID, AccesoID, Dispositivo, Ubicacion, TiempoID, TotalIngresosSuscripcion)
    SELECT to_number(usuarios."id_usuario")+3000, to_number(usuarios."id_usuario")+3000, TO_DATE(suscripciones."fecha_suscripcion"), suscripciones."dispositivo", suscripciones."ubicacion",
    to_date(pagos."fecha"),sum(to_number(pagos."monto"))
    FROM usuarios@link_photo
    INNER JOIN pagos@link_photo
    ON usuarios."id_usuario"=pagos."id_usuario"
    INNER JOIN suscripciones@link_photo
    ON suscripciones."id_usuario"=usuarios."id_usuario"    
    GROUP BY to_number(usuarios."id_usuario")+3000, to_number(usuarios."id_usuario")+3000, TO_DATE(suscripciones."fecha_suscripcion"), suscripciones."dispositivo", suscripciones."ubicacion",
    to_date(pagos."fecha");
END;





BEGIN
etl_tipo_suscripciones_photo;
etl_accesos_photo;
etl_dimension_tiempo_photo;
etl_dimension_suscriptor_photo;
etl_tabla_hechos_ingresos_photo;
END;










-----Tablas temporales para preprocesamiento

CREATE TABLE dim_suscripcion_Temp(
	SuscripcionID INT,
    Tipo_suscripcion VARCHAR2(20) NOT NULL,
    Fecha_suscripcion DATE NOT NULL
);



CREATE TABLE dim_suscriptor_Temp(
	SuscriptorID INT,
    Genero VARCHAR2(1) NOT NULL,
    Fecha_nacimiento DATE NOT NULL
);


CREATE TABLE dim_tiempo_Temp(
	TiempoID VARCHAR(100),
    Anio INT NULL,
	Trimestre INT NULL,
	Mes INT NULL
);





CREATE TABLE dim_acceso_Temp(
    AccesoID DATE NOT NULL, 
    Dispositivo VARCHAR2(50) NOT NULL,
    Ubicacion VARCHAR2(150) NOT NULL
);




CREATE TABLE Fact_ingresos_Temp
(
	SuscripcionID INT NOT NULL,
	SuscriptorID INT,
	AccesoID DATE NOT NULL,
    Dispositivo VARCHAR2(50) NOT NULL,
    Ubicacion VARCHAR2(150) NOT NULL,
	TiempoID DATE NOT NULL,
	TotalIngresosSuscripcion NUMBER(10,2) NOT NULL
);

