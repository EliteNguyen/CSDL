-- BÀI THỰC HÀNH SỐ 3 - BÀI GIẢI MẪU
-- PHAM NGOC VINH - 16DTHA2

-- TẠO DATABASE
create database QUANLYCH
go
use QUANLYCH
go

-- TẠO CÁC TABLE

create table NHACC
(
	MaNCC varchar(5) primary key, 
	TenNCC nvarchar(50) not null, 
	DiaChiNCC nvarchar(100) not null,
	DTNCC varchar(11) not null unique
)

create table LOAINGK
(
	MaLoaiNGK varchar(5) primary key, 
	TenLoaiNGK nvarchar(20) not null unique, 
	MaNCC varchar(5) not null,
	constraint ThuocNCC foreign key (MaNCC) references NHACC(MaNCC)
) 

create table NGK
(
	MaNGK varchar(5) primary key, 
	TenNGK nvarchar(20) not null, 
	Quycach nvarchar(10) not null, 
	MaLoaiNGK varchar(5) not null,
	constraint ThuocLoaiNGK foreign key (MaLoaiNGK) references LOAINGK(MaLoaiNGK),
	check (Quycach in (N'Chai',N'Lon',N'Bịch',N'Thùng'))
) 

create table KH
(
	MaKH varchar(5) primary key,
	TenKH nvarchar(50) not null,  
	DCKH nvarchar(100), 
	DTKH varchar(11) not null unique
)

create table DDH
(
	SoDDH varchar(5) primary key,
	NgayDH datetime not null, 
	MaNCC varchar(5),
	constraint MuaHang foreign key (MaNCC) references NHACC(MaNCC)
) 

create table CT_DDH
(
	SoDDH varchar(5) not null, 
	MaNGK varchar(5) not null, 
	SLDat int not null,
	primary key (SoDDH, MaNGK),
	constraint ThuocDDH foreign key (SoDDH) references DDH(SoDDH),
	constraint ThuocNGK foreign key (MaNGK) references NGK(MaNGK),
	Check (SLDat >= 0)
)

create table PHIEUGH
(
	SoPGH varchar(5) primary key,
	NgayGH datetime not null, 
	SoDDH varchar(5) not null,
	constraint ThuocDDH2 foreign key (SoDDH) references DDH(SoDDH),
)

create table CT_PGH
(
	SoPGH varchar(5) not null, 
	MaNGK varchar(5) not null,  
	SLGiao int not null, 
	DGGiao bigint not null,
	primary key (SoPGH, MaNGK),
	constraint ThuocPGH foreign key (SoPGH) references PHIEUGH(SoPGH),
	constraint ThuocNGK2 foreign key (MaNGK) references NGK(MaNGK)
)

create table HOADON
(
	SoHD varchar(5) primary key, 
	NgaylapHD datetime not null, 
	MaKH varchar(5),
	constraint ThuocKH foreign key (MaKH) references KH(MaKH)
) 

create table CT_HOADON
(
	SoHD varchar(5) not null,  
	MaNGK varchar(5) not null, 
	SLKHMua int not null, 
	DGBan bigint not null,
	primary key (SoHD, MaNGK),
	constraint ThuocHD foreign key (SoHD) references HOADON(SoHD),
	constraint ThuocNGK3 foreign key (MaNGK) references NGK(MaNGK)
) 

create table PHIEUHEN
(
	SoPH varchar(5) primary key,
	NgayLapPH datetime not null, 
	NgayHenGiao datetime not null, 
	MaKH varchar(5) not null,
	constraint ThuocKH2 foreign key (MaKH) references KH(MaKH)
)

create table CT_PH
(
	SoPH varchar(5) not null,   
	MaNGK varchar(5) not null,   
	SLHen int not null,
	primary key (SoPH, MaNGK),
	constraint ThuocNGK4 foreign key (MaNGK) references NGK(MaNGK),
	constraint ThuocPH foreign key (SoPH) references PHIEUHEN(SoPH)
)

create table PHIEUTRANNO
(
	SoPTN varchar(5) primary key,
	NgayTra datetime not null, 
	SoTienTra bigint not null, 
	SoHD varchar(5) not null,
	constraint ThuocHD2 foreign key (SoHD) references HOADON(SoHD)
) 


