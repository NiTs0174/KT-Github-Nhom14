--2180601448
--Nguyễn Minh Thắng 

-----------------TAO CSDL--------------------------------------------------
CREATE DATABASE QLBH
GO
USE QLBH
GO

-----------------TAO BANG--------------------------------------------------
SET DATEFORMAT DMY
CREATE TABLE KHACHHANG(
	MAKH VARCHAR(5) NOT NULL PRIMARY KEY (MAKH),
	TENKH NVARCHAR(30) NOT NULL,
	DIACHI NVARCHAR(50),
	DT VARCHAR(11) CHECK (DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
							DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
							DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
							DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
							DT IS NULL),
	EMAIL VARCHAR(30),
);

CREATE TABLE VATTU(
	MAVT VARCHAR(5) NOT NULL PRIMARY KEY(MAVT),
	TENVT NVARCHAR(30) NOT NULL,
	DVT NVARCHAR(20),
	GIAMUA MONEY CHECK (GIAMUA>0),
	SLTON INT CHECK (SLTON>=0),
);

CREATE TABLE HOADON(
	MAHD VARCHAR(10) NOT NULL PRIMARY KEY (MAHD),
	NGAY DATE CHECK (NGAY<GETDATE()),
	MAKH VARCHAR(5) FOREIGN KEY REFERENCES KHACHHANG(MAKH),
	TONGTG FLOAT,
);

CREATE TABLE CTHD(
	MAHD VARCHAR(10) FOREIGN KEY REFERENCES HOADON,
	MAVT VARCHAR(5) FOREIGN KEY REFERENCES VATTU,
	SL INT CHECK (SL>0),
	KHUYENMAI FLOAT,
	GIABAN FLOAT,
	PRIMARY KEY(MAHD,MAVT)
);

-------------------NHAP LIEU------------------------------------------------
INSERT INTO KHACHHANG VALUES('KH01',N'Nguyễn Thị Bé',N'Tân Bình','38457895','bnt@yahoo.com')
INSERT INTO KHACHHANG VALUES('KH02',N'Lê Hoàng Nam',N'Bình Chánh','39878987','namlehoang@gmail.com')
INSERT INTO KHACHHANG VALUES('KH03',N'Trần Thị Chiêu',N'Tân Bình','38457895',NULL)
INSERT INTO KHACHHANG VALUES('KH04',N'Mai Thị Quế Anh',N'Bình Chánh',NULL,NULL)
INSERT INTO KHACHHANG VALUES('KH05',N'Lê Văn Sáng',N'Quận 10',NULL,'sanglv@hcm.vnn.vn')
INSERT INTO KHACHHANG VALUES('KH06',N'Trần Hoàng',N'Tân Bình','38457897',NULL)
SELECT * FROM KHACHHANG

INSERT INTO VATTU VALUES('VT01',N'Xi măng',N'Bao',50000,5000)
INSERT INTO VATTU VALUES('VT02',N'Cát',N'Khối',45000,50000)
INSERT INTO VATTU VALUES('VT03',N'Gạch ống',N'Viên',120,800000)
INSERT INTO VATTU VALUES('VT04',N'Gạch thẻ',N'Viên',110,800000)
INSERT INTO VATTU VALUES('VT05',N'Đá lớn',N'Khối',25000,100000)
INSERT INTO VATTU VALUES('VT06',N'Đá nhỏ',N'Khối',33000,100000)
INSERT INTO VATTU VALUES('VT07',N'Lam gió',N'Cái',15000,50000)
SELECT * FROM VATTU

