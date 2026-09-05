-- VIEW 1: сводные результаты участников.

CREATE OR REPLACE VIEW vw_student_results AS
SELECT
    s.student_id,
    CONCAT_WS(' ',s.last_name,s.first_name,s.middle_name) AS student_name,
    eo.short_name AS organization_name,
    sp.code AS specialty_code,
    sp.name AS specialty_name,
    e.name AS exam_name,
    es.exam_date,
    ec.name AS center_name,
    er.score,
    er.max_score,
    ROUND(er.score*100.0/er.max_score,2) AS score_percent,
    er.passed
FROM exam_results er
JOIN registrations r ON r.registration_id=er.registration_id
JOIN students s ON s.student_id=r.student_id
JOIN educational_organizations eo ON eo.organization_id=s.organization_id
JOIN specialties sp ON sp.specialty_id=s.specialty_id
JOIN exam_sessions es ON es.session_id=r.session_id
JOIN exams e ON e.exam_id=es.exam_id
JOIN exam_centers ec ON ec.center_id=es.center_id;
