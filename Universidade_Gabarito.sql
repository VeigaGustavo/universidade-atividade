create table curso(
id_curso serial not null,
numcurso int not null,
nome varchar(40) not null,
totalcreditos int not null,
constraint curso_pk primary key (id_curso));

insert into curso values
(1, 2142, 'Engenharia Civil', 1500),
(2, 2143, 'Ciência da Computação', 2000),
(3, 2144, 'Direito', 1750),
(4, 2145, 'Pedagogia', 1500),
(5, 2146, 'Odontologia', 1600);

select setval ('curso_id_curso_seq', 5);

create table aluno(
numaluno serial not null,
nome varchar(80) not null,
endereco varchar(80) not null,
cidade varchar(80) not null,
telefone varchar(20) not null,
curso_fk int not null,
constraint aluno_pk primary key (numaluno),
constraint aluno_curso_fk foreign key (curso_fk) references curso(id_curso));

insert into aluno values
(1, 'Edvaldo Carlos Silva', '110 NORTE ALAMEDA 01', 'PALMAS', '(63)9999-9999',2),
(2, 'João Benedito Silva', '110 NORTE ALAMEDA 01', 'PALMAS', '(63)9999-9999',1),
(3, 'Carol Antônia Silveira', '110 NORTE ALAMEDA 01', 'PALMAS', '(63)9999-9999',4),
(4, 'Marcos João Oliveira', '110 NORTE ALAMEDA 01', 'PALMAS', '(63)9999-9999',2),
(5, 'Simone Cristina Lima', '110 NORTE ALAMEDA 01', 'PALMAS', '(63)9999-9999',3),
(6, 'Ailton Castro', '110 NORTE ALAMEDA 01', 'PALMAS', '(63)9999-9999',1),
(7, 'José Paulo Figueira', '110 NORTE ALAMEDA 01', 'PALMAS', '(63)9999-9999',4);

select setval('aluno_numaluno_seq', 7);

create table professor(
numprof serial not null,
nome varchar(80) not null,
areapesquisa varchar(80)not null,
constraint professor_pk primary key (numprof));

insert into professor values
(1, 'Abgair Simon Ferreira', 'Banco de Dados'),
(2, 'Ramon Travanti', 'Direito Romano'),
(3, 'Gustavo Golveia Netto', 'Sociologia'),
(4, 'Marcos Salvador', 'Matemática Financeira'),
(5, 'Cintia Falcão', 'Engenharia de Software'),
(6, 'Hernani Schwaitz', 'Química Orgânica');

select setval ('professor_numprof_seq', 6);

create table disciplina(
numdisp serial not null,
nome varchar(80) not null,
quantcreditos int not null,
constraint disciplina_pk primary key (numdisp));

insert into disciplina values
(1, 'Banco de Dados', 30),
(2, 'Estrutura de Dados', 30),
(3, 'Direito Penal', 25),
(4, 'Cálculo Numérico', 30),
(5, 'Psicologia Infantil', 25),
(6, 'Direito Tributário', 33),
(7, 'Engenharia de Software', 27);

select setval ('disciplina_numdisp_seq', 7);

create table aula(
aluno_fk int not null,
disciplina_fk int not null,
professor_fk int not null,
semestre varchar(7) not null,
nota int not null,
constraint aula_pk primary key (aluno_fk, disciplina_fk, professor_fk, semestre),
constraint aula_aluno_fk foreign key (aluno_fk) references aluno (numaluno),
constraint aula_disciplina_fk foreign key (disciplina_fk) references disciplina (numdisp),
constraint aula_professor_fk foreign key (professor_fk) references professor (numprof));

insert into aula values
(1,1,1,'01/1998',9),
(1,2,1,'01/1998',6),
(1,2,1,'02/1998',7),
(1,4,4,'01/1998',8),
(1,7,5,'01/1998',10),
(1,4,4,'02/1998',7),
(2,7,5,'01/1998',6),
(2,7,5,'02/1998',10),
(3,5,3,'01/1998',8),
(4,1,1,'01/1998',7),
(4,2,1,'01/1998',8),
(4,4,4,'01/1998',6),
(4,4,4,'02/1998',9),
(4,7,5,'01/1998',10),
(5,3,2,'01/1998',5),
(5,3,2,'02/1998',5),
(5,6,2,'01/1998',9),
(6,4,4,'01/1998',4),
(6,4,4,'02/1998',10),
(6,7,5,'01/1998',9);

create table disciplinacurso(
disciplina_fk int not null,
curso_fk int not null,
constraint disciplinacurso_pk primary key (disciplina_fk, curso_fk),
constraint disciplinacurso_disciplina_fk foreign key (disciplina_fk) references disciplina (numdisp),
constraint disciplinacurso_curso_fk foreign key (curso_fk) references curso (id_curso));

insert into disciplinacurso values
(4,1),
(7,1),
(1,2),
(2,2),
(4,2),
(7,2),
(3,3),
(6,3),
(5,4);

-- 1. Quais os nomes das disciplinas do curso de Ciência da Computação?
SELECT d.nome
FROM disciplina d
JOIN disciplinacurso dc ON d.numdisp = dc.disciplina_fk
JOIN curso c ON dc.curso_fk = c.id_curso
WHERE c.nome = 'Ciência da Computação';

