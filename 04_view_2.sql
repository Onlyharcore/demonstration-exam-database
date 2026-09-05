-- VIEW 2: агрегированная статистика по специальностям.

CREATE OR REPLACE VIEW vw_specialty_statistics AS
SELECT
    sp.code AS specialty_code,
    sp.name AS specialty_name,
    COUNT(er.result_id) AS participants_count,
    ROUND(AVG(er.score*100.0/er.max_score),2) AS average_score_percent,
    COUNT(*) FILTER (WHERE er.passed=TRUE) AS passed_count,
    ROUND(COUNT(*) FILTER (WHERE er.passed=TRUE)*100.0/COUNT(*),2) AS pass_rate_percent
FROM specialties sp
JOIN students s ON s.specialty_id=sp.specialty_id
JOIN registrations r ON r.student_id=s.student_id
JOIN exam_results er ON er.registration_id=r.registration_id
GROUP BY sp.code,sp.name;
