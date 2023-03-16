-- create and use database
DROP DATABASE IF EXISTS Group_12;
CREATE DATABASE Group_12;

USE Group_12;

-- create tables
    DROP TABLE IF EXISTS tblDIAG_TREAT, tblTREATMENT, tblDIAGNOSE,
    tblILLNESS, tblVISIT_DOC, tblVISIT, tblPLAN, tblDOC_DEPT, tblDOCTOR, tblPATIENT,
    tblINS_PROVIDER, tblVISIT_TYPE, tblTREATMENT_TYPE, tblILLNESS_TYPE, tblDEPARTMENT,
    tblLOCATION, tblSEVERITY, tblRACE, tblGENDER;

    CREATE TABLE tblGENDER (
        GenderID INT NOT NULL IDENTITY(1, 1),
        Gender VARCHAR(50),
        PRIMARY KEY (GenderID)
    );

    CREATE TABLE tblRACE (
        RaceID INT NOT NULL IDENTITY(1, 1),
        Race VARCHAR(50),
        PRIMARY KEY (RaceID)
    );

    CREATE TABLE tblSEVERITY (
        SeverityID INT NOT NULL IDENTITY(1, 1),
        SeverityName VARCHAR(50),
        SeverityDescr VARCHAR(500),
        PRIMARY KEY (SeverityID)
    );

    CREATE TABLE tblLOCATION (
        LocationID INT NOT NULL IDENTITY(1, 1),
        LocationName VARCHAR(50),
        PRIMARY KEY (LocationID)
    );

    CREATE TABLE tblDEPARTMENT (
        DeptID INT NOT NULL IDENTITY(1, 1),
        DeptName VARCHAR(50),
        PRIMARY KEY (DeptID)
    );

    CREATE TABLE tblILLNESS_TYPE (
        IllnessTypeID INT NOT NULL IDENTITY(1, 1),
        IllnessTypeName VARCHAR(50),
        PRIMARY KEY (IllnessTypeID)
    );

    CREATE TABLE tblTREATMENT_TYPE (
        TreatmentTypeID INT NOT NULL IDENTITY(1, 1),
        TreatmentTypeName VARCHAR(50),
        TreatmentTypeDescr VARCHAR(500),
        PRIMARY KEY (TreatmentTypeID)
    );

    CREATE TABLE tblVISIT_TYPE (
        VisitTypeID INT NOT NULL IDENTITY(1, 1),
        VisitTypeName VARCHAR(50),
        PRIMARY KEY (VisitTypeID)
    );

    CREATE TABLE tblINS_PROVIDER (
        InsProviderID INT NOT NULL IDENTITY(1, 1),
        InsProviderName VARCHAR(50),
        PRIMARY KEY (InsProviderID)
    );

    CREATE TABLE tblPATIENT (
        PatientID INT NOT NULL IDENTITY(1, 1),
        PatientFname VARCHAR(50),
        PatientLname VARCHAR(50),
        PatientDOB DATE,
        [Weight] NUMERIC(5, 2),
        Height NUMERIC(5, 2),
        GenderID INT,
        RaceID INT,
        PRIMARY KEY (PatientID),
        FOREIGN KEY (GenderID) REFERENCES tblGENDER (GenderID),
        FOREIGN KEY (RaceID) REFERENCES tblRACE (RaceID)
    );

    CREATE TABLE tblDOCTOR (
        DoctorID INT NOT NULL IDENTITY(1, 1),
        DocFname VARCHAR(50),
        DocLname VARCHAR(50),
        DocDOB DATE,
        GenderID INT,
        RaceID INT,
        PRIMARY KEY (DoctorID),
        FOREIGN KEY (GenderID) REFERENCES tblGENDER (GenderID),
        FOREIGN KEY (RaceID) REFERENCES tblRACE (RaceID)
    );

    CREATE TABLE tblDOC_DEPT (
        DoctorID INT NOT NULL,
        DeptID INT NOT NULL,
        PRIMARY KEY (DoctorID, DeptID),
        FOREIGN KEY (DoctorID) REFERENCES tblDOCTOR (DoctorID),
        FOREIGN KEY (DeptID) REFERENCES tblDEPARTMENT (DeptID)
    );

    CREATE TABLE tblPLAN (
        PlanID INT NOT NULL IDENTITY(1, 1),
        PlanName VARCHAR(50),
        PlanDescr VARCHAR(500),
        InsProviderID INT, 
        PRIMARY KEY (PlanID),
        FOREIGN KEY (InsProviderID) REFERENCES tblINS_PROVIDER (InsProviderID)
    );

    CREATE TABLE tblVISIT (
        VisitID INT NOT NULL IDENTITY(1, 1),
        VisitDate DATE,
        Expenses NUMERIC(6, 2),
        PatientID INT FOREIGN KEY REFERENCES tblPATIENT (PatientID),
        VisitTypeID INT FOREIGN KEY REFERENCES tblVISIT_TYPE (VisitTypeID),
        LocationID INT FOREIGN KEY REFERENCES tblLOCATION (LocationID),
        PlanID INT REFERENCES tblPLAN (PlanID)
        PRIMARY KEY (VisitID),
    );

    CREATE TABLE tblVISIT_DOC (
        VisitID INT,
        DoctorID INT,
        PRIMARY KEY (VisitID, DoctorID),
        FOREIGN KEY (VisitID) REFERENCES tblVISIT (VisitID),
        FOREIGN KEY (DoctorID) REFERENCES tblDOCTOR (DoctorID)
    );

    CREATE TABLE tblILLNESS (
        IllnessID INT NOT NULL IDENTITY(1, 1),
        IllnessName VARCHAR(50),
        IllnessDescr VARCHAR(500),
        IllnessTypeID INT,
        PRIMARY KEY (IllnessID),
        FOREIGN KEY (IllnessTypeID) REFERENCES tblILLNESS_TYPE (IllnessTypeID)
    );

    CREATE TABLE tblDIAGNOSE (
        DiagnoseID INT NOT NULL IDENTITY(1, 1),
        VisitID INT REFERENCES tblVISIT (VisitID),
        IllnessID INT REFERENCES tblILLNESS (IllnessID),
        SeverityID INT REFERENCES tblSEVERITY (SeverityID),
        PRIMARY KEY (DiagnoseID)
    );

    CREATE TABLE tblTREATMENT (
        TreatmentID INT NOT NULL IDENTITY(1, 1),
        TreatmentName VARCHAR(50),
        TreatmentTypeID INT,
        PRIMARY KEY (TreatmentID),
        FOREIGN KEY (TreatmentTypeID) REFERENCES tblTREATMENT_TYPE (TreatmentTypeID)
    );

    CREATE TABLE tblDIAG_TREAT (
        DiagnoseID INT,
        TreatmentID INT,
        BeginDate DATE,
        EndDate DATE,
        PRIMARY KEY (DiagnoseID, TreatmentID),
        FOREIGN KEY (DiagnoseID) REFERENCES tblDIAGNOSE (DiagnoseID),
        FOREIGN KEY (TreatmentID) REFERENCES tblTREATMENT (TreatmentID)
    );

