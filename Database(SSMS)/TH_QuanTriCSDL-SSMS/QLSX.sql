--2180601448
--Nguyễn Minh Thắng

----------------------TAO CSDL------------------------------------------------------------------------
CREATE DATABASE QLSX
go
use QLSX
GO

-----------------------TAO BANG-----------------------------------------------------------------------
SET DATEFORMAT DMY

CREATE TABLE LOAI(
	MALOAI VARCHAR(5) NOT NULL PRIMARY KEY (MALOAI),
	TENLOAI NVARCHAR(30) NOT NULL,
);	

CREATE TABLE SANPHAM(
	MASP VARCHAR(5) NOT NULL PRIMARY KEY(MASP),
	TENSP NVARCHAR(30) NOT NULL UNIQUE,		--UNIQUE LA DUY NHAT NHUNG KO PHAI KHOA CHINH
	MALOAI VARCHAR(5) FOREIGN KEY REFERENCES LOAI(MALOAI),
);	

CREATE TABLE NHANVIEN(
	MANV VARCHAR(5) NOT NULL PRIMARY KEY (MANV),
	HOTEN NVARCHAR(30) NOT NULL,
	NGAYSINH DATE CHECK (YEAR(GETDATE())-YEAR(NGAYSINH) BETWEEN 18 AND 55) DEFAULT NULL,
	PHAI BIT CHECK (PHAI=1 OR PHAI=0) DEFAULT 0
);

CREATE TABLE PHIEUXUAT(
	MAPX INT NOT NULL PRIMARY KEY (MAPX), --IDENTITY(1,1)
	NGAYLAP DATE,
	MANV VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES NHANVIEN(MANV),
);	--!!!

CREATE TABLE CTPX(
	MAPX INT NOT NULL FOREIGN KEY REFERENCES PHIEUXUAT(MAPX),
	MASP VARCHAR(5) NOT NULL FOREIGN KEY REFERENCES SANPHAM(MASP),
	SOLUONG INT CHECK (SOLUONG>0),
	CONSTRAINT PK_CTPX PRIMARY KEY (MAPX,MASP)
);

--------------------------------------------------------------------------------------------
--NHAP LIEU
INSERT INTO LOAI VALUES('1',N'Vật liệu xây dựng')
INSERT INTO LOAI VALUES('2',N'Hàng tiêu dùng')
INSERT INTO LOAI VALUES('3',N'Ngũ cốc')
SELECT * FROM LOAI;

INSERT INTO SANPHAM VALUES('1',N'Xi măng','1')
INSERT INTO SANPHAM VALUES('2',N'Gạch','1')
INSERT INTO SANPHAM VALUES('3',N'Gạo nàng hương','3')
INSERT INTO SANPHAM VALUES('4',N'Bột mì','3')
INSERT INTO SANPHAM VALUES('5',N'Kệ chén','2')
INSERT INTO SANPHAM VALUES('6',N'Đậu xanh','3')
SELECT * FROM SANPHAM;

INSERT INTO NHANVIEN VALUES('NV01',N'Nguyễn Mai Thi',convert(datetime,'15/5/1982',103),0)
INSERT INTO NHANVIEN VALUES('NV02',N'Trần Đình Chiến',convert(datetime,'2/12/1980',103),1)
INSERT INTO NHANVIEN VALUES('NV03',N'Lê Thị Chi',convert(datetime,'23/1/1979',103),0)
SELECT * FROM NHANVIEN;

INSERT INTO PHIEUXUAT VALUES(1,'12/3/2010','NV01')
INSERT INTO PHIEUXUAT VALUES(2,'3/2/2010','NV02')
INSERT INTO PHIEUXUAT VALUES(3,'1/6/2010','NV03')
INSERT INTO PHIEUXUAT VALUES(4,'16/6/2010','NV01')
SELECT * FROM PHIEUXUAT;

INSERT INTO CTPX VALUES(1,'1',10)
INSERT INTO CTPX VALUES(1,'2',15)
INSERT INTO CTPX VALUES(1,'3',5)
INSERT INTO CTPX VALUES(2,'2',20)
INSERT INTO CTPX VALUES(3,'1',20)
INSERT INTO CTPX VALUES(3,'3',25)
INSERT INTO CTPX VALUES(4,'5',12)
SELECT * FROM CTPX;

