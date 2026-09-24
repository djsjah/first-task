CREATE TABLE positions (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE departments (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE document_types (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE employees (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    internal_id VARCHAR(255) NOT NULL UNIQUE,
    surname VARCHAR(128) NOT NULL,
    name VARCHAR(128) NOT NULL,
    patronymic VARCHAR(128),
    email VARCHAR(255) NOT NULL UNIQUE,
    birth_date DATE NOT NULL,
    position_id BIGINT NOT NULL REFERENCES positions(id)
);

CREATE TABLE documents (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    number VARCHAR(255) NOT NULL,
    issuing_organization VARCHAR(255) NOT NULL,
    issue_date DATE NOT NULL,
    employee_id BIGINT NOT NULL REFERENCES employees(id),
    document_type_id BIGINT NOT NULL REFERENCES document_types(id),

    UNIQUE (document_type_id, number)
);

CREATE TABLE employee_departments (
    employee_id BIGINT NOT NULL REFERENCES employees(id),
    department_id BIGINT NOT NULL REFERENCES departments(id),

    PRIMARY KEY (employee_id, department_id)
);

CREATE INDEX idx_employees_position_id ON employees(position_id);

CREATE INDEX idx_employee_departments_department_id ON employee_departments(department_id);

CREATE INDEX idx_documents_issue_date ON documents(issue_date);

CREATE INDEX idx_documents_employee_id ON documents(employee_id);

CREATE INDEX idx_employees_surname_name ON employees(surname, name);