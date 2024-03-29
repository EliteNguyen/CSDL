create database DIALYVN
go
use DIALYVN
go
create table TINH_TP 
(
	MA_T_TP varchar(3) primary key, 
	TEN_T_TP nVarchar(20), 
	DT float, 
	DS bigint, 
	MIEN NVarchar(10)
)

create table BIENGIOI 
(
	NUOC NVarchar(15) not null, 
	MA_T_TP varchar(3) not null,
	primary key (NUOC, MA_T_TP),
	constraint rb2 foreign key (MA_T_TP) references TINH_TP(MA_T_TP)
)

create table LANGGIENG 
(
	MA_T_TP varchar(3) not null, 
	LG varchar(3) not null,
	primary key (LG, MA_T_TP),
	constraint rb3 foreign key (MA_T_TP) references TINH_TP(MA_T_TP),
	constraint rb4 foreign key (LG) references TINH_TP(MA_T_TP)
)
go

-- CAU HOI

--1.	Xuất ra tên tỉnh, TP cùng với dân số của tỉnh,TP:
--a) Có diện tích >= 5000 Km2
select TEN_T_TP "Tên Tỉnh / TP", DS "Dân Số" 
from TINH_TP
where DT >= 5000

--b) Có diện tích >= [input] (SV nhập một số bất kỳ)

--2.	Xuất ra tên tỉnh, TP cùng với diện tích của tỉnh,TP:
--a) Thuộc miền Bắc
select TEN_T_TP "Tên Tỉnh / TP", DT "Diện tích" 
from TINH_TP
where MIEN = N'Bắc'

--b) Thuộc miền [input] (SV nhập một miền bất kỳ)
--3.	Xuất ra các Tên tỉnh, TP biên giới thuộc miền [input] (SV cho một miền bất kỳ)
select distinct TEN_T_TP
from BIENGIOI a, TINH_TP b
where	b.MIEN = N'Nam' and
		a.MA_T_TP = b.MA_T_TP

--4.	Cho biết diện tích trung bình của các tỉnh, TP (Tổng DT/Tổng số tỉnh_TP).
select TEN_T_TP "Tên TP", DT/(select COUNT(*) from TINH_TP) "Diện tích TB"
from TINH_TP

--5.	Cho biết dân số cùng với tên tỉnh của các tỉnh, TP có diện tích > 7000 Km2.
select TEN_T_TP "Tên Tỉnh / TP", DS "Dân Số" 
from TINH_TP
where DT >= 7000

--6.	Cho biết dân số cùng với tên tỉnh của các tỉnh miền ‘Bắc’.
select TEN_T_TP "Tên Tỉnh / TP", DT "Diện tích" 
from TINH_TP
where MIEN = N'Bắc'

--7.	Cho biết mã các nước biên giới của các tỉnh miền ‘Nam’.
select distinct NUOC "Mã nước BG" 
from BIENGIOI a, TINH_TP b
where	MIEN = N'Nam' and
		a.MA_T_TP = b.MA_T_TP

--8.	Cho biết diện tích trung bình của các tỉnh, TP. (Sử dụng hàm)
select TEN_T_TP "Tên TP", DT/(select COUNT(*) from TINH_TP) "Diện tích TB"
from TINH_TP
		
--9.	Cho biết mật độ dân số (DS/DT) cùng với tên tỉnh, TP của tất cả các tỉnh, TP.
select TEN_T_TP "Tên TP", DS/DT "Mật độ DS"
from TINH_TP

--10.	Cho biết tên các tỉnh,TP láng giềng của tỉnh ‘Long An’.
select a.TEN_T_TP "Tên TP"
from TINH_TP a, LANGGIENG b, TINH_TP c
where	a.MA_T_TP = b.MA_T_TP and
		b.LG = c.MA_T_TP and
		c.TEN_T_TP = N'Long An'
		

--11.	Cho biết số lượng các tỉnh, TP giáp với ‘CPC’.
select COUNT(*) "Số lượng tỉnh / TP giáp CPC"
from BIENGIOI
where NUOC='CPC'

--12.	Cho biết tên những tỉnh, TP có diện tích lớn nhất.
select TEN_T_TP "Tên tỉnh / TP có DT lớn nhất" 
from TINH_TP
where DT >= (select MAX(DT) from TINH_TP)

--13.	Cho biết tỉnh, TP có mật độ DS đông nhất.
select TEN_T_TP "Tên tỉnh / TP có mật độ DS lớn nhất" 
from TINH_TP
where DT/(select COUNT(*) from TINH_TP) >= ALL(select DT/(select COUNT(*) from TINH_TP) from TINH_TP)



--14.	Cho biết tên những tỉnh, TP giáp với hai nước biên giới khác nhau.
select distinct TEN_T_TP "Tên tỉnh / TP giáp với 2 nước biên giới khác nhau" 
from TINH_TP a, BIENGIOI b
where	a.MA_T_TP = b.MA_T_TP and
		(select COUNT(*) from BIENGIOI where MA_T_TP = a.MA_T_TP) = 2

--15.	Cho biết danh sách các miền cùng với các tỉnh, TP trong các miền đó.
select MIEN "Miền", COUNT(TEN_T_TP) "Số lượng tỉnh TP"
from TINH_TP
group by MIEN

--16.	Cho biết tên những tỉnh, TP có nhiều láng giềng nhất.
select top 1 with ties TEN_T_TP "Tên tỉnh TP có nhiều láng giềng nhất", COUNT(*)
from TINH_TP a, LANGGIENG b
where	a.MA_T_TP = b.MA_T_TP
group by TEN_T_TP
order by COUNT(*) DESC

--17.	Cho biết những tỉnh, TP có diện tích nhỏ hơn diện tích trung bình của tất cả tỉnh, TP.
select TEN_T_TP "Tên TP / Tỉnh có DT nhỏ hơn DT TB"
from TINH_TP
where DT < (select AVG(DT) from TINH_TP)

--18.	Cho biết tên những tỉnh, TP giáp với các tỉnh, TP ở miền ‘Nam’ và không phải là miền ‘Nam’.
select a.TEN_T_TP "Tên TP / Tỉnh giáp Các tỉnh TP miền Nam"
from TINH_TP a, LANGGIENG b, TINH_TP c
where	a.MA_T_TP = b.MA_T_TP and
		a.MIEN != N'Nam' and
		b.LG = c.MA_T_TP and
		c.MIEN = N'Nam';
		

--19.	Cho biết tên những tỉnh, TP có diện tích lớn hơn tất cả các tỉnh, TP láng giềng của nó.
select TEN_T_TP
from TINH_TP a
where a.DT > (select MAX(DT) from TINH_TP b, LANGGIENG c where b.MA_T_TP = c.MA_T_TP and c.LG = a.MA_T_TP)


--20.	Cho biết tên những tỉnh, TP mà ta có thể đến bằng cách đi từ ‘TP.HCM’ xuyên qua ba tỉnh khác nhau và cũng khác với điểm xuất phát, nhưng láng giềng với nhau.
select distinct a.TEN_T_TP
from TINH_TP a, LANGGIENG b, LANGGIENG c, LANGGIENG d
where	a.MA_T_TP = b.LG and b.MA_T_TP = c.LG and c.MA_T_TP = d.LG and
		a.MA_T_TP != b.MA_T_TP and a.MA_T_TP != c.MA_T_TP and d.MA_T_TP != b.MA_T_TP and a.MA_T_TP != 'HCM' and
		d.MA_T_TP = 'HCM'
