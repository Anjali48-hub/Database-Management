Use Spring_2018_Baseball
go

IF OBJECT_ID (N'dbo.[prereq]', N'U') IS NOT NULL
DROP TABLE dbo.[prereq];
GO

create table prereq
	(course_id		varchar(8), 
	 prereq_id		varchar(8),
	 primary key (course_id, prereq_id)
	);

insert into prereq values('376', '130');
insert into prereq values('760', '169');
insert into prereq values('403', '345');
insert into prereq values('353', '647');
insert into prereq values('629', '139');
insert into prereq values('608', '864');
insert into prereq values('158', '408');
insert into prereq values('496', '489');
insert into prereq values('241', '486');
insert into prereq values('958', '969');
insert into prereq values('591', '403');
insert into prereq values('656', '659');
insert into prereq values('864', '634');
insert into prereq values('559', '500');
insert into prereq values('209', '780');
insert into prereq values('603', '735');
insert into prereq values('804', '947');
insert into prereq values('545', '947');
insert into prereq values('353', '694');
insert into prereq values('692', '761');
insert into prereq values('774', '258');
insert into prereq values('747', '927');
insert into prereq values('496', '416');
insert into prereq values('544', '702');
insert into prereq values('608', '421');
insert into prereq values('313', '731');
insert into prereq values('258', '137');
insert into prereq values('486', '371');
insert into prereq values('224', '227');
insert into prereq values('972', '958');
insert into prereq values('359', '694');
insert into prereq values('998', '319');
insert into prereq values('392', '875');
insert into prereq values('443', '852');
insert into prereq values('324', '408');
insert into prereq values('805', '774');
insert into prereq values('242', '304');
insert into prereq values('795', '123');
insert into prereq values('169', '603');
insert into prereq values('774', '769');
insert into prereq values('958', '735');
insert into prereq values('692', '426');
insert into prereq values('958', '139');
insert into prereq values('663', '998');
insert into prereq values('586', '468');
insert into prereq values('254', '877');
insert into prereq values('802', '666');
insert into prereq values('820', '371');
insert into prereq values('902', '130');
insert into prereq values('362', '242');
insert into prereq values('359', '818');
insert into prereq values('664', '489');
insert into prereq values('276', '403');
insert into prereq values('582', '487');
insert into prereq values('694', '254');
insert into prereq values('841', '818');
insert into prereq values('852', '133');
insert into prereq values('843', '324');
insert into prereq values('810', '966');
insert into prereq values('628', '340');
insert into prereq values('242', '594');
insert into prereq values('292', '399');
insert into prereq values('618', '352');
insert into prereq values('664', '704');
insert into prereq values('793', '791');
insert into prereq values('692', '774');
insert into prereq values('324', '857');
insert into prereq values('612', '123');
insert into prereq values('991', '598');
insert into prereq values('544', '254');
insert into prereq values('852', '267');
insert into prereq values('792', '814');
insert into prereq values('133', '852');
insert into prereq values('496', '443');
insert into prereq values('338', '133');
insert into prereq values('399', '664');
insert into prereq values('747', '272');
insert into prereq values('696', '101');
insert into prereq values('403', '352');
insert into prereq values('545', '318');
insert into prereq values('634', '864');
insert into prereq values('947', '494');
insert into prereq values('647', '792');
insert into prereq values('631', '681');
insert into prereq values('236', '984');
insert into prereq values('362', '696');
insert into prereq values('875', '458');
insert into prereq values('457', '544');
insert into prereq values('704', '416');
insert into prereq values('656', '559');
insert into prereq values('272', '275');
insert into prereq values('338', '852');
insert into prereq values('780', '345');
insert into prereq values('458', '696');
insert into prereq values('239', '628');
insert into prereq values('411', '401');
insert into prereq values('830', '748');
insert into prereq values('558', '130');
insert into prereq values('877', '599');
insert into prereq values('349', '612');
