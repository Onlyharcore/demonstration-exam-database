-- Аналитика 4: средний процент выполнения заданий.

SELECT
    task_number,
    task_type,
    COUNT(*) AS results_count,
    ROUND(AVG(score*100.0/max_score),2) AS average_task_percent
FROM task_results
GROUP BY task_number,task_type
ORDER BY task_number;
