--
-- 1 - Construir uma função que atualizará o salário de todos os funcionários em 15%
--
SET search_path = alison_moura;

CREATE OR REPLACE FUNCTION atualizar_salario()
RETURNS decimal AS $$

DECLARE
    e RECORD;
BEGIN
    FOR e IN SELECT * FROM empregado LOOP
    	e.salario := e.salario + 0.15*e.salario;
 		RAISE NOTICE 'Acrescendo 15% do salário para: %', i.pnome;
 	END LOOP;
END
$$LANGUAGE 'plpgsql'



--
-- 2 - Construa uma função que atualize o nome de cada funcionário em letra maiúscula.
--

--
-- 3 - Adicione na tabela de funcionários dois atributos: data de nascimento e idade. Crie uma função que calcule a idade
--