-- PHẦN CÂU HỎI
--1)	Liệt kê các NGK và loại NGK tương ứng.
select TenNGK "Tên nước giải khát", Quycach "Kiểu", TenLoaiNGK "Loại"
from NGK a, LOAINGK b
where	a.MaLoaiNGK = b.MaLoaiNGK

--2)	Cho biết thông tin về nhà cung cấp ở Thành phố HCM.
select TenNCC "Tên nhà cung cấp", DiaChiNCC "Địa chỉ", DTNCC "Điện thoại"
from NHACC
where	DiaChiNCC LIKE '%Hồ Chí Minh%' or
		DiaChiNCC LIKE '%HCM%'

--3)	Liệt kê các hóa đơn mua hàng trong tháng 5/2010.
select SoHD "Số hóa đơn mua hàng 5/2010", NgaylapHD "Ngày lập"
from HOADON
where	MONTH(NgaylapHD) = 5 and
		YEAR(NgaylapHD) = 2010

--4)	Cho biết tên các nhà cung cấp có cung cấp NGK ‘Coca Cola’.
select distinct a.MaNCC "Mã NCC", a.TenNCC "Nhà cung cấp có cung cấp Coca Cola"
from NHACC a, LOAINGK b, NGK c
where	a.MaNCC = b.MaNCC and
		b.MaLoaiNGK = c.MaLoaiNGK and
		c.TenNGK = 'Coca Cola'

--5)	Cho biết tên các nhà cung cấp có thể cung cấp nhiều loại NGK nhất.
select top 1 with ties TenNCC "Tên nhà cung cấp cung cấp nhiều loại nhất", count(*) "SL"
from NHACC a, LOAINGK b
where	a.MaNCC = b.MaNCC
group by TenNCC
order by SL DESC

--6)	Cho biết tên nhà cung cấp không có khả năng cung cấp NGK có tên ‘Pepsi’.
--(Hướng dẫn: Cách 1: Sử dụng NOT EXISTS. Cách 2: Sử dụng NOT IN)
select TenNCC "Tên NCC không cung cấp Pepsi"
from NHACC
where	MaNCC 
		not in 
		(select a.MaNCC from NHACC a, LOAINGK b, NGK c where a.MaNCC = b.MaNCC and b.MaLoaiNGK = c.MaLoaiNGK and c.TenNGK = 'Pepsi')


--7)	Hiển thị thông tin của NGK chưa bán được.
select TenNGK "Tên NGK chưa bán được", Quycach "Kiểu", TenLoaiNGK "Loại"
from NGK a, LOAINGK b
where	a.MaLoaiNGK = b.MaLoaiNGK and
		a.MaNGK not in
		(select MaNGK from CT_HOADON)

--8)	Hiển thị tên và tổng số lượng bán của từng NGK.
select TenNGK "Tên NGK", Quycach "Kiểu", sum(SLKHMua) "Số lượng bán"
from NGK a, CT_HOADON b
where a.MaNGK = b.MaNGK
group by TenNGK, Quycach

--9)	Hiển thị tên và tổng số lượng của NGK nhập về.
select TenNGK "Tên NGK", Quycach "Kiểu", sum(SLDat) "Số lượng đặt"
from NGK a, CT_DDH b
where	a.MaNGK = b.MaNGK
group by TenNGK, Quycach

--10)	Hiển thị ĐĐH đã đặt NGK với số lượng nhiều nhất so với các ĐĐH khác có đặt NGK đó. Thông tin hiển thị: SoDDH, MaNGK, [SL đặt nhiều nhất].
select SoDDH, MaNGK, sum(SLDat) "SL đặt nhiều nhất"
from CT_DDH
group by SoDDH, MaNGK
having SoDDH in (	select top 1 with ties SoDDH
					from CT_DDH
					where MaNGK = 'CC2'
					group by SoDDH order by sum(SLDat) DESC )
  

--11)	Hiển thị các NGK không được nhập trong tháng 1/2010.
select MaNGK "Mã NGK",TenNGK "Tên NGK không được nhập vào 1/2010"
from NGK
where	MaNGK not in
		(select MaNGK from CT_DDH a, DDH b where	b.SoDDH = a.SoDDH and (YEAR(b.NgayDH) = 2010 or MONTH(b.NgayDH) = 1))


