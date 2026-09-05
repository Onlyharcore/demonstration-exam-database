-- Небольшой набор тестовых данных.

INSERT INTO educational_organizations
(organization_code, short_name, full_name, ogrn, inn, kpp, omsu, ate, address, contact_person, phone, email)
VALUES
('000101','Колледж №1','ГБПОУ Колледж №1','1027700000001','7701000001','770101001','Москва','ЦАО','Москва, ул. Учебная, д. 1','Иванов И.И.','+7 495 111-11-11','college1@example.ru'),
('000102','Колледж №2','ГБПОУ Колледж №2','1027700000002','7701000002','770101002','Москва','САО','Москва, ул. Северная, д. 2','Петров П.П.','+7 495 222-22-22','college2@example.ru'),
('000103','Колледж №3','ГБПОУ Колледж №3','1027700000003','7701000003','770101003','Москва','ВАО','Москва, ул. Восточная, д. 3','Сидоров С.С.','+7 495 333-33-33','college3@example.ru'),
('000104','Колледж №4','ГБПОУ Колледж №4','1027700000004','7701000004','770101004','Москва','ЮАО','Москва, ул. Южная, д. 4','Орлова О.О.','+7 495 444-44-44','college4@example.ru'),
('000105','Колледж №5','ГБПОУ Колледж №5','1027700000005','7701000005','770101005','Москва','ЗАО','Москва, ул. Западная, д. 5','Кузнецов К.И.','+7 495 555-55-55','college5@example.ru');

INSERT INTO ugs (code,name) VALUES
('09.00.00','Информатика и вычислительная техника'),
('38.00.00','Экономика и управление');

INSERT INTO specialties (ugs_id,code,name,status) VALUES
(1,'09.02.07','Информационные системы и программирование','Активна'),
(1,'09.02.01','Компьютерные системы и комплексы','Активна'),
(2,'38.02.01','Экономика и бухгалтерский учет','Активна');

INSERT INTO exam_centers
(organization_id,center_code,name,omsu,ate,address,inn,kpp,phone,email,status) VALUES
(1,'CPDE-001','ЦПДЭ №1','Москва','ЦАО','Москва, ул. Учебная, д. 1','7701000001','770101001','+7 495 111-11-11','cpde1@example.ru','Активен'),
(2,'CPDE-002','ЦПДЭ №2','Москва','САО','Москва, ул. Северная, д. 2','7701000002','770101002','+7 495 222-22-22','cpde2@example.ru','Активен'),
(3,'CPDE-003','ЦПДЭ №3','Москва','ВАО','Москва, ул. Восточная, д. 3','7701000003','770101003','+7 495 333-33-33','cpde3@example.ru','Активен');

INSERT INTO auditorium_types (name,description) VALUES
('Компьютерная','Аудитория с ПК'),
('Практическая','Аудитория для практических работ'),
('Универсальная','Аудитория общего назначения');

INSERT INTO auditoriums
(center_id,auditorium_type_id,number,name,floor,capacity,computer_count,has_video_surveillance,seating_principle,subject_specialization) VALUES
(1,1,'101','Компьютерный класс 101',1,12,12,TRUE,'Общая','Программирование'),
(1,2,'105','Практическая лаборатория',1,12,4,TRUE,'Общая','Практика'),
(2,1,'201','Компьютерный класс 201',2,12,12,TRUE,'Общая','Информационные системы'),
(2,3,'205','Универсальная аудитория',2,12,6,FALSE,'Общая',NULL),
(3,1,'301','Компьютерный класс 301',3,12,12,TRUE,'Общая','Экономика'),
(3,2,'305','Практическая аудитория',3,12,4,TRUE,'Общая','Практика');

INSERT INTO auditorium_seats (auditorium_id,seat_number,row_number,is_unused)
SELECT a.auditorium_id, gs::VARCHAR, ((gs-1)/4)+1, FALSE
FROM auditoriums a CROSS JOIN generate_series(1,12) gs;

INSERT INTO students
(organization_id,specialty_id,last_name,first_name,middle_name,birth_date,gender,citizenship,
 document_type,document_series,document_number,snils,email,study_form,course,status)
SELECT
    ((n-1)%5)+1,
    ((n-1)/20)+1,
    'Фамилия'||n,
    'Имя'||n,
    'Отчество'||n,
    DATE '2006-01-01' + n,
    CASE WHEN n%2=0 THEN 'Мужской' ELSE 'Женский' END,
    'Российская Федерация',
    'Паспорт РФ',
    LPAD((4500+n)::TEXT,4,'0'),
    LPAD((100000+n)::TEXT,6,'0'),
    LPAD((10000000000+n)::TEXT,11,'0'),
    'student'||n||'@example.ru',
    'Очная',
    4,
    'Активен'
