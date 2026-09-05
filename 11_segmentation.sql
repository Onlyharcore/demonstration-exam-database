-- Сегментация = разделение участников на группы по уровню результата.
-- Агрегация = подсчёт количества участников и среднего результата внутри каждой группы.

WITH student_segments AS (
    SELECT
        er.result_id,
        er.score*100.0/er.max_score AS score_percent,
        CASE
            WHEN er.score*100.0/er.max_score >= 80 THEN 'Высокий результат'
            WHEN er.score*100.0/er.max_score >= 60 THEN 'Средний результат'
            ELSE 'Низкий результат'
        END AS result_segment
    FROM exam_results er
)
SELECT
    result_segment,
    COUNT(*) AS participants_count,
    ROUND(AVG(score_percent),2) AS average_score_percent
FROM student_segments
GROUP BY result_segment
ORDER BY average_score_percent DESC;
