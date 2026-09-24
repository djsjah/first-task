/*
Задание 1. Поиск сотрудников по характеристике с сортировкой

В моей схеме сотрудник связан со своими документами отношением one-to-many через поле documents.employee_id, 
поэтому я делаю JOIN employees с documents.
Тип документа хранится отдельно в таблице document_types, поэтому documents дополнительно соединяется с document_types по document_type_id.
*/

SELECT
    CONCAT_WS(' ', e.surname, e.name, e.patronymic) AS full_name,
    dt.name,
    d.number,
    d.issue_date
FROM employees e
INNER JOIN documents d ON e.id = d.employee_id
INNER JOIN document_types dt ON d.document_type_id = dt.id
WHERE d.issue_date >= DATE '2023-01-01'
ORDER BY e.surname, d.issue_date DESC;

/*
Задание 2. Анализ распределения сотрудников по департаментам

В моей схеме связь сотрудников с департаментами реализована через отношение many-to-many по таблице employee_departments, поэтому я соединяю
departments с employees через employee_departments.
Должность сотрудника хранится отдельно в таблице positions и связана с employees через position_id, 
поэтому дополнительно делаю JOIN с positions.
*/

SELECT
    d.name,
    p.name,
    COUNT(*) AS employee_count
FROM departments d
INNER JOIN employee_departments ed ON d.id = ed.department_id
INNER JOIN employees e ON ed.employee_id = e.id
INNER JOIN positions p ON e.position_id = p.id
GROUP BY d.name, p.name
ORDER BY d.name, employee_count DESC;

/*
Задание 3. Выявление перегруженных и недогруженных департаментов

В моей схеме связь сотрудников с департаментами реализована через таблицу employee_departments, 
поэтому я соединяю departments с employees через неё.
Из employees я использую birth_date для расчёта среднего возраста и position_id для подсчёта количества уникальных должностей. 
*/

SELECT
    d.name,
    COUNT(*) AS employee_count,
    ROUND(
        AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.birth_date)))
    ) AS average_age,
    COUNT(DISTINCT e.position_id) AS unique_position_count
FROM departments d 
INNER JOIN employee_departments ed ON d.id = ed.department_id
INNER JOIN employees e ON ed.employee_id = e.id
GROUP BY d.name
HAVING COUNT(*) > 10 OR COUNT(*) = 1
ORDER BY employee_count DESC, d.name;