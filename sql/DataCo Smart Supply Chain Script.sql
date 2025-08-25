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
-- INSERT Dữ liệu
-- Insert dữ liệu cho bảng khách hàng
INSERT INTO Customer(customer_id,customer_lastname,customer_fullname,
					 customer_country,customer_city,customer_street,customer_segment,customer_state, customer_zip_code)
SELECT 
	Customer_Id,
	Customer_Lname,
	Customer_Fname,
	Customer_Country,
	Customer_City,
	Customer_Street,
	Customer_Segment,
	Customer_State,
	Customer_Zipcode
FROM RawTable
GROUP BY 
	Customer_Id,
	Customer_Lname,
	Customer_Fname,
	Customer_Country,
	Customer_City,
	Customer_Street,
	Customer_Segment,
	Customer_State,
	Customer_Zipcode
GO;
-- Kiểm tra lại bảng khách hàng 
SELECT * FROM Customer
GO;
-- Insert dữ liệu cho bảng Cửa hàng 
INSERT INTO Store(latitude,longtitude)
SELECT 
	Latitude,
	Longitude
FROM RawTable
GROUP BY Latitude,Longitude
GO;
-- Kiểm tra lại bảng Store
SELECT * FROM Store
ORDER BY store_id
GO;
-- Insert dữ liệu cho bảng Department
INSERT INTO Department(department_id,department_name)
SELECT Department_Id, Department_Name
FROM RawTable
GROUP BY Department_Id, Department_Name
ORDER BY Department_Id
GO;
-- Kiểm tra lại bảng Department
SELECT * FROM Department
GO;
-- Insert dữ liệu cho bảng DepartmentStore
INSERT INTO DepartmentSrore(store_id,department_id)
SELECT Store.store_id, RawTable.Department_Id
FROM RawTable INNER JOIN Store
	ON RawTable.Latitude = Store.latitude AND RawTable.Longitude = Store.longtitude
GROUP BY Store.store_id, RawTable.Department_Id
ORDER BY Store.store_id, RawTable.Department_Id
GO;
-- Kiểm tra lại bảng DepartmentStore
SELECT * FROM DepartmentSrore
GO;
-- Insert dữ liệu cho bảng Category
INSERT INTO Category(category_id,department_id,category_name)
SELECT Category_Id,Department_Id,Category_Name
FROM RawTable
GROUP BY Category_Id,Department_Id,Category_Name
ORDER BY Category_Id,Department_Id
GO;
-- Kiểm tra lại bảng Category
SELECT * FROM Category
GO;
-- Insert dữ liệu cho bảng Product
INSERT INTO Product(product_id,category_id,product_name,product_price,product_status,product_image)
SELECT 
	Product_Card_Id,
	Category_Id,
	Product_Name,
	Product_Price,
	Product_Status,
	Product_Image
FROM RawTable
GROUP BY Product_Card_Id,Category_Id,Product_Name,Product_Price,Product_Status,Product_Image
ORDER BY Product_Card_Id
GO;
-- Kiểm tra lại bảng Product
SELECT * FROM Product
GO;
-- Insert dữ liệu cho bảng Order
INSERT INTO [DataCoSmartDB ].dbo.[Order](order_id,customer_id,store_id,order_country,order_city,market,
										order_date,order_region,order_state,order_status,shipping_date,
										shipping_mode,transaction_type,day_for_ship_scheduled,day_for_ship_real,
										delivery_status,late_risk)
SELECT
	RawTable.Order_Id, 
	RawTable.Customer_Id, 
	Store.store_id,
	RawTable.Order_Country,
	RawTable.Order_City,
	RawTable.Market,
	RawTable.order_date_DateOrders,
	RawTable.Order_Region,
	RawTable.Order_State,
	RawTable.Order_Status,
	RawTable.shipping_date_DateOrders,
	RawTable.Shipping_Mode,
	RawTable.[Type],
	RawTable.Days_for_shipment_scheduled,
	RawTable.Days_for_shipping_real,
	RawTable.Delivery_Status,
	RawTable.Late_delivery_risk
FROM RawTable INNER JOIN Store 
	ON RawTable.Latitude = Store.latitude AND RawTable.Longitude = Store.longtitude
