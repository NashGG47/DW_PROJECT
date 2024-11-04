-- c)	Give me the RRh, RRc, PRRh, PRRc, MRRh and MRRc per aircraft (also per model and manufacturer) 
--      per month (also per year).

--EXPLAIN PLAN FOR

SELECT 
    a.AircraftID,                      -- Select the aircraft ID
    a.AircraftModel,                   -- Select the aircraft model
    a.Manufacturer,                    -- Select the aircraft manufacturer
    t.Year,                            -- Select the year
    t.Month,                           -- Select the month
    (1000 * (SUM(m.PLBC)+SUM(m.MLBC)) / SUM(f.FH)) AS report_rate_hour,  -- Calculate Report Rate per Hour (RRh)
    (100 * (SUM(m.PLBC)+SUM(m.MLBC)) / COUNT(CASE WHEN NOT f.CN THEN f)) AS report_rate_cycle,  -- Calculate Report Rate per Cycle (RRc)
    (1000 * SUM(m.PLBC) / SUM(f.FH)) AS pilot_report_rate_hour,  -- Calculate Pilot Report Rate per Hour (PRRh)
    (100 * SUM(m.PLBC) / COUNT(CASE WHEN NOT f.CN THEN f)) AS pilot_report_rate_cycle,  -- Calculate Pilot Report Rate per Cycle (PRRc)
    (1000 * SUM(m.MLBC) / SUM(f.FH)) AS maintenance_report_rate_hour,  -- Calculate Maintenance Report Rate per Hour (MRRh)
    (100 * SUM(m.MLBC) / COUNT(CASE WHEN NOT f.CN THEN f)) AS maintenance_report_rate_cycle  -- Calculate Maintenance Report Rate per Cycle (MRRc)
FROM 
    Maintenance_Fact m,                -- From the Maintenance_Fact table
    Aircraft_Dim a,                    -- From the Aircraft_Dim table
    Time_Dim t,                        -- From the Time_Dim table
    Flight_FACT f                      -- From the Flight_FACT table
WHERE 
    m.AircraftID = a.AircraftID        -- Join the aircraft ID between Maintenance_Fact and Aircraft_Dim
    AND m.TimeID = t.TimeID            -- Join the time ID between Maintenance_Fact and Time_Dim
    AND f.AircraftID = a.AircraftID    -- Join the aircraft ID between Flight_FACT and Aircraft_Dim
    AND f.TimeID = t.TimeID            -- Join the time ID between Flight_FACT and Time_Dim
GROUP BY 
    a.AircraftID,                      -- Group by aircraft ID
    a.AircraftModel,                   -- Group by aircraft model
    a.Manufacturer,                    -- Group by manufacturer
    t.Year,                            -- Group by year
    t.Month                            -- Group by month
ORDER BY 
    a.AircraftID,                      -- Order by aircraft ID
    t.Year,                            -- Order by year
    t.Month                            -- Order by month

--SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);