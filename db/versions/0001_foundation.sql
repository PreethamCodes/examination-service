CREATE SCHEMA IF NOT EXISTS examination;
SET LOCAL search_path TO examination, pg_catalog;
CREATE ROLE examination_runtime NOLOGIN;
REVOKE ALL ON SCHEMA examination FROM PUBLIC;
GRANT USAGE ON SCHEMA examination TO examination_runtime;

CREATE TABLE examination_students (
    student_id text primary key
);
ALTER TABLE examination_students ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE ON examination_students TO examination_runtime;
CREATE POLICY service_access ON examination_students TO examination_runtime USING (true) WITH CHECK (true);

CREATE TABLE examination_results (
    id text primary key,
    student_id text not null references examination_students,
    level text not null check(level in ('SSC','INTERMEDIATE')),
    total_marks int not null check(total_marks >= 0),
    maximum_marks int not null check(maximum_marks > 0 and total_marks <= maximum_marks),
    result_status text not null check(result_status in ('PASS','FAIL','WITHHELD')),
    exam_year int not null check(exam_year between 1900 and 2200),
    updated_at timestamptz not null default now(),
    unique(student_id,level,exam_year)
);
ALTER TABLE examination_results ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE ON examination_results TO examination_runtime;
CREATE POLICY service_access ON examination_results TO examination_runtime USING (true) WITH CHECK (true);
CREATE INDEX ON examination_results (student_id);

CREATE TABLE examination_certificates (
    certificate_ref text primary key,
    result_id text unique not null references examination_results
);
ALTER TABLE examination_certificates ENABLE ROW LEVEL SECURITY;
GRANT SELECT, INSERT, UPDATE ON examination_certificates TO examination_runtime;
CREATE POLICY service_access ON examination_certificates TO examination_runtime USING (true) WITH CHECK (true);
GRANT USAGE ON ALL SEQUENCES IN SCHEMA examination TO examination_runtime;
