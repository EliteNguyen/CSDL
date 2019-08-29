create database QLDUAXEDAP
go
use QLDUAXEDAP
go
-- Tạo bảng
create table LANTHI
(
	Lanthi varchar(6) primary key, 
	Namthi int, 
	Ynghia nvarchar(100), 
	NgayBatdau datetime, 
	NgayKetthuc datetime,
	Check (Namthi > 1990),
	Check (NgayKetthuc > NgayBatdau)
)

create table CHANGDUA
(
	MaCD varchar(6) primary key, 
	TenCD nvarchar(100), 
	DiemXP nvarchar(30), 
	DiemVedich nvarchar(30), 
	SoKm int, 
	Hinhthuc nvarchar(50), 
	Thoigianthuong int, 
	Thoigiantoida int,
	Check (SoKm > 0)
)

create table CT_CHANG_LANTHI
(
	MaCD varchar(6) not null, 
	Lanthi varchar(6) not null, 
	primary key (MaCD, Lanthi),
	constraint CTTHI_ThuocMaCD foreign key (MaCD) references CHANGDUA(MaCD),
	constraint CTTHI_ThuocLanThi foreign key (Lanthi) references LANTHI(Lanthi)
)

create table NHATAITRO
(
	MaNTT varchar(6) primary key, 
	TenNTT nvarchar(100), 
	DiachiNTT nvarchar(100),  
	DienthoaiNTT varchar(15)
)

create table CT_TAITRO
(
	Lanthi varchar(6) not null, 
	MaNTT varchar(6) not null, 
	SotienTT bigint,
	primary key (Lanthi, MaNTT),
	constraint NTT_ThuocNTT foreign key (MaNTT) references NHATAITRO(MaNTT),
	constraint NTT_ThuocLanThi foreign key (Lanthi) references LANTHI(Lanthi),
	Check (SotienTT > 0)
)

create table QUOCGIA
(
	MaQG varchar(6) primary key,  
	TenQG nvarchar(100)
)

create table DOI
(
	MaDoi varchar(6) primary key,  
	TenDoi nvarchar(100), 
	MaQG varchar(6) not null,
	constraint DOI_ThuocQG foreign key (MaQG) references QUOCGIA(MaQG)
)

create table EKIP
(
	MaEkip varchar(6) primary key, 
	TenEkip nvarchar(100), 
	Bacsi nvarchar(100), 
	Taixe nvarchar(100), 
	HLV nvarchar(100)
)

create table VDV
(
	MaVDV varchar(6) primary key,   
	TenVDV nvarchar(100),  
	NgaysinhVDV datetime, 
	DiachiVDV nvarchar(100),
	ChucvuVDV nvarchar(100), 
	MaDoi varchar(6), 
	MaEkip varchar(6),
	constraint VDV_ThuocDoi foreign key (MaDoi) references DOI(MaDoi),
	constraint VDV_ThuocEkip foreign key (MaEkip) references EKIP(MaEkip)
)

create table DSTHIDAU
(
	Lanthi varchar(6) not null, 
	MaVDV varchar(6) not null,  
	SoAo smallint,
	primary key (Lanthi, MaVDV),
	constraint DS_ThuocLanthi foreign key (Lanthi) references LANTHI(Lanthi),
	constraint DS_ThuocVDV foreign key (MaVDV) references VDV(MaVDV)
)

create table DANGKY
(
	Lanthi varchar(6) not null, 
	MaDoi varchar(6) not null, 
	NgayDangky datetime,
	primary key (Lanthi, MaDoi),
	constraint DK_ThuocLanthi foreign key (Lanthi) references LANTHI(Lanthi),
	constraint DK_ThuocDoi foreign key (MaDoi) references DOI(MaDoi)
)

create table GIAITHUONG
(
	MaGT varchar(6) primary key,  
	TenGT nvarchar(100), 
	Sotien bigint, 
	MaCD varchar(6), 
	Lanthi varchar(6), 
	MaVDV varchar(6),
	constraint GT_ThuocCD foreign key (MaCD) references CHANGDUA(MaCD),
	constraint GT_ThuocVDV foreign key (MaVDV) references VDV(MaVDV),
	constraint GT_ThuocLanthi foreign key (Lanthi) references LANTHI(Lanthi)
)

