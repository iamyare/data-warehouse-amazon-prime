CREATE TABLE dim_suscripcion(
	SuscripcionID INT,
    Tipo_suscripcion VARCHAR2(20) NOT NULL,
    CONSTRAINT PK_SUSCRIPCION PRIMARY KEY(SuscripcionID)
);

CREATE TABLE dim_suscriptor(
	SuscriptorID INT,
    Genero VARCHAR2(1) NOT NULL,
    Fecha_nacimiento DATE NOT NULL,
    CONSTRAINT PK_SUSCRIPTOR PRIMARY KEY(SuscriptorID)
);


CREATE TABLE dim_tiempo(
	TiempoID INT,
    Anio INT NOT NULL,
	Trimestre INT NOT NULL,
	Mes INT NOT NULL,
    CONSTRAINT PK_TIEMPO PRIMARY KEY(TiempoID)
);



CREATE TABLE dim_dispositivo(
	DispositivoID INT,
    nombre VARCHAR2(50),
    CONSTRAINT PK_DISPOSITIVO PRIMARY KEY(DispositivoID)
);




CREATE TABLE dim_ubicacion(
	UbicacionID INT,
    nombre VARCHAR2(150),
    CONSTRAINT PK_UBICACION PRIMARY KEY(UbicacionID)
);


CREATE TABLE Fact_ingresos
(
	IngresosSuscripcionID INT,
	SuscripcionID INT NOT NULL,
	SuscriptorID INT,
	DispositivoID INT NOT NULL,
	UbicacionID INT NOT NULL,
	TiempoID INT NOT NULL,
	TotalIngresosSuscripcion NUMBER(10,2) NOT NULL,

	CONSTRAINT PK_ingresos_suscripcion PRIMARY KEY(IngresosSuscripcionID,SuscripcionID,SuscriptorID,DispositivoID,UbicacionID, TiempoID),

	CONSTRAINT FK_ingresos_suscripcion FOREIGN KEY(SuscripcionID) REFERENCES Dim_suscripcion(SuscripcionID),
	CONSTRAINT FK_ingresos_suscriptor FOREIGN KEY(SuscriptorID) REFERENCES Dim_suscriptor(SuscriptorID),
	CONSTRAINT FK_ingresos_dispositivo FOREIGN KEY(DispositivoID) REFERENCES Dim_dispositivo(DispositivoID),
	CONSTRAINT FK_ingresos_ubicacion FOREIGN KEY(UbicacionID) REFERENCES Dim_ubicacion(UbicacionID),
	CONSTRAINT FK_ingresos_Tiempo FOREIGN KEY(TiempoID) REFERENCES Dim_Tiempo(TiempoID)
);


CREATE TABLE ETL_Log (
    Log_ID      NUMBER PRIMARY KEY,
    Procedure_Name  VARCHAR2(100),
    Execution_Date  DATE,
    Success_value    CHAR(1) CHECK (Success_value IN ('Y', 'N')),
    Error_Message   VARCHAR2(500)
);


