create database TOURDULICH
go
use TOURDULICH
go

-- Tạo bảng
create table DIEMTQ
(
	MaDTQ varchar(6) primary key,
	TenDTQ nvarchar(50) not null,
	Noidung ntext,
	Ynghia ntext
)


create table TOUR
(
	MaTour varchar(6) primary key, 
	TenTour ntext not null, 
	Songay int not null, 
	Sodem int default 0,
	Check (Songay > 0 and Sodem >= 0)
) 

create table CT_THAMQUAN
(
	MaTour varchar(6) not null, 
	MaDTQ varchar(6) not null, 
	Thoigian int default 0,
	primary key (MaTour, MaDTQ),
	constraint CTThuocDoan foreign key (MaDTQ) references DIEMTQ(MaDTQ),
	constraint CTThuocTour foreign key (MaTour) references TOUR(MaTour),
	check (Thoigian >= 0)
)

create table DOAN
(
	MaDoan varchar(6) primary key, 
	TenDoan nvarchar(50) default null, 
	HoTenNDD nvarchar(50) not null, 
	Diachi nvarchar(100), 
	Dienthoai nvarchar(15) not null
) 

create table HOPDONG
(
	SoHD varchar(6) primary key, 
	NgaylapHD datetime not null, 
	NoidungHD ntext,
	SoNguoidi int not null, 
	Noidon nvarchar(50) not null,
	NgaydiHD datetime not null, 
	MaTour varchar(6) not null, 
	MaDoan varchar(6) not null,
	constraint HDThuocDoan foreign key (MaDoan) references DOAN(MaDoan),
	constraint HDThuocTour foreign key (MaTour) references TOUR(MaTour),
	Check (NgaydiHD >= NgaylapHD and SoNguoidi > 0) 
)


create table DIEMDUNGCHAN
(
	MaDDC varchar(6) primary key, 
	TenDDC ntext not null, 
	Thanhpho nvarchar(50) not null
)

create table LOTRINH
(
	MaNoiDi varchar(6) not null, 
	MaNoiDen varchar(6) not null,
	primary key(MaNoiDi, MaNoiDen),
	constraint ThuocDiem1 foreign key (MaNoiDi) references DIEMDUNGCHAN(MaDDC),
	constraint ThuocDiem2 foreign key (MaNoiDen) references DIEMDUNGCHAN(MaDDC)
)

create table LOTRINH_TOUR
(
	MaTour varchar(6) not null, 
	MaNoiDi varchar(6) not null, 
	MaNoiDen varchar(6) not null, 
	SongayO int default 0, 
	SongaydicuaPT int not null, 
	LoaiPhuongtien nvarchar(50) not null, 
	LoaiKhachsan nvarchar(10) default null,
	primary key (MaTour, MaNoiDi, MaNoiDen),
	constraint ThuocDiem3 foreign key (MaNoiDi) references DIEMDUNGCHAN(MaDDC),
	constraint ThuocDiem4 foreign key (MaNoiDen) references DIEMDUNGCHAN(MaDDC),
	constraint ThuocTour foreign key (MaTour) references TOUR(MaTour),
	Check (SongayO >= 0 and SongaydicuaPT >= 0)
) 


create table NHANVIENHDDL
(
	MaNVHDDL varchar(6) primary key, 
	TenNV nvarchar(50) not null, 
	NgaysinhNV datetime, 
	PhaiNV nvarchar(5) not null, 
	DiachiNV nvarchar(100), 
	DienthoaiNV varchar(15) not null unique,
	Check (PhaiNV in (N'Nam', N'Nữ'))
) 

create table CHUYEN
(
	MaChuyen varchar(6) primary key, 
	Tenchuyen ntext not null, 
	NgaydiCuaChuyen datetime not null, 
	MaNVHDDL varchar(6) not null, 
	MaTour varchar(6) not null,
	constraint ChuyenThuocTour foreign key (MaTour) references TOUR(MaTour),
	constraint ChuyenThuocNVHD foreign key (MaNVHDDL) references NHANVIENHDDL(MaNVHDDL)
)

