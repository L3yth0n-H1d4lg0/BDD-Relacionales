drop table if exists detalle_ventas;
drop table if exists cabecera_ventas;
drop table if exists historial_stock;
drop table if exists detalle_pedido;
drop table if exists cabecera_pedido;
drop table if exists estados_pedido;
drop table if exists proveedores;
drop table if exists tipo_documentos;
drop table if exists producto;
drop table if exists unidades_medida;
drop table if exists categorias_unidad_medida;
drop table if exists categorias;

-------------------- TABLAS --------------------
create table categorias(
	codigo serial not null,
	nombre varchar(100) not null,
	categoria_padre int,
	constraint categorias_pk primary key (codigo),
	constraint categorias_fk foreign key (categoria_padre) references categorias(codigo)
);

create table categorias_unidad_medida(
	codigo char(1) not null,
	nombre varchar(50) not null,
	constraint categorias_um_pk primary key (codigo)
);

create table unidades_medida(
	codigo varchar(2) not null,
	descripcion varchar(50) not null,
	categoria_um char(1) not null,
	constraint unidades_medida_pk primary key (codigo),
	constraint categoria_fk foreign key (categoria_um) references categorias_unidad_medida(codigo)
);

create table producto(
	codigo serial not null,
	nombre varchar(100) not null,
	unidad_medida varchar(2) not null,
	precio_venta money not null,
	tiene_iva boolean not null, 
	coste money not null,
	categoria int not null,
	stock int not null,
	constraint producto_pk primary key (codigo),
	constraint unidad_medida_fk foreign key (unidad_medida) references unidades_medida(codigo),
	constraint categoria_fk foreign key (categoria) references categorias(codigo)
);

create table tipo_documentos(
	codigo char(1) not null,
	descripcion varchar(20),
	constraint tipo_documentos_pk primary key (codigo)
);

create table proveedores(
	identificador varchar(13) not null,
	tipo_documento char(1) not null,
	nombre varchar(50) not null,
	telefono char(10) not null,
	correo varchar(50) not null,
	direccion varchar(100) not null,
	constraint proveedores_pk primary key (identificador),
	constraint tipo_documento_fk foreign key (tipo_documento) references tipo_documentos(codigo)
);

create table estados_pedido(
	codigo char(1) not null,
	descripcion varchar(20) not null,
	constraint estados_pedido_pk primary key (codigo)
);

create table cabecera_pedido(
	numero serial not null,
	proveedor varchar(13) not null,
	fecha date not null,
	estado char(1) not null,
	constraint cabecera_pedido_pk primary key (numero),
	constraint proveedor_fk foreign key (proveedor) references proveedores(identificador)
);

create table detalle_pedido(
	codigo serial not null,
	cabecera_pedido int not null,
	producto int not null,
	cantidad int not null,
	subtotal money not null,
	cantidad_requerida int  not null,
	constraint detalle_pedido_pk primary key (codigo),
	constraint cabecera_pedido_fk foreign key (cabecera_pedido) references cabecera_pedido(numero)
);

create table historial_stock(
	codigo serial not null,
	fecha timestamp without time zone not null,
	referencia varchar(20) not null,
	producto int not null,
	cantidad int not null,
	constraint historial_stock_pk primary key(codigo),
	constraint producto_fk foreign key(producto) references producto(codigo) 
);

create table cabecera_ventas(
	codigo serial not null,
	fecha timestamp without time zone not null,
	total_sin_iva money not null,
	iva money not null,
	total money not null,
	constraint cabecera_ventas_pk primary key (codigo)
);

create table detalle_ventas(
	codigo serial not null,
	cabecera_ventas int not null,
	producto int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
	subtotal_con_iva money not null,
	constraint detalle_ventas_pk primary key (codigo),
	constraint producto_fk foreign key (producto) references producto(codigo)
);

-------------------- REGISTROS --------------------
insert into categorias(nombre, categoria_padre) 
values ('Materia Prima', null), ('Proteina', 1), ('Salsas', 1), ('Punto de Venta', null), ('Bebidas', 4), ('Con alcohol', 5), ('Sin alcohol', 5);

insert into categorias_unidad_medida(codigo, nombre)
values ('U', 'Unidades'), ('V', 'Volumen'), ('P', 'Peso');

insert into unidades_medida(codigo, descripcion, categoria_um)
values ('ml', 'mililitros', 'V'), ('l', 'litros', 'V'), ('u', 'unidad', 'U'), ('d', 'docena', 'U'), ('g', 'gramos', 'P'), ('kg', 'kilogramos', 'P'), ('lb', 'libras', 'P');

insert into producto(nombre, unidad_medida, precio_venta, tiene_iva, coste, categoria, stock)
values ('Coca cola pequeña', 'u', 0.5804, true, 0.3729, 7, 110), ('Salsa de tomate', 'kg', 0.95, true, 0.8736, 3, 0), ('Mostaza', 'kg', 0.95, true, 0.89, 3, 0), ('Fuze Tea', 'u', 0.8, true, 0.7, 7, 50);

insert into tipo_documentos(codigo, descripcion)
values ('C', 'Cedula'), ('R', 'RUC');

insert into proveedores(identificador, tipo_documento, nombre, telefono, correo, direccion)
values ('1792285747', 'C', 'Santiago Mosquera', '0992920306', 'zantycb89@gmail.com', 'Cumbayork'), ('1792285747001', 'R', 'Snacks SA', '0992920398', 'snacks@gmail.com', 'La Tola');

insert into estados_pedido(codigo, descripcion)
values('S', 'Solicitado'), ('R', 'Recibido');

insert into cabecera_pedido(proveedor, fecha, estado)
values('1792285747', '30/11/2023', 'R'), ('1792285747', '01/12/2023', 'R');

insert into detalle_pedido(cabecera_pedido, producto, cantidad, subtotal, cantidad_requerida)
values (1,1,100,37.29,100), (1,4,50,11.8,50), (2,1,10,3.73,0);

insert into historial_stock(fecha, referencia, producto, cantidad)
values ('20/11/2023 19:59', 'Pedido 1', 1, 100), ('21/11/2023 19:59', 'Pedido 1', 4, 50), ('22/11/2023 20:00', 'Pedido 2', 1, 10), ('23/11/2023 20:00', 'Venta 1', 1, -5), ('24/11/2023 20:00', 'Venta 2', 4, 1);

insert into cabecera_ventas(fecha, total_sin_iva, iva, total)
values ('20/11/2023 20:00', 3.26, 0.39, 3.65);

insert into detalle_ventas(cabecera_ventas, producto, cantidad, precio_venta, subtotal, subtotal_con_iva)
values (1, 1, 5, 0.58, 2.9, 3.25), (1, 4, 1, 0.36, 0.36, 0.4);

-------------------- Selects --------------------
select * from categorias;
select * from categorias_unidad_medida;
select * from unidades_medida;
select * from producto;
select * from tipo_documentos;
select * from proveedores;
select * from estados_pedido;
select * from cabecera_pedido;
select * from detalle_pedido;
select * from historial_stock;
select * from cabecera_ventas;
select * from detalle_ventas;