--12)	Hiển thị tên các NGK không bán được trong tháng 6/2010.
select MaNGK "Mã NGK",TenNGK "Tên NGK không bán được vào 6/2010"
from NGK
where	MaNGK not in
		(select MaNGK from CT_HOADON a, HOADON b where b.SoHD = a.SoHD and (YEAR(b.NgaylapHD) = 2010 or MONTH(b.NgaylapHD) = 6))


--13)	Cho biết cửa hàng bán bao nhiêu thứ NGK.
select count(MaNGK) "Số thứ NGK cửa hàng bán"
from NGK

--14)	Cho biết cửa hàng bán bao nhiêu loại NGK.
select count(MaLoaiNGK) "Số loại NGK cửa hàng bán"
from LOAINGK

--15)	Hiển thị thông tin của khách hàng có giao dịch với cửa hàng nhiều nhất (căn cứ vào số lần mua hàng).
select MaKH "Mã KH", TenKH "Tên Khách hàng có giao dịch nhiều nhất", DCKH "Địa chỉ", DTKH "Điện thoại"
from KH
where	MaKH in
		(	select top 1 with ties MaKH
			from HOADON
			group by MaKH
			order by count(SoHD) DESC )


--16)	Tính tổng doanh thu năm 2010 của cửa hàng.
select (Sum(SLKHMua*DGBan) - Sum(SLGiao*DGGiao)) "Doanh thu 2010"
from CT_HOADON a, HOADON b, CT_PGH c, PHIEUGH d, DDH e
where	a.SoHD = b.SoHD and
		YEAR(b.NgaylapHD) = 2010 and
		c.SoPGH = d.SoPGH and
		e.SoDDH = d.SoDDH and
		YEAR(e.NgayDH) = 2010

--17)	Liệt kê 5 loại NGK bán chạy nhất (doanh thu) trong tháng 5/2010.
select top 5 a.MaLoaiNGK "Mã", a.TenLoaiNGK "Tên loại hàng", (SUM(b.SLKHMua*b.DGBan)) "Doanh thu tháng 5/2010"
from LOAINGK a, CT_HOADON b, HOADON c, NGK e
where	a.MaLoaiNGK = e.MaLoaiNGK and
		e.MaNGK = b.MaNGK and
		b.SoHD = c.SoHD and
		YEAR(c.NgaylapHD) = 2010 and MONTH(c.NgaylapHD) = 5
group by a.MaLoaiNGK, a.TenLoaiNGK
order by "Doanh thu tháng 5/2010" DESC

--18)	Liệt kê thông tin bán NGK của tháng 5/2010. Thông tin hiển thị: Mã NGK, Tên NGK, SL bán.
select a.MaNGK "Mã", TenNGK "Tên", SUM(b.SLKHMua) "SL bán"
from NGK a, CT_HOADON b, HOADON c
where	a.MaNGK = b.MaNGK and
		b.SoHD = c.SoHD and
		YEAR(c.NgaylapHD) = 2010 and MONTH(c.NgaylapHD) = 5
group by a.MaNGK, TenNGK

--19)	Liệt kê thông tin của NGK có nhiều người mua nhất.
select top 1 with ties a.MaNGK "Mã", TenNGK "Tên", SUM(b.SLKHMua) "SL bán"
from NGK a, CT_HOADON b, HOADON c
where	a.MaNGK = b.MaNGK and
		b.SoHD = c.SoHD
group by a.MaNGK, TenNGK
order by "SL bán" DESC

--20)	Hiển thị ngày nhập hàng gần nhất của cửa hàng.
select top 1 with ties SoPGH "Số phiếu giao hàng gần nhất", NgayGH "Ngày giao"
from PHIEUGH a
order by datediff(DAY,a.NgayGH, GETDATE())

--21)	Cho biết số lần mua hàng của khách có mã là ‘KH001’.
select count(*) "Số lần mua hàng của khách có mã KH001"
from HOADON
where MaKH = 'KH01'

