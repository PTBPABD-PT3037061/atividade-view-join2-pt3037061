-- ==============================================================================
-- Questão 1
-- Lista de instrutores (ID, nome) e o número de secções ministradas.
-- Utiliza LEFT OUTER JOIN para incluir instrutores sem secções (contagem = 0).
-- ==============================================================================
SELECT 
    i.ID, 
    i.name, 
    COUNT(t.sec_id) AS [Number of sections]
FROM 
    instructor i
LEFT OUTER JOIN 
    teaches t ON i.ID = t.ID
GROUP BY 
    i.ID, 
    i.name;


-- ==============================================================================
-- Questão 2
-- Mesma lista da Questão 1, mas utilizando uma subconsulta escalar.
-- ==============================================================================
SELECT 
    i.ID, 
    i.name, 
    (SELECT COUNT(*) 
     FROM teaches t 
     WHERE t.ID = i.ID) AS [Number of sections]
FROM 
    instructor i;


-- ==============================================================================
-- Questão 3
-- Lista de todas as secções oferecidas na primavera (Spring) de 2010.
-- Se não houver instrutor, a função COALESCE garante que é devolvido "-".
-- ==============================================================================
SELECT 
    s.course_id, 
    s.sec_id, 
    t.ID, 
    s.semester, 
    s.year, 
    COALESCE(i.name, '-') AS name
FROM 
    section s
LEFT OUTER JOIN 
    teaches t ON s.course_id = t.course_id 
             AND s.sec_id = t.sec_id 
             AND s.semester = t.semester 
             AND s.year = t.year
LEFT OUTER JOIN 
    instructor i ON t.ID = i.ID
WHERE 
    s.semester = 'Spring' 
    AND s.year = 2010;


-- ==============================================================================
-- Questão 4
-- Simula o comportamento do NATURAL JOIN que gerou a imagem de gabarito,
-- filtrando apenas os cursos que são do mesmo departamento do aluno
-- (AND s.dept_name = c.dept_name).
-- ==============================================================================
SELECT 
    s.ID, 
    s.name, 
    c.title, 
    c.dept_name, 
    t.grade, 
    CAST(CASE t.grade 
        WHEN 'A+' THEN 4.0 WHEN 'A' THEN 3.7 WHEN 'A-' THEN 3.3 
        WHEN 'B+' THEN 3.0 WHEN 'B' THEN 2.7 WHEN 'B-' THEN 2.3 
        WHEN 'C+' THEN 2.0 WHEN 'C' THEN 1.7 WHEN 'C-' THEN 1.3 
        WHEN 'D+' THEN 1.0 WHEN 'D' THEN 0.7 WHEN 'D-' THEN 0.3 
        WHEN 'F' THEN 0.0 
    END AS FLOAT) AS points,
    c.credits, 
    CAST(CASE t.grade 
        WHEN 'A+' THEN 4.0 WHEN 'A' THEN 3.7 WHEN 'A-' THEN 3.3 
        WHEN 'B+' THEN 3.0 WHEN 'B' THEN 2.7 WHEN 'B-' THEN 2.3 
        WHEN 'C+' THEN 2.0 WHEN 'C' THEN 1.7 WHEN 'C-' THEN 1.3 
        WHEN 'D+' THEN 1.0 WHEN 'D' THEN 0.7 WHEN 'D-' THEN 0.3 
        WHEN 'F' THEN 0.0 
    END * c.credits AS FLOAT) AS [Pontos totais]
FROM 
    student s
JOIN 
    takes t ON s.ID = t.ID
JOIN 
    course c ON t.course_id = c.course_id
WHERE 
    t.grade IS NOT NULL
    AND s.dept_name = c.dept_name
ORDER BY 
    s.ID;


-- ==============================================================================
-- Questão 5
-- Criação da view baseada na consulta da Questão 4, com a mesma regra de
-- departamento. (Views no SQL Server não aceitam ORDER BY, por isso foi omitido).
-- ==============================================================================
CREATE VIEW coeficiente_rendimento AS
SELECT 
    s.ID, 
    s.name, 
    c.title, 
    c.dept_name, 
    t.grade, 
    CAST(CASE t.grade 
        WHEN 'A+' THEN 4.0 WHEN 'A' THEN 3.7 WHEN 'A-' THEN 3.3 
        WHEN 'B+' THEN 3.0 WHEN 'B' THEN 2.7 WHEN 'B-' THEN 2.3 
        WHEN 'C+' THEN 2.0 WHEN 'C' THEN 1.7 WHEN 'C-' THEN 1.3 
        WHEN 'D+' THEN 1.0 WHEN 'D' THEN 0.7 WHEN 'D-' THEN 0.3 
        WHEN 'F' THEN 0.0 
    END AS FLOAT) AS points,
    c.credits, 
    CAST(CASE t.grade 
        WHEN 'A+' THEN 4.0 WHEN 'A' THEN 3.7 WHEN 'A-' THEN 3.3 
        WHEN 'B+' THEN 3.0 WHEN 'B' THEN 2.7 WHEN 'B-' THEN 2.3 
        WHEN 'C+' THEN 2.0 WHEN 'C' THEN 1.7 WHEN 'C-' THEN 1.3 
        WHEN 'D+' THEN 1.0 WHEN 'D' THEN 0.7 WHEN 'D-' THEN 0.3 
        WHEN 'F' THEN 0.0 
    END * c.credits AS FLOAT) AS [Pontos totais]
FROM 
    student s
JOIN 
    takes t ON s.ID = t.ID
JOIN 
    course c ON t.course_id = c.course_id
WHERE 
    t.grade IS NOT NULL
    AND s.dept_name = c.dept_name;