INSERT INTO HOADON VALUES('HD001',CONVERT(DATETIME,'12/05/2010',103),'KH01',NULL)
INSERT INTO HOADON VALUES('HD002',CONVERT(DATETIME,'25/05/2010',103),'KH02',NULL)
INSERT INTO HOADON VALUES('HD003',CONVERT(DATETIME,'25/05/2010',103),'KH01',NULL)
INSERT INTO HOADON VALUES('HD004',CONVERT(DATETIME,'25/05/2010',103),'KH04',NULL)
INSERT INTO HOADON VALUES('HD005',CONVERT(DATETIME,'26/05/2010',103),'KH04',NULL)
INSERT INTO HOADON VALUES('HD006',CONVERT(DATETIME,'02/06/2010',103),'KH03',NULL)
INSERT INTO HOADON VALUES('HD007',CONVERT(DATETIME,'22/06/2010',103),'KH04',NULL)
INSERT INTO HOADON VALUES('HD008',CONVERT(DATETIME,'25/06/2010',103),'KH03',NULL)
INSERT INTO HOADON VALUES('HD009',CONVERT(DATETIME,'15/08/2010',103),'KH04',NULL)
INSERT INTO HOADON VALUES('HD010',CONVERT(DATETIME,'30/09/2010',103),'KH01',NULL)
SELECT * FROM HOADON

INSERT INTO CTHD VALUES('HD001','VT01',5,NULL,52000)
INSERT INTO CTHD VALUES('HD001','VT05',10,NULL,30000)
INSERT INTO CTHD VALUES('HD002','VT03',10000,NULL,150)
INSERT INTO CTHD VALUES('HD003','VT02',20,NULL,55000)
INSERT INTO CTHD VALUES('HD004','VT03',50000,NULL,150)
INSERT INTO CTHD VALUES('HD004','VT04',20000,NULL,120)
INSERT INTO CTHD VALUES('HD005','VT05',10,NULL,30000)
INSERT INTO CTHD VALUES('HD005','VT06',15,NULL,35000)
INSERT INTO CTHD VALUES('HD005','VT07',20,NULL,17000)
INSERT INTO CTHD VALUES('HD006','VT04',10000,NULL,120)
INSERT INTO CTHD VALUES('HD007','VT04',20000,NULL,125)
INSERT INTO CTHD VALUES('HD008','VT01',100,NULL,55000)
INSERT INTO CTHD VALUES('HD008','VT02',20,NULL,47000)
INSERT INTO CTHD VALUES('HD009','VT02',25,NULL,48000)
INSERT INTO CTHD VALUES('HD010','VT01',25,NULL,57000)
SELECT * FROM CTHD

-------------------BACKUP CSDL QLBH---------------------------------------------
USE master
GO
BACKUP DATABASE QLBH
TO DISK = N'C:\Backup\CSDL_QLBH.bak' WITH NOFORMAT, NOINIT,
NAME = N'CSDL Quản Lý Bán Hàng - Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10;

--------------------RESTORE CSDL QLBH---------------------------------------------
USE master
GO
RESTORE DATABASE [QLBH]
FROM DISK = N'C:\Backup\CSDL_QLBH.bak' WITH FILE = 1, NOUNLOAD, STATS =5;

-------------------VIEW------------------------------------------------
--1.	Hiển thị danh sách các khách hàng có địa chỉ là “Tân Bình” gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
CREATE VIEW CAU1
AS
	SELECT *
	FROM KHACHHANG
	WHERE DIACHI LIKE N'Tân Bình'
GO
SELECT * FROM CAU1

--2.	Hiển thị danh sách các khách hàng gồm các thông tin mã khách hàng, tên khách hàng, địa chỉ và địa chỉ E-mail của những khách hàng chưa có số điện thoại.
CREATE VIEW CAU2
AS
	SELECT *
	FROM KHACHHANG
	WHERE MAKH NOT IN (SELECT MAKH FROM KHACHHANG WHERE DT LIKE '%')
GO
SELECT * FROM CAU2

--3.	Hiển thị danh sách các khách hàng chưa có số điện thoại và cũng chưa có địa chỉ Email gồm mã khách hàng, tên khách hàng, địa chỉ.
CREATE VIEW CAU3
AS
	SELECT *
	FROM KHACHHANG
	WHERE MAKH NOT IN (SELECT MAKH FROM KHACHHANG WHERE DT LIKE '%' OR EMAIL LIKE '%')
GO
SELECT * FROM CAU3