create table HOPDONG_NV
(
	SoHD varchar(6) not null, 
	MaNVHDDL varchar(6) not null, 
	NoidungHD_NV ntext not null,
	primary key (SoHD, MaNVHDDL),
	constraint HopDongNV foreign key (MaNVHDDL) references NHANVIENHDDL(MaNVHDDL)
) 
go


--1)	Hiển thị thông tin các hướng dẫn viên du lịch của công ty.
select * from NHANVIENHDDL

--2)	Cho biết hiện tại công ty có những tour du lịch nào.
select * from TOUR

--3)	Liệt kê các tour có số ngày đi >= 3.
select * from TOUR
where SoNgay >= 3

--4)	Liệt kê đầy đủ thông tin các điểm tham quan.
select * from DIEMTQ

--5)	Liệt kê các tour mà có ghé qua điểm du lịch Nha Trang (Thành Phố nơi đến).
select *
from TOUR a
where	a.MaTour in
		(
			select MaTour
			from LOTRINH_TOUR b, DIEMDUNGCHAN c
			where b.MaNoiDen = c.MaDDC and c.Thanhpho = 'Nha Trang'
		)
		

--6)	Tìm nhân viên đã hướng dẫn nhiều chuyến đi nhất của công ty.
select top 1 with ties a.MaNVHDDL, TenNV, NgaysinhNV, DiachiNV, DienthoaiNV, count(MaChuyen) "Số chuyến"
from NHANVIENHDDL a, CHUYEN b
where	a.MaNVHDDL = b.MaNVHDDL
group by a.MaNVHDDL, TenNV, NgaysinhNV, DiachiNV, DienthoaiNV
order by count(MaChuyen) DESC


--7)	Liệt kê mã các đoàn khách và số lượng khách trong đoàn do ‘Nguyễn Văn A’ làm đại diện trong năm 2010.
select a.MaDoan "Mã đoàn", b.SoNguoidi "Số người đi"
from DOAN a, HOPDONG b
where	a.MaDoan = b.MaDoan and
		YEAR(b.NgaylapHD) = 2010 and
		a.TenDoan = N'Nguyễn Văn A'

--8)	Cho biết có bao nhiêu chuyến đi đến Nha Trang (Thành Phố đến) được mở trong năm 2010.
select count(distinct MaChuyen) "Số chuyến đi đến Nha Trang mở trong năm 2010"
from CHUYEN a, LOTRINH_TOUR b, DIEMDUNGCHAN c
where	a.MaTour = b.MaTour and
		b.MaNoiDen = c.MaDDC and
		c.Thanhpho = N'Nha Trang' and
		YEAR(a.NgaydiCuaChuyen) = 2010

--9)	Hiển thị thông tin những nhân viên nào đang đi tour (tính đến ngày 10/6/2010).
select distinct MaNVHDDL, TenNV, NgaysinhNV, DiachiNV, DienthoaiNV
from NHANVIENHDDL
where	MaNVHDDL in	(
					select distinct a.MaNVHDDL
					from CHUYEN a, TOUR b
					where	a.MaTour = b.MaTour and
							a.NgaydiCuaChuyen <= '2010/6/10'
					)


--10)	Hiển thị thông tin những những nhân viên nào đang rảnh trong ngày 10/6/2010.
select distinct MaNVHDDL, TenNV, NgaysinhNV, DiachiNV, DienthoaiNV
from NHANVIENHDDL
where	MaNVHDDL not in	(
					select distinct a.MaNVHDDL
					from CHUYEN a, TOUR b
					where	a.MaTour = b.MaTour and
							DATEADD(day, b.Songay, a.NgaydiCuaChuyen) >= '2010/6/10' and
							a.NgaydiCuaChuyen <= '2010/6/10'
					)