GROUP BY 
	RawTable.Order_Id, 
	RawTable.Customer_Id, 
	Store.store_id,
	RawTable.Order_Country,
	RawTable.Order_City,
	RawTable.Market,
	RawTable.order_date_DateOrders,
	RawTable.Order_Region,
	RawTable.Order_State,
	RawTable.Order_Status,
	RawTable.shipping_date_DateOrders,
	RawTable.Shipping_Mode,
	RawTable.[Type],
	RawTable.Days_for_shipment_scheduled,
	RawTable.Days_for_shipping_real,
	RawTable.Delivery_Status,
	RawTable.Late_delivery_risk
GO;
-- Kiểm tra lại bảng Order
SELECT * FROM [Order]
GO;
-- Insert dữ liệu cho bảng OrderDetail
INSERT INTO OrderDetail(order_id,item_id,product_id,discount,discount_rate,
						profit_ratio,quantity,sales,total_amount,profit_per_order)
SELECT
	RawTable.Order_Id,
	RawTable.Order_Item_Id,
	RawTable.Product_Card_Id,
	RawTable.Order_Item_Discount,
	RawTable.Order_Item_Discount_Rate,
	RawTable.Order_Item_Profit_Ratio,
	RawTable.Order_Item_Quantity,
	RawTable.Sales,
	RawTable.Order_Item_Total,
	RawTable.Order_Profit_Per_Order
FROM RawTable
GROUP BY 
	RawTable.Order_Id,
	RawTable.Order_Item_Id,
	RawTable.Product_Card_Id,
	RawTable.Order_Item_Discount,
	RawTable.Order_Item_Discount_Rate,
	RawTable.Order_Item_Profit_Ratio,
	RawTable.Order_Item_Quantity,
	RawTable.Sales,
	RawTable.Order_Item_Total,
	RawTable.Order_Profit_Per_Order
ORDER BY Order_Id
GO
-- KIỂM TRA TỔNG QUÁT VÀ LÀM SẠCH DỮ LIỆU
-- Kiểm tra dữ liệu có bị null ở các bảng không ?
-- Kiểm tra bảng khách hàng trước  
SELECT 
	SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_id,
	SUM(CASE WHEN customer_lastname IS NULL THEN 1 ELSE 0 END) AS null_lastname,
	SUM(CASE WHEN customer_fullname IS NULL THEN 1 ELSE 0 END) AS null_fullname,
	SUM(CASE WHEN customer_country IS NULL THEN 1 ELSE 0 END) AS null_fullname,
	SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS null_city,
	SUM(CASE WHEN customer_street IS NULL THEN 1 ELSE 0 END) AS null_street,
	SUM(CASE WHEN customer_segment IS NULL THEN 1 ELSE 0 END) AS null_segment,
	SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS null_state,
	SUM(CASE WHEN customer_zip_code IS NULL THEN 1 ELSE 0 END) AS null_zip
FROM Customer
/*
Như vậy cột lastname có 8 bản ghi null, zip_code có 3 dòng null. Ta sẽ kiểm tra chi tiết
*/
SELECT *
FROM Customer
WHERE customer_lastname IS NULL OR customer_zip_code IS NULL
GO
/* Đối với lastname có thể khách hàng không muốn cung cấp nên ta sẽ gắn tạm là "Unknown",
còn đối với ZipCode cho 3 bản ghi đều thuộc thành phố California,Mỹ nên ta có thể tra cứu thủ công và bổ sung*/
UPDATE Customer
SET customer_lastname = 'Unknown'
WHERE customer_lastname IS NULL
GO
UPDATE Customer
SET customer_zip_code = 91731
WHERE customer_street = 'El Monte' AND customer_city = 'CA' AND customer_country = 'EE. UU.'
GO
UPDATE Customer
SET customer_zip_code = 95758
WHERE customer_street = 'Elk Grove' AND customer_city = 'CA' AND customer_country = 'EE. UU.'
GO
-- KIỂM TRA BẢNG Department VÀ Category
SELECT * FROM Department
SELECT * FROM Category
GO
-- Hai bảng này không có dữ liệu bị null
-- KIỂM TRA BẢNG Product
SELECT
	SUM(CASE WHEN product_price IS NULL THEN 1 ELSE 0 END) AS null_price,
	SUM(CASE WHEN product_status IS NULL THEN 1 ELSE 0 END) AS null_status
