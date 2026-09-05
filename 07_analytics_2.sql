-- Аналитика 2: результаты по образовательным организациям.

SELECT
    eo.short_name AS organization_name,
    COUNT(er.result_id) AS participants_count,
    ROUND(AVG(er.score*100.0/er.max_score),2) AS average_score_percent,
    COUNT(*) FILTER (WHERE er.passed=TRUE) AS passed_count
FROM educational_organizations eo
JOIN students s ON s.organization_id=eo.organization_id
JOIN registrations r ON r.student_id=s.student_id
JOIN exam_results er ON er.registration_id=r.registration_id
GROUP BY eo.organization_id,eo.short_name
ORDER BY average_score_percent DESC;