--11)	Trong năm 2010, đoàn nào có số lượng khách đi du lịch nhiều nhất. Thông tin hiển thị: Mã đoàn, Tên đoàn, Số lượng Khách.
select top 1 with ties a.MaDoan "Mã đoàn", a.TenDoan "Tên đoàn", b.SoNguoidi "Số người đi"
from DOAN a, HOPDONG b
where	a.MaDoan = b.MaDoan and
		YEAR(b.NgaylapHD) = 2010
order by b.SoNguoidi DESC


--12)	Cho biết tour du lịch nào sử dụng phương tiện ‘Ô tô’ nhiều nhất.
select top 1 with ties a.MaTour "Mã tour", CAST(a.TenTour AS NVARCHAR(100)) "Tên tour", COUNT(*) "SL"
from TOUR a, LOTRINH_TOUR b
where	a.MaTour = b.MaTour
group by a.MaTour, CAST(a.TenTour AS NVARCHAR(100))
order by SL DESC

--13)	Hiển thị thông tin các tour mà toàn bộ lộ trình sử dụng phương tiện là ‘Ô tô’.
select MaTour, TenTour "Tên tour toàn bộ lộ trình dùng ô tô"
from TOUR
where	MaTour not in	(
						select a.MaTour
						from TOUR a, LOTRINH_TOUR b
						where	a.MaTour = b.MaTour and
								b.LoaiPhuongtien != N'Ô tô'
						)

--14)	Cho biết thông tin của tour bán chạy nhất theo hợp đồng (Số lượng khách nhiều nhất của Tour).
select b.MaTour "Mã", b.TenTour "Tên tour bán chạy nhất", a.SoHD "Thuộc số HD"
from HOPDONG a, TOUR b
where	a.MaTour = b.MaTour and
		a.SoNguoidi >= (select Max(c.SoNguoidi) from HOPDONG c)

--15)	Hiển thị tour du lịch có nhiều điểm tham quan nhất.
select top 1 with ties a.MaTour "Mã", CAST(a.TenTour AS NVARCHAR(100)) "Tên tour bán chạy nhất", Count(*) "SL"
from TOUR a, CT_THAMQUAN b
where	a.MaTour = b.MaTour
group by a.MaTour, CAST(a.TenTour AS NVARCHAR(100))
order by SL DESC

--16)	Hiển thị thông tin các tour đã đi (tính đến ngày 10/6/2010).
select a.MaTour "Mã tour đã đi", a.TenTour "Tên tour đã đi", a.Songay, a.Sodem
from TOUR a, HOPDONG b
where	a.MaTour = b.MaTour and
		b.NgaydiHD <= '2010/6/10'

--17)	Hiển thị thông tin các tour đang đi (tính đến ngày 10/6/2010).
select a.MaTour "Mã tour đã đi", a.TenTour "Tên tour đã đi", a.Songay, a.Sodem
from TOUR a, HOPDONG b
where	a.MaTour = b.MaTour and
		b.NgaydiHD <= '2010/6/10'

--18)	Hiển thị thông tin các tour đang mở ở chuyến tính đến ngày 10/6/2010.

--19)	Liệt kê các điểm dừng chân ở thành phố Nha Trang.
select *
from DIEMDUNGCHAN
where Thanhpho = N'Nha Trang'

--20)	In thông tin hợp đồng (Số HĐ, Ngày lập HĐ, Số người đi, Mã Tour, Tên Tour, Mã Đoàn, Tên Đoàn) có số lượng người đi nhiều nhất theo tour đó.
select a.SoHD "Số HĐ", a.NgaylapHD "Ngày lập", a.SoNguoidi "Số người đi", a.MaTour "Mã tour", b.TenTour "Tên tour", c.TenDoan "Tên đoàn"
from HOPDONG a, TOUR b, DOAN c
where	a.MaDoan = c.MaDoan and
		a.MaTour = b.MaTour and
		a.SoNguoidi >=	(
							select Max(d.SoNguoiDi) from HOPDONG d where d.MaTour = a.MaTour
						)