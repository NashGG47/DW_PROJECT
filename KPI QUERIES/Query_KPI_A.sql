-- a)	Give me FH and TO per aircraft (also per model) per day (also per month and per year). 


SELECT 
    a.AircraftID,                      -- Select the aircraft ID
    a.AircraftModel,                   -- Select the aircraft model
    t.Year,                            -- Select the year
    t.Month,                           -- Select the month
    t.Day,                             -- Select the day
    SUM(f.FH) AS total_flight_hours,   -- Sum up the flight hours (FH)
    SUM(f.TOFF) AS total_takeoffs      -- Sum up the number of takeoffs (TO)
FROM 
    Flight_Fact f,                     -- From the Flight_FACT table
    Aircraft_Dim a,                    -- From the Aircraft_Dim table
    Time_Dim t                         -- From the Time_Dim table
WHERE 
    f.AircraftID = a.AircraftID        -- Join the aircraft ID between Flight_FACT and Aircraft_Dim
    AND f.TimeID = t.TimeID            -- Join the time ID between Flight_FACT and Time_Dim
GROUP BY 
    a.AircraftID,                      -- Group by aircraft ID
    a.AircraftModel,                   -- Group by aircraft model
    t.Year,                            -- Group by year
    t.Month,                           -- Group by month
    t.Day                              -- Group by day
ORDER BY 
    a.AircraftID,                      -- Order by aircraft ID
    t.Year,                            -- Order by year
    t.Month,                           -- Order by month
    t.Day                              -- Order by day