FROM Product
GO
/* Như vậy bảng product cũng không có dữ liệu bị null
- TA SẼ KIỂM TRA HAI BẢNG CUỐI CÙNG LÀ Order và DetailOrder*/
SELECT 
	SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_cusid,
	SUM(CASE WHEN order_country IS NULL THEN 1 ELSE 0 END) AS null_country,
	SUM(CASE WHEN order_city IS NULL THEN 1 ELSE 0 END) AS null_city,
	SUM(CASE WHEN market IS NULL THEN 1 ELSE 0 END) AS null_market,
	SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
	SUM(CASE WHEN order_region IS NULL THEN 1 ELSE 0 END) AS null_region,
	SUM(CASE WHEN order_state IS NULL THEN 1 ELSE 0 END) AS null_state,
	SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_status,
	SUM(CASE WHEN shipping_date IS NULL THEN 1 ELSE 0 END) AS null_ship_date,
	SUM(CASE WHEN shipping_mode IS NULL THEN 1 ELSE 0 END) AS null_mode,
	SUM(CASE WHEN transaction_type IS NULL THEN 1 ELSE 0 END) AS null_type,
	SUM(CASE WHEN day_for_ship_real IS NULL THEN 1 ELSE 0 END) AS null_ship_real,
	SUM(CASE WHEN day_for_ship_scheduled IS NULL THEN 1 ELSE 0 END) AS null_ship_scheduled,
	SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS null_status_del
FROM [Order]
GO
SELECT
	SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS null_discount,
	SUM(CASE WHEN discount_rate IS NULL THEN 1 ELSE 0 END) AS null_discount_rate,
	SUM(CASE WHEN profit_ratio IS NULL THEN 1 ELSE 0 END) AS null_profit,
	SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
	SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sale,
	SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS null_total,
	SUM(CASE WHEN profit_per_order IS NULL THEN 1 ELSE 0 END) AS null_profit_per_order
FROM OrderDetail
GO
/*Như vậy cả 2 bảng Order đều không có giá trị null. Tiếp theo ta sẽ tiến hành 
kiểm tra các giá trị sai lệch hoặc không đúng định dạng
- Việc dữ liệu bị sai lệch thường sảy ra ở các cột có dạng chuỗi ký tự nên ta sẽ kiểm 
tra các trường liên quan đến địa điểm*/
SELECT customer_country, customer_city, customer_street 
FROM Customer
GROUP BY customer_country, customer_city, customer_street
GO
SELECT order_region,order_country,market
FROM [Order]
GROUP BY order_region,order_country,market
GO
/* Dễ dàng nhận thấy cột order_city có các đất nước bị lỗi tên do unicode. 
Việc này sảy ra có thể là do Import Wizard nên ta sẽ sửa đổi lại */
SELECT order_country, COUNT(*) AS cnt
FROM [Order]
WHERE order_country LIKE '%?%'
GROUP BY order_country
ORDER BY cnt DESC
GO
-- Ta sẽ tạo bảng CountryFixMap(old_name,new_name,cnt) để cập nhật lại tên quốc gia
SELECT SUM(cnt) FROM CountryFixMap
GO
UPDATE [Order]
SET [Order].order_country = CountryFixMap.new_name
FROM [Order] JOIN CountryFixMap ON [Order].order_country = CountryFixMap.old_name
GO
SELECT order_state, COUNT(*) AS cnt
FROM [Order]
WHERE order_state LIKE '%?%'
GROUP BY order_state
ORDER BY cnt DESC
/*Hoàn thành quá trình làm sạch dữ liệu, ta sẽ bắt đầu quá trình phân tích dữ liệu
- TRƯỚC HẾT TA SẼ XEM CÁC CHỈ SỐ TỔNG QUÁT NHƯ
*/
-- TỔNG SỐ ĐƠN HÀNG ĐÃ ĐƯỢC ĐẶT
SELECT COUNT(order_id) AS cnt_order
FROM [Order]
-- CÓ 65752 ĐƠN HÀNG ĐƯỢC GHI NHẬN TRONG 4 NĂM TỪ 2015 - 2018	
GO
-- TỶ LỆ GIAO ĐƠN TRỄ
SELECT 
	YEAR(order_date) AS 'year',
	SUM(CASE WHEN late_risk = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*) AS pct_late
