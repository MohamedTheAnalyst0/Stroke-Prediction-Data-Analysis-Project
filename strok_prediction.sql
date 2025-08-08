SELECT *
FROM stroke_prediction;

UPDATE stroke_prediction
SET [Residence_type] = 
    UPPER(LEFT([Residence_type], 1)) + 
    LOWER(SUBSTRING([Residence_type], 2, LEN([Residence_type])));

EXEC sp_rename 'stroke_prediction.Residence_type', 'residence_type', 'COLUMN';


-- Remove Nulls --
SELECT COUNT(*) AS null_bmi 
FROM stroke_prediction WHERE bmi IS NULL;

DELETE 
FROM stroke_prediction WHERE bmi IS NULL;

-- Remove Dublicates --
SELECT DISTINCT *
FROM stroke_prediction;

WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY [gender], age, hypertension, heart_disease, ever_married,
                            work_type, residence_type, avg_glucose_level, bmi,
                            smoking_status, stroke
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM stroke_prediction
)
DELETE FROM CTE WHERE rn > 1;

-------------------------------------------------------------------------------
 -- Total Patient --
 SELECT COUNT(*) AS total_patients
 FROM stroke_prediction;

 -- The Incidence of stroke --

 SELECT COUNT(*) * 100.0 / (SELECT COUNT(*) FROM stroke_prediction) AS stroke_percentage
 FROM stroke_prediction WHERE stroke = 1 ;

 -- Average Age Per Stroke --

 SELECT stroke, ROUND(AVG(age), 0 ) AS average_age
 FROM stroke_prediction
 GROUP BY stroke;

-- Average Glucose Per Stroke --

 SELECT stroke, ROUND(AVG(avg_glucose_level), 0 ) AS average_glucose
 FROM stroke_prediction
 GROUP BY stroke;

 -- Distribution Of Work Per Stroke --

 SELECT work_type, COUNT(*) AS total_cases, SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) AS stroke_cases 
 FROM stroke_prediction
 GROUP BY work_type;

 -- Average Age Per Gender --

 DELETE FROM stroke_prediction
 WHERE gender = 'Other';

 SELECT gender, ROUND(AVG(age), 0 ) AS average_age
 FROM stroke_prediction
 GROUP BY gender;

 -- Distribution Of Cases Per Stroke --

 SELECT stroke, COUNT(*) AS count_stroke
 FROM stroke_prediction
 GROUP BY stroke;

 -- The Relationship Between Stroke and Hypertension --

 SELECT stroke,hypertension, COUNT(*) AS count_stroke
 FROM stroke_prediction
 GROUP BY stroke,hypertension ;

 -- Top 10 Ages Of Stroke --

 SELECT TOP 10 *
 FROM stroke_prediction
 WHERE stroke = 1
 ORDER BY age DESC ;
