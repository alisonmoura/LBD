SET search_path = alison_moura;

ALTER TABLE empregado ADD COLUMN cpf VARCHAR;

--
-- FUNÇÃO DE ANÁLISE DOS CPF
--
CREATE OR REPLACE FUNCTION verificar_cpf()
RETURNS TRIGGER AS $$

BEGIN
	SELECT COUNT(cpf) as qtd FROM empregado WHERE cpf=NEW.cpf;
    IF (qtd > 0) THEN
		RAISE EXCEPTION 'CPF já cadastrado';
	END IF; 
	RETURN NEW;
END
$$LANGUAGE 'plpgsql'

--
-- TRIGGER
--
CREATE TRIGGER tr_verificar_cpf
BEFORE INSERT OR UPDATE ON empregado
FOR EACH ROW
EXECUTE PROCEDURE verificar_cpf()