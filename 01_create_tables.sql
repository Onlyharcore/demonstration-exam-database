-- Создание таблиц. PostgreSQL

DROP TABLE IF EXISTS practice_results CASCADE;
DROP TABLE IF EXISTS task_criterion_results CASCADE;
DROP TABLE IF EXISTS task_results CASCADE;
DROP TABLE IF EXISTS exam_results CASCADE;
DROP TABLE IF EXISTS registrations CASCADE;
DROP TABLE IF EXISTS exam_sessions CASCADE;
DROP TABLE IF EXISTS exams CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS auditorium_seats CASCADE;
DROP TABLE IF EXISTS auditoriums CASCADE;
DROP TABLE IF EXISTS auditorium_types CASCADE;
DROP TABLE IF EXISTS exam_centers CASCADE;
DROP TABLE IF EXISTS specialties CASCADE;
DROP TABLE IF EXISTS ugs CASCADE;
DROP TABLE IF EXISTS educational_organizations CASCADE;

CREATE TABLE educational_organizations (
    organization_id BIGSERIAL PRIMARY KEY,
    organization_code VARCHAR(6) UNIQUE NOT NULL,
    short_name VARCHAR(255) NOT NULL,
    full_name VARCHAR(500) NOT NULL,
    ogrn VARCHAR(15), inn VARCHAR(12), kpp VARCHAR(9),
    omsu VARCHAR(255), ate VARCHAR(255),
    address VARCHAR(500) NOT NULL,
    contact_person VARCHAR(255), phone VARCHAR(50), email VARCHAR(255)
);

CREATE TABLE ugs (
    ugs_id SERIAL PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE specialties (
    specialty_id SERIAL PRIMARY KEY,
    ugs_id INTEGER NOT NULL REFERENCES ugs(ugs_id),
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(500) NOT NULL,
    status VARCHAR(30) NOT NULL
);

CREATE TABLE exam_centers (
    center_id SERIAL PRIMARY KEY,
    organization_id BIGINT REFERENCES educational_organizations(organization_id),
    center_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    omsu VARCHAR(255), ate VARCHAR(255),
    address VARCHAR(500) NOT NULL,
    inn VARCHAR(12), kpp VARCHAR(9), phone VARCHAR(50), email VARCHAR(255),
    status VARCHAR(30) NOT NULL
);

CREATE TABLE auditorium_types (
    auditorium_type_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description VARCHAR(500)
);

CREATE TABLE auditoriums (
    auditorium_id SERIAL PRIMARY KEY,
    center_id INTEGER NOT NULL REFERENCES exam_centers(center_id),
    auditorium_type_id INTEGER NOT NULL REFERENCES auditorium_types(auditorium_type_id),
    number VARCHAR(50) NOT NULL,
    name VARCHAR(255),
    floor INTEGER NOT NULL,
    capacity INTEGER NOT NULL CHECK (capacity >= 0),
    computer_count INTEGER CHECK (computer_count IS NULL OR computer_count >= 0),
    has_video_surveillance BOOLEAN NOT NULL,
    seating_principle VARCHAR(50),
    subject_specialization VARCHAR(255)
);

CREATE TABLE auditorium_seats (
    seat_id SERIAL PRIMARY KEY,
    auditorium_id INTEGER NOT NULL REFERENCES auditoriums(auditorium_id),
    seat_number VARCHAR(20) NOT NULL,
    row_number INTEGER NOT NULL,
    is_unused BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE (auditorium_id, seat_number)
);

CREATE TABLE students (
    student_id BIGSERIAL PRIMARY KEY,
    organization_id BIGINT NOT NULL REFERENCES educational_organizations(organization_id),
    specialty_id INTEGER NOT NULL REFERENCES specialties(specialty_id),
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100),
    birth_date DATE NOT NULL,
    gender VARCHAR(20),
    citizenship VARCHAR(100),
    document_type VARCHAR(50),
    document_series VARCHAR(20),
    document_number VARCHAR(30),
    snils VARCHAR(20) UNIQUE,
    email VARCHAR(255),
    study_form VARCHAR(30),
    course INTEGER,
    status VARCHAR(30) NOT NULL
);

CREATE TABLE exams (
    exam_id SERIAL PRIMARY KEY,
    specialty_id INTEGER NOT NULL REFERENCES specialties(specialty_id),
    name VARCHAR(255) NOT NULL,
    kim_code VARCHAR(50) NOT NULL,
    exam_level VARCHAR(30) NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    exam_year INTEGER NOT NULL,
    status VARCHAR(30) NOT NULL
);

CREATE TABLE exam_sessions (
    session_id BIGSERIAL PRIMARY KEY,
    exam_id INTEGER NOT NULL REFERENCES exams(exam_id),
    center_id INTEGER NOT NULL REFERENCES exam_centers(center_id),
    auditorium_id INTEGER NOT NULL REFERENCES auditoriums(auditorium_id),
    exam_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME,
    status VARCHAR(30) NOT NULL
);

CREATE TABLE registrations (
    registration_id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES students(student_id),
    session_id BIGINT NOT NULL REFERENCES exam_sessions(session_id),
    seat_id INTEGER REFERENCES auditorium_seats(seat_id),
    registration_date TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL,
    UNIQUE (student_id, session_id)
);

CREATE TABLE exam_results (
    result_id BIGSERIAL PRIMARY KEY,
    registration_id BIGINT UNIQUE NOT NULL REFERENCES registrations(registration_id),
    score NUMERIC(6,2) NOT NULL,
    max_score NUMERIC(6,2) NOT NULL CHECK (max_score > 0),
    passed BOOLEAN NOT NULL,
    completed_at TIMESTAMP,
    status VARCHAR(30) NOT NULL,
    CHECK (score >= 0 AND score <= max_score)
);

CREATE TABLE task_results (
    task_result_id BIGSERIAL PRIMARY KEY,
    result_id BIGINT NOT NULL REFERENCES exam_results(result_id),
    task_number INTEGER NOT NULL,
    task_type VARCHAR(30) NOT NULL,
    max_score NUMERIC(6,2) NOT NULL CHECK (max_score > 0),
    score NUMERIC(6,2) NOT NULL,
    requires_expert_review BOOLEAN NOT NULL DEFAULT FALSE,
    CHECK (score >= 0 AND score <= max_score),
    UNIQUE (result_id, task_number)
);

CREATE TABLE task_criterion_results (
    criterion_result_id BIGSERIAL PRIMARY KEY,
    task_result_id BIGINT NOT NULL REFERENCES task_results(task_result_id),
    criterion_code VARCHAR(20) NOT NULL,
    max_score NUMERIC(6,2) NOT NULL CHECK (max_score > 0),
    score NUMERIC(6,2) NOT NULL,
    CHECK (score >= 0 AND score <= max_score),
    UNIQUE (task_result_id, criterion_code)
);

CREATE TABLE practice_results (
    practice_result_id BIGSERIAL PRIMARY KEY,
    result_id BIGINT NOT NULL REFERENCES exam_results(result_id),
    practice_number INTEGER NOT NULL,
    practice_type VARCHAR(50),
    max_score NUMERIC(6,2) NOT NULL CHECK (max_score > 0),
    score NUMERIC(6,2) NOT NULL,
    CHECK (score >= 0 AND score <= max_score),
    UNIQUE (result_id, practice_number)
);
