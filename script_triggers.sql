create or replace function cap_logs()
returns trigger as $$ 
begin

if(tg_op = 'INSERT') THEN
   INSERT INTO auditor_logs_data.logs (
            tabela_afetada,
            dados_novos,
            operacao,
            usuario,
            data_operacao,
            sucesso
        )
        values
        (tg_table_name,
         row_to_jsonb(new),
        'INSERT',
        current_user,
        current_timestamp,
        TRUE
        );
        return new;
    end if;

if(tg_op = 'UPDATE') THEN
    INSERT INTO auditor_logs_data.logs (
            tabela_afetada,
            dados_alterado_antigos,
            dados_novos,
            operacao,
            usuario,
            data_operacao,
            sucesso)
            VALUES
            (tg_table_name, row_to_jsonb(old),
            row_to_jsonb(new), 'UPDATE',
            CURRENT_USER,
            current_timestamp,
            TRUE);
            return new;
    end if;

     IF (TG_OP = 'DELETE') THEN
        INSERT INTO auditor_logs_data.logs (
            tabela_afetada,
            dados_alterado_antigos,
            operacao,
            usuario,
            data_operacao,
            sucesso
        )
        VALUES (
            TG_TABLE_NAME,  -- Nome da tabela afetada
            row_to_json(OLD),  -- Dados excluídos
            'DELETE',
            CURRENT_USER,
            CURRENT_TIMESTAMP,
            TRUE
        );
        RETURN OLD;
    END IF;


    return null;
end;
$$ language plpgsql;

-- Trigger para a tabela alunos_data.alunos
CREATE TRIGGER auditoria_alunos
AFTER INSERT OR UPDATE OR DELETE
ON alunos_data.alunos
FOR EACH ROW
EXECUTE FUNCTION cap_logs();

-- Trigger para a tabela alunos_data.matriculas
CREATE TRIGGER auditoria_matriculas
AFTER INSERT OR UPDATE OR DELETE
ON alunos_data.matriculas
FOR EACH ROW
EXECUTE FUNCTION cap_logs();

-- Trigger para a tabela alunos_data.frequencia_alunos
CREATE TRIGGER auditoria_frequencia_alunos
AFTER INSERT OR UPDATE OR DELETE
ON alunos_data.frequencia_alunos
FOR EACH ROW
EXECUTE FUNCTION cap_logs();

-- Trigger para a tabela disciplinas_data.disciplinas
CREATE TRIGGER auditoria_disciplinas
AFTER INSERT OR UPDATE OR DELETE
ON disciplinas_data.disciplinas
FOR EACH ROW
EXECUTE FUNCTION cap_logs();

-- Trigger para a tabela disciplinas_data.grade_serie
CREATE TRIGGER auditoria_grade_serie
AFTER INSERT OR UPDATE OR DELETE
ON disciplinas_data.grade_serie
FOR EACH ROW
EXECUTE FUNCTION cap_logs();

-- Trigger para a tabela disciplinas_data.disciplinas_professores
CREATE TRIGGER auditoria_disciplinas_professores
AFTER INSERT OR UPDATE OR DELETE
ON disciplinas_data.disciplinas_professores
FOR EACH ROW
EXECUTE FUNCTION cap_logs();

-- Trigger para a tabela professores_data.professores
CREATE TRIGGER auditoria_professores
AFTER INSERT OR UPDATE OR DELETE
ON professores_data.professores
FOR EACH ROW
EXECUTE FUNCTION cap_logs();

-- Trigger para a tabela rh_data.cargos
CREATE TRIGGER auditoria_cargos
AFTER INSERT OR UPDATE OR DELETE
ON rh_data.cargos
FOR EACH ROW
EXECUTE FUNCTION cap_logs();

-- Trigger para a tabela auditor_logs_data.logs
CREATE TRIGGER auditoria_logs
AFTER INSERT OR UPDATE OR DELETE
ON auditor_logs_data.logs
FOR EACH ROW
EXECUTE FUNCTION cap_logs();