--4.	Hiển thị danh sách các khách hàng đã có số điện thoại và địa chỉ E-mail gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
CREATE VIEW CAU4
AS
	SELECT *
	FROM KHACHHANG
	WHERE DT LIKE '%' OR EMAIL LIKE '%'
GO
SELECT * FROM CAU4

--5.	Hiển thị danh sách các vật tư có đơn vị tính là “Cái” gồm mã vật tư, tên vật tư và giá mua.
CREATE VIEW CAU5
AS
	SELECT MAVT,TENVT,GIAMUA,DVT
	FROM VATTU
	WHERE DVT LIKE N'Cái'
GO
SELECT * FROM CAU5

--6.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá mua trên 25000.
CREATE VIEW CAU6
AS
	SELECT MAVT,TENVT,GIAMUA,DVT
	FROM VATTU
	WHERE GIAMUA > 25000
GO
SELECT * FROM CAU6

--7.	Hiển thị danh sách các vật tư là “Gạch” (bao gồm các loại gạch) gồm mã vật tư, tên vật tư, đơn vị tính và giá mua.
CREATE VIEW CAU7
AS
	SELECT MAVT,TENVT,GIAMUA,DVT
	FROM VATTU
	WHERE TENVT LIKE N'Gạch%'
GO
SELECT * FROM CAU7

--8.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá mua nằm trong khoảng từ 20000 đến 40000.
CREATE VIEW CAU8
AS
	SELECT MAVT,TENVT,GIAMUA,DVT
	FROM VATTU
	WHERE GIAMUA BETWEEN 20000 AND 40000
GO
SELECT * FROM CAU8

--9.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại.
CREATE VIEW CAU9
AS
	SELECT MAHD,NGAY,TENKH,DIACHI,DT
	FROM HOADON H, KHACHHANG K
GO
SELECT * FROM CAU9

--10.
CREATE VIEW CAU10
AS
	select H.MAHD, TENKH, DIACHI, DT, NGAY
	from HOADON H,KhachHang K
	where H.MAKH = K.MAKH and NGAY = '25/5/2010'
GO
SELECT * FROM CAU10

--11.
CREATE VIEW CAU11
AS
	select H.MAHD, NGAY, TENKH, DIACHI, DT
	from HOADON H,KhachHang K
	where H.MAKH = K.MAKH and month(H.Ngay)='6' and year(H.Ngay)='2010'
GO
SELECT * FROM CAU11


--12.
CREATE VIEW CAU12
AS
	select TENKH, DIACHI, DT, NGAY
	from HoaDon H,KhachHang K
	where H.MAKH = K.MAKH and month(H.Ngay)='6' and year(H.Ngay)='2010'
GO
SELECT * FROM CAU12

--13.
CREATE VIEW CAU13
AS
	select TENKH, DIACHI, DT
	from KhachHang K
	where MAKH not in(
						select MAKH
						from HoaDon
						where MONTH(Ngay)='6' and YEAR(Ngay)='2010')
GO
SELECT * FROM CAU13

--14.
CREATE VIEW CAU14
AS
	select C.MAHD, V.MAVT, TENVT, DVT, GiaBan, GiaMua, SL, (GiaMua*SL) as N'Trị Gia Mua', (GiaBan*SL) as N'Tri giá bán'
	from VatTu V,CTHD C
	where C.MAVT = V.MAVT
GO
SELECT * FROM CAU14

--15.
CREATE VIEW CAU15
AS
	select C.MAHD, V.MAVT, TENVT, DVT, GiaBan, GiaMua, SL, (GiaMua*SL) as N'Trị Gia Mua', (GiaBan*SL) as N'Tri giá bán'
	from VatTu V,CTHD C
	where V.MAVT = C.MAVT and GiaBan>=GiaMua
GO
SELECT * FROM CAU15

--16.
CREATE VIEW CAU16
AS
	select C.MAHD, V.MAVT, TENVT, DVT, GiaBan, GiaMua, SL, (GiaMua*SL) as N'Trị Gia Mua', (GiaBan*SL) as N'Tri giá bán', KhuyenMai = case when (sl>100) then 0.1 else 0 end
	from VatTu V,CTHD C
	where V.MAVT = C.MAVT
