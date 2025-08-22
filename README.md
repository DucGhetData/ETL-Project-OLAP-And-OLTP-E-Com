# 📊 Xây dựng Cơ sở dữ liệu và Dashboard trên OLAP & OLTP với SQL  

## 📝 1. Mô tả dự án
Trong bối cảnh bùng nổ của thị trường E-commerce, việc xử lý và phân tích khối lượng dữ liệu khổng lồ là vô cùng quan trọng đối với các doanh nghiệp dù nhỏ hay lớn. Việc xử lý và phân tích dữ liệu liên tục và kịp thời giúp các doanh nghiệp quản lý và đưa ra phương án vận hành kịp thời và nhanh chóng. Hiểu được sự quan trọng đó, dự án này sẽ mô phỏng cơ sở dữ liệu chuỗi cung ứng của công ty DataCo Global trong đó:
- Dự án sử dụng dữ liệu mẫu của DataCo Global để xây dựng lược đồ quan hệ 
- OLTP để xử lý đơn hàng, sản phẩm, khách hàng,....  
- OLAP để phân tích doanh thu, khách hàng, sản phẩm, hiệu suất theo thời gian.  
- Dashboard hiển thị các chỉ số quan trọng (KPI) phục vụ quản lý và đưa ra quyết định.  

---

## 🎯 2. Mục tiêu  
- Thiết kế cơ sở dữ liệu **OLTP** cho giao dịch hằng ngày.  
- Xây dựng **Data Warehouse (OLAP)** để phân tích dữ liệu.  
- Thực hiện **ETL** từ OLTP → OLAP.  
- Trực quan hóa dữ liệu bằng **Power BI / Excel Dashboard**.  

---

## 🔄 3. Quy trình thực hiện dự án  
1. **[Thu thập dữ liệu mẫu DataCo Global trên Kaggle](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)**  
2. **Phân tích và tái tạo mô hình dữ liệu OLTP**  
3. **Xây dựng OLTP Database bằng SQL Server**   
4. **Thiết kế Data Warehouse (OLAP) theo mô hình StarSchema** 
5. **Xây dựng ETL Pipeline**  
6. **Xây dựng Dashboard phân tích các chỉ số bằng Power BI**
7. **Viết báo cáo & tài liệu hóa**  

---

## 📊 4. Báo cáo

## 🛠️ 5. Công cụ & Công nghệ

## 📂 6. Cấu trúc thư mục  
```bash
OLAP_OLTP_Project/
│── README.md
│── data/
│   ├── oltp_sample.sql
│   ├── olap_sample.sql
│   └── etl_scripts.sql
│── sql/
│   ├── oltp_schema.sql
│   ├── olap_schema.sql
│   └── views/
│── reports/
│   ├── diagrams/
│   ├── dashboard/
│   └── final_report.pdf
│── dashboard/
│   ├── powerbi.pbix
│   └── excel_dashboard.xlsx
│── docs/
│   ├── project_plan.md
│   ├── data_dictionary.md
│   └── design_notes.md



