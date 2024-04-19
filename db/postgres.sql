create table Material(
	item_id_ BIGSERIAL PRIMARY KEY,
	item_name_ CHAR(200),
	category_ INT,
	req_dt_ DATE,
	type_ CHAR(200)
);

create table Customer(
	client_id_ BIGSERIAL PRIMARY KEY,
	name_ CHAR(200),
	age_ INT,
	birth_dt_ DATE,
	bonus_card_number_ INT,
	bonus_count_ INT
);

create table Emp_data(
	emp_id_ BIGSERIAL PRIMARY KEY,
	name_ CHAR(200),
	req_dt_ DATE
);

create table Order_t(
	order_id_ BIGSERIAL PRIMARY KEY,
	order_dt DATE,
	client_id_ BIGSERIAL REFERENCES Customer(client_id_),
	item_id_ BIGSERIAL REFERENCES Material(item_id_),
	channel_ INT,
	store_id_ BIGSERIAL
);

create table Discounts(
	item_id_ BIGSERIAL REFERENCES Material(item_id_),
	discont_ REAL,
	txtsh_ CHAR(1000),
	author_ CHAR(200),
	date_to_ DATE,
	date_from_ DATE
);

create table Non_pers_recs(
	item1_id_ BIGSERIAL REFERENCES Material(item_id_),
	item2_id_ BIGSERIAL REFERENCES Material(item_id_),
	rnk_ INT,
	category_ INT,
	kpi_ INT
);

create table Pers_recs(
	client_id_ BIGSERIAL REFERENCES Customer(client_id_),
	item_id_ BIGSERIAL REFERENCES Material(item_id_),
	rnk_ INT,
	category_ INT,
	kpi_ INT
);

create table Prop_descriptr(
	prop_code_ BIGSERIAL PRIMARY KEY,
	prop_name_ CHAR(200),
	update_dt_ DATE
);

create table Mat_prop(
	item_id_ BIGSERIAL REFERENCES Material(item_id_),
	value_ CHAR(200),
	prop_code_ BIGSERIAL REFERENCES Prop_descriptr(prop_code_),
	update_dt_ DATE
);

create table Stock_plants(
	stock_id_ BIGSERIAL PRIMARY KEY,
	place_ CHAR(1000),
	free_space_ CHAR(1000),
	prop_name_ CHAR(1000)
);

create table Stars(
	stock_id_ BIGSERIAL REFERENCES Stock_plants(stock_id_),
	item_id_ BIGSERIAL REFERENCES Material(item_id_),
	star_ INT
);

create table Checks(
	check_id_ BIGSERIAL PRIMARY KEY,
	client_id_ BIGSERIAL REFERENCES Customer(client_id_),
	item_id_ BIGSERIAL REFERENCES Material(item_id_),
	bill_ CHAR(200),
	stock_id_ BIGSERIAL REFERENCES Stock_plants(stock_id_),
	sell_dt_ DATE,
	ret_flg_ BOOl
);

create table Prices(
	item_id_ BIGSERIAL REFERENCES Material(item_id_),
	stock_id_ BIGSERIAL REFERENCES Stock_plants(stock_id_),
	price_ INT,
	date_to_ DATE,
	date_from_ DATE
);