--22)	Cho biết tổng tiền của từng hóa đơn.
select SoHD "Số hóa đơn", sum(SLKHMua*DGBan) "Tổng tiền"
from CT_HOADON
group by SoHD

--23)	Cho biết danh sách các hóa đơn gồm SoHD, NgaylapHD, MaKH, TenKH và tổng trị giá của từng HoaDon. Danh sách sắp xếp tăng dần theo ngày và giảm dần theo tổng trị giá của hóa đơn.
select a.SoHD "Số hóa đơn", NgaylapHD "Ngày lập HĐ", c.MaKH "Mã KH",TenKH "Tên KH", sum(SLKHMua*DGBan) "Trị giá"
from CT_HOADON a, KH c, HOADON b
where	a.SoHD = b.SoHD and
		b.MaKH = c.MaKH
group by a.SoHD, NgaylapHD, c.MaKH, TenKH
order by NgaylapHD, "Trị giá" DESC

--24)	Cho biết các hóa đơn có tổng trị giá lớn hơn tổng trị giá trung bình của các hóa đơn trong ngày 18/06/2010.
select SoHD "Số hóa đơn có GT >= GTTB trong ngày 18/06/2010"
from HOADON a
where	(select SUM(SLKHMua*DGBan) from CT_HOADON b where a.SoHD = b.SoHD) >
		(select SUM(SLKHMua*DGBan)/COUNT(distinct c.SoHD) from CT_HOADON c, HOADON d where c.SoHD = d.SoHD and DAY(d.NgaylapHD) = 18 and MONTH(d.NgaylapHD) = 6 and YEAR(d.NgaylapHD) = 2010)

--25)	Cho biết số lượng từng NGK tiêu thụ theo từng tháng của năm 2010.
select a.MaNGK "Mã", a.TenNGK "Tên", MONTH(c.NgaylapHD) "Tháng", SUM(b.SLKHMua) "SL tiêu thụ"
from NGK a, CT_HOADON b, HOADON c
where	a.MaNGK = b.MaNGK and
		b.SoHD = c.SoHD and
		YEAR(c.NgaylapHD) = 2010
group by a.MaNGK, a.TenNGK, MONTH(c.NgaylapHD)

--26)	Đưa ra danh sách NGK chưa được bán trong tháng 9 năm 2010.
select TenNGK "Tên NGK chưa bán được 9/2010", Quycach "Kiểu", TenLoaiNGK "Loại"
from NGK a, LOAINGK b
where	a.MaLoaiNGK = b.MaLoaiNGK and
		a.MaNGK not in
		(select MaNGK from CT_HOADON a, HOADON b where a.SoHD = b.SoHD and YEAR(b.NgaylapHD) = 2010 and MONTH(b.NgaylapHD) = 9)


--27)	Đưa ra danh sách khách hàng có địa chỉ ở TP.HCM và từng mua NGK trong tháng 9 năm 2010.
select a.MaKH "Mã KH", TenKH "Tên KH từng mua hàng 9/2010", DCKH "Địa chỉ"
from KH a, HOADON b
where	a.MaKH = b.MaKH and
		YEAR(b.NgaylapHD) = 2010 and MONTH(b.NgaylapHD) = 9 and
		a.DCKH LIKE '%HCM%' or a.DCKH LIKE '%Hồ Chí Minh%'

--28)	Đưa ra số lượng đã bán tương ứng của từng NGK trong tháng 10 năm 2010.
select TenNGK "Tên NGK", Quycach "Kiểu", sum(SLKHMua) "Số lượng bán"
from NGK a, CT_HOADON b, HOADON c
where a.MaNGK = b.MaNGK and b.SoHD = c.SoHD and YEAR(c.NgaylapHD) = 2010 and MONTH(c.NgaylapHD) = 10
group by TenNGK, Quycach


--29)	Hiển  thị thông tin khách hàng đã từng mua và tổng số lượng của từng NGK tại cửa hàng.
select c.MaKH "Mã KH",TenKH "Tên KH", a.MaNGK "Mã hàng đã mua", sum(SLKHMua) "Số lượng mua"
from CT_HOADON a, KH c, HOADON b
where	a.SoHD = b.SoHD and
		b.MaKH = c.MaKH
group by c.MaKH, TenKH, a.MaNGK