GO
SELECT * FROM CAU16

--17.
CREATE VIEW CAU17
AS
	select*
	from VatTu
	where MAVT not in(
						SELECT MAVT
						FROM CTHD
						WHERE SL>0)
GO
SELECT * FROM CAU17

--18.
CREATE VIEW CAU18
AS
	select H.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL, (GiaMua*SL) as N'Trị Gia Mua', (GiaBan*SL) as N'Tri giá bán'
	from HoaDon H,KhachHang K,CTHD C,VatTu V
	where H.MAKH=K.MAKH and H.MAHD=C.MAHD and C.MAVT=V.MAVT
GO
SELECT * FROM CAU18

--19.
CREATE VIEW CAU19
AS
	select H.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL, (GiaMua*SL) as N'Trị Gia Mua', (GiaBan*SL) as N'Tri giá bán'
	from HoaDon H,KhachHang K,CTHD C,VatTu V
	where H.MAKH=K.MAKH and H.MAHD=C.MAHD and C.MAVT=V.MAVT and MONTH(Ngay)=5 and YEAR(Ngay)=2010
GO
SELECT * FROM CAU19

--20.
CREATE VIEW CAU20
AS
	select H.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL, (GiaMua*SL) as N'Trị Gia Mua', (GiaBan*SL) as N'Tri giá bán'
	from HoaDon H,KhachHang K,CTHD C,VatTu V
	where H.MAKH=K.MAKH and H.MAHD=C.MAHD and C.MAVT=V.MAVT and YEAR(Ngay)=2010 and (MONTH(Ngay) between 1 and 3)
GO
SELECT * FROM CAU20

--21.
CREATE VIEW CAU21
AS
	select C.MAHD, tenkh, DIACHI, sum(sl*GiaBan) AS N'TỔNG TRỊ GIÁ'
	from HoaDon H,KhachHang K,CTHD C,VatTu V
	where H.MAKH=K.MAKH and H.MAHD=C.MAHD and C.MAVT=V.MAVT
	group by C.MAHD,TENKH,DIACHI
GO
SELECT * FROM CAU21

--22.
CREATE VIEW CAU22
AS
	select TOP 1 WITH TIES C.MAHD, tenkh, DIACHI, sum(sl*GiaBan) AS N'TỔNG TRỊ GIÁ'
	from HoaDon H,KhachHang K,CTHD C
	where H.MAKH=K.MAKH and H.MAHD=C.MAHD
	group by C.MAHD,TENKH,DIACHI
	ORDER BY sum(sl*GiaBan) DESC
GO
SELECT * FROM CAU22

--23.
CREATE VIEW CAU23
AS
	select TOP 1 WITH TIES C.MAHD, tenkh, DIACHI, sum(sl*GiaBan) AS N'TỔNG TRỊ GIÁ'
	from HoaDon H,KhachHang K,CTHD C
	where H.MAKH=K.MAKH and H.MAHD=C.MAHD and MONTH(Ngay) =5 and YEAR(Ngay)=2010
	group by C.MAHD, TENKH, DIACHI
	ORDER BY sum(sl*GiaBan) DESC
GO
SELECT * FROM CAU23
--24.
CREATE VIEW CAU24
AS
	select K.MAKH, TENKH, count(*) AS N'SỐ HÓA ĐƠN'
	from KhachHang K,HoaDon H
	where K.MAKH=H.MAKH
	group by K.MAKH, TENKH
GO
SELECT * FROM CAU24

--25.
CREATE VIEW CAU25
AS
	select K.MAKH, TENKH, count(*) AS N'SỐ HÓA ĐƠN'
	from KhachHang K,HoaDon H
	where K.MAKH=H.MAKH
	group by K.MAKH, TENKH, MONTH(NGAY)
GO
SELECT * FROM CAU25

