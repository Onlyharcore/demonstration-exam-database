-- Аналитика 3: статистика по центрам проведения.

SELECT
    ec.center_code AS "Код центра",
    ec.name AS "Центр проведения",
    COUNT(DISTINCT es.session_id) AS "Количество сессий",
    COUNT(er.result_id) AS "Количество участников",
    ROUND(AVG(er.score * 100.0 / er.max_score), 2) AS "Средний результат, %"
FROM exam_centers ec
JOIN exam_sessions es ON es.center_id = ec.center_id
JOIN registrations r ON r.session_id = es.session_id
JOIN exam_results er ON er.registration_id = r.registration_id
GROUP BY ec.center_code, ec.name
ORDER BY "Количество участников" DESC;
