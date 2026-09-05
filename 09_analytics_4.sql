-- Аналитика 4: средний процент выполнения заданий.

SELECT
    task_number AS "Номер задания",
    task_type AS "Тип задания",
    COUNT(*) AS "Количество результатов",
    ROUND(AVG(score * 100.0 / max_score), 2) AS "Средний процент выполнения, %"
FROM task_results
GROUP BY task_number, task_type
ORDER BY "Номер задания";