--26.
CREATE VIEW CAU26
AS
	Select TOP 1 WITH TIES K.MAKH, TENKH, count(*) AS N'SỐ LƯỢNG HD'
	from KhachHang K,HoaDon H
	where K.MAKH=H.MAKH
	group by K.MAKH, TENKH
	ORDER BY count(*) DESC
GO
SELECT * FROM CAU26
--27.
CREATE VIEW CAU27
AS
	select TOP 1 WITH TIES K.MAKH, TENKH, COUNT(sl) AS N'SỐ LƯỢNG HD'
	from KhachHang K,HoaDon H,CTHD C
	where K.MAKH=H.MAKH and H.MAHD=C.MAHD
	group by K.MAKH,TENKH
	ORDER BY COUNT(SL) DESC
GO
SELECT * FROM CAU27

--28.
CREATE VIEW CAU28
AS
	select TOP 1 WITH TIES C.MAHD, TENVT, count(*) AS SL
	from CTHD C, VatTu V
	where C.MAVT=V.MAVT
	group by C.MAHD, TENVT
	ORDER BY COUNT(*) DESC
GO
SELECT * FROM CAU28

--29.
CREATE VIEW CAU29
AS
	select TOP 1 WITH TIES C.MAVT, TENVT, count(*) AS SL
	from CTHD C, VatTu V
	where C.MAVT=V.MAVT
	group by C.MAVT,TENVT
	ORDER BY COUNT(*) DESC
GO
SELECT * FROM CAU29

--30.
CREATE VIEW CAU30
AS
	select k.makh,tenkh,diachi, COUNT(H.MAHD) AS SLHĐ
	from KHACHHANG K LEFT JOIN HOADON H ON K.MAKH=H.MAKH
	group by k.makh,tenkh,diachi
GO
SELECT * FROM CAU30

-----------------PROCEDURE--------------------------------------------------
--1.	Lấy ra danh các khách hàng đã mua hàng trong ngày X, với X là tham số truyền vào.
CREATE PROC CAU1P(@NGAY INT)
AS
	BEGIN
		SELECT K.MAKH, TENKH, MAHD, NGAY
		FROM KHACHHANG K, HOADON H 
		WHERE K.MAKH=H.MAKH AND DAY(NGAY)=@NGAY
	END
EXEC CAU1P 25

--2.	Lấy ra danh sách khách hàng có tổng trị giá các đơn hàng lớn hơn X (X là tham số).
CREATE PROC CAU2P(@TONG FLOAT)
AS
	BEGIN
		SELECT K.MAKH, TENKH, H.MAHD, NGAY, (SL*GIABAN) AS TONG
		FROM KHACHHANG K, HOADON H, CTHD C
		WHERE K.MAKH=H.MAKH AND C.MAHD=H.MAHD AND (SL*GIABAN)>@TONG
	END
EXEC CAU2P 560000

--3.	Lấy ra danh sách X khách hàng có tổng trị giá các đơn hàng lớn nhất (X là tham số).
--DROP PROC CAU3P
IF EXISTS(SELECT * FROM SYS.OBJECTS WHERE NAME = 'CAU3P')
	DROP PROC CAU3P
GO
CREATE PROC CAU3P(@X INT)
AS
	BEGIN
		SELECT TOP (@X) WITH TIES K.MAKH, TENKH, H.MAHD, SUM(SL*GIABAN) AS [TỔNG TRỊ GIÁ]
		FROM KHACHHANG K JOIN HOADON H ON K.MAKH=H.MAKH 
						JOIN CTHD C ON C.MAHD=H.MAHD
		GROUP BY K.MAKH, TENKH, H.MAHD
		ORDER BY SUM(SL*GIABAN) DESC
	END
GO	--THUC THI
DECLARE @X INT
SET @X = 2
EXEC CAU3P @X

--4.	Lấy ra danh sách X mặt hàng có số lượng bán lớn nhất (X là tham số).
IF EXISTS(SELECT * FROM SYS.OBJECTS WHERE NAME = 'CAU4P')
	DROP PROC CAU4P
