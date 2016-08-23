SELECT CONVERT(DATE, @your_date)
-- or
SELECT DATEADD(dd, 0, DATEDIFF(dd, 0, @your_date))