-- Аналитика 5: статистика по экзаменам.

SELECT
    e.name AS "Экзамен",
    e.exam_level AS "Уровень экзамена",
    COUNT(er.result_id) AS "Количество участников",
    ROUND(AVG(er.score * 100.0 / er.max_score), 2) AS "Средний результат, %",
    ROUND(COUNT(*) FILTER (WHERE er.passed = TRUE) * 100.0 / COUNT(*), 2) AS "Доля сдавших, %"
FROM exams e
JOIN exam_sessions es ON es.exam_id = e.exam_id
JOIN registrations r ON r.session_id = es.session_id
JOIN exam_results er ON er.registration_id = r.registration_id
GROUP BY e.exam_id, e.name, e.exam_level
ORDER BY "Средний результат, %" DESC;
