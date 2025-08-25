-- Khởi tạo Database 
CREATE DATABASE DataCoSmartDB 
GO
-- Tạo bảng Category
CREATE TABLE [Category] (
	[category_id] INTEGER NOT NULL UNIQUE,
	[department_id] TINYINT NOT NULL,
	[category_name] VARCHAR(20),
	PRIMARY KEY([category_id])
);
GO
-- Tạo bảng Customer
CREATE TABLE [Customer] (
	[customer_id] INTEGER NOT NULL UNIQUE,
	[customer_lastname] VARCHAR(255),
	[customer_fullname] VARCHAR(255),
	[customer_country] VARCHAR(255),
	[customer_city] VARCHAR(255),
	[customer_street] VARCHAR(255),
	[customer_segment] VARCHAR(15),
	[customer_state] VARCHAR(5),
	[customer_zip_code] INTEGER,
	PRIMARY KEY([customer_id])
);
GO
-- Tạo bảng Sản phẩm
CREATE TABLE [Product] (
	[product_id] INTEGER NOT NULL UNIQUE,
	[category_id] INTEGER,
	[product_name] VARCHAR(255),
	[product_price] FLOAT,
	[product_status] BIT,
	[product_image] VARCHAR(255),
	PRIMARY KEY([product_id])
);
GO
-- Tạo bảng Department
CREATE TABLE [Department] (
	[department_id] TINYINT NOT NULL UNIQUE,
	[department_name] VARCHAR(20),
	PRIMARY KEY([department_id])
);
GO
-- Tạo bảng Order
CREATE TABLE [Order] (
	[order_id] INTEGER NOT NULL UNIQUE,
	[customer_id] INTEGER,
	[store_id] INTEGER,
	[order_country] VARCHAR(255),
	[order_city] VARCHAR(255),
	[market] VARCHAR(15),
	[order_date] DATETIME,
	[order_region] VARCHAR(20),
	[order_state] VARCHAR(40),
	[order_status] VARCHAR(15),
	[shipping_date] DATETIME,
	[shipping_mode] VARCHAR(20),
	[transaction_type] VARCHAR(8),
	[day_for_ship_scheduled] TINYINT,
	[day_for_ship_real] TINYINT,
	[delivery_status] VARCHAR(20),
	[late_risk] BIT,
	PRIMARY KEY([order_id])
);
GO
-- Tạo bảng OrderDetail
CREATE TABLE [OrderDetail] (
	[order_id] INTEGER NOT NULL,
	[item_id] INTEGER NOT NULL,
	[product_id] INTEGER NOT NULL,
	[discount] FLOAT,
	[discount_rate] FLOAT,
	[profit_ratio] FLOAT,
	[quantity] INTEGER,
	[sales] FLOAT,
	[total_amount] FLOAT,
	[profit_per_order] FLOAT,
	PRIMARY KEY([order_id], [item_id])
);
GO
-- Tạo bảng Store
CREATE TABLE [Store] (
	[store_id] INTEGER NOT NULL IDENTITY(1,1) UNIQUE,
	[latitude] FLOAT,
	[longtitude] FLOAT,
	PRIMARY KEY([store_id]),
	CONSTRAINT UC_LatLong UNIQUE (latitude,longtitude)
);
GO
-- Tạo bảng DepartmentStore
CREATE TABLE [DepartmentSrore] (
	[store_id] INTEGER NOT NULL ,
	[department_id] TINYINT NOT NULL,
	PRIMARY KEY([store_id], [department_id])
);
GO
-- Thiết lập các khóa ngoại cho các bảng
ALTER TABLE [Product]
ADD FOREIGN KEY([category_id]) REFERENCES [Category]([category_id])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [Order]
ADD FOREIGN KEY([customer_id]) REFERENCES [Customer]([customer_id])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [OrderDetail]
ADD FOREIGN KEY([order_id]) REFERENCES [Order]([order_id])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [OrderDetail]
ADD FOREIGN KEY([product_id]) REFERENCES [Product]([product_id])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [Category]
ADD FOREIGN KEY([department_id]) REFERENCES [Department]([department_id])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [DepartmentSrore]
ADD FOREIGN KEY([store_id]) REFERENCES [Store]([store_id])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [DepartmentSrore]
ADD FOREIGN KEY([department_id]) REFERENCES [Department]([department_id])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO
ALTER TABLE [Order]
ADD FOREIGN KEY([store_id]) REFERENCES [Store]([store_id])
ON UPDATE NO ACTION ON DELETE NO ACTION;
GO