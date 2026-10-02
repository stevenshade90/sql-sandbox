CREATE TABLE current_time_example(
	time_id integer GENERATED ALWAYS AS IDENTITY,
	current_timestamp_col timestamptz,
	clock_timestamp_col timestamptz
);

SELECT * FROM current_time_example;

INSERT INTO current_time_example(current_timestamp_col, clock_timestamp_col)
	(SELECT current_timestamp, clock_timestamp() FROM generate_series(1,1000));

SHOW timezone;
SELECT current_setting('timezone');

-- Seeing the time drift that results across the 1000 rows as they're inserted
SELECT 
    time_id,
    current_timestamp_col,
    clock_timestamp_col,
    EXTRACT(MICROSECONDS FROM (clock_timestamp_col - current_timestamp_col))::integer AS drift_sec
FROM current_time_example
ORDER BY drift_sec DESC;