GO
CREATE PROC CAU4P(@X INT)
AS
	BEGIN
		SELECT TOP (@X) WITH TIES V.MAVT, TENVT, SL
		FROM CTHD C JOIN VATTU V ON V.MAVT=C.MAVT
		ORDER BY SL DESC
	END
GO
DECLARE @X INT
SET @X = 2
EXEC CAU4P @X

--5.	Lấy ra danh sách X mặt hàng bán ra có lãi ít nhất (X là tham số).
create proc CAU5P(@X INT)
as
	begin
		select top (@X) WITH TIES V.MAVT ,TENVT, (GIABAN-GIAMUA) AS [LÃI]
		from CTHD C JOIN VatTu V ON C.MAVT=V.MAVT
		order by (GIABAN-GIAMUA) asc
	end
GO
DECLARE @X INT
SET @X = 2
EXEC CAU5P @X

--6.	Lấy ra danh sách X đơn hàng có tổng trị giá lớn nhất (X là tham số).
CREATE PROC CAU6P(@X INT)
AS
	BEGIN
		SELECT TOP (@X) WITH TIES MAHD, MAVT, SUM(SL*GIABAN) AS [TỔNG TRỊ GIÁ]
		FROM CTHD
		GROUP BY MAHD, MAVT
		ORDER BY SUM(SL*GIABAN) DESC
	END
GO
DECLARE @X INT
SET @X = 2
EXEC CAU6P @X

--7.	Tính giá trị cho cột khuyến mãi như sau: Khuyến mãi 5% nếu SL > 100, 10% nếu SL > 500.
create proc P7
	as
		begin
			select MAHD,SL,KhuyenMai = case when (sl>100 and sl<=500) then '5%' when (sl>500) then '10%' end 
			from  CTHD
		end
GO
exec P7

--8.	Tính lại số lượng tồn cho tất cả các mặt hàng (SLTON = SLTON – tổng SL bán được).
create proc P8
	as
		begin
			select V.MAVT,TENVT,slton=(SlTon-sum(sl))
			from VatTu V JOIN CTHD C ON V.MAVT = C.MAVT
			group by V.MAVT,TENVT,SlTon
		end
GO
EXEC P8
--9.
create proc CAU9P
as
	begin
		select H.mahd,TongTG=(sl*GiaBan)
		from HoaDon H JOIN CTHD C ON H.MAHD=C.MAHD
		group by H.MAHD,TongTG,sl,GiaBan
	end
GO
EXEC CAU9P
/*
--10.
CREATE TABLE KH_VIP(
MAKH_VIP VARCHAR(5) NOT NULL PRIMARY KEY (MAKH_VIP),
TENKH_VIP NVARCHAR(30) NOT NULL,
DIACHI_VIP NVARCHAR(50),
DT_VIP VARCHAR(11) CHECK (DT_VIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
							DT_VIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
							DT_VIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
							DT_VIP LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' OR
							DT_VIP IS NULL),
EMAIL_VIP VARCHAR(30),
);
select* from KH_VIP

CREATE proc CAU10P
as
	begin
		declare @makh_VIP VARCHAR(5)
		declare @tenkh_VIP nvarchar(30)
		deClare @diachi_VIP nvarchar(50)
		declare @dt_VIP nvarchar(11)
		declare @email_VIP nvarchar(30)

		select @makh_VIP=H.mahd,@tenkh_VIP=TENKH,@diachi_VIP=DIACHI,@dt_VIP=DT,@email_VIP=EMAIL,TG=(SL*GIABAN)
		from HoaDon H JOIN KhachHang K ON H.MAKH= K.MAKH JOIN CTHD C ON H.MAHD=C.MAHD
		where (SL*GIABAN)>=10000000
		group by H.MAHD,TongTG,TENKH,DIACHI,DT,EMAIL

		declare @i int
		set @i=0
	
		insert into KH_VIP values(@makh_VIP,@tenkh_VIP,@diachi_VIP,@dt_VIP,@email_VIP)		
	end
GO
exec  CAU10P

select* from KH_VIP
*/
-----------------------FUNCTION--------------------------------------------
--1.	Viết hàm tính doanh thu của năm, với năm là tham số truyền vào.
CREATE FUNCTION TINH_DOANH_THU(@NAM INT)
RETURNS FLOAT
AS
	BEGIN
		RETURN(
			SELECT SUM(SL*GIABAN)
			FROM CTHD C JOIN HOADON H ON C.MAHD=H.MAHD
			WHERE YEAR(NGAY)=@NAM)
	END