FROM [Order]
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)
-- TỶ LỆ GIAO HÀNG MUỘN CÒN NẰM Ở MỨC CAO TRUNG BÌNH TỪ 54 - 56% TRONG VÒNG 4 NĂM 
GO
-- THỜI GIAN XỬ LÝ ĐƠN TRUNG BÌNH(TÍNH TỪ LÚC ĐẶT ĐẾN KHI SHIP)
SELECT
	YEAR(order_date) AS 'year',
	ROUND(AVG(DATEDIFF(DAY,order_date,shipping_date)),2) AS avg_processing_day
FROM [Order]
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)
-- THỜI GIAN XỬ LÝ ĐƠN HÀNG Ở MỨC TRUNG BÌNH QUA CÁC NĂM MẤT KHOẢNG 3 NGÀY ĐỂ BẮT ĐẦU VẬN CHUYỂN
GO
-- GIÁ TRỊ ĐƠN HÀNG TRUNG BÌNH VÀ SỐ ĐƠN HÀNG THEO TỪNG NĂM
SELECT
	YEAR([Order].order_date) AS 'year',
	COUNT(DISTINCT [Order].order_id) AS cnt_order,
	ROUND(AVG(OrderDetail.total_amount),2) AS avg_amount	
FROM [Order] INNER JOIN OrderDetail
	ON [Order].order_id = OrderDetail.order_id
GROUP BY YEAR([Order].order_date)
ORDER BY YEAR([Order].order_date)
-- ĐƠN HÀNG ĐƯỢC DUY TRÌ Ở MỨC HƠN 20K ĐƠN VỚI MỖI ĐƠN HÀNG KHOẢNG 177$
GO
-- TOP CÁC THỊ TRƯỜNG TIÊU THỤ HÀNG HÓA NHIỀU NHẤT
SELECT TOP 5
	[Order].order_region AS region,
	COUNT(order_id) AS cnt_order
FROM [Order]
GROUP BY [Order].order_region
ORDER BY cnt_order DESC
-- THỊ TRƯỜNG CHỦ YẾU LÀ CÁC NƯỚC PHÁT TRIỂN Ở Ở CHÂU ÂU, BẮC MỸ, NGOÀI RA CÒN CÓ NAM MỸ VÀ ĐÔNG NAM Á
GO
-- TOP NGÀNH HÀNG BÁN CHẠY NHẤT
SELECT TOP 5
	Department.department_name,
	SUM(OrderDetail.quantity) AS total_quantity
FROM Department INNER JOIN Category
	ON Department.department_id = Category.department_id
INNER JOIN Product
	ON Category.category_id = Product.category_id
INNER JOIN OrderDetail 
	ON Product.product_id = OrderDetail.product_id
GROUP BY Department.department_name
ORDER BY total_quantity DESC
-- CÁC THIẾT BỊ LÀM MÁT CÓ SỐ LƯỢNG TIÊU THỤ LỚN NHẤT THEO SAU LÀ GOLF VÀ QUẦN ÁO
GO
/*TA SẼ TÌM HIỂU VẤN ĐỀ ĐẦU TIÊN ĐÓ LÀ TẠI SAO TỶ LỆ GIAO HÀNG MUỘN LẠI NHIỀU NHƯ VẬY*/
--Kiểm tra tỷ lệ giao hàng muộn ở các khu vực 
SELECT
	order_region,
	SUM(CASE WHEN late_risk = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*) AS pct_late,
	ROUND(AVG(DATEDIFF(DAY,order_date,shipping_date)),2) AS avg_processing
FROM [Order]
GROUP BY order_region
ORDER BY pct_late DESC
-- Các khu vực cũng có tỷ lệ giao hàng muộn tương tự tỷ lệ trung bình không có khu vực nào tốt hơn cả
GO
SELECT 
	order_status,
	SUM(CASE WHEN late_risk = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*) AS pct_late
FROM [Order]
GROUP BY order_status
ORDER BY pct_late DESC,order_status
-- Trạng thái của đơn hàng cũng không hề tác động đến việc giao hàng bị muộn
GO
SELECT
	shipping_mode,
	COUNT(*) AS cnt_order,
	SUM(CASE WHEN late_risk = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*) AS pct_late