-- populate look-up tables
    -- insert into gender
        INSERT INTO tblGENDER
        VALUES ('Male'), ('Female'), ('Other');

    -- insert into race
        INSERT INTO tblRACE
        VALUES 
            ('White'), ('Hispanic'), ('Black'), ('Asian'), ('Multiple Races'), 
            ('American Indian/Alaska Native'), ('Native Hawaiian/Other Pacific Islander');

    -- insert into severity
        INSERT INTO tblSEVERITY
        VALUES
            ('Mild', 'Constitutional symptoms, no need for hospitalization'),
            ('Moderate', 'Requires medical care or hospitalization'),
            ('Severe', 'Requires hopitalization'),
            ('Critical', 'Requires intensive care'),
            ('Fatel', 'Unable to support through illness, irreversable damage');

    -- insert into location
        INSERT INTO tblLOCATION
        VALUES 
            ('Clinic/Doctor Office'), 
            ('Hospital'),
            ('Urgent Care Center'),
            ('Emergency Room');

    -- insert into treatment type
        INSERT INTO tblTREATMENT_TYPE
        VALUES ('Medication', NULL), ('Therapy', NULL), ('Operation', NULL);

    -- insert into illness type
        INSERT INTO tblILLNESS_TYPE
        VALUES 
            ('Heart Disease'), ('Cancer'), ('Chronic Lower Respiratory Diseases'),
            ('Obesity'), ('Diabetes'), ('Influenza and Pneumonia'),
            ('Kidney Disease'), ('Mental Health Conditions')

    -- insert into visit type
        INSERT INTO tblVISIT_TYPE
        VALUES ('Telemedicine'), ('On Site')
    
    -- insert into department
        INSERT INTO tblDEPARTMENT
        VALUES 
            ('Accident and Emergency'), ('Anesthetics'), ('Cardiology'), ('Critical Care'),
            ('Infection Control'), ('Neurology'), ('Occupational Therapy'), ('Pharmacy'),
            ('Radiotherapy'), ('Otolaryngology'), ('General Services'), ('Maternity')

    -- insert into insurance provider
        INSERT INTO tblINS_PROVIDER
        VALUES
            ('United Health'), ('Kaiser Foundation'), ('Centene Corporation'),
            ('Humana'), ('CVS'), ('Health Care Service Corporation'), ('CIGNA'),
            ('Metropolitan'), ('Highmark Group')

    -- insert into plan
        INSERT INTO tblPLAN
        VALUES
        --('Exclusive Provider Organization', 'A managed care plan where services are covered only if you use doctors, specialists, or hospitals in the plan’s network (except in an emergency).'),
        --('Health Maintenance Organization', 'A type of health insurance plan that usually limits coverage to care from doctors who work for or contract with the HMO. It generally will not cover out-of-network care except in an emergency. An HMO may require you to live or work in its service area to be eligible for coverage. HMOs often provide integrated care and focus on prevention and wellness.'),
        --('Point of Service', 'A type of plan where you pay less if you use doctors, hospitals, and other health care providers that belong to the plan’s network. POS plans require you to get a referral from your primary care doctor in order to see a specialist.'),
        --('Preferred Provider Organization', 'A type of health plan where you pay less if you use providers in the plan’s network. You can use doctors, hospitals, and providers outside of the network without a referral for an additional cost.'),
        --('Uninsured', 'The patient does not have health care coverage.')
            ('United Health Gold Coverage', 'The premium coverage package (80%) for United Health.', 1),
            ('United Health Silver Coverage', 'The standard coverage package (70%) for United Health.', 1),
            ('United Health Bronze Coverage', 'The economy coverage package (60%) for United Health.', 1),
            ('Kaiser Gold Coverage', 'The premium coverage package (80%) for the Kaiser Foundation.', 2),
            ('Kaiser Silver Coverage', 'The standard coverage package (70%) for the Kaiser Foundation.', 2),
            ('Kaiser Bronze Coverage', 'The economy coverage package (60%) for the Kaiser Foundation.', 2),
            ('Centene Gold Coverage', 'The premium coverage package (80%) for the Centene Corporation.', 3),
            ('Centene Silver Coverage', 'The standard coverage package (70%) for the Centene Corporation.', 3),
            ('Centene Bronze Coverage', 'The economy coverage package (60%) for the Centene Corporation.', 3),
            ('Humana Gold Coverage', 'The premium coverage package (80%) for Humana.', 4),
            ('Humana Silver Coverage', 'The standard coverage package (70%) for Humana.', 4),
            ('Humana Bronze Coverage', 'The economy coverage package (60%) for the Humana.', 4),
            ('CVS Coverage', 'The premium coverage package (80%) for CVS.', 5),
            ('CVS Silver Coverage', 'The standard coverage package (70%) for CVS.', 5),
            ('CVS Bronze Coverage', 'The economy coverage package (60%) for CVS.', 5),
            ('HCSC Gold Coverage', 'The premium coverage package (80%) for the Health Care Service Corporation.', 6),
            ('HCSC Silver Coverage', 'The standard coverage package (70%) for the Health Care Service Corporation.', 6),
            ('HCSC Bronze Coverage', 'The economy coverage package (60%) for the Health Care Service Corporation.', 6),
            ('CIGNA Gold Coverage', 'The premium coverage package (80%) for CIGNA.', 7),
            ('CIGNA Silver Coverage', 'The standard coverage package (70%) for CIGNA.', 7),
            ('CIGNA Bronze Coverage', 'The economy coverage package (60%) for CIGNA.', 7),
            ('Metropolitan Gold Coverage', 'The premium coverage package (80%) for Metropolitan.', 8),
            ('Metropolitan Silver Coverage', 'The standard coverage package (70%) for Metropolitan.', 8),
            ('Metropolitan Bronze Coverage', 'The economy coverage package (60%) for Metropolitan.', 8),
            ('Highmark Gold Coverage', 'The premium coverage package (80%) for Highmark Group.', 9),
            ('Highmark Silver Coverage', 'The standard coverage package (70%) for Highmark Group.', 9),
            ('Highmark Bronze Coverage', 'The economy coverage package (60%) for Highmark Group.', 9)

    -- insert into illness
        INSERT INTO tblILLNESS
        VALUES
            ('Coronary Artery Disease', 'A condition where the coronary arteries struggle to supply the heart with enough blood, oxygen, and nutrients.', 1),
            ('Heart Failure', 'A condition which occurs when the heart is unable to pump blood effectively, causing backups and fluid buildup in the lungs.', 1),
            ('Kidney Cancer', 'A disease in which the cells of the kidneys replicate without growth-blocking agents.', 2),
            ('Leukemia', 'A malignant progressive disease in which the bone marrow and othr blood-producing organs produce increased numbers of immature or abnormal leukocytes.', 2),
            ('Chronic Bronchitis', 'A lung condition in which he bronchi become inflamed and scarred leading to difficulty breathing and a persistent, phhlegmmy cough.', 3),
            ('Asthma', 'A chronic condition that affects the airways of the lungs, which become inflamedand make it harder to breathe.', 3),
            ('Type 2 Diabetes', 'A disease that results from the body ineffective use of insulin, resulting in high blood sugar and eventually blind', 4),
            ('High Blood Pressure', 'A disease where the hydrostatic pressure of blood in the blood vessels places excessive strain on a person cardiovascular health and heart.', 4),
            ('Nerve Damage', 'Impaired bloodflow to the extremities resulting in a loss of sensation or pain pangs.', 5),
            ('Retinopathy', 'Poor oxygenation due to decrerased bloodflow circulation in the retina leading to partial or full blindness.', 5),
            ('Flu', 'Also known as common influenza, a viral infectionthat causes high fevers, chills, and can be potentially fatal to those with comorbidities.', 6),
            ('Bacterial Pneumonia', 'An infection most commonly caused by streptococcus pneumoniae that results in labored breathing due to excessive fluid in the lungs.', 6),
            ('Kidney Stones', 'The buildup minerals and other substances in the blood which crystallize in the kidneys, forming solid masses that are often very painful.', 7),
            ('Chronic Kidney Disease', 'Commonly caused by high blood pressure, this disease increases pressure on the filtrative blood vessels of the kidneys, damaging vessels and impairing kidney function.', 7),
            ('Major Depressive Disorder', 'A condition that negatively affects how a person feels, they way they think, and how they act, causing feelings of sadness, letthargy, and disinterest.', 8),
            ('Generalized Anxiety Disorder', 'A condition that involves a persistent feeling of anxiety or dread, which can interfere with daily life, and causes feelings of restlessness, fatigue, and emotional distress.', 8)

    -- insert into treatment
        INSERT INTO tblTREATMENT
        VALUES
            ('Andidepressants', 1),
            ('Anxiolytics', 1),
            ('Antihypertensives', 1),
            ('ACE Inhibitors', 1),
            ('Insulin', 1),
            ('Anti-Inflammatories', 1),
            ('Opioid Pain Relievers', 1),
            ('Steroids', 1),
            ('Chemotherapy', 2),
            ('Talk Therapy', 2),
            ('Cognitive Behavioral Therapy', 2),
            ('Physical Therapy', 2),
            ('Bedrest', 2),
            ('Joint Replalcement', 3),
            ('Broken Bone Repair', 3),
            ('Angioplasty', 3),
            ('Heart Surgery', 3),
            ('Vitrectomy', 3),
            ('C-Section', 3)

    -- insert into illness type
        INSERT INTO tblILLNESS_TYPE
        VALUES ('Bone Fracture'), ('Muscle Strain')
        GO
    
