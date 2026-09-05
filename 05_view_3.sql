-- VIEW 3: общая статистика по центрам проведения.

CREATE OR REPLACE VIEW vw_center_statistics AS
SELECT
    ec.center_code,
    ec.name AS center_name,
    COUNT(DISTINCT es.session_id) AS sessions_count,
    COUNT(er.result_id) AS participants_count,
    ROUND(AVG(er.score*100.0/er.max_score),2) AS average_score_percent
FROM exam_centers ec
JOIN exam_sessions es ON es.center_id=ec.center_id
JOIN registrations r ON r.session_id=es.session_id
JOIN exam_results er ON er.registration_id=r.registration_id
GROUP BY ec.center_code,ec.name;
