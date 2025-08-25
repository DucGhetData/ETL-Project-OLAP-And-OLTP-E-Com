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