--------------------VIEW--------------------------------------------------------
--1.	Cho biết mã sản phẩm, tên sản phẩm, tổng số lượng xuất của từng sản phẩm trong năm 2010. Lấy dữ liệu từ View này sắp xếp tăng dần theo tên sản phẩm.
CREATE VIEW V1
AS
	SELECT S.MASP, TENSP, NGAYLAP, SUM(SOLUONG) AS [TONGSL]
	FROM SANPHAM S JOIN CTPX C ON C.MASP=S.MASP
				   JOIN PHIEUXUAT P ON P.MAPX=C.MAPX
	WHERE YEAR(NGAYLAP) = 2010
	GROUP BY S.MASP, TENSP, NGAYLAP
GO
SELECT * FROM V1
ORDER BY TENSP ASC

--2.	Cho biết mã sản phẩm, tên sản phẩm, tên loại sản phẩm mà đã được bán từ ngày 1/1/2010 đến 30/6/2010.
CREATE VIEW V2
AS
	SELECT S.MASP, TENSP, TENLOAI, NGAYLAP
	FROM LOAI L JOIN SANPHAM S ON L.MALOAI=S.MALOAI
				JOIN CTPX C ON C.MASP=S.MASP 
				JOIN PHIEUXUAT P ON P.MAPX=C.MAPX
	WHERE NGAYLAP BETWEEN '1/1/2010' AND '30/6/2010'
GO
SELECT * FROM V2

--3.	Cho biết số lượng sản phẩm trong từng loại sản phẩm gồm các thông tin: mã loại sản phẩm, tên loại sản phẩm, số lượng các sản phẩm.
CREATE VIEW V3
AS
	SELECT L.MALOAI, TENLOAI, SOLUONG
	FROM LOAI L JOIN SANPHAM S ON L.MALOAI=S.MALOAI
				JOIN CTPX C ON C.MASP=S.MASP
	GROUP BY L.MALOAI, TENLOAI, SOLUONG
GO
SELECT * FROM V3

--4.	Cho biết tổng số lượng phiếu xuất trong tháng 6 năm 2010.
CREATE VIEW V4
AS
	SELECT C.MAPX,NGAYLAP,COUNT(C.MAPX) AS [TONGSLPX]
	FROM CTPX C JOIN PHIEUXUAT P ON P.MAPX=C.MAPX
	WHERE MONTH(NGAYLAP)=6 AND YEAR(NGAYLAP)=2010
	GROUP BY C.MAPX,NGAYLAP
GO
SELECT * FROM V4

--5.	Cho biết thông tin về các phiếu xuất mà nhân viên có mã NV01 đã xuất.
CREATE VIEW V5
AS
	SELECT *
	FROM PHIEUXUAT
	WHERE MANV='NV01'
GO
SELECT * FROM V5

--6.	Cho biết danh sách nhân viên nam có tuổi trên 25 nhưng dưới 30.
CREATE VIEW V6
AS
	SELECT *
	FROM NHANVIEN
	WHERE PHAI=1 AND YEAR(GETDATE())-YEAR(NGAYSINH) BETWEEN 25 AND 30
GO
SELECT * FROM V6

--7.Thống kê số lượng phiếu xuất theo từng nhân viên.
CREATE VIEW V7
AS
	SELECT P.MANV,SOLUONG
	FROM PHIEUXUAT P JOIN CTPX C ON P.MAPX=C.MAPX
	GROUP BY P.MANV,SOLUONG
GO
SELECT * FROM V7

--8.	Thống kê số lượng sản phẩm đã xuất theo từng sản phẩm.
CREATE VIEW V8
AS
	SELECT MASP,SOLUONG
	FROM CTPX
	GROUP BY MASP,SOLUONG
GO
SELECT * FROM V8

--9.	Lấy ra tên của nhân viên có số lượng phiếu xuất lớn nhất.
CREATE VIEW V9
AS
	SELECT TOP 1 WITH TIES HOTEN,SOLUONG
	FROM NHANVIEN N JOIN PHIEUXUAT P ON N.MANV=P.MANV
					JOIN CTPX C ON C.MAPX=P.MAPX
	ORDER BY SOLUONG DESC
GO
SELECT * FROM V9

