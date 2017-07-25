SET search_path= alison_moura;

--
-- Exercício 1
--

--
-- FUNÇÃO DE ANÁLISE DA QUANTIDADE DE DEPENDENTES DE UM FUNCIONÁRIO
--
CREATE OR REPLACE FUNCTION verificar_quantidade_dependentes()
RETURNS TRIGGER AS $$

BEGIN
	SELECT COUNT(*) as qtd FROM dependente WHERE essn=NEW.essn;
    IF (qtd > 3) THEN
		RAISE EXCEPTION 'Quantidade máxima de dependentes excedida';
	END IF; 
	RETURN NEW;
END
$$LANGUAGE 'plpgsql'

--
-- TRIGGER
--
CREATE TRIGGER tr_verificar_quantidade_dependentes
BEFORE INSERT OR UPDATE ON dependente
FOR EACH ROW
EXECUTE PROCEDURE verificar_quantidade_dependentes()

--
-- Exercício 2
--

--
-- FUNÇÃO DE ANÁLISE DE QUANTIDADES DE SUPERVISIONADOS POR SUPERVISOR
--
CREATE OR REPLACE FUNCTION verificar_quantidade_supervisionados()
RETURNS TRIGGER AS $$

BEGIN
	SELECT COUNT(*) as qtd FROM empregado WHERE superssn=NEW.superssn;
    IF (qtd > 2) THEN
		RAISE EXCEPTION 'Quantidade máxima de supervisionados excedida';
	END IF; 
	RETURN NEW;
END
$$LANGUAGE 'plpgsql'

--
-- TRIGGER
--
CREATE TRIGGER tr_verificar_quantidade_supervisionados
BEFORE INSERT OR UPDATE ON empregado
FOR EACH ROW
EXECUTE PROCEDURE verificar_quantidade_supervisionados()


--
-- Exercício 3
--

--
-- FUNÇÃO DE ANÁLISE DA CARGA HORÁRIA DE UM EMPREGADO
--
CREATE OR REPLACE FUNCTION verificar_carga_horaria()
RETURNS TRIGGER AS $$

BEGIN
	SELECT SUM(horas) as horas FROM trabalha_em WHERE essn=NEW.ssn;
    IF (horas > 40) THEN
		RAISE EXCEPTION 'Quantidade máxima de horas de trabalho por empregado excedida';
	END IF; 
	RETURN NEW;
END
$$LANGUAGE 'plpgsql'

--
-- TRIGGER
--
CREATE TRIGGER tr_verificar_carga_horaria
BEFORE INSERT OR UPDATE ON trabalha_em
FOR EACH ROW
EXECUTE PROCEDURE verificar_carga_horaria()

--
-- Exercício 4
--

--
-- FUNÇÃO DE ANÁLISE DE PROJETOS POR DEPARTAMENTO
--
CREATE OR REPLACE FUNCTION verificar_projetos_departamento()
RETURNS TRIGGER AS $$

BEGIN
	SELECT COUNT(*) as qtd FROM projeto WHERE dnum=NEW.dnum;
    IF (qtd > 4) THEN
		RAISE EXCEPTION 'Quantidade máxima de projetos por departamento excedida';
	END IF; 
	RETURN NEW;
END
$$LANGUAGE 'plpgsql'

--
-- TRIGGER
--
CREATE TRIGGER tr_verificar_projetos_departamento
BEFORE INSERT OR UPDATE ON projeto
FOR EACH ROW
EXECUTE PROCEDURE verificar_projetos_departamento()


--
-- Exercício 5
--

CREATE TABLE log_auditoria (tabela VARCHAR NOT NULL, operacao VARCHAR NOT NULL, data DATE NOT NULL DEFAULT NOW(), dado TEXT NOT NULL, id SERIAL NOT NULL PRIMARY KEY); 

CREATE OR REPLACE FUNCTION fn_auditoria_todas_tabelas() RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'DELETE') THEN
 		INSERT INTO log_auditoria VALUES (TG_TABLE_NAME, 'DELETE', NOW( ), CAST(OLD.* AS text));
 		RETURN OLD;
 	ELSIF (TG_OP = 'UPDATE') THEN
 		INSERT INTO log_auditoria values(TG_TABLE_NAME, 'UPDATE', NOW( ), CAST(NEW.* AS text));
 		RETURN NEW;
 	ELSIF (TG_OP = 'INSERT') THEN
 		INSERT INTO log_auditoria VALUES(TG_TABLE_NAME, 'INSERT', NOW( ), CAST(NEW.* AS text));
 		RETURN NEW;
 	END IF;
 	RETURN NULL;
 END;
$$language 'plpgsql';

CREATE TRIGGER tr_log_auditoria_empregado
BEFORE INSERT OR UPDATE OR DELETE ON empregado
FOR EACH ROW
EXECUTE PROCEDURE fn_auditoria_todas_tabelas()

CREATE TRIGGER tr_log_auditoria_dependente
BEFORE INSERT OR UPDATE OR DELETE ON dependente
FOR EACH ROW
EXECUTE PROCEDURE fn_auditoria_todas_tabelas()

CREATE TRIGGER tr_log_auditoria_departamento
BEFORE INSERT OR UPDATE OR DELETE ON departamento
FOR EACH ROW
EXECUTE PROCEDURE fn_auditoria_todas_tabelas()

CREATE TRIGGER tr_log_auditoria_projeto
BEFORE INSERT OR UPDATE OR DELETE ON projeto
FOR EACH ROW
EXECUTE PROCEDURE fn_auditoria_todas_tabelas()

CREATE TRIGGER tr_log_auditoria_trabalha_em
BEFORE INSERT OR UPDATE OR DELETE ON trabalha_em
FOR EACH ROW
EXECUTE PROCEDURE fn_auditoria_todas_tabelas()

CREATE TRIGGER tr_log_auditoria_depto_localizacoes
BEFORE INSERT OR UPDATE OR DELETE ON depto_localizacoes
FOR EACH ROW
EXECUTE PROCEDURE fn_auditoria_todas_tabelas()