FROM generate_series(1,60) n;

INSERT INTO exams
(specialty_id,name,kim_code,exam_level,duration_minutes,exam_year,status) VALUES
(1,'Демонстрационный экзамен 09.02.07','KIM-090207-2026','Базовый',240,2026,'Активен'),
(2,'Демонстрационный экзамен 09.02.01','KIM-090201-2026','Профильный',240,2026,'Активен'),
(3,'Демонстрационный экзамен 38.02.01','KIM-380201-2026','Базовый',180,2026,'Активен');

INSERT INTO exam_sessions
(exam_id,center_id,auditorium_id,exam_date,start_time,end_time,status) VALUES
(1,1,1,'2026-06-01','09:00','13:00','Завершена'),
(1,1,2,'2026-06-02','09:00','13:00','Завершена'),
(2,2,3,'2026-06-03','09:00','13:00','Завершена'),
(2,2,4,'2026-06-04','09:00','13:00','Завершена'),
(3,3,5,'2026-06-05','09:00','12:00','Завершена'),
(3,3,6,'2026-06-06','09:00','12:00','Завершена');

INSERT INTO registrations (student_id,session_id,seat_id,registration_date,status)
SELECT
    s.student_id,
    CASE
        WHEN s.specialty_id=1 AND ((s.student_id-1)%20)<10 THEN 1
        WHEN s.specialty_id=1 THEN 2
        WHEN s.specialty_id=2 AND ((s.student_id-1)%20)<10 THEN 3
        WHEN s.specialty_id=2 THEN 4
        WHEN s.specialty_id=3 AND ((s.student_id-1)%20)<10 THEN 5
        ELSE 6
    END,
    (
        SELECT seat_id
        FROM auditorium_seats x
        WHERE x.auditorium_id =
            CASE
                WHEN s.specialty_id=1 AND ((s.student_id-1)%20)<10 THEN 1
                WHEN s.specialty_id=1 THEN 2
                WHEN s.specialty_id=2 AND ((s.student_id-1)%20)<10 THEN 3
                WHEN s.specialty_id=2 THEN 4
                WHEN s.specialty_id=3 AND ((s.student_id-1)%20)<10 THEN 5
                ELSE 6
            END
          AND x.seat_number = ((((s.student_id-1)%10)+1)::VARCHAR)
    ),
    TIMESTAMP '2026-05-20 10:00:00',
    'Завершил'
FROM students s;

INSERT INTO exam_results
(registration_id,score,max_score,passed,completed_at,status)
SELECT
    r.registration_id,
    55 + ((r.registration_id*7)%40),
    100,
    (55 + ((r.registration_id*7)%40)) >= 60,
    TIMESTAMP '2026-06-10 13:00:00' + (r.registration_id || ' minutes')::INTERVAL,
    'Получен'
FROM registrations r;

INSERT INTO task_results
(result_id,task_number,task_type,max_score,score,requires_expert_review)
SELECT
    er.result_id,
    t.task_number,
    CASE WHEN t.task_number=3 THEN 'Развернутый ответ' ELSE 'Краткий ответ' END,
    CASE WHEN t.task_number=3 THEN 20 ELSE 10 END,
    CASE
        WHEN t.task_number=1 THEN 5 + ((er.result_id*3)%6)
        WHEN t.task_number=2 THEN 4 + ((er.result_id*5)%7)
        ELSE 10 + ((er.result_id*7)%11)
    END,
    t.task_number=3
FROM exam_results er
CROSS JOIN (VALUES (1),(2),(3)) AS t(task_number);

INSERT INTO task_criterion_results
(task_result_id,criterion_code,max_score,score)
SELECT
    tr.task_result_id,
    c.criterion_code,
    10,
    CASE
        WHEN c.criterion_code='К1' THEN LEAST(10,ROUND(tr.score/2))
        ELSE LEAST(10,tr.score-ROUND(tr.score/2))
    END
FROM task_results tr
CROSS JOIN (VALUES ('К1'),('К2')) AS c(criterion_code)
WHERE tr.requires_expert_review=TRUE;

INSERT INTO practice_results
(result_id,practice_number,practice_type,max_score,score)
SELECT
    er.result_id,
    1,
    'Практическая работа',
    60,
    30 + ((er.result_id*11)%31)
FROM exam_results er;