-- 2. Quais os nomes dos cursos que possuem no currículo a disciplina Cálculo Numérico?
SELECT c.nome
FROM curso c
JOIN disciplinacurso dc ON c.id_curso = dc.curso_fk
JOIN disciplina d ON dc.disciplina_fk = d.numdisp
WHERE d.nome = 'Cálculo Numérico';

-- 3. Quais os nomes das disciplinas que o aluno Marcos João Oliveira cursou no 1o semestre de 1998?
SELECT d.nome
FROM disciplina d
JOIN aula a ON d.numdisp = a.disciplina_fk
JOIN aluno al ON a.aluno_fk = al.numaluno
WHERE al.nome = 'Marcos João Oliveira' AND a.semestre = '01/1998';

-- 4. Quais os nomes de disciplinas que o aluno Ailton Castro foi reprovado?
SELECT d.nome
FROM disciplina d
JOIN aula a ON d.numdisp = a.disciplina_fk
JOIN aluno al ON a.aluno_fk = al.numaluno
WHERE al.nome = 'Ailton Castro' AND a.nota < 6;

-- 5. Quais os nomes de alunos reprovados na disciplina de Cálculo Numérico no 1o semestre de 1998?
SELECT al.nome
FROM aluno al
JOIN aula a ON al.numaluno = a.aluno_fk
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE d.nome = 'Cálculo Numérico' AND a.semestre = '01/1998' AND a.nota < 6;

-- 6. Quais os nomes das disciplinas ministradas pelo prof. Ramon Travanti?
SELECT d.nome
FROM disciplina d
JOIN aula a ON d.numdisp = a.disciplina_fk
JOIN professor p ON a.professor_fk = p.numprof
WHERE p.nome = 'Ramon Travanti';

-- 7. Quais os nomes professores que já ministraram aula de Banco de Dados?
SELECT DISTINCT p.nome
FROM professor p
JOIN aula a ON p.numprof = a.professor_fk
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE d.nome = 'Banco de Dados';

-- 8. Qual a maior e a menor nota na disciplina de Cálculo Numérico no 1o semestre de 1998?
SELECT MAX(a.nota) AS maior_nota, MIN(a.nota) AS menor_nota
FROM aula a
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE d.nome = 'Cálculo Numérico' AND a.semestre = '01/1998';

-- 9. Qual o nome do aluno e nota que obteve maior nota na disciplina de Engenharia de Software no 1o semestre de 1998?
SELECT al.nome, a.nota
FROM aluno al
JOIN aula a ON al.numaluno = a.aluno_fk
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE d.nome = 'Engenharia de Software' AND a.semestre = '01/1998'
ORDER BY a.nota DESC
LIMIT 1;

-- 10. Quais nomes de alunos, nome de disciplina e nome de professores que cursaram o 1o semestre de 1998 em ordem de aluno?
SELECT al.nome AS aluno, d.nome AS disciplina, p.nome AS professor
FROM aula a
JOIN aluno al ON a.aluno_fk = al.numaluno
JOIN disciplina d ON a.disciplina_fk = d.numdisp
JOIN professor p ON a.professor_fk = p.numprof
WHERE a.semestre = '01/1998'
ORDER BY al.nome;

-- 11. Quais nomes de alunos, nome de disciplina e notas do 1o semestre de 1998 no curso de Ciência da Computação?
SELECT al.nome AS aluno, d.nome AS disciplina, a.nota
FROM aula a
JOIN aluno al ON a.aluno_fk = al.numaluno
JOIN disciplina d ON a.disciplina_fk = d.numdisp
JOIN disciplinacurso dc ON d.numdisp = dc.disciplina_fk
JOIN curso c ON dc.curso_fk = c.id_curso
WHERE c.nome = 'Ciência da Computação' AND a.semestre = '01/1998';

-- 12. Qual a média de notas do professor Marcos Salvador?
SELECT AVG(a.nota) AS media_notas
FROM aula a
JOIN professor p ON a.professor_fk = p.numprof
WHERE p.nome = 'Marcos Salvador';

-- 13. Quais nomes de alunos, nomes de disciplinas e notas que tiveram nota entre 5.0 e 7.0 em ordem de disciplina?
SELECT al.nome AS aluno, d.nome AS disciplina, a.nota
FROM aula a
JOIN aluno al ON a.aluno_fk = al.numaluno
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE a.nota BETWEEN 5.0 AND 7.0
ORDER BY d.nome;

-- 14. Qual a média de notas da disciplina Cálculo Numérico no 1o semestre de 1998?
SELECT AVG(a.nota) AS media_notas
FROM aula a
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE d.nome = 'Cálculo Numérico' AND a.semestre = '01/1998';

-- 15. Quantos alunos o professor Abgair teve no 1o semestre de 1998?
SELECT COUNT(DISTINCT a.aluno_fk) AS quantidade_alunos
FROM aula a
JOIN professor p ON a.professor_fk = p.numprof
WHERE p.nome = 'Abgair Simon Ferreira' AND a.semestre = '01/1998';