--10.	Lấy ra tên sản phẩm được xuất nhiều nhất trong năm 2010.
CREATE VIEW V10
AS
	SELECT TOP 1 WITH TIES TENSP,SOLUONG
	FROM SANPHAM S JOIN CTPX C ON S.MASP=C.MASP
	ORDER BY SOLUONG DESC
GO
SELECT * FROM V10

----------------------FUNCTION------------------------------------------------------
--1.	Function F1 có 2 tham số vào là: tên sản phẩm, năm. Function cho biết: số lượng xuất kho của tên sản phẩm đó trong năm này. (Chú ý: Nếu tên sản phẩm đó không tồn tại thì phải trả về 0)
CREATE FUNCTION F1(@TENSP NVARCHAR(30), @NAM INT)
RETURNS BIGINT
AS
	BEGIN
		DECLARE @TONGSL BIGINT
			IF NOT EXISTS(SELECT * FROM SANPHAM WHERE TENSP LIKE @TENSP)
				SET @TONGSL = 0
			SELECT @TONGSL = SUM(SOLUONG)
			FROM SANPHAM S JOIN CTPX C ON S.MASP=C.MASP
							JOIN PHIEUXUAT P ON P.MAPX=C.MAPX
			WHERE TENSP LIKE @TENSP AND YEAR(NGAYLAP)=@NAM
			GROUP BY S.MASP,TENSP
		RETURN @TONGSL
	END
GO
PRINT DBO.F1(N'GẠCH',2010)

--2.Function F2 có 1 tham số nhận vào là mã nhân viên. Function trả về số lượng phiếu xuất của nhân viên truyền vào. Nếu nhân viên này không tồn tại thì trả về 0.
CREATE FUNCTION F2(@MANV NVARCHAR(5))
RETURNS BIGINT
AS
	BEGIN
		DECLARE @SL BIGINT
			IF NOT EXISTS(SELECT * FROM NHANVIEN WHERE MANV LIKE @MANV)
				SET @SL = 0
			SELECT @SL = SOLUONG
			FROM NHANVIEN N JOIN PHIEUXUAT P ON P.MANV=N.MANV
							JOIN CTPX C ON P.MAPX=C.MAPX	
							
			WHERE N.MANV LIKE @MANV
		RETURN @SL
	END
GO
PRINT DBO.F2('NV01')

--3.Function F3 có 1 tham số vào là năm, trả về danh sách các sản phẩm được xuất trong năm truyền vào. 
CREATE FUNCTION F3(@NAM INT)
RETURNS TABLE
AS
	RETURN(
		SELECT S.MASP,TENSP,NGAYLAP
		FROM SANPHAM S JOIN CTPX C ON S.MASP=C.MAPX
							JOIN PHIEUXUAT P ON P.MAPX=C.MAPX
		WHERE YEAR(NGAYLAP)=@NAM)
GO
SELECT * FROM F3(2010)

--4.	Function F4 có một tham số vào là mã nhân viên để trả về danh sách các phiếu xuất của nhân viên đó. Nếu mã nhân viên không truyền vào thì trả về tất cả các phiếu xuất.
CREATE FUNCTION F4(@MANV VARCHAR(5))
RETURNS @TONGHOP TABLE(
	MAPX INT,
	NGAYLAP DATE,
	MANV VARCHAR(5)
)
AS
	BEGIN
		IF(@MANV IS NULL) INSERT INTO @TONGHOP
			SELECT MAPX,NGAYLAP,MANV FROM PHIEUXUAT
		ELSE INSERT INTO @TONGHOP
			SELECT P.MAPX,NGAYLAP,N.MANV
			FROM NHANVIEN N JOIN PHIEUXUAT P ON N.MANV=P.MANV
			WHERE N.MANV=@MANV
		RETURN
	END
GO
SELECT * FROM F4('NV01')
SELECT * FROM F4(NULL)


--5.	Function F5 để cho biết tên nhân viên của một phiếu xuất có mã phiếu xuất là tham số truyền vào.
CREATE FUNCTION F5(@MAPX INT)
RETURNS NVARCHAR(30)
AS
	BEGIN
		DECLARE @TENNV NVARCHAR(30)
			SELECT @TENNV=HOTEN
			FROM NHANVIEN N JOIN PHIEUXUAT P ON N.MANV=P.MANV
			WHERE P.MAPX = @MAPX 
		RETURN @TENNV
	END
