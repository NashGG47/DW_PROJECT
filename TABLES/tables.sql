CREATE TABLE Flight_FACT (
	aircraftID CHAR(26) NOT NULL,
    timeID CHAR(26) NOT NULL,
    FH SMALLINT                                     -- Time flown in hours
    DY SMALLINT CHECK (DY BETWEEN 15 AND 360),      -- Delay in minutes.
	CN INTEGER(1) NOT NULL                          -- Acts as a Boolean, but 1 and 0 can be used in Sums

    PRIMARY KEY (aircraftID, timeID),
    FOREIGN KEY (aircraftID) REFERENCES Aircraft_Dim(aircraftID),
    FOREIGN KEY (timeID) REFERENCES Time_Dim(timeID)
);

CREATE TABLE Flight_FACT (
	aircraftID CHAR(26) NOT NULL,
    reporteurID CHAR(26) NOT NULL,
    timeID CHAR(26) NOT NULL,
    ADOS INT NOT NULL,                              -- Duration of the maintenance in minutes
    scheduled INTEGER(1) NOT NULL,
    PLBC INT NOT NULL,
    MLBC INT NOT NULL,                            

    PRIMARY KEY (aircraftID, reporteurID, timeID),
    FOREIGN KEY (aircraftID) REFERENCES Aircraft_Dim(aircraftID),
    FOREIGN KEY (timeID) REFERENCES Time_Dim(timeID),
    FOREIGN KEY (reporteurID) REFERENCES Reporteur_Dim(reporteurID)
);

CREATE TABLE Aircraft_Dim (
    aircraftID CHAR(26) NOT NULL,
    aircraftRegistration VARCHAR NOT NULL,
    aircraftModel VARCHAR NOT NULL,
    manufacturer VARCHAR NOT NULL,
    manufacturerSerialNumber VARCHAR NOT NULL,

    PRIMARY KEY (aricraftID)
);

CREATE TABLE Time_Dim (
    timeID CHAR(26) NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,

    PRIMARY KEY (timeID)
);

CREATE TABLE Reporteur_Dim (
    reporteurID CHAR(26) NOT NULL,
    airport VARCHAR NOT NULL,

    PRIMARY KEY (reporteurID)
);