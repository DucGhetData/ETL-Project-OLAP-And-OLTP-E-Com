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