GO
PRINT DBO.F5(2)
--SELECT * FROM PHIEUXUAT

--6.	Function F6 để cho biết danh sách các phiếu xuất từ ngày T1 đến ngày T2. (T1, T2 là tham số truyền vào). Chú ý: T1 <= T2.
CREATE FUNCTION F6(@T1 INT,@T2 INT)
RETURNS @TONGHOP TABLE(
	MAPX INT,
	NGAYLAP DATE,
	MANV VARCHAR(5)
)
AS		
	BEGIN
		IF(@T1 > @T2) INSERT INTO @TONGHOP
			SELECT * FROM PHIEUXUAT
		ELSE INSERT INTO @TONGHOP
			SELECT MAPX,NGAYLAP,MANV
			FROM PHIEUXUAT
			WHERE DAY(NGAYLAP) BETWEEN @T1 AND @T2
		RETURN 
	END
GO
SELECT * FROM F6(1,6)

--7.	Function F7 để cho biết ngày xuất của một phiếu xuất với mã phiếu xuất là tham số truyền vào.
CREATE FUNCTION F7(@MAPX INT)
RETURNS DATE
AS
	BEGIN
		DECLARE @NGAY DATE
			SELECT @NGAY=NGAYLAP
			FROM PHIEUXUAT
			WHERE MAPX=@MAPX
		RETURN @NGAY
	END
GO
PRINT DBO.F7('2')

--------------------PROCEDURE--------------------------------------------------------
--1.	Procedure tên là P1 cho có 2 tham số sau:
--			1 tham số nhận vào là: tên sản phẩm.
--			1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong năm 2010 (Không viết lại truy vấn, hãy sử dụng Function F1 ở câu 4 để thực hiện)
CREATE PROC P1
@TENSP NVARCHAR(30),
@TONGSL INT OUT
AS
	BEGIN
		SELECT @TONGSL = DBO.F1(@TENSP,2010)
	END
GO
DECLARE @TONGSL INT
EXEC P1 N'XI MĂNG', @TONGSL OUT
PRINT N'Tổng số lượng xuất kho:' + CONVERT(VARCHAR(30),@TONGSL)

--2.	Procedure tên là P2 có 2 tham số sau:
--			1 tham số nhận vào là: tên sản phẩm.
--			1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010 (Chú ý: Nếu tên sản phẩm này không tồn tại thì trả về 0)
CREATE PROC P2
@TENSP NVARCHAR(30),
@TONGSL INT OUT
AS
	BEGIN
		IF NOT EXISTS(SELECT * FROM SANPHAM WHERE TENSP=@TENSP)
			SET @TONGSL=0
		SELECT @TONGSL=SUM(SOLUONG)
		FROM CTPX C JOIN PHIEUXUAT P ON P.MAPX=C.MAPX
					JOIN SANPHAM S ON S.MASP=C.MASP
		WHERE TENSP=@TENSP AND YEAR(NGAYLAP)=2010 AND MONTH(NGAYLAP) BETWEEN 4 AND 6
		GROUP BY P.MAPX
	END
GO
DECLARE @TONGSL INT
EXEC P2 N'XI MĂNG', @TONGSL OUT
PRINT N'Tổng số lượng xuất kho: ' + CONVERT(NVARCHAR(30),@TONGSL)

--3.Procedure tên là P3 chỉ có duy nhất 1 tham số nhận vào là tên sản phẩm. 
--Trong Procedure này có khai báo 1 biến cục bộ được gán giá trị là: 
--số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010. Việc gán trị này chỉ được thực hiện bằng cách gọi Procedure P2.
CREATE PROC P3
@TENSP NVARCHAR(30),
@TONGSL INT OUT
AS
	BEGIN
		--DECLARE @TONGSL2 INT
		EXEC P2 @TENSP, @TONGSL OUT
	END
GO
DECLARE @TONGSL INT
EXEC P3 N'Gạch', @TONGSL OUT
PRINT N'Tổng số lượng xuất kho:' + CONVERT(NVARCHAR(30),@TONGSL)

