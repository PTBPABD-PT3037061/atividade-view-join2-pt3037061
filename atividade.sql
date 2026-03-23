-- Questão 1
-- Gere uma lista de todos os instrutores, mostrando sua ID, nome e número de seções que eles ministraram. Não se esqueça de mostrar o número de seções como 0 
-- para os instrutores que não ministraram qualquer seção. Sua consulta deverá utilizar outer join e não deverá utilizar subconsultas escalares.
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


-- Questão 2
-- Escreva a mesma consulta do item anterior, mas usando uma subconsulta escalar, sem outer join.

SELECT 
    i.ID, 
    i.name, 
    (SELECT COUNT(*) 
     FROM teaches t 
     WHERE t.ID = i.ID) AS [Number of sections]
FROM 
    instructor i;


-- Questão 3
-- Gere a lista de todas as seções de curso oferecidas na primavera de 2010, junto com o nome dos
-- instrutores ministrando a seção. Se uma seção tiver mais de 1 instrutor, ela deverá aparecer
-- uma vez no resultado para cada instrutor. Se não tiver instrutor algum, ela ainda deverá
-- aparecer no resultado, com o nome do instrutor definido como “-”.
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


-- Questão 4
-- Suponha que você tenha recebido uma relação grade_points (grade, points), que oferece uma 
-- conversão de conceitos (letras) na relação takes para notas numéricas; por exemplo, uma 
-- nota “A+” poderia ser especificada para corresponder a 4 pontos, um “A” para 3,7 pontos,
-- e “A-” para 3,4, e “B+” para 3,1 pontos, e assim por diante. 
-- Os Pontos totais obtidos por um aluno para uma oferta de curso (section) são definidos
-- como o número de créditos para o curso multiplicado pelos pontos numéricos para a nota que o aluno recebeu.
-- Dada essa relação e o nosso esquema university, escreva: 
-- Ache os pontos totais recebidos por aluno, para todos os cursos realizados por ele.
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


-- Questão 5
-- Crie uma view a partir do resultado da Questão 4 com o nome “coeficiente_rendimento”.
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
