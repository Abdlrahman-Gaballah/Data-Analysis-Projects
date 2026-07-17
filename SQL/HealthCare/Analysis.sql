-- calculate sucess rate (Attendance Rate)
select
c.Category1 as camp_category,
count(t.patient_ID) as total_regestration,
count(coalesce(f.patient_ID, s.patient_ID, th.patient_ID)) as total_actual_attended,
round((count(coalesce(f.patient_ID, s.patient_ID, th.patient_ID)) / count(t.patient_ID))*100,2) as attendance_rate_precentage
from train t 
join health_camp_detail c on t.Health_Camp_ID =c.Health_Camp_ID
left join first_health_camp_attended f on t.Patient_ID = f.Patient_ID and t.Health_Camp_ID = f.Health_Camp_ID
left join second_health_camp_attended s on t.Patient_ID = s.Patient_ID and t.Health_Camp_ID = s.Health_Camp_ID
left join third_health_camp_attended th on t.Patient_ID = th.Patient_ID and t.Health_Camp_ID = th.Health_Camp_ID
group by c.Category1
order by attendance_rate_precentage desc;

-- Top 10 Loyal Patients
select	
        patient_ID,
        count(*) as camps_attended
from (
select patient_ID from first_health_camp_attended 
union all
select patient_ID from second_health_camp_attended 
union all
select patient_ID from third_health_camp_attended 
) as total_attendance
group by patient_ID
order by camps_attended desc
limit 10;
-- connecting loyal patients with thir info
select
p.City_type,
avg(p.Age) as avarge_age,
count(t.patient_ID) as  total_attendance_recordes
from (
select patient_ID from first_health_camp_attended 
union all
select patient_ID from second_health_camp_attended 
union all
select patient_ID from third_health_camp_attended 
) as t
join patient_profile p on t.Patient_ID = p.patient_ID
group by City_type
order by total_attendance_recordes desc;

-- patient loalty 
select 
patient_ID,
count(distinct Camp_Type) as uniqe_camp_category_visit
from (
select patient_ID , 'First' as Camp_Type from first_health_camp_attended 
union all
select patient_ID , 'Second' as Camp_Type from second_health_camp_attended 
union all
select patient_ID , 'Third' as Camp_Type from third_health_camp_attended 
) as compined 
group by patient_ID
having uniqe_camp_category_visit >1 
order by uniqe_camp_category_visit desc ;

-- لgeographic analysis
select
p.City_Type,
count( distinct loyal_ids.patient_ID ) as  loyal_patients_recordes
from (
select patient_ID  from first_health_camp_attended 
union all
select patient_ID  from second_health_camp_attended 
union all
select patient_ID  from third_health_camp_attended 
) as Loyal_ids
join patient_profile p on loyal_ids.patient_ID = p.patient_ID 
group by p.City_Type
order by loyal_patients_recordes desc;

-- analysis socio economic actor 

select 
Income,
avg(Education_Score)as avg_education,
count(*) as total_pationts 
from patient_profile 
where 	Income != 'None'
group by Income
order by total_pationts desc;
	
-- booking window 
select 
case 
when datediff(c.Camp_Start_Date ,t.Registration_Date) <= 7 then 'within 1 week'
when datediff(c.Camp_Start_Date ,t.Registration_Date) <= 30 then 'within 1 week'
else 'more than 1 month '
end  as Regestration_window,
count(*) as attendance_count
from train t

