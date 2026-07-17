-- connection between train and health_camp_details 
alter table `train`
add constraint fk_patient_train foreign key (`patient_id`) references `Patient_Profile`(`Patient_ID`),
add constraint fk_camp_train foreign key (`Health_Camp_ID`) references `Health_Camp_Detail`(`Health_Camp_ID`);

-- conect the first results of first camp 
alter table `first_health_camp_attended`
add constraint fk_patient_first foreign key (`patient_id`) references `Patient_Profile`(`Patient_ID`),
add constraint fk_camp_first foreign key (`Health_Camp_ID`) references `Health_Camp_Detail`(`Health_Camp_ID`);

-- connection of the sec_camp
alter table `second_health_camp_attended`
add constraint fk_patient_second foreign key (`patient_id`) references `Patient_Profile`(`Patient_ID`),
add constraint fk_camp_second foreign key (`Health_Camp_ID`) references `Health_Camp_Detail`(`Health_Camp_ID`);

-- connection of the third camp 
alter table `third_health_camp_attended`
add constraint fk_patient_third foreign key (`patient_id`) references `Patient_Profile`(`Patient_ID`),
add constraint fk_camp_third foreign key (`Health_Camp_ID`) references `Health_Camp_Detail`(`Health_Camp_ID`);

-- testing connections 
select 
p.city_type,
f.health_score,
c.category1
from patient_profile p 
join first_health_camp_attended f on p.Patient_ID = f.Patient_ID
join health_camp_detail c  on f.Health_Camp_ID =c.Health_Camp_ID
where f.Health_Score >0.8;