--30)	Cho biết trong năm 2010, khách hàng nào đã mua nợ nhiều nhất.
select MaKH "Mã KH", TenKH "Tên KH mua nợ nhiều nhất trong 2010", DCKH "Địa chỉ"
from KH
where	MaKH in 
		(	select top 1 with ties MaKH
			from PHIEUTRANNO b, HOADON c, CT_HOADON d
			where	b.SoHD = c.SoHD and c.SoHD = d.SoHD and
					YEAR(c.NgaylapHD) = 2010
			group by MaKH
			order by SUM(d.SLKHMua*d.DGBan) DESC	)



--31)	Có bao nhiêu hóa đơn chưa thanh toán hết số tiền?
select count(distinct a.SoHD) "Số hóa đơn chưa thanh toán hết tiền"
from PHIEUTRANNO a, HOADON b
where	a.SoHD = b.SoHD and
		(select SUM(e.SoTienTra) from PHIEUTRANNO e where e.SoHD = b.SoHD) - (select SUM(f.DGBan*f.SLKHMua) from CT_HOADON f where b.SoHD = f.SoHD) < 0


--32)	Liệt kê các hóa đơn cùng tên của khách hàng tương ứng đã mua NGK và thanh toán tiền đầy đủ 1 lần. (Không có phiếu trả nợ)
select b.SoHD, c.MaKH "Mã KH",TenKH "Tên KH"
from KH c, HOADON b
where	b.MaKH = c.MaKH and
		b.SoHD not in (select d.SoHD from PHIEUTRANNO d)
group by b.SoHD, c.MaKH, TenKH


--33)	Thông kê cho biết thông tin đặt hàng của cửa hàng trong năm 2010:
--Mã NGK, Tên NGK, Tổng SL đặt.
select c.MaKH "Mã KH",TenKH "Tên KH", sum(SLKHMua) "Tổng số lượng đặt năm 2010"
from CT_HOADON a, KH c, HOADON b
where	a.SoHD = b.SoHD and
		b.MaKH = c.MaKH and
		YEAR(b.NgaylapHD) = 2010
group by c.MaKH, TenKH


--34)	Để thuận tiện trong việc tặng quà Tết cho khách hàng, hãy liệt kê danh sách khách hàng đã mua NGK với tổng số tiền tương ứng trong năm 2010 (hiển thị giảm dần theo số tiền đã mua).
select c.MaKH "Mã KH",TenKH "Tên KH", sum(a.SLKHMua*a.DGBan) "Tổng tiền đã mua trong 2010"
from CT_HOADON a, KH c, HOADON b
where	a.SoHD = b.SoHD and
		b.MaKH = c.MaKH and
		YEAR(b.NgaylapHD) = 2010
group by c.MaKH, TenKH
order by "Tổng tiền đã mua trong 2010" DESC

--35)	* Tạo View để tổng hợp dữ liệu về từng NGK đã được bán (Cấu trúc View gồm các thuộc tính: MaNGK, TenNGK, DVT, SoLuongBan)
--36)	* Tạo View để tổng hợp dữ liệu về các mặt hàng đã được bán.
--37)	* Tạo View để tổng hợp dữ liệu về các khách hàng đã mua hàng trong ngày 20/10/2010.
--38)	* Tạo thủ tục có tham số vào là @SoHD để đưa ra danh mục các NGK có trong hóa đơn trên.
--39)	* Tạo thủ tục có tham số vào là @Ngay để đưa ra danh mục các NGK đã được bán vào ngày trên (Danh sách đưa ra gồm các thuộc tính sau: MaNGK, TenNGK, DVT, SoLuong).
--40)	* Tạo TRIGGER để kiểm tra khi nhập dữ liệu vào bảng ChiTietHoaDon nếu số lượng hoặc đơn giá nhập vào nhỏ hơn 0 thì in ra màn hình thông báo lỗi “Dữ liệu nhập vào không hợp lệ” và bản ghi này không được phép nhập vào bảng.
--41)	* Tạo kiểu dữ liệu CURSOR để lưu trữ thông tin về các mặt hàng đã được bán trong ngày 20/10/2010, sau đó đưa ra màn hình danh sách dữ liệu trên.
