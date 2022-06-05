USE Manifacturer;

CREATE TABLE Product (
	prod_id int primary key identity(1,1) not null,
	prod_name varchar(50) null,
	quantity int 
)

CREATE TABLE Supplier (
	supp_id int primary key identity(1,1) not null,
	supp_name varchar(50) null,
	supp_location varchar(50) null,
	supp_country varchar(50) null,
	is_active bit
)

CREATE TABLE Component (
	comp_id int primary key identity(1,1) not null,
	comp_name varchar(50) null,
	description varchar(50) null,
	quantity_comp int null
)


CREATE TABLE Prod_Comp (
	prod_id int identity(1,1) not null foreign key references product (prod_id) ,
	comp_id int not null foreign key references component (comp_id),
	quantity_comp int null,
	primary key(prod_id, comp_id)
)

CREATE TABLE Comp_Supp (
	supp_id int  identity(1,1) not null,
	comp_id int  not null,
	order_date date,
	quantity int
	
	primary key(supp_id, comp_id),
	
	foreign key (supp_id) references Supplier (supp_id),
	foreign key (comp_id) references Component (comp_id)
)



