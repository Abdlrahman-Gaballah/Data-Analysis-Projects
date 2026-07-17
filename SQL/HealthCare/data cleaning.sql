-- cleaning by changing the date type
set sql_safe_updates =0;
-- cleaning  patient_profile
update `patient_profile`
set `First_Interaction` = str_to_date(nullif(`First_Interaction`,''), '%d-%b-%y')
where `First_Interaction` is not null
 and `First_Interaction` !='';
 
alter table `patient_profile`
modify column  `First_Interaction` date ;
select First_Interaction
from patient_profile
limit 10;
-------------------------------------------------------------------------------------------------------
-- cleaning  health_camp_details 
update `health_camp_detail`
set `Camp_Start_Date` = str_to_date(nullif(`Camp_Start_Date`,''), '%d-%b-%y'),
	`Camp_End_Date` = str_to_date(nullif(`Camp_End_Date`,''), '%d-%b-%y');
alter table `health_camp_detail`
modify column  `Camp_Start_Date` date ,
modify column  `Camp_End_Date` date ;
select Camp_Start_Date , Camp_End_Date
from health_camp_detail
limit 10;
-----------------------------------------------------------------------------------------------------------

-- cleaning  train date (regestration date 
set sql_safe_updates =0;
-- dealing with blanks and nulls in column
UPDATE `train` 
set `Registration_Date` = null 
where `Registration_Date` = '' 
or `Registration_Date` = ' ' 
or `Registration_Date` = 'null';
-- change type to date 
update train 
set Registration_Date = STR_TO_DATE(Registration_Date, '%d-%b-%y')
where Registration_Date regexp '^[0-9]{1,2}-[A-Za-z]{3}-[0-9]{2}$';
update train 
set Registration_Date = null
where Registration_Date is not null 
  and Registration_Date not like  '20%'; 
  alter table train 
modify column Registration_Date date;
-- make sure every thing is done 
select  Registration_Date 
from  train
 where Registration_Date is not null
 limit 10;
set sql_safe_updates =1;
----------------------------------------------------------------------------------------------------------------------
-- cleaning nones and nulls in patient profile 
select * 
from patient_profile;
set sql_safe_updates =0;
update patient_profile
set Income = nullif(Income,'None'),
    Education_Score = nullif(Education_Score,'None'),
    Age = nullif(Age,'None'),
    City_Type = trim(nullif(City_Type, '')),
    Employer_Category = trim(nullif(Employer_Category, '' ));
    set sql_safe_updates =1; 
    -- make sure every thing is okay
select * 
from patient_profile;
-- update data types 
alter table patient_profile
modify column Age int;
alter table patient_profile
modify column Patient_ID int;
alter table patient_profile
modify column Education_Score float;
-- cleaning out comes tables 
delete from  first_health_camp_attended 
where Health_Score is not null
or Health_Score =0 ;
-- CHEKING DUPLICATES 
select patient_ID , health_camp_ID , count(*)
from train
group by patient_ID , health_camp_ID
having count(*) >1;


-- cleaning check 
select t.patient_ID , t.Registration_Date, c.Camp_End_Date
from train t 
join health_camp_detail c  on t.Health_Camp_ID = c.Health_Camp_ID
where t.Registration_Date > c.Camp_End_Date ;

-- ةmore check
select t.patient_ID , t.Registration_Date, c.Camp_End_Date
from train t 
join health_camp_detail c  on t.Health_Camp_ID = c.Health_Camp_ID
where t.Registration_Date <=  c.Camp_End_Date 
limit 10 ;

-- final quality check
select 
    (select Health_Camp_ID from train limit 1) as sample_train_id,
    (select Health_Camp_ID from health_camp_detail limit 1) as sample_camp_id,
    (select count(*) from train where Registration_Date is null) as null_date_count;

-- mae sure data types is okay 
desc train;
desc patient_profile;
desc health_camp_detail;

alter table train
modify column Registration_Date date;