-- TẠO CSDL
create database BONGDATG
go
use BONGDATG
go

-- TẠO CÁC BẢNG CHO CSDL
create table DOI
(
	MaDoi varchar(5) primary key,
	TenDoi nvarchar(15) -- sử dụng được tiếng Việt có dấu
)

create table KQTRANDAU
(
	MaTran varchar(5) not null,
	MaDoi varchar(5) not null,
	BanThang int,
	primary key (MaTran, MaDoi),
	constraint Thuoc foreign key (MaDoi) references DOI(MaDoi), 
	-- thuộc tính khóa ngoại, được đặt tên là Thuoc
	Check (BanThang >= 0) -- Ràng buộc nhập dữ liệu Bàn thắng phải là số dương
)


Select a.MaDoi, a.TenDoi, Count(*) "Tổng số trận"
From DOI a, TRANDAN b
Where a.MaDoi = b.MaDoi
Group by a.MaDoi, a.TenDoi


-- Câu 2: in ra tỉ số
select a.MaTran, a.MaDoi + ' - ' + b.MaDoi "Tên đội", str(a.BanThang,2) + ' - ' + str(b.BanThang,2) "Tỉ số"
from TRANDAN a, TRANDAN b
where	a.MaDoi > b.MaDoi and
		a.MaTran = b.MaTran

Select a.MaTran, c.TenDoi + ' – ' + d.TenDoi "Đội",
       str(a.BanThang,2) + ' – ' + str(b.BanThang,2) "Tỉ số"
From TRANDAN a, TRANDAN b, DOI c, DOI d
Where a.MaTran = b.MaTran and a.MaDoi > b.MaDoi 
           and a.MaDoi = c.MaDoi and b.MaDoi = d.MaDoi


-- Câu 3: In kq mỗi trận theo điểm
select distinct	a.MaTran "Mã trận", a.MaDoi "Mã đội", 
		(case when a.BanThang > b.BanThang then 3 else (case when a.BanThang < b.BanTHang then 0 else 2 end) end)
from TRANDAN a, TRANDAN b
where	a.MaTran = b.MaTran and a.MaDoi != b.MaDoi

-- Câu 4: in tổng số điểm
select t1.MaDoi, TenDoi, Sum(t1.Diem) "Điểm"
from	(
		select	a.MaDoi, (case when a.BanThang > b.BanTHang then 3 else (case when a.BanThang < b.BanTHang then 0 else 1 end) end) as Diem
		from TRANDAN a, TRANDAN b
		where	a.MaTran = b.MaTran and a.MaDoi != b.MaDoi
		) as t1, DOI t2
where t1.MaDoi = t2.MaDoi
group by t1.MaDoi, TenDoi

-- Câu 5: sắp xếp theo điểm và hiệu số bàn thắng
select top 3 with ties t1.MaDoi, TenDoi, Sum(t1.Diem) "Điểm", (Sum(BanThang)-Sum(BanThua)) "Hiệu số"
from	(
		select a.MaTran, a.MaDoi, (case when a.BanThang > b.BanTHang then 3 else (case when a.BanThang < b.BanTHang then 0 else 1 end) end) as Diem, a.BanThang as BanThang, b.BanThang as BanThua
		from TRANDAN a, TRANDAN b
		where	a.MaTran = b.MaTran and a.MaDoi != b.MaDoi
		) as t1, DOI t2
where t1.MaDoi = t2.MaDoi
group by t1.MaDoi, TenDoi
order by Điểm DESC, [Hiệu số] DESC

-- Câu 6: in ra các trận chưa diễn ra
select	a.TenDoi + ' - ' + b.TenDoi "Tên đội chưa đá"
from DOI a, DOI b
where a.MaDoi > b.MaDoi and b.MaDoi not in (select distinct (case when c.MaDoi = a.MaDoi then d.MaDoi else c.MaDoi end) from TRANDAN c, TRANDAN d where c.MaTran = d.MaTran and (c.MaDoi = a.MaDoi or d.MaDoi = a.MaDoi))