create table THANHTICH
(
	MaCD varchar(6) not null,  
	Lanthi varchar(6) not null,  
	MaVDV varchar(6) not null,  
	Thoigian time,
	primary key (MaCD, Lanthi, MaVDV),
	constraint TT_ThuocCD foreign key (MaCD) references CHANGDUA(MaCD),
	constraint TT_ThuocVDV foreign key (MaVDV) references VDV(MaVDV),
	constraint TT_ThuocLanthi foreign key (Lanthi) references LANTHI(Lanthi)
)

-- CÂU HỎI
--1)	Cho biết cuộc đua xe đạp đã tổ chức được bao nhiêu lần?
select count(*) "Số lần tổ chức cuộc thi" from LANTHI

--2)	Cho biết lần thi nào có thời gian diễn ra dài nhất (NgàyKetthuc – NgayBatdau)?
select top 1 with ties Lanthi, DATEDIFF(DAY,NgayBatdau,NgayKetthuc) "Số ngày diễn ra"
from LANTHI
order by [Số ngày diễn ra] DESC

--3)	Trong các lần thi, nhà tài trợ nào đã tài trợ số tiền nhiều nhất? Thông tin hiển thị: MaNTT, TenNTT, Lanthi, SotienTT.
select b.MaNTT, b.TenNTT, a.Lanthi, a.SotienTT
from CT_TAITRO a, NHATAITRO b
where	a.MaNTT = b.MaNTT and
		a.SotienTT >=	(select Max(c.SotienTT) from CT_TAITRO c where c.Lanthi = a.Lanthi)

--4)	Cho biết cuộc đua lần thứ 22 có bao nhiêu chặng?
select count(*) "Số chặng cuộc đua lần 22"
from CT_CHANG_LANTHI
where Lanthi = 22

--5)	Có bao nhiêu VĐV tham dự chặn đua lần thứ 22?
select count(*) "Số VĐV tham gia cuộc đua lần 22"
from DSTHIDAU
where Lanthi = 22

--6)	Hiển thị thông tin các đội tham dự cuộc đua lần thứ 22. Thông tin gồm: MaDoi, TenDoi, TenQG.
select a.MaDoi, b.TenDoi, c.TenQG
from DANGKY a, DOI b, QUOCGIA c
where Lanthi = 22 and a.MaDoi = b.MaDoi and b.MaQG = c.MaQG

--7)	Hiển thị thông tin các êkíp của đội ‘ADC Truyền hình Vĩnh Long’.
select b.MaDoi, b.TenVDV, b.NgaysinhVDV, b.DiachiVDV, b.ChucvuVDV
from EKIP a, VDV b
where a.MaEkip = b.MaEkip and a.TenEkip = N'ADC Truyền hình Vĩnh Long'

--8)	Cho biết tổng số tiền thưởng của lần thi thứ 22.
select sum(Sotien) "Tiền thưởng lần thi 22"
from GIAITHUONG
where Lanthi = 22

--9)	Cho biết thông tin của cầu thủ đạt áo vàng (về nhất) chặng thứ nhất của lần thi thứ 22?
select *
from VDV
where MaVDV in (select top 1 with ties t1.MaVDV from THANHTICH t1 where t1.Lanthi = 22 order by t1.Thoigian) 

--10)	Cho biết thông tin của cầu thủ đạt áo xanh (về nhì) chặng thứ nhất của lần thi thứ 22?
select *
from VDV
where MaVDV in (select top 1 with ties t1.MaVDV from THANHTICH t1 where t1.Lanthi = 22 and t1.Thoigian > (select Min(t2.Thoigian) from THANHTICH t2 where t2.Lanthi = 22) order by t1.Thoigian) 

--11)	Liệt kê các VĐV đạt áo đỏ (về nhất) trong các chặng có hình thức là ‘Leo đèo’.
select *
from VDV
where MaVDV in (select top 1 with ties t1.MaVDV from THANHTICH t1, CHANGDUA t2 where t1.MaCD = t2.MaCD and t2.Hinhthuc = N'Leo đèo' order by t1.Thoigian) 

--12)	Xếp loại VĐV và êkíp cho chặng đua có MaCD là CD02 của lần thi thứ 22.
--13)	Hiển thị thông tin VĐV đoạt áo vàng chung cuộc (thời gian nhỏ nhất) của lần thi thứ 22.
--14)	Cho biết đội đoạt giải nhất, nhì, ba của lần thi thứ 22.
