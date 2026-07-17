CREATE DATABASE IF NOT EXISTS Healthcare_DB;
USE Healthcare_DB;


CREATE TABLE IF NOT EXISTS `Patient_Profile` (
    `Patient_ID` INT PRIMARY KEY,
    `Online_Follower` INT,
    `LinkedIn_Shared` INT,
    `Twitter_Shared` INT,
    `Facebook_Shared` INT,
    `Income` VARCHAR(50),
    `Education_Score` VARCHAR(50),
    `Age` VARCHAR(50),
    `First_Interaction` VARCHAR(50),
    `City_Type` VARCHAR(10),
    `Employer_Category` VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS `Health_Camp_Detail` (
    `Health_Camp_ID` INT PRIMARY KEY,
    `Camp_Start_Date` VARCHAR(50),
    `Camp_End_Date` VARCHAR(50),
    `Category1` VARCHAR(50),
    `Category2` VARCHAR(50),
    `Category3` INT
);

CREATE TABLE IF NOT EXISTS `Train` (
    `Patient_ID` INT,
    `Health_Camp_ID` INT,
    `Registration_Date` VARCHAR(50),
    `Var1` INT,
    `Var2` INT,
    `Var3` INT,
    `Var4` INT,
    `Var5` INT
);

CREATE TABLE IF NOT EXISTS `test` (
    `Patient_ID` INT,
    `Health_Camp_ID` INT,
    `Registration_Date` VARCHAR(50),
    `Var1` INT,
    `Var2` INT,
    `Var3` INT,
    `Var4` INT,
    `Var5` INT
);

CREATE TABLE IF NOT EXISTS `First_Health_Camp_Attended` (
    `Patient_ID` INT,
    `Health_Camp_ID` INT,
    `Donation` INT,
    `Health_Score` FLOAT,
    `Unnamed_4` VARCHAR(10) -- عمود إضافي ظهر في الملف
);


CREATE TABLE IF NOT EXISTS `Second_Health_Camp_Attended` (
    `Patient_ID` INT,
    `Health_Camp_ID` INT,
    `Health_Score` FLOAT
);


CREATE TABLE IF NOT EXISTS `Third_Health_Camp_Attended` (
    `Patient_ID` INT,
    `Health_Camp_ID` INT,
    `Number_of_stall_visited` INT,
    `Last_Stall_Visited_Number` INT
);