FROM [Order]
GROUP BY shipping_mode
ORDER BY pct_late DESC
/*Nhận thấy rằng Standard Class dù có số lượng đơn nhưng tỷ lệ đơn hàng trễ lại khá thấp chỉ 
khoảng 38%, tuy nhiên hai loại hình giao hàng cao cấp dù số lượng đơn ít hơn nhưng lại gần luôn 
đến muộn
*/
GO
-- GIẢ THUYẾT ĐẶT RA: LIỆU CÓ PHẢI DO LÊN LỊCH SHIP QUÁ NGẮN KHIẾN CHO ĐƠN HÀNG LUÔN BỊ ĐẾN MUỘN KHÔNG
SELECT 
	shipping_mode,
	AVG(CAST(day_for_ship_real AS FLOAT) - CAST(day_for_ship_scheduled AS FLOAT)) AS diff_real_sche
FROM [Order]
WHERE shipping_mode LIKE '%Class'
GROUP BY shipping_mode
/* Như vậy có thể nhận thấy việc lên lịch giao hàng dự kiến và tg giao thực tế thường lệch 1 - 2 ngày
do đó mà nhiều đơn hàng luôn bị đánh dấu là đến trễ. Để đánh giá xem liệu việc giao hàng muộn này có ảnh 
hưởng đến thương hiệu không ta cần thêm dữ liệu liên quan đến cảm xúc và đánh giá của khách hàng
- Tuy nhiên ta hãy kiểm tra xem nhóm khách hàng nào chiếm nhiều nhất và vị trí của các cửa hàng phân bố 
đã hợp lý chưa
*/
GO
SELECT
	Customer.customer_segment,
	COUNT([Order].order_id) AS cnt_order
FROM [Order] INNER JOIN Customer
	ON [Order].customer_id = Customer.customer_id
GROUP BY Customer.customer_segment
GO
SELECT 
	Store.store_id,
	Store.latitude,
	Store.longtitude,
	COUNT(*) AS cnt_order
FROM [Order] RIGHT JOIN Store
	ON [Order].store_id = Store.store_id
GROUP BY
	Store.store_id,
	Store.latitude,
	Store.longtitude
ORDER BY cnt_order DESC
/* Qua dữ liệu có thể thấy không có cửa hàng nào có số lượng đơn  vượt trội, số lượng cửa hàng 
rất lớn nhưng lại có tỷ lệ giao hàng muộn, có thể do các cửa hàng đang được đặt tự phát và không có kế 
hoạch cụ thể dẫn tới điểm nghẽn khiến giao hàng muộn
- Minh họa các cửa hàng trên bản đồ bằng chấm tròn ta có thể nhận thấy các cửa hàng chủ yếu được đặt ở 
khắp nước mỹ, ít có cửa hàng trên các khu vực khác nên thường sẽ p mất 3 - 4 ngày giao hàng thì mới đến được
các khu vực khác 
*/
GO
/* BƯỚC SANG VIỆC PHÂN TÍCH NGÀNH HÀNG TIÊU THỤ 
- Trước đó ta đã biết top những ngành hàng có số lượng lớn nhất 
- Bây giờ ta sẽ xem danh sách đó có đem lại lợi nhuận tương ứng không 
*/
SELECT
	Department.department_name,
	COUNT(DISTINCT OrderDetail.order_id) AS total_order,
	SUM(OrderDetail.quantity) AS total_quantity,
	FORMAT(SUM(OrderDetail.profit_per_order),'C','en-US') AS total_profit
FROM Department INNER JOIN Category
	ON Department.department_id = Category.department_id
INNER JOIN Product
	ON Category.category_id = Product.category_id
INNER JOIN OrderDetail 
	ON Product.product_id = OrderDetail.product_id
GROUP BY Department.department_name
ORDER BY SUM(OrderDetail.profit_per_order) DESC
GO
-- Xem các loại mặt hàng của Fanshop và xem mặt hàng nào thường xuyên đến trễ
SELECT
	Department.department_name,
	SUM(CASE WHEN [Order].late_risk = 1 THEN 1 ELSE 0 END)*100.0/COUNT([Order].order_id) AS late_pct 
FROM OrderDetail INNER JOIN [Order]
	ON OrderDetail.order_id = [Order].order_id
INNER JOIN Product
	ON OrderDetail.product_id = Product.product_id
INNER JOIN Category
	ON Product.category_id = Category.category_id
INNER JOIN Department
	ON Department.department_id = Category.department_id
GROUP BY Department.department_name
ORDER BY late_pct DESC
-- Tỷ lệ giao hàng muộn cũng gần như tương tự đối với tỷ lệ giao hàng khi tham chiếu theo khu vực hay loại hình vận chuyển












