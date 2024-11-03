CREATE MATERIALIZED VIEW QueryB
BUILD IMMEDIATE
REFRESH COMPLETE
ON DEMAND
AS

SELECT 
    a.AircraftID,                      -- Select the aircraft ID
    a.AircraftModel,                   -- Select the aircraft model  
    t.Month,                           -- Select the MONTH
    t.Year,                            -- Select the year  
    SUM(m.ADOSS + m.ADOSU) AS total_ADOS,    -- Sum of Aircraft Days Out of Service (ADOS)
    SUM(m.ADOSS) AS total_ADOSS,       -- Sum of Aircraft Days Out of Service Scheduled (ADOSS)
    SUM(m.ADOSU) AS total_ADOSU,       -- Sum of Aircraft Days Out of Service Unscheduled (ADOSU)
    (EXTRACT(DAY FROM LAST_DAY(TO_DATE(t.Year || '-' || t.Month || '-01', 'YYYY-MM-DD'))) - SUM(m.ADOSS + m.ADOSU)) AS total_ADIS,   -- Sum of Aircraft Days In Service (ADIS)
    (SUM(f.DY) / SUM(f.TOFF)) * 100 AS delay_rate,  -- Calculate Delay Rate (DYR)
    (SUM(f.CN) / SUM(f.TOFF)) * 100 AS cancellation_rate,  -- Calculate Cancellation Rate (CNR)
    100 - (((SUM(f.DY) + SUM(f.CN)) / SUM(f.TOFF)) * 100) AS technical_dispatch_reliability,  -- Calculate Technical Dispatch Reliability (TDR)
    (SUM(f.DY) / COUNT(f.DY)) * 100 AS average_delay_duration  -- Calculate Average Delay Duration (ADD)
FROM 
    Maintenance_Fact m,                -- From the Maintenance_Fact TABLE
    Flight_Fact f,                     -- From the Flight_FACT table
    Aircraft_Dim a,                    -- From the Aircraft_Dim table
    Time_Dim t                         -- From the Time_Dim table  
WHERE 
    m.AircraftID = a.AircraftID        -- Join the aircraft ID between Maintenance_Fact and Aircraft_Dim
    AND m.TimeID = t.TimeID            -- Join the time ID between Maintenance_Fact and Time_Dim
    AND f.AircraftID = a.AircraftID    -- Join the aircraft ID between Flight_FACT and Aircraft_Dim
    AND f.TimeID = t.TimeID            -- Join the time ID between Flight_FACT and Time_Dim
GROUP BY 
    a.AircraftID,                      -- Group by aircraft ID
    a.AircraftModel,                   -- Group by aircraft model
    t.Year,                            -- Group by year
    t.Month                            -- Group by month
ORDER BY 
    a.AircraftID,                      -- Order by aircraft ID
    t.Year,                            -- Order by year
    t.Month                            -- Order by MONTH