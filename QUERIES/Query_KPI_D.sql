-- d)	Give me the MRRh and MRRc per airport of the reporting person per aircraft (also per model). 

--EXPLAIN PLAN FOR

SELECT 
    a.AircraftID,                      -- Select the aircraft ID
    a.AircraftModel,                   -- Select the aircraft model
    r.Airport,                         -- Select the airport of the reporting person
    (1000 * SUM(m.MLBC) / SUM(f.FH)) AS maintenance_report_rate_hour,  -- Calculate Maintenance Report Rate per Hour (MRRh)
    (100 * SUM(m.MLBC) / SUM(CASE WHEN f.CN = 1 THEN 1 ELSE 0 END)) AS maintenance_report_rate_cycle   -- Calculate Maintenance Report Rate per Cycle (MRRc)
FROM 
    Maintenance_Fact m,                -- From the Maintenance_Fact table
    Aircraft_Dim a,                    -- From the Aircraft_Dim table
    Reporteur_Dim r,                   -- From the Reporteur_Dim table
    Flight_FACT f                      -- From the Flight_FACT table
WHERE 
    m.AircraftID = a.AircraftID        -- Match the aircraft ID between Maintenance_Fact and Aircraft_Dim
    AND m.ReporteurID = r.ReporteurID  -- Match the reporteur ID between Maintenance_Fact and Reporteur_Dim
    AND f.AircraftID = a.AircraftID    -- Match the aircraft ID between Flight_FACT and Aircraft_Dim
    AND f.TimeID = m.TimeID            -- Match the time ID between Flight_FACT and Maintenance_Fact
GROUP BY 
    a.AircraftID,                      -- Group by aircraft ID
    a.AircraftModel,                   -- Group by aircraft model
    r.Airport                          -- Group by the reporting person's airport
ORDER BY 
    a.AircraftID,                      -- Order by aircraft ID
    r.Airport                         -- Order by airport

--SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);