GO
SELECT DBO.TINH_DOANH_THU(2010) AS [DOANH THU]
--2.	Viết hàm tính doanh thu của tháng, năm, với tháng và năm là 2 tham số truyền vào.
CREATE function F2(@thang int, @NAM INT)
returns int
as
	begin
		return (
			select sum(SL*GIABAN)
			from CTHD C JOIN HOADON H ON C.MAHD=H.MAHD
			where month(Ngay)=@thang AND YEAR(NGAY)=@NAM)
	end
GO
select dbo.F2(5,2010) AS [DOANH THU]

--3.	Viết hàm tính doanh thu của khách hàng với mã khách hàng là tham số truyền vào.
create function F3(@makh VARCHAR(5))
returns FLOAT
as
begin
	return (
		select sum(SL*GIABAN)
			from CTHD C JOIN HOADON H ON C.MAHD=H.MAHD
						JOIN KHACHHANG K ON K.MAKH=H.MAKH
			where K.MAKH=@MAKH)
end
GO
select dbo.F3('KH02') AS [DOANHTHU]
	
--4.	Viết hàm tính tổng số lượng bán được cho từng mặt hàng theo tháng, năm nào đó. Với mã hàng, tháng và năm là các tham số truyền vào, nếu tháng không nhập vào tức là tính tất cả các tháng.
CREATE function F4 (@mavt VARCHAR(5),@thang int)
returns int
as
begin
	declare @tinhtong int
		if not exists(select *from HoaDon where MONTH(ngay)=@thang)
			set @tinhtong=(select sum(sl) from CTHD)
		else
			set @tinhtong=
			(select sum(sl)
			from CTHD C,HoaDon H
			where C.MAHD=H.MAHD and MONTH(ngay)=@thang and mavt=@mavt
			group by month(ngay))
		return @tinhtong
end
GO		
select dbo.F4 ('VT02',5) AS [TONG SL]

--5.
CREATE function F5 (@mavt VARCHAR(5))
returns FLOAT
as
begin
	declare @TINHLAI FLOAT
		if not exists(select *from VATTU where MAVT=@MAVT)
			set @TINHLAI=(select (GIABAN-GIAMUA)*SL from CTHD C JOIN VATTU V ON C.MAVT=V.MAVT)
		else
			set @TINHLAI=
			(select (GIABAN-GIAMUA)*SL
			from CTHD C JOIN vattu v ON C.MAVT=V.MAVT
			where V.mavt=@mavt)
		return @TINHLAI
end
GO		
select dbo.F5 ('VT02') AS [TONG SL]


--------------------TRIGGER-----------------------------------------------
--7.Mỗi hóa đơn cho phép bán tối đa 5 mặt hàng.
CREATE TRIGGER T1 ON CTHD
FOR INSERT
AS
	DECLARE @MAHD VARCHAR(5)
	SELECT @MAHD=MAHD FROM INSERTED
	IF(SELECT COUNT(*) FROM CTHD C JOIN INSERTED I ON C.MAHD=I.MAHD WHERE I.MAHD=@MAHD)>5

	BEGIN
		PRINT(N'Mỗi hóa đơn cho phép bán tối đa 5 mặt hàng.')
		ROLLBACK TRANSACTION
	END
------------------------------------------------
SELECT* FROM CTHD
INSERT INTO CTHD VALUES('HD005','VT01',1,NULL,100)
INSERT INTO CTHD VALUES('HD005','VT02',1,NULL,100)
INSERT INTO CTHD VALUES('HD005','VT03',1,NULL,100)