-- 16. Qual a média de notas do aluno Edvaldo Carlos Silva?
SELECT AVG(a.nota) AS media_notas
FROM aula a
JOIN aluno al ON a.aluno_fk = al.numaluno
WHERE al.nome = 'Edvaldo Carlos Silva';

-- 17. Quais as médias por nome de disciplina de todos os cursos do 1o semestre de 1998 em ordem de disciplina?
SELECT d.nome AS disciplina, AVG(a.nota) AS media_notas
FROM aula a
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE a.semestre = '01/1998'
GROUP BY d.nome
ORDER BY d.nome;

-- 18. Quais as médias das notas por nome de professor no 1o semestre de 1998?
SELECT p.nome AS professor, AVG(a.nota) AS media_notas
FROM aula a
JOIN professor p ON a.professor_fk = p.numprof
WHERE a.semestre = '01/1998'
GROUP BY p.nome;

-- 19. Qual a média por disciplina no 1o semestre de 1998 do curso de Ciência da Computação?
SELECT d.nome AS disciplina, AVG(a.nota) AS media_notas
FROM aula a
JOIN disciplina d ON a.disciplina_fk = d.numdisp
JOIN disciplinacurso dc ON d.numdisp = dc.disciplina_fk
JOIN curso c ON dc.curso_fk = c.id_curso
WHERE c.nome = 'Ciência da Computação' AND a.semestre = '01/1998'
GROUP BY d.nome;

-- 20. Qual foi a quantidade de créditos concluídos (somente as disciplinas aprovadas) do aluno Edvaldo Carlos Silva?
SELECT SUM(d.quantcreditos) AS total_creditos
FROM aula a
JOIN disciplina d ON a.disciplina_fk = d.numdisp
JOIN aluno al ON a.aluno_fk = al.numaluno
WHERE al.nome = 'Edvaldo Carlos Silva' AND a.nota >= 6;

-- 21. Quais nomes de alunos e quantidade de créditos que já completaram 70 créditos (somente os aprovados na disciplina)?
SELECT al.nome AS aluno, SUM(d.quantcreditos) AS total_creditos
FROM aula a
JOIN aluno al ON a.aluno_fk = al.numaluno
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE a.nota >= 6 -- Considerando que a nota mínima para aprovação é 6
GROUP BY al.nome
HAVING SUM(d.quantcreditos) >= 70;

-- 22. Quais nomes de alunos, nome de disciplina e nome de professores que cursaram o 1o semestre de 1998 e pertencem ao curso de Ciência da Computação que possuem nota superior à 8.0?
SELECT al.nome AS aluno, d.nome AS disciplina, p.nome AS professor, a.nota
FROM aula a
JOIN aluno al ON a.aluno_fk = al.numaluno
JOIN disciplina d ON a.disciplina_fk = d.numdisp
JOIN professor p ON a.professor_fk = p.numprof
JOIN disciplinacurso dc ON d.numdisp = dc.disciplina_fk
JOIN curso c ON dc.curso_fk = c.id_curso
WHERE c.nome = 'Ciência da Computação' AND a.semestre = '01/1998' AND a.nota > 8.0;

-- 23. Qual a disciplina com nota mais baixa em qualquer época?
SELECT d.nome AS disciplina, MIN(a.nota) AS menor_nota
FROM aula a
JOIN disciplina d ON a.disciplina_fk = d.numdisp
GROUP BY d.nome
ORDER BY menor_nota ASC
LIMIT 1;

-- 24. Qual a disciplina com média de nota mais alta em qualquer época?
SELECT d.nome AS disciplina, AVG(a.nota) AS media_nota
FROM aula a
JOIN disciplina d ON a.disciplina_fk = d.numdisp
GROUP BY d.nome
ORDER BY media_nota DESC
LIMIT 1;

-- 25. Quais alunos já concluíram o curso de Ciência da Computação?
SELECT al.nome AS aluno
FROM aluno al
JOIN curso c ON al.curso_fk = c.id_curso
JOIN disciplinacurso dc ON c.id_curso = dc.curso_fk
JOIN disciplina d ON dc.disciplina_fk = d.numdisp
JOIN aula a ON al.numaluno = a.aluno_fk AND a.disciplina_fk = d.numdisp
WHERE c.nome = 'Ciência da Computação'
GROUP BY al.nome
HAVING SUM(d.quantcreditos) >= (
    SELECT SUM(d2.quantcreditos)
    FROM disciplina d2
    JOIN disciplinacurso dc2 ON d2.numdisp = dc2.disciplina_fk
    JOIN curso c2 ON dc2.curso_fk = c2.id_curso
    WHERE c2.nome = 'Ciência da Computação'
);


-- 26. Ordene as disciplinas por quantidade de reprovações.
SELECT d.nome AS disciplina, COUNT(*) AS qtd_reprovacoes
FROM aula a
JOIN disciplina d ON a.disciplina_fk = d.numdisp
WHERE a.nota < 6 -- Considerando reprovação para notas abaixo de 6
GROUP BY d.nome
ORDER BY qtd_reprovacoes DESC;
