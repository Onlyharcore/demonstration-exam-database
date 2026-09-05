-- Аналитика 1: результаты по специальностям.

SELECT
    sp.code AS "Код специальности",
    sp.name AS "Специальность",
    COUNT(er.result_id) AS "Количество участников",
    ROUND(AVG(er.score * 100.0 / er.max_score), 2) AS "Средний результат, %",
    ROUND(COUNT(*) FILTER (WHERE er.passed = TRUE) * 100.0 / COUNT(*), 2) AS "Доля сдавших, %"
FROM specialties sp
JOIN students s ON s.specialty_id = sp.specialty_id
JOIN registrations r ON r.student_id = s.student_id
JOIN exam_results er ON er.registration_id = r.registration_id
GROUP BY sp.code, sp.name
ORDER BY "Средний результат, %" DESC;
