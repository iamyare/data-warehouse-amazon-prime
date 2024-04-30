
CREATE TABLE tbl_actores (
    id_actor         NUMBER NOT NULL,
    nombres          VARCHAR2(50) NOT NULL,
    apellidos        VARCHAR2(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero           VARCHAR2(1 CHAR) NOT NULL,
    nacionalidad     VARCHAR2(50) NOT NULL,
    url_foto         VARCHAR2(150) NOT NULL
);

ALTER TABLE tbl_actores ADD CONSTRAINT tbl_actores_pk PRIMARY KEY ( id_actor );

CREATE TABLE tbl_capitulos (
    id_capitulo                NUMBER NOT NULL,
    temporada                  NUMBER NOT NULL,
    titulo                     VARCHAR2(100) NOT NULL,
    descripcion                VARCHAR2(250) NOT NULL,
    fecha_lanzamiento          DATE NOT NULL,
    valoracion                 NUMBER(3, 1),
    tbl_contenido_id_contenido NUMBER NOT NULL
);

ALTER TABLE tbl_capitulos
    ADD CONSTRAINT tbl_capitulos_pk PRIMARY KEY ( id_capitulo,
                                                  temporada,
                                                  tbl_contenido_id_contenido );

CREATE TABLE tbl_cargos (
    id_cargo NUMBER NOT NULL,
    cargo    VARCHAR2(80) NOT NULL
);

COMMENT ON COLUMN tbl_cargos.cargo IS
    'cargo del empleado puede ser Especialistas en seguridad, Especialistas en atención al cliente,Gerentes de producto, Analistas de datos, Especialistas en recursos humanos o Especialistas en soporte técnico.'
    ;

ALTER TABLE tbl_cargos ADD CONSTRAINT tbl_puestos_pk PRIMARY KEY ( id_cargo );

CREATE TABLE tbl_categorias (
    id_categoria NUMBER NOT NULL,
    nombre       VARCHAR2(80) NOT NULL
);

ALTER TABLE tbl_categorias ADD CONSTRAINT tbl_categorias_pk PRIMARY KEY ( id_categoria );

CREATE TABLE tbl_contenido (
    id_contenido      NUMBER NOT NULL,
    titulo            VARCHAR2(80) NOT NULL,
    descripcion       VARCHAR2(250) NOT NULL,
    valoracion        NUMBER(3, 1) NOT NULL,
    pais              VARCHAR2(50) NOT NULL,
    restriccion_edad  VARCHAR2(20) NOT NULL,
    duracion          NUMBER(4, 1) NOT NULL,
    url_caratula      VARCHAR2(150) NOT NULL,
    url_trailer       VARCHAR2(150),
    fecha_lanzamiento DATE NOT NULL
);

ALTER TABLE tbl_contenido ADD CONSTRAINT tbl_contenido_pk PRIMARY KEY ( id_contenido );

CREATE TABLE tbl_cto_ats (
    id_actor     NUMBER NOT NULL,
    id_contenido NUMBER NOT NULL,
    papel        VARCHAR2(20) NOT NULL,
    personaje    VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN tbl_cto_ats.papel IS
    'Papel que interpreto en la película (principal, secundario)';

COMMENT ON COLUMN tbl_cto_ats.personaje IS
    'Personaje como tal que interpreta';

ALTER TABLE tbl_cto_ats ADD CONSTRAINT interpretan_pk PRIMARY KEY ( id_actor,
                                                                    id_contenido );

CREATE TABLE tbl_cto_cts (
    id_contenido NUMBER NOT NULL,
    id_categoria NUMBER NOT NULL
);

ALTER TABLE tbl_cto_cts ADD CONSTRAINT relation_4_pk PRIMARY KEY ( id_contenido,
                                                                   id_categoria );

CREATE TABLE tbl_cto_drs (
    id_director  NUMBER NOT NULL,
    id_contenido NUMBER NOT NULL
);

ALTER TABLE tbl_cto_drs ADD CONSTRAINT dirigir_pk PRIMARY KEY ( id_director,
                                                                id_contenido );

CREATE TABLE tbl_cto_hr (
    id_historial        NUMBER NOT NULL,
    id_contenido        NUMBER NOT NULL,
    fecha_visualizacion DATE NOT NULL
);

ALTER TABLE tbl_cto_hr ADD CONSTRAINT relation_16_pk PRIMARY KEY ( id_historial,
                                                                   id_contenido );

CREATE TABLE tbl_cto_io (
    id_idioma    NUMBER NOT NULL,
    id_contenido NUMBER NOT NULL
);

ALTER TABLE tbl_cto_io ADD CONSTRAINT tbl_cto_io__pk PRIMARY KEY ( id_idioma,
                                                                   id_contenido );

CREATE TABLE tbl_cto_lrs (
    id_contenido   NUMBER NOT NULL,
    id_lista       NUMBER NOT NULL,
    fecha_agregado DATE NOT NULL
);

ALTER TABLE tbl_cto_lrs ADD CONSTRAINT relation_15_pk PRIMARY KEY ( id_contenido,
                                                                    id_lista );

CREATE TABLE tbl_cto_pds (
    id_contenido NUMBER NOT NULL,
    id_productor NUMBER NOT NULL
);

ALTER TABLE tbl_cto_pds ADD CONSTRAINT relation_6_pk PRIMARY KEY ( id_contenido,
                                                                   id_productor );

CREATE TABLE tbl_directores (
    id_director      NUMBER NOT NULL,
    nombres          VARCHAR2(50) NOT NULL,
    apellidos        VARCHAR2(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    nacionalidad     VARCHAR2(50) NOT NULL
);

ALTER TABLE tbl_directores ADD CONSTRAINT tbl_directores_pk PRIMARY KEY ( id_director );

CREATE TABLE tbl_empleados (
    dni_empleado     NUMBER NOT NULL,
    nombres          VARCHAR2(50) NOT NULL,
    apellidos        VARCHAR2(50),
    genero           VARCHAR2(1 CHAR) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono         VARCHAR2(15) NOT NULL,
    correo           VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN tbl_empleados.dni_empleado IS
    'dni del empleado';

COMMENT ON COLUMN tbl_empleados.nombres IS
    'Primer y segundo nombre del empleado';

COMMENT ON COLUMN tbl_empleados.apellidos IS
    'Apellidos del empleado';

COMMENT ON COLUMN tbl_empleados.genero IS
    'Genero del empleado (F o M)';

COMMENT ON COLUMN tbl_empleados.fecha_nacimiento IS
    'fecha de nacimiento del empleado';

COMMENT ON COLUMN tbl_empleados.telefono IS
    'telefono del empleado';

COMMENT ON COLUMN tbl_empleados.correo IS
    'correo del empleado';

ALTER TABLE tbl_empleados ADD CONSTRAINT tbl_empleados_pk PRIMARY KEY ( dni_empleado );

CREATE TABLE tbl_eps_cgs (
    dni_empleado NUMBER NOT NULL,
    id_cargo     NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_final  DATE
);

COMMENT ON COLUMN tbl_eps_cgs.fecha_inicio IS
    'Fecha en la cual comienza el empleado en este puesto';

COMMENT ON COLUMN tbl_eps_cgs.fecha_final IS
    'Fecha en la cual finaliza  el empleado en este puesto';

ALTER TABLE tbl_eps_cgs
    ADD CONSTRAINT tbl_eps_cgs_pk PRIMARY KEY ( dni_empleado,
                                                id_cargo,
                                                fecha_inicio );

CREATE TABLE tbl_historial_accesos (
    fecha_acceso        DATE NOT NULL,
    fecha_cierre_sesion DATE,
    dispositivo         VARCHAR2(50),
    ubicacion           VARCHAR2(150) NOT NULL,
    id_suscriptor       NUMBER NOT NULL
);

COMMENT ON COLUMN tbl_historial_accesos.fecha_acceso IS
    'fecha y hora del acceso a la plataforma ';

COMMENT ON COLUMN tbl_historial_accesos.fecha_cierre_sesion IS
    'Fecha en la cual se cierra la sesión';

COMMENT ON COLUMN tbl_historial_accesos.dispositivo IS
    'Dispositivo de acceso, tablet, laptop, movil';

ALTER TABLE tbl_historial_accesos ADD CONSTRAINT tbl_historial_accesos_pk PRIMARY KEY ( id_suscriptor,
                                                                                        fecha_acceso );

CREATE TABLE tbl_historiales_reproduccion (
    id_historial    NUMBER NOT NULL,
    id_perfil       NUMBER NOT NULL,
    fecha_historial DATE NOT NULL
);

ALTER TABLE tbl_historiales_reproduccion ADD CONSTRAINT historial_reproduccion_pk PRIMARY KEY ( id_historial );

CREATE TABLE tbl_idiomas (
    id_idioma NUMBER NOT NULL,
    idioma    VARCHAR2(50) NOT NULL
);

ALTER TABLE tbl_idiomas ADD CONSTRAINT tbl_idiomas_pk PRIMARY KEY ( id_idioma );

CREATE TABLE tbl_licencias (
    id_licencia                  NUMBER NOT NULL,
    fecha_inicio                 DATE NOT NULL,
    fecha_fin                    DATE,
    tarifa                       NUMBER(4, 1) NOT NULL,
    descripcion                  VARCHAR2(150) NOT NULL,
    tbl_contenido_id_contenido   NUMBER NOT NULL,
    tbl_proveedores_id_proveedor NUMBER NOT NULL
);

ALTER TABLE tbl_licencias ADD CONSTRAINT tbl_licencias_pk PRIMARY KEY ( id_licencia );

CREATE TABLE tbl_listas_reproduccion (
    id_lista       NUMBER NOT NULL,
    fecha_creacion DATE NOT NULL,
    id_perfil      NUMBER NOT NULL
);

ALTER TABLE tbl_listas_reproduccion ADD CONSTRAINT tbl_listas_reproduccion_pk PRIMARY KEY ( id_lista );

CREATE TABLE tbl_pagos (
    id_pago       NUMBER NOT NULL,
    fecha         DATE NOT NULL,
    monto         NUMBER(4, 1),
    id_suscriptor NUMBER NOT NULL
);

ALTER TABLE tbl_pagos ADD CONSTRAINT tbl_pagos_pk PRIMARY KEY ( id_pago );

CREATE TABLE tbl_perfiles (
    id_perfil     NUMBER NOT NULL,
    nombre        VARCHAR2(15) NOT NULL,
    tipo          VARCHAR2(2 CHAR) NOT NULL,
    url_foto      VARCHAR2(150) NOT NULL,
    id_suscriptor NUMBER NOT NULL
);

ALTER TABLE tbl_perfiles ADD CONSTRAINT tbl_perfiles_pk PRIMARY KEY ( id_perfil );

CREATE TABLE tbl_productores (
    id_productor NUMBER NOT NULL,
    nombre       VARCHAR2(100) NOT NULL
);

ALTER TABLE tbl_productores ADD CONSTRAINT tbl_productores_pk PRIMARY KEY ( id_productor );

CREATE TABLE tbl_proveedores (
    id_proveedor NUMBER NOT NULL,
    nombre       VARCHAR2(50) NOT NULL,
    telefono     VARCHAR2(15) NOT NULL,
    correo       VARCHAR2(50) NOT NULL
);

ALTER TABLE tbl_proveedores ADD CONSTRAINT tbl_proveedores_pk PRIMARY KEY ( id_proveedor );

CREATE TABLE tbl_salarios (
    fecha_inicio DATE NOT NULL,
    fecha_final  DATE,
    monto        NUMBER(8, 2) NOT NULL,
    dni_empleado NUMBER NOT NULL
);

ALTER TABLE tbl_salarios ADD CONSTRAINT tbl_salarios_pk PRIMARY KEY ( fecha_inicio,
                                                                      dni_empleado );

CREATE TABLE tbl_suscripcion_tarjeta (
    id_tarjeta           NUMBER NOT NULL,
    id_suscriptor        NUMBER NOT NULL,
    fecha_vinculacion    DATE NOT NULL,
    fecha_desvinculacion DATE
);

ALTER TABLE tbl_suscripcion_tarjeta ADD CONSTRAINT tbl_suscripcion_tarjetav1_pk PRIMARY KEY ( id_tarjeta,
                                                                                              id_suscriptor );

CREATE TABLE tbl_suscripciones (
    id_suscripcion NUMBER(6) NOT NULL,
    descripcion    VARCHAR2(50) NOT NULL,
    tipo           VARCHAR2(20) NOT NULL,
    fecha_inicio   DATE NOT NULL,
    fecha_fin      DATE,
    precio         NUMBER(4, 1) NOT NULL,
    id_suscriptor  NUMBER NOT NULL
);

CREATE UNIQUE INDEX tbl_suscripciones__idx ON
    tbl_suscripciones (
        id_suscriptor
    ASC );

ALTER TABLE tbl_suscripciones ADD CONSTRAINT tbl_suscripciones_pk PRIMARY KEY ( id_suscripcion );

CREATE TABLE tbl_suscriptores (
    id_suscriptor    NUMBER NOT NULL,
    nombre           VARCHAR2(50) NOT NULL,
    apellidos        VARCHAR2(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    genero           VARCHAR2(1 CHAR) NOT NULL,
    direccion        VARCHAR2(100) NOT NULL,
    numero_celular   VARCHAR2(12) NOT NULL,
    correo           VARCHAR2(100) NOT NULL,
    contrasenia      VARCHAR2(150) NOT NULL
);

ALTER TABLE tbl_suscriptores ADD CONSTRAINT tbl_suscriptoresv1_pk PRIMARY KEY ( id_suscriptor );

CREATE TABLE tbl_tarjetas (
    id_tarjeta        NUMBER NOT NULL,
    num_tarjeta       VARCHAR2(150) NOT NULL,
    titular           VARCHAR2(50) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    pin               VARCHAR2(5) NOT NULL,
    tipo              VARCHAR2(30) NOT NULL
);

ALTER TABLE tbl_tarjetas ADD CONSTRAINT tbl_tarjetas_pk PRIMARY KEY ( id_tarjeta );

CREATE TABLE tbl_tickets_soporte (
    id_ticket      NUMBER NOT NULL,
    fecha_creacion DATE NOT NULL,
    descripcion    VARCHAR2(100) NOT NULL,
    prioridad      NUMBER(1) NOT NULL,
    estado         VARCHAR2(50) NOT NULL,
    dni_empleado   NUMBER NOT NULL,
    id_suscriptor  NUMBER NOT NULL
);

COMMENT ON COLUMN tbl_tickets_soporte.descripcion IS
    'Una breve descripción del problema o la solicitud del usuario';

COMMENT ON COLUMN tbl_tickets_soporte.prioridad IS
    'Nivel de prioridad del ticket, 3 niveles';

COMMENT ON COLUMN tbl_tickets_soporte.estado IS
    'Estado del ticket (e.g resuelto, en curso, etc)';

ALTER TABLE tbl_tickets_soporte ADD CONSTRAINT tbl_tickets_soporte_pk PRIMARY KEY ( id_ticket );

CREATE TABLE tbl_valoraciones (
    puntaje       NUMBER(2, 1) NOT NULL,
    fecha         DATE NOT NULL,
    id_suscriptor NUMBER NOT NULL,
    id_contenido  NUMBER NOT NULL
);

ALTER TABLE tbl_valoraciones ADD CONSTRAINT tbl_valoraciones_pk PRIMARY KEY ( id_suscriptor,
                                                                              id_contenido );

ALTER TABLE tbl_historial_accesos
    ADD CONSTRAINT accesos_suscriptores_fk FOREIGN KEY ( id_suscriptor )
        REFERENCES tbl_suscriptores ( id_suscriptor );

ALTER TABLE tbl_cto_pds
    ADD CONSTRAINT contenido_productores_fk FOREIGN KEY ( id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_cto_hr
    ADD CONSTRAINT cto_hr_contenido_fk FOREIGN KEY ( id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_cto_hr
    ADD CONSTRAINT cto_hr_historiales_fk FOREIGN KEY ( id_historial )
        REFERENCES tbl_historiales_reproduccion ( id_historial );

ALTER TABLE tbl_cto_io
    ADD CONSTRAINT cto_io_contenido_fk FOREIGN KEY ( id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_cto_io
    ADD CONSTRAINT cto_io_idiomas_fk FOREIGN KEY ( id_idioma )
        REFERENCES tbl_idiomas ( id_idioma );

ALTER TABLE tbl_cto_lrs
    ADD CONSTRAINT cto_lrs_contenido_fk FOREIGN KEY ( id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_cto_lrs
    ADD CONSTRAINT cto_lrs_listas_fk FOREIGN KEY ( id_lista )
        REFERENCES tbl_listas_reproduccion ( id_lista );

ALTER TABLE tbl_cto_drs
    ADD CONSTRAINT dirigir_contenido_fk FOREIGN KEY ( id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_cto_drs
    ADD CONSTRAINT dirigir_directores_fk FOREIGN KEY ( id_director )
        REFERENCES tbl_directores ( id_director );

ALTER TABLE tbl_historiales_reproduccion
    ADD CONSTRAINT historiales_perfiles_fk FOREIGN KEY ( id_perfil )
        REFERENCES tbl_perfiles ( id_perfil );

ALTER TABLE tbl_cto_ats
    ADD CONSTRAINT interpretan_actores_fk FOREIGN KEY ( id_actor )
        REFERENCES tbl_actores ( id_actor );

ALTER TABLE tbl_cto_ats
    ADD CONSTRAINT interpretan_contenido_fk FOREIGN KEY ( id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_licencias
    ADD CONSTRAINT licencias_contenido_fk FOREIGN KEY ( tbl_contenido_id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_licencias
    ADD CONSTRAINT licencias_proveedores_fk FOREIGN KEY ( tbl_proveedores_id_proveedor )
        REFERENCES tbl_proveedores ( id_proveedor );

ALTER TABLE tbl_listas_reproduccion
    ADD CONSTRAINT listas_perfiles_fk FOREIGN KEY ( id_perfil )
        REFERENCES tbl_perfiles ( id_perfil );

ALTER TABLE tbl_pagos
    ADD CONSTRAINT pagos_suscriptores_fk FOREIGN KEY ( id_suscriptor )
        REFERENCES tbl_suscriptores ( id_suscriptor );

ALTER TABLE tbl_perfiles
    ADD CONSTRAINT perfiles_suscriptores_fk FOREIGN KEY ( id_suscriptor )
        REFERENCES tbl_suscriptores ( id_suscriptor );

ALTER TABLE tbl_cto_cts
    ADD CONSTRAINT relation_4_tbl_categorias_fk FOREIGN KEY ( id_categoria )
        REFERENCES tbl_categorias ( id_categoria );

ALTER TABLE tbl_cto_cts
    ADD CONSTRAINT relation_4_tbl_contenido_fk FOREIGN KEY ( id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_cto_pds
    ADD CONSTRAINT relation_productores_fk FOREIGN KEY ( id_productor )
        REFERENCES tbl_productores ( id_productor );

ALTER TABLE tbl_tickets_soporte
    ADD CONSTRAINT soporte_empleados_fk FOREIGN KEY ( dni_empleado )
        REFERENCES tbl_empleados ( dni_empleado );

ALTER TABLE tbl_tickets_soporte
    ADD CONSTRAINT soporte_suscriptores_fk FOREIGN KEY ( id_suscriptor )
        REFERENCES tbl_suscriptores ( id_suscriptor );

ALTER TABLE tbl_suscripcion_tarjeta
    ADD CONSTRAINT suscripcion_suscriptores_fk FOREIGN KEY ( id_suscriptor )
        REFERENCES tbl_suscriptores ( id_suscriptor );

ALTER TABLE tbl_suscripcion_tarjeta
    ADD CONSTRAINT suscripcion_tarjetas_fk FOREIGN KEY ( id_tarjeta )
        REFERENCES tbl_tarjetas ( id_tarjeta );

ALTER TABLE tbl_suscripciones
    ADD CONSTRAINT suscripciones_suscriptores_fk FOREIGN KEY ( id_suscriptor )
        REFERENCES tbl_suscriptores ( id_suscriptor );

ALTER TABLE tbl_capitulos
    ADD CONSTRAINT tbl_capitulos_tbl_contenido_fk FOREIGN KEY ( tbl_contenido_id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_eps_cgs
    ADD CONSTRAINT tbl_eps_cgs_tbl_cargos_fk FOREIGN KEY ( id_cargo )
        REFERENCES tbl_cargos ( id_cargo );

ALTER TABLE tbl_eps_cgs
    ADD CONSTRAINT tbl_eps_cgs_tbl_empleados_fk FOREIGN KEY ( dni_empleado )
        REFERENCES tbl_empleados ( dni_empleado );

ALTER TABLE tbl_salarios
    ADD CONSTRAINT tbl_salarios_tbl_empleados_fk FOREIGN KEY ( dni_empleado )
        REFERENCES tbl_empleados ( dni_empleado );

ALTER TABLE tbl_valoraciones
    ADD CONSTRAINT valoraciones_contenido_fk FOREIGN KEY ( id_contenido )
        REFERENCES tbl_contenido ( id_contenido );

ALTER TABLE tbl_valoraciones
    ADD CONSTRAINT valoraciones_suscriptores_fk FOREIGN KEY ( id_suscriptor )
        REFERENCES tbl_suscriptores ( id_suscriptor );

CREATE OR REPLACE TRIGGER fkntm_tbl_capitulos BEFORE
    UPDATE OF tbl_contenido_id_contenido ON tbl_capitulos
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table TBL_CAPITULOS is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_tbl_licencias BEFORE
    UPDATE OF tbl_contenido_id_contenido ON tbl_licencias
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table TBL_LICENCIAS is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_tbl_perfiles BEFORE
    UPDATE OF id_suscriptor ON tbl_perfiles
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table TBL_PERFILES is violated');
END;
/

CREATE OR REPLACE TRIGGER fkntm_tbl_suscripciones BEFORE
    UPDATE OF id_suscriptor ON tbl_suscripciones
BEGIN
    raise_application_error(-20225, 'Non Transferable FK constraint  on table TBL_SUSCRIPCIONES is violated');
END;
/