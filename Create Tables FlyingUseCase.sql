
-- Create the Time Dimension Table
CREATE TABLE Time_Dim (
    TimeID      NUMBER PRIMARY KEY,   -- Surrogate primary key for Time
    Day         NUMBER(2),            -- Day of the month
    Month       NUMBER(2),            -- Month of the year (1-12)
    Year        NUMBER(4)             -- Year (e.g., 2024)
);


-- Create the Aircraft Dimension Table
CREATE TABLE Aircraft_Dim (
    AircraftID NUMBER PRIMARY KEY,		 -- Surrogate primary key for Aircraft
    AircraftRegistration VARCHAR(20),	 -- Aircraft Registration
    AircraftModel VARCHAR(50),			 -- Aircraft Model
    Manufacturer VARCHAR(50),			 -- Manufacturer
    ManufacturerSerialNumber VARCHAR(50) -- Manufacturer Serial Number
);


-- Create the Flights Fact Table
CREATE TABLE Flight_Fact (
    AircraftID NUMBER NOT NULL,		-- Foreign key to Aircraft Dimension
    TimeID NUMBER NOT NULL,			-- Foreign key to Time Dimension
    FH DECIMAL(5,2),     		    -- Flight Hours
    TOFF INT,            		    -- Number of Take-offs
    DY INT,              		    -- Number of Delays
    CN INT,              		    -- Number of Cancellations
    
    -- Foreign key constraints
    CONSTRAINT fk_aircraft
    	FOREIGN KEY (AircraftID) REFERENCES Aircraft_Dim(AircraftID),
    CONSTRAINT fk_time
    	FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID)   
);


-- Create the Reporteur Dimension Table
CREATE TABLE Reporteur_Dim (
    ReporteurID NUMBER PRIMARY KEY,		 -- Surrogate primary key for Reporteur
    Airport VARCHAR(50)	 			     -- Reporteur Airport
);


-- Create the Maintenance Fact Table
CREATE TABLE Maintenance_Fact (
    AircraftID NUMBER NOT NULL,			-- Foreign key to Aircraft Dimension
    ReporteurID NUMBER NOT NULL,		-- Foreign key to Reporteur Dimension
    TimeID NUMBER NOT NULL,				-- Foreign key to Time Dimension 
    ADOSS INT,         					-- Scheduled Out-of-Service Days
    ADOSU INT,         					-- Unscheduled Out-of-Service Days
    PLBC INT,         					-- Pilot Logbook Count
    MLBC INT,         					-- Maintenance Logbook Count
    
    -- Foreign key constraints
    CONSTRAINT fk_maintenance_aircraft
    	FOREIGN KEY (AircraftID) REFERENCES Aircraft_Dim(AircraftID),
    CONSTRAINT fk_maintenance_reporteur
    	FOREIGN KEY (ReporteurID) REFERENCES Reporteur_Dim(ReporteurID),
    CONSTRAINT fk_maintenance_time
    	FOREIGN KEY (TimeID) REFERENCES Time_Dim(TimeID)
);