--4.Procedure P4 để INSERT một record vào trong table LOAI. Giá trị các field là tham số truyền vào.
CREATE PROC P4
@MALOAI VARCHAR(5),
@TENLOAI NVARCHAR(30)
AS
	BEGIN
		INSERT INTO LOAI VALUES(@MALOAI,@TENLOAI)
	END
GO
EXEC P4 @MALOAI='4', @TENLOAI=N'FOOD'
SELECT * FROM LOAI
--DELETE FROM LOAI WHERE MALOAI='4'

--5.	Procedure P5 để DELETE một record trong Table NhânViên theo mã nhân viên. Mã NV là tham số truyền vào.
CREATE PROC P5
@MANV VARCHAR(5)
AS
	BEGIN
		DELETE FROM NHANVIEN WHERE MANV=@MANV
	END
GO
EXEC P5 'NV02'	--!!!(DINH KHOA NGOAI)
SELECT * FROM NHANVIEN

ALTER TABLE NHANVIEN --KHONG KHOA NGOAI
	NOCHECK CONSTRAINT FK__PHIEUXUAT__MANV__1BFD2C07

-----------------------TRIGGER-----------------------------------------------------
--1.	Chỉ cho phép một phiếu xuất có tối đa 5 chi tiết phiếu xuất.
CREATE TRIGGER T1 ON CTPX
FOR INSERT
AS
	DECLARE @MAPX VARCHAR(5)
	SELECT @MAPX=MAPX FROM INSERTED
	IF(SELECT COUNT(*) FROM CTPX C JOIN INSERTED I ON C.MAPX=I.MAPX WHERE I.MAPX=@MAPX) > 5
	
	BEGIN
		PRINT('1 PHIEU XUAT CHI CO 5 CHI TIET')
		ROLLBACK TRANSACTION
	END
----------------------------------
SELECT * FROM CTPX
INSERT INTO CTPX VALUES(1,'4',20)
INSERT INTO CTPX VALUES(1,'5',20)	--DELETE FROM CTPX WHERE MAPX='1'
INSERT INTO CTPX VALUES(1,'6',20)

--2.	Chỉ cho phép một nhân viên lập tối đa 10 phiếu xuất trong một ngày.
CREATE TRIGGER T2 ON PHIEUXUAT
FOR INSERT 
AS
	DECLARE @MANV VARCHAR(5),@NGAYLAP DATE
	SELECT @MANV=MANV,@NGAYLAP=NGAYLAP FROM INSERTED
	IF(SELECT COUNT(*) FROM PHIEUXUAT WHERE MANV=@MANV AND NGAYLAP=@NGAYLAP) > 10

	BEGIN
		PRINT('1 NHAN VIEN LAP TOI DA 10 PHIEU XUAT TRONG 1 NGAY')
		ROLLBACK TRANSACTION
	END
----------------------------------
 SELECT * FROM PHIEUXUAT
 INSERT INTO PHIEUXUAT VALUES(5,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(6,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(7,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(8,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(9,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(10,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(11,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(12,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(13,'12/3/2010','NV01')	--DELETE FROM PHIEUXUAT WHERE MAPX='15'
 INSERT INTO PHIEUXUAT VALUES(14,'12/3/2010','NV01')
 INSERT INTO PHIEUXUAT VALUES(15,'16/6/2010','NV01')

--3.	Khi người dùng viết 1 câu truy vấn nhập 1 dòng cho bảng chi tiết phiếu xuất thì CSDL kiểm tra, nếu mã phiếu xuất mới đó chưa tồn tại trong bảng phiếu xuất thì CSDL sẽ không cho phép nhập và thông báo lỗi “Phiếu xuất này không tồn tại”. Hãy viết 1 trigger đảm bảo điều này.
ALTER TRIGGER T3 ON CTPX
FOR INSERT
AS
	DECLARE @MAPX VARCHAR(5)
	SELECT MAPX=@MAPX FROM INSERTED
	IF NOT EXISTS(SELECT MAPX=@MAPX FROM CTPX WHERE MAPX=@MAPX)

	BEGIN
		PRINT(N'Phiếu xuất này không tồn tại')
		ROLLBACK TRANSACTION
	END
--------------------------------------
SELECT * FROM CTPX
INSERT INTO CTPX VALUES(1,'2',17)	--

ALTER TABLE CTPX 
	NOCHECK CONSTRAINT FK__CTPX__MAPX__1ED998B2
