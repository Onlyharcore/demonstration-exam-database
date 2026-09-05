-- Аналитика 5: статистика по экзаменам.

SELECT
    e.name AS exam_name,
    e.exam_level,
    COUNT(er.result_id) AS participants_count,
    ROUND(AVG(er.score*100.0/er.max_score),2) AS average_score_percent,
    ROUND(COUNT(*) FILTER (WHERE er.passed=TRUE)*100.0/COUNT(*),2) AS pass_rate_percent
FROM exams e
JOIN exam_sessions es ON es.exam_id=e.exam_id
JOIN registrations r ON r.session_id=es.session_id
JOIN exam_results er ON er.registration_id=r.registration_id
GROUP BY e.exam_id,e.name,e.exam_level
ORDER BY average_score_percent DESC;
