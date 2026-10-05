-- Create basic table with made-up values
CREATE TABLE train_rides (
	trip_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	segment text NOT NULL,
	departure timestamptz NOT NULL,
	arrival timestamptz NOT NULL
);

INSERT INTO train_rides (segment, departure, arrival)
VALUES
	('Chicago to New York', '2020-11-13 21:30 CST', '2020-11-14 18:23 CST'),
	('New York to Chicago', '2020-11-13 21:30 CST', '2020-11-14 18:23 CST'),
	('New York to New Orleans', '2020-11-15 14:35 EST', '2020-11-17 20:23 CST'),
	('New Orleans to Los Angeles', '2020-11-17 13:45 CST', '2020-11-18 9:00 PST'),
	('Los Angeles to San Francisco', '2020-11-19 10:10 PST', '2020-11-19 21:24 PST');

-- Change tz to explore different values
SET TIME ZONE 'US/Central';

-- Query #1: Basic query to see travel durations
SELECT segment,
	to_char(departure, 'YYYY-MM-DD HH12:MI a.m TZ') AS departure,
	arrival - departure AS segment_duration
FROM train_rides;

-- Query #2: Testing justify_interval() function with OVER to see cumulative duration
SELECT segment,
	arrival - departure AS segment_duration,
	justify_interval(sum(arrival-departure)
		OVER (ORDER BY trip_id)) AS cumulative_duration
FROM train_rides;

-- Query #3: Basic aggregation
SELECT count(*), arrival FROM train_rides 
GROUP BY arrival
ORDER BY count
WHERE 