-- stored procedures
    -- get gender id
        CREATE OR ALTER PROCEDURE GetGenderID
        @Gender VARCHAR(50),
        @GenderID INT OUTPUT
        AS SET @GenderID = (
            SELECT Top 1GenderID 
            FROM tblGENDER
            WHERE Gender = @Gender
        )
        GO

    -- get race id
        CREATE OR ALTER PROCEDURE GetRaceID
        @Race VARCHAR(50),
        @RaceID INT OUTPUT
        AS SET @RaceID = (
            SELECT TOP 1 RaceID
            FROM tblRACE
            WHERE Race = @Race
        )
        GO

    -- get visit type id
        CREATE OR ALTER PROCEDURE GetVisitTypeID
        @VisitTypeName VARCHAR(50),
        @VisitTypeID INT OUTPUT
        AS SET @VisitTypeID = (
            SELECT TOP 1 VisitTypeID 
            FROM tblVISIT_TYPE
            WHERE VisitTypeName = @VisitTypeName
        )
        GO

    -- get location id
        CREATE OR ALTER PROCEDURE GetLocationID
        @LocationName VARCHAR(50),
        @LocationID INT OUTPUT
        AS SET @LocationID = (
            SELECT TOP 1 LocationID 
            FROM tblLOCATION
            WHERE LocationName = @LocationName
        )
        GO

    -- get department id
        CREATE OR ALTER PROCEDURE GetDepartmentID
        @DeptName VARCHAR(50),
        @DeptID INT OUTPUT
        AS SET @DeptID = (
            SELECT TOP 1 DeptID 
            from tblDEPARTMENT
            WHERE DeptName = @DeptName
        )
        GO

    -- get severty id
        CREATE OR ALTER PROCEDURE GetSeverityID 
        @SeverityName VARCHAR(50),
        @SeverityID INT OUTPUT
        AS SET @SeverityID = (
            SELECT TOP 1 SeverityID 
            from tblSEVERITY
            WHERE SeverityName = @SeverityName
        )
        GO

    -- get illness type id
        CREATE OR ALTER PROCEDURE GetIllnessTypeID 
        @IllnessTypeName VARCHAR(50),
        @IllnessTypeID INT OUTPUT
        AS SET @IllnessTypeID = (
            SELECT TOP 1 IllnessTypeID 
            from tblILLNESS_TYPE
            WHERE IllnessTypeName = @IllnessTypeName
        )
        GO

    -- get treatment type id
        CREATE OR ALTER PROCEDURE GetTreatmentTypeID 
        @TreatmentTypeName VARCHAR(50),
        @TreatmentTypeID INT OUTPUT
        AS SET @TreatmentTypeID = (
            SELECT TOP 1 TreatmentTypeID
            from tblTREATMENT_TYPE
            WHERE TreatmentTypeName = @TreatmentTypeName
        )
        GO

    -- get insurance provider id
        CREATE OR ALTER PROCEDURE GetInsProviderID  
        @InsProviderName VARCHAR(50),
        @InsProviderID INT OUTPUT
        AS SET @InsProviderID = (
            SELECT TOP 1 InsProviderID
            from tblINS_PROVIDER
            WHERE InsProviderName = @InsProviderName
        )
        GO

    -- insert into patient
        CREATE OR ALTER PROCEDURE InsertPatient
        @Fname VARCHAR(50),
        @Lname VARCHAR(50),
        @DOB DATE,
        @Weight NUMERIC(6, 2),
        @Height NUMERIC(6, 2),
        @Gender VARCHAR(50),
        @Race VARCHAR(50)
        AS
        DECLARE @GenderID INT, @RaceID INT

        EXEC GetGenderID
        @Gender = @Gender,
        @GenderID = @GenderID OUTPUT
        IF @GenderID IS NULL
            BEGIN
                PRINT '@GenderID is currently empty';
                THROW 54412, '@GenderID is NULL and is being terminated', 1;
            END

        EXEC GetRaceID
        @Race = @Race,
        @RaceID = @RaceID OUTPUT 
        IF @Race IS NULL
            BEGIN
                PRINT '@RaceID is currently empty';
                THROW 54412, '@RaceID is NULL and is being terminated', 1;
            END

        BEGIN TRAN T1
        INSERT INTO tblPATIENT (PatientFname, PatientLname, PatientDOB, [Weight], Height, GenderID, RaceID)
        VALUES (@Fname, @Lname, @DOB, @Weight, @Height, @GenderID, @RaceID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO

    -- insert into doctor
        CREATE OR ALTER PROCEDURE InsertDoctor
        @Fname VARCHAR(50),
        @Lname VARCHAR(50),
        @DOB DATE,
        @Gender VARCHAR(50),
        @Race VARCHAR(50)
        AS
        DECLARE @GenderID INT, @RaceID INT

        EXEC GetGenderID
        @Gender = @Gender,
        @GenderID = @GenderID OUTPUT
        IF @GenderID IS NULL
            BEGIN
                PRINT '@GenderID is currently empty';
                THROW 54412, '@GenderID is NULL and is being terminated', 1;
            END

        EXEC GetRaceID
        @Race = @Race,
        @RaceID = @RaceID OUTPUT 
        IF @RaceID IS NULL
            BEGIN
                PRINT '@RaceID is currently empty';
                THROW 54412, '@RaceID is NULL and is being terminated', 1;
            END

        BEGIN TRAN T1
        INSERT INTO tblDOCTOR (DocFname, DocLname, DocDOB, GenderID, RaceID)
        VALUES (@Fname, @Lname, @DOB, @GenderID, @RaceID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO

    -- insert into plan
        CREATE OR ALTER PROCEDURE InsertPlan
        @PlanName VARCHAR(50),
        @InsProviderName VARCHAR(50)
        AS
        DECLARE @InsProviderID INT

        EXEC GetInsProviderID
        @InsProviderName = @InsProviderName,
        @InsProviderID = @InsProviderName OUTPUT
        IF @InsProviderID IS NULL
            BEGIN
                PRINT '@InsProviderID is currently empty';
                THROW 54412, '@InsProviderID is NULL and is being terminated', 1;
            END

        BEGIN TRAN T1
        INSERT INTO tblPLAN (PlanName, InsProviderID)
        VALUES (@PlanName, @InsProviderID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO

    -- get plan id
        CREATE OR ALTER PROCEDURE GetPlanID
        @PlanName VARCHAR(50),
        @PlanID INT OUTPUT
        AS SET @PlanID = (
            SELECT TOP 1 PlanID 
            FROM tblPLAN
            WHERE PlanName = @PlanName
        )
        GO

    -- get patient id
        CREATE OR ALTER PROCEDURE GetPatientID
        @Fname VARCHAR(100),
        @Lname VARCHAR(100),
        @DOB DATE,
        @PatientID INT OUTPUT
        AS SET @PatientID = (
            SELECT TOP 1 PatientID 
            FROM tblPATIENT
            WHERE PatientFname = @Fname
            AND PatientLname = @Lname
            AND PatientDOB = @DOB
        )
        GO

    -- get doctor id
        CREATE OR ALTER PROCEDURE GetDoctorID
        @Fname VARCHAR(50),
        @Lname VARCHAR(50),
        @DOB DATE,
        @DoctorID INT OUTPUT 
        AS SET @DoctorID = (
            SELECT TOP 1 DoctorID 
            FROM tblDOCTOR
            WHERE DocFname = @Fname
            AND DocLname = @Lname
            AND DocDOB = @DOB
        )
        GO
 
    -- insert into visit
        CREATE OR ALTER PROCEDURE InsertVisit
        @VisitDate DATE,
        @Expenses NUMERIC(6, 2),
        @P_Fname VARCHAR(50),
        @P_Lname VARCHAR(50),
        @P_DOB DATE,
        @VisitTypeName VARCHAR(50),
        @LocationName VARCHAR(50),
        @PlanName VARCHAR(50)
        AS 
        DECLARE
            @PatientID INT,
            @VisitTypeID INT,
            @LocationID INT,
            @PlanID INT

        EXEC GetPatientID
        @Fname = @P_Fname,
        @Lname = @P_Lname,
        @DOB = @P_DOB,
        @PatientID = @PatientID OUTPUT
        IF @PatientID IS NULL
            BEGIN
                PRINT '@PatientID is currently empty';
                THROW 54412, '@PatientID is NULL and is being terminated', 1;
            END

        EXEC GetVisitTypeID
        @VisitTypeName = @VisitTypeName,
        @VisitTypeID = @VisitTypeID OUTPUT
        IF @VisitTypeID IS NULL
            BEGIN
                PRINT '@VisitTypeID is currently empty';
                THROW 54412, '@VisitTypeID is NULL and is being terminated', 1;
            END

        EXEC GetLocationID
        @LocationName = @LocationName,
        @LocationID = @LocationID OUTPUT 
        IF @LocationID IS NULL
            BEGIN
                PRINT '@LocationID is currently empty';
                THROW 54412, '@LocationID is NULL and is being terminated', 1;
            END

        EXEC GetPlanID
        @PlanName = @PlanName,
        @PlanID = @PlanID OUTPUT
        IF @PlanID IS NULL
            BEGIN
                PRINT '@PlanID is currently empty';
                THROW 54412, '@PlanID is NULL and is being terminated', 1;
            END

        BEGIN TRAN T1
        INSERT INTO tblVISIT (VisitDate, Expenses, PatientID, VisitTypeID, LocationID, PlanID)
        VALUES (@VisitDate, @Expenses, @PatientID, @VisitTypeID, @LocationID, @PlanID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO

    -- get visit id
        CREATE OR ALTER PROCEDURE GetVisitID
        @VisitDate DATE,
        @Expenses NUMERIC(6, 2),
        @VisitID INT OUTPUT
        AS SET @VisitID = (
            SELECT TOP 1 VisitID
            FROM tblVISIT
            WHERE VisitDate = @VisitDate
            AND Expenses = @Expenses
        )
        GO

    -- insert into visit doctor
        CREATE OR ALTER PROCEDURE InsertVISIT_DOC
        @VisitDate DATE,
        @Expenses NUMERIC(6, 2),
        @D_Fname VARCHAR(50),
        @D_Lname VARCHAR(50),
        @D_DOB DATE
        AS
        DECLARE @VisitID INT, @DoctorID INT

        EXEC GetVisitID
        @VisitDate = @VisitDate,
        @Expenses = @Expenses,
        @VisitID = @VisitID OUTPUT
        IF @VisitID IS NULL
            BEGIN
                PRINT '@VisitID is currently empty';
                THROW 54412, '@VisitID is NULL and is being terminated', 1;
            END

        EXEC GetDoctorID
        @Fname = @D_Fname,
        @Lname = @D_Lname,
        @DOB = @D_DOB,
        @DoctorID = @DoctorID OUTPUT
        IF @DoctorID IS NULL
            BEGIN
                PRINT '@DoctorID is currently empty';
                THROW 54412, '@DoctorID is NULL and is being terminated', 1;
            END

        BEGIN TRAN T1
        INSERT INTO tblVISIT_DOC (VisitID, DoctorID)
        VALUES (@VisitID, @DoctorID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO
    
    -- insert into doctor department
        CREATE OR ALTER PROCEDURE InsertDOC_DEPT
        @D_Fname VARCHAR(50),
        @D_Lname VARCHAR(50),
        @D_DOB DATE,
        @DeptName VARCHAR(50)
        AS
        DECLARE @DoctorID INT, @DeptID INT

        EXEC GetDoctorID
        @Fname = @D_Fname,
        @Lname = @D_Lname,
        @DOB = @D_DOB,
        @DoctorID = @DoctorID OUTPUT
        IF @DoctorID IS NULL
            BEGIN
                PRINT '@DoctorID is currently empty';
                THROW 54412, '@DoctorID is NULL and is being terminated', 1;
            END
        
        EXEC GetDepartmentID
        @DeptName = @DeptName,
        @DeptID = @DeptID OUTPUT
        IF @DeptID IS NULL
            BEGIN
                PRINT '@DeptID is currently empty';
                THROW 54412, '@DeptID is NULL and is being terminated', 1;
            END
        
        BEGIN TRAN T1
        INSERT INTO tblDOC_DEPT (DoctorID, DeptID)
        VALUES (@DoctorID, @DeptID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO

    -- insert into illness
        CREATE OR ALTER PROCEDURE InsertIllness
        @IllnessName VARCHAR(50),
        @IllnessDescr VARCHAR(500),
        @IllnessTypeName VARCHAR(50)
        AS
        DECLARE @IllnessTypeID INT

        EXEC GetIllnessTypeID 
        @IllnessTypeName = @IllnessTypeName,
        @IllnessTypeID = @IllnessTypeID OUTPUT 
        IF @IllnessTypeID IS NULL
            BEGIN
                PRINT '@IllnessTypeID is currently empty';
                THROW 54412, '@IllnessTypeID is NULL and is being terminated', 1;
            END

        BEGIN TRAN T1
        INSERT INTO tblILLNESS (IllnessName, IllnessDescr, IllnessTypeID)
        VALUES (@IllnessName, @IllnessDescr, @IllnessTypeID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO

    -- get illness id
        CREATE OR ALTER PROCEDURE GetIllnessID
        @IllnessName VARCHAR(50),
        @IllnessID INT OUTPUT
        AS SET @IllnessID = (
            SELECT TOP 1 IllnessID
            FROM tblILLNESS
            WHERE IllnessName = @IllnessName
        )
        GO

    -- insert into diagnose
        CREATE OR ALTER PROCEDURE InsertDiagnose
        @VisitDate DATE,
        @Expenses NUMERIC(6, 2),
        @IllnessName VARCHAR(50),
        @SeverityName VARCHAR(50)
        AS
        DECLARE
            @VisitID INT,
            @IllnessID INT,
            @SeverityID INT
        
        EXEC GetVisitID
        @VisitDate = @VisitDate,
        @Expenses = @Expenses,
        @VisitID = @VisitID OUTPUT
        IF @VisitID IS NULL
            BEGIN
                PRINT '@VisitID is currently empty';
                THROW 54412, '@VisitID is NULL and is being terminated', 1;
            END
        
        EXEC GetIllnessID
        @IllnessName = @IllnessName,
        @IllnessID = @IllnessID OUTPUT
        IF @IllnessID IS NULL
            BEGIN
                PRINT '@IllnessID is currently empty';
                THROW 54412, '@IllnessID is NULL and is being terminated', 1;
            END
        
        EXEC GetSeverityID
        @SeverityName = @SeverityName,
        @SeverityID = @SeverityID OUTPUT
        IF @SeverityID IS NULL
            BEGIN
                PRINT '@SeverityID is currently empty';
                THROW 54412, '@SeverityID is NULL and is being terminated', 1;
            END

        BEGIN TRAN T1
        INSERT INTO tblDIAGNOSE (VisitID, IllnessID, SeverityID)
        VALUES (@VisitID, @IllnessID, @SeverityID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO
    
    -- get diagnose id
        CREATE OR ALTER PROCEDURE GetDiagnoseID
        @VisitDate DATE,
        @Expenses NUMERIC(6, 2),
        @IllnessName VARCHAR(50),
        @SeverityName VARCHAR(50),
        @DiagnoseID INT OUTPUT
        AS SET @DiagnoseID = (
            SELECT TOP 1 D.DiagnoseID
            FROM tblDIAGNOSE D
                JOIN tblVISIT V ON V.VisitID = D.VisitID
                JOIN tblILLNESS I ON I.IllnessID = D.IllnessID
                JOIN tblSEVERITY SE ON SE.SeverityID = D.SeverityID
            WHERE V.VisitDate = @VisitDate
            AND V.Expenses = @Expenses
            AND I.IllnessName = @IllnessName
            AND SE.SeverityName = @SeverityName
        )
        GO

    -- insert into treatment
        CREATE OR ALTER PROCEDURE InsertTreatment
        @TreatmentName VARCHAR(50),
        @TreatmentTypeName VARCHAR(50)
        AS
        DECLARE @TreatmentTypeID INT

        EXEC GetTreatmentTypeID
        @TreatmentTypeName = @TreatmentTypeID,
        @TreatmentTypeID = @TreatmentTypeID OUTPUT
        IF @TreatmentTypeID IS NULL
            BEGIN
                PRINT '@TreatmentTypeID is currently empty';
                THROW 54412, '@TreatmentTypeID is NULL and is being terminated', 1;
            END
        
        BEGIN TRAN T1
        INSERT INTO tblTREATMENT (TreatmentName, TreatmentTypeID)
        VALUES (@TreatmentName, @TreatmentTypeID)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO
    
    -- get treatment id
        CREATE OR ALTER PROCEDURE GetTreatmentID
        @TreatmentName VARCHAR(50),
        @TreatmentID INT OUTPUT
        AS SET @TreatmentID = (
            SELECT TOP 1 TreatmentID
            FROM tblTREATMENT
            WHERE TreatmentName = @TreatmentName
        )
        GO

    -- insert diagnose treatment
        CREATE OR ALTER PROCEDURE InsertDiagTreat
        @VisitDate DATE,
        @Expenses NUMERIC(6, 2),
        @IllnessName VARCHAR(50),
        @SeverityName VARCHAR(50),
        @TreatmentName VARCHAR(50),
        @BeginDate DATE, 
        @EndDate DATE
        AS
        DECLARE @DiagnoseID INT, @TreatmentID INT

        EXEC GetDiagnoseID
        @VisitDate = @VisitDate,
        @Expenses = @Expenses,
        @IllnessName = @IllnessName,
        @SeverityName = @SeverityName,
        @DiagnoseID = @DiagnoseID OUTPUT
        IF @DiagnoseID IS NULL
            BEGIN
                PRINT '@DiagnoseID is currently empty';
                THROW 54412, '@DiagnoseID is NULL and is being terminated', 1;
            END
        
        EXEC GetTreatmentID
        @TreatmentName = @TreatmentName,
        @TreatmentID = @TreatmentID OUTPUT
        IF @TreatmentID IS NULL
            BEGIN
                PRINT '@TreatmentID is currently empty';
                THROW 54412, '@TreatmentID is NULL and is being terminated', 1;
            END

        BEGIN TRAN T1
        INSERT INTO tblDIAG_TREAT (DiagnoseID, TreatmentID, BeginDate, EndDate)
        VALUES (@DiagnoseID, @TreatmentID, @BeginDate, @EndDate)
        IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN T1
            END
        ELSE
        COMMIT TRAN T1
        GO

-- synthetic transactions
    -- ST --> insert patients
        CREATE OR ALTER PROCEDURE ST_InsertPatient 
        @Run INT
        AS
        DECLARE 
            -- declare required variables
                @P_Fname VARCHAR(50), @P_Lname VARCHAR(50), @P_DOB DATE, @Weight NUMERIC(5, 2), 
                @Height NUMERIC(5, 2), @Gender VARCHAR(50), @Race VARCHAR(50),

                @PatientCOUNT INT = (SELECT COUNT(*) FROM PEEPS.dbo.tblCUSTOMER),
                @GenderCOUNT INT = (SELECT COUNT(*) FROM tblGENDER),
                @RaceCOUNT INT = (SELECT COUNT(*) FROM tblRACE),

                @PatientID INT, @GenderID INT, @RaceID INT

        WHILE @Run > 0
            BEGIN
                -- assign values to declared variables
                    SET @PatientID = (SELECT RAND() * @PatientCOUNT + 1)
                    SET @P_Fname = (SELECT CustomerFname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @PatientID)
                    IF @P_Fname IS NULL
                        BEGIN
                            SET @PatientID = (SELECT RAND() * @PatientCOUNT + 1)
                            SET @P_Fname = (SELECT CustomerFname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @PatientID)
                        END
                    SET @P_Lname = (SELECT CustomerLname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @PatientID)
                    SET @P_DOB = (SELECT DateOfBirth FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @PatientID)

                    SET @Weight = (SELECT RAND() * (150 - 50 + 1) + 50)

                    SET @Height = (SELECT RAND() * (200 - 80 + 1) + 80)
                    
                    SET @GenderID = (SELECT RAND() * @GenderCOUNT + 1)
                    SET @Gender = (SELECT Gender FROM tblGENDER WHERE GenderID = @GenderID)
                    IF @Gender IS NULL
                        BEGIN
                            SET @Gender = (SELECT TOP 1 Gender FROM tblGENDER)
                        END
                    
                    SET @RaceID = (SELECT RAND() * @RaceCOUNT + 1)
                    SET @Race = (SELECT Race FROM tblRACE WHERE RaceID = @RaceID)
                    IF @Race IS NULL
                        BEGIN
                            SET @Race = (SELECT TOP 1 Race FROM tblRACE)
                        END

                EXEC InsertPatient 
                @Fname = @P_Fname,
                @Lname = @P_Lname,
                @DOB = @P_DOB,
                @Weight = @Weight,
                @Height = @Height,
                @Gender = @Gender,
                @Race = @Race

                SET @Run = @Run - 1
            END
        GO
        -- EXEC ST_InsertPatient @Run = 200;
        -- SELECT * FROM tblPATIENT;

    -- ST --> insert doctor
        CREATE OR ALTER PROCEDURE ST_InsertDoctor
        @Run INT 
        AS
        DECLARE 
            @D_Fname VARCHAR(100), @D_Lname VARCHAR(100), @D_DOB DATE, 
            @Gender VARCHAR(100), @Race VARCHAR(50),

            @DocCOUNT INT = (SELECT COUNT(*) FROM PEEPS.dbo.tblCUSTOMER),
            @GenderCOUNT INT = (SELECT COUNT(*) FROM tblGENDER),
            @RaceCOUNT INT = (SELECT COUNT(*) FROM tblRACE),

            @DoctorID INT, @GenderID INT, @RaceID INT

        WHILE @Run > 0
            BEGIN
                SET @DoctorID = (SELECT RAND() * @DocCOUNT + 1)
                SET @D_Fname = (SELECT CustomerFname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @DoctorID)
                IF @D_Fname IS NULL
                    BEGIN
                        SET @DoctorID = (SELECT RAND() * @DocCOUNT + 1)
                        SET @D_Fname = (SELECT CustomerFname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @DoctorID)
                    END
                SET @D_Lname = (SELECT CustomerLname FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @DoctorID)
                SET @D_DOB = ((SELECT DateOfBirth FROM PEEPS.dbo.tblCUSTOMER WHERE CustomerID = @DoctorID))

                SET @GenderID = (SELECT RAND() * @GenderCOUNT + 1)
                SET @Gender = (SELECT Gender FROM tblGENDER WHERE GenderID = @GenderID)
                IF @Gender IS NULL
                    BEGIN
                        SET @Gender = (SELECT TOP 1 Gender FROM tblGENDER)
                    END
                
                SET @RaceID = (SELECT RAND() * @RaceCOUNT + 1)
                SET @Race = (SELECT Race FROM tblRACE WHERE RaceID = @RaceID)
                IF @Race IS NULL
                    BEGIN
                        SET @Race = (SELECT TOP 1 Race FROM tblRACE)
                    END

                EXEC InsertDoctor
                @Fname = @D_Fname,
                @Lname = @D_Lname,
                @DOB = @D_DOB,
                @Gender = @Gender,
                @Race = @Race

                SET @Run = @Run - 1
            END
        GO
        -- EXEC ST_InsertDoctor @Run = 1000;
        -- SELECT * FROM tblDOCTOR;

    -- ST --> insert visit
        CREATE OR ALTER PROCEDURE ST_InsertVisit
        @Run INT
        AS
        DECLARE
            @VisitDate DATE, @Expenses NUMERIC(6, 2), @P_Fname VARCHAR(50),
            @P_Lname VARCHAR(50), @P_DOB DATE, @VisitTypeName VARCHAR(50),
            @LocationName VARCHAR(50), @PlanName VARCHAR(50),

            @PatientCOUNT INT = (SELECT COUNT(*) FROM tblPATIENT),

            @PatientID INT, @VisitTypeID INT, @LocationID INT, @PlanID INT
        
        WHILE @Run > 0
            BEGIN
                SET @VisitDate = (SELECT DATEADD(DAY,(SELECT -RAND() * 1825 + 1), GETDATE()))

                SET @Expenses = (SELECT RAND() * (5000 - 300 + 1) + 300)

                SET @PatientID = (SELECT TOP 1 PatientID FROM tblPATIENT ORDER BY NEWID())
                SET @P_Fname = (SELECT PatientFname FROM tblPATIENT WHERE PatientID = @PatientID)
                IF @P_Fname IS NULL
                    BEGIN
                        SET @PatientID = (SELECT TOP 1 PatientID FROM tblPATIENT ORDER BY NEWID())
                        SET @P_Fname = (SELECT PatientFname FROM tblPATIENT WHERE PatientID = @PatientID)
                    END
                SET @P_Lname = (SELECT PatientLname FROM tblPATIENT WHERE PatientID = @PatientID)
                SET @P_DOB = (SELECT PatientDOB FROM tblPATIENT WHERE PatientID = @PatientID)

                SET @VisitTypeID = (SELECT TOP 1 VisitTypeID FROM tblVISIT_TYPE ORDER BY NEWID())
                SET @VisitTypeName = (SELECT VisitTypeName FROM tblVISIT_TYPE WHERE VisitTypeID = @VisitTypeID)
                IF @VisitTypeName IS NULL
                    BEGIN
                        SET @VisitTypeName = (SELECT TOP 1 VisitTypeName FROM tblVISIT_TYPE)
                    END

                SET @LocationID = (SELECT TOP 1 LocationID FROM tblLOCATION ORDER BY NEWID())
                SET @LocationName = (SELECT LocationName FROM tblLOCATION WHERE LocationID = @LocationID)
                IF @LocationName IS NULL
                    BEGIN
                        SET @LocationName = (SELECT TOP 1 LocationName FROM tblLOCATION)
                    END

                SET @PlanID = (SELECT TOP 1 PlanID FROM tblPLAN ORDER BY NEWID())
                SET @PlanName = (SELECT PlanName FROM tblPLAN WHERE PlanID = @PlanID)
                IF @PlanName IS NULL
                    BEGIN
                        SET @PlanName = (SELECT TOP 1 PlanName FROM tblPLAN)
                    END

                EXEC InsertVisit
                @VisitDate = @VisitDate,
                @Expenses = @Expenses,
                @P_Fname = @P_Fname,
                @P_Lname = @P_Lname,
                @P_DOB = @P_DOB,
                @VisitTypeName = @VisitTypeName,
                @LocationName = @LocationName,
                @PlanName = @PlanName

                SET @Run = @Run - 1
            END
        GO
        -- EXEC ST_InsertVisit @Run = 1000;
        -- SELECT * FROM tblVISIT;

    -- ST --> insert diagnose
        CREATE OR ALTER PROCEDURE ST_InsertDiagnose
        @Run INT
        AS
        DECLARE
            @VisitDate DATE, @Expenses NUMERIC(6, 2), @IllnessName VARCHAR(50), @SeverityName VARCHAR(50),

            @VisitID INT, @IllnessID INT, @SeverityID INT
        
        WHILE @Run > 0
            BEGIN
                SET @VisitID = (SELECT TOP 1 VisitID FROM tblVISIT ORDER BY NEWID())
                SET @VisitDate = (SELECT VisitDate FROM tblVISIT WHERE VisitID = @VisitID)
                SET @Expenses = (SELECT Expenses FROM tblVISIT WHERE VisitID = @VisitID)

                SET @IllnessID = (SELECT TOP 1 IllnessID FROM tblILLNESS ORDER BY NEWID())
                SET @IllnessName = (SELECT IllnessName FROM tblILLNESS WHERE IllnessID = @IllnessID)

                SET @SeverityID = (SELECT TOP 1 SeverityID FROM tblSEVERITY ORDER BY NEWID())
                SET @SeverityName = (SELECT SeverityName FROM tblSEVERITY WHERE SeverityID = @SeverityID)

                EXEC InsertDiagnose
                @VisitDate = @VisitDate,
                @Expenses = @Expenses,
                @IllnessName = @IllnessName,
                @SeverityName = @SeverityName

                SET @Run = @Run - 1
            END
        GO
        -- EXEC ST_InsertDiagnose @Run = 300000;
        -- SELECT * FROM tblDiagnose;

    -- ST --> insert doctor department
        CREATE OR ALTER PROCEDURE ST_InsertDocDept
        @Run INT
        AS
        DECLARE
            @D_Fname VARCHAR(50), @D_Lname VARCHAR(50),
            @D_DOB DATE, @DeptName VARCHAR(50),

            @DoctorID INT, @DeptID INT

        WHILE @Run > 0
            BEGIN
                SET @DoctorID = (SELECT TOP 1 DoctorID FROM tblDOCTOR ORDER BY NEWID())
                SET @D_Fname = (SELECT DocFname FROM tblDOCTOR WHERE DoctorID = @DoctorID)
                SET @D_Lname = (SELECT DocLname FROM tblDOCTOR WHERE DoctorID = @DoctorID)
                SET @D_DOB = ((SELECT DocDOB FROM tblDOCTOR WHERE DoctorID = @DoctorID))

                SET @DeptID = (SELECT TOP 1 DeptID FROM tblDEPARTMENT ORDER BY NEWID())
                SET @DeptName = (SELECT DeptName FROM tblDEPARTMENT WHERE DeptID = @DeptID)

                EXEC InsertDOC_DEPT
                @D_Fname = @D_Fname,
                @D_Lname = @D_Lname,
                @D_DOB = @D_DOB,
                @DeptName = @DeptName

                SET @Run = @Run - 1
            END
        GO
        -- EXEC ST_InsertDocDept @Run = 1000;
        -- SELECT * FROM tblDOC_DEPT;

    -- ST --> insert diagnose treatment
        CREATE OR ALTER PROCEDURE ST_InsertDiagTreat
        @Run INT
        AS
        DECLARE
            @VisitDate DATE, @Expenses NUMERIC(6, 2), @IllnessName VARCHAR(50), 
            @SeverityName VARCHAR(50), @TreatmentName VARCHAR(50), @BeginDate DATE, @EndDate DATE,
            
            @DiagnoseID INT, @TreatmentID INT

        WHILE @Run > 0
            BEGIN
                SET @DiagnoseID = (SELECT TOP 1 DiagnoseID FROM tblDIAGNOSE ORDER BY NEWID())
                SET @VisitDate = (SELECT V.VisitDate FROM tblDIAGNOSE D JOIN tblVISIT V ON D.VisitID = V.VisitID WHERE D.DiagnoseID = @DiagnoseID)
                SET @Expenses = (SELECT V.Expenses FROM tblDIAGNOSE D JOIN tblVISIT V ON D.VisitID = V.VisitID WHERE D.DiagnoseID = @DiagnoseID)
                SET @IllnessName = (SELECT I.IllnessName FROM tblDIAGNOSE D JOIN tblILLNESS I ON D.IllnessID = I.IllnessID WHERE D.DiagnoseID = @DiagnoseID)
                SET @SeverityName = (SELECT S.SeverityName FROM tblDIAGNOSE D JOIN tblSEVERITY S ON D.SeverityID = S.SeverityID WHERE D.DiagnoseID = @DiagnoseID)
                
                SET @TreatmentID = (SELECT TOP 1 TreatmentID FROM tblTREATMENT ORDER BY NEWID())
                SET @TreatmentName = (SELECT TreatmentName FROM tblTREATMENT WHERE TreatmentID = @TreatmentID)

                SET @BeginDate = @VisitDate
                SET @EndDate = (SELECT DATEADD(DAY, (SELECT RAND() * 365 + 1), @BeginDate))

                EXEC InsertDiagTreat
                @VisitDate = @VisitDate,
                @Expenses = @Expenses,
                @IllnessName = @IllnessName,
                @SeverityName = @SeverityName,
                @TreatmentName = @TreatmentName,
                @BeginDate = @BeginDate,
                @EndDate = @EndDate

                SET @Run = @Run - 1
            END
        GO
        -- EXEC ST_InsertDiagTreat @Run = 10000;
        -- SELECT * FROM tblDIAG_TREAT;


    -- ST --> insert visit doctor
        CREATE OR ALTER PROCEDURE ST_InsertVisitDoc
        @Run INT
        AS
        DECLARE
            @VisitDate DATE, @Expenses NUMERIC(6, 2), @D_Fname VARCHAR(50),
            @D_Lname VARCHAR(50), @D_DOB DATE,

            @VisitID INT, @DoctorID INT

        WHILE @Run > 0
            BEGIN
                SET @VisitID = (SELECT TOP 1 VisitID FROM tblVISIT ORDER BY NEWID())
                SET @VisitDate = (SELECT VisitDate FROM tblVISIT WHERE VisitID = @VisitID)
                SET @Expenses = (SELECT Expenses FROM tblVISIT WHERE VisitID = @VisitID)

                SET @DoctorID = (SELECT TOP 1 DoctorID FROM tblDOCTOR ORDER BY NEWID())
                SET @D_Fname = (SELECT DocFname FROM tblDOCTOR WHERE DoctorID = @DoctorID)
                SET @D_Lname = (SELECT DocLname FROM tblDOCTOR WHERE DoctorID = @DoctorID)
                SET @D_DOB = ((SELECT DocDOB FROM tblDOCTOR WHERE DoctorID = @DoctorID))

                EXEC InsertVISIT_DOC
                @VisitDate = @VisitDate,
                @Expenses = @Expenses,
                @D_Fname = @D_Fname,
                @D_Lname = @D_Lname,
                @D_DOB = @D_DOB

                SET @Run = @Run - 1
            END
        GO
        -- EXEC ST_InsertVisitDoc @Run = 100;
        -- SELECT * FROM tblVISIT_DOC;
    
-- calculated columns
    -- patient BMI
        ALTER TABLE tblPATIENT
        ADD BMI AS ([Weight] / ((Height / 100) * (Height / 100)));

    -- patient age
        ALTER TABLE tblPATIENT
        ADD Age AS (DATEDIFF(YEAR, PatientDOB, GETDATE()));
    
    -- doc age 
        ALTER TABLE tblDOCTOR
        ADD Age AS (DATEDIFF(YEAR, DocDOB, GETDATE()));

    -- treatment duration
        ALTER TABLE tblDIAG_TREAT
        ADD Duration AS (DATEDIFF(DAY, BeginDate, EndDate));

-- business rules
    -- the age of the doctor should be greater than 25

    -- physical therapist cannot be older than 65

    -- male patient cannot have C-Section

    -- patient BMI cannot be zero, negative, or greater than 80

-- some queries for demonstration
-- What is the proportion of patients within each demographic (or just Asian/Black/etc.) having a Gold insurance plan
WITH CTE_Gold (RaceID, Race, NumGold)
AS (
    SELECT R.RaceID, R.Race, COUNT(P.PatientID)
    FROM tblRACE R
        JOIN tblPATIENT P ON P.RaceID = R.RaceID
        JOIN tblVISIT V ON V.PatientID = P.PatientID
        JOIN tblPLAN PL ON PL.PlanID = V.PlanID
    WHERE PL.PlanName LIKE '%Gold%'
    GROUP BY R.RaceID, R.Race
), CTE_Total (RaceID, Race, TotalPatient)
AS (
    SELECT R.RaceID, R.Race, COUNT(P.PatientID)
    FROM tblRACE R
        JOIN tblPATIENT P ON P.RaceID = R.RaceID
        JOIN tblVISIT V ON V.PatientID = P.PatientID
        JOIN tblPLAN PL ON PL.PlanID = V.PlanID
    GROUP BY R.RaceID, R.Race
)
SELECT A.RaceID, A.Race, 
CAST((100 * (CAST(A.NumGold AS FLOAT) / B.TotalPatient)) AS NUMERIC(5, 2)) AS Proportion
FROM CTE_Gold A
    JOIN CTE_Total B ON A.RaceID = B.RaceID;

-- What is the most popular illness by race?
WITH CTE_Popular_Illness (RaceID, Race, IllnessID, IllnessName, TotalDiagnose, Rank)
AS (
    SELECT R.RaceID, R.Race, I.IllnessID, I.IllnessName, COUNT(D.DiagnoseID),
    RANK() OVER (PARTITION BY Race ORDER BY COUNT(D.DiagnoseID))
    FROM tblRACE R
        JOIN tblPATIENT P ON P.RaceID = R.RaceID
        JOIN tblVISIT V ON V.PatientID = P.PatientID
        JOIN tblDIAGNOSE D ON D.VisitID = V.VisitID
        JOIN tblILLNESS I ON I.IllnessID = D.IllnessID
    GROUP BY R.RaceID, R.Race, I.IllnessID, I.IllnessName
)
SELECT *
FROM CTE_Popular_Illness
WHERE Rank = 1
ORDER BY RaceID;