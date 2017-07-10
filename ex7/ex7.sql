SET search_path = alison_moura;

--
-- EXERCÍCIO 1
-- 
CREATE VIEW view_nome_empregados
	AS SELECT COUNT(*) 
	FROM empregado
	WHERE pnome LIKE 'A%' OR pnome LIKE 'a%';

--
-- EXERCÍCIO 2
--
CREATE VIEW view_quantidade_gerenete
	AS SELECT COUNT(*) AS gerentes FROM empregado WHERE superssn IS NULL
	UNION
	SELECT COUNT(*) AS nao_gerentes FROM empregado WHERE superssn IS NOT NULL

--
-- EXERCÍCIO 3
--
CREATE VIEW view_empregados_com_4_ou_mais_dependentes
	AS SELECT f.pnome FROM empregado f 
	INNER JOIN dependente d ON d.essn=f.ssn 
	GROUP BY pnome HAVING(COUNT(f.pnome)>3);

--
-- EXERCÍCIO 4
--
CREATE VIEW view_top_dois_empregados_que_mais_trabalham
 	AS SELECT e.pnome,SUM(t.horas) as soma FROM empregado e
	INNER JOIN trabalha_em t ON t.essn=e.ssn
	WHERE t.horas > 0
	GROUP BY e.pnome ORDER BY soma DESC LIMIT 2;

--
-- EXERCÍCIO 5
--
CREATE VIEW view_empregados_ordenados_por_departamento
	AS SELECT * FROM empregado e INNER JOIN departamento d 
	ON e.dno=d.dnumero ORDER BY d.dnome

--
-- EXERCÍCIO 6
--
CREATE VIEW view_empregados_ordenados_por_horas_trabalhadas
	AS SELECT e.pnome, e.ssn, SUM(t.horas) as horas FROM empregado e
	INNER JOIN trabalha_em t ON t.essn=e.ssn
	WHERE t.horas > 0
	GROUP BY e.pnome ORDER BY horas DESC;

--
-- EXERCÍCIO 7
--
CREATE VIEW view_funcionarios_com_dependentes
	AS SELECT f.pnome,f.ssn,d.nome_dependente FROM empregado f 
	INNER JOIN dependente d ON d.essn=f.ssn ORDER BY f.pnome,d.nome_dependente;