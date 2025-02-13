create database EscolaCiceroNogueira;
CREATE SCHEMA alunos_data;
CREATE SCHEMA professores_data;
CREATE SCHEMA disciplinas_data;
CREATE SCHEMA security_data;
CREATE SCHEMA auditor_logs_data;
create schema Rh_data;


-- ALUNOS 
create table if not exists alunos_data.alunos( -- preencher 5° 
    aluno_id serial primary key,
    nome varchar(100) not null,
    cpf varchar(14) not null unique,
    data_nascimento date not null,
    telefone varchar(20) not null,
    email varchar(100) not null unique,
    nome_responsavel varchar(100) not null
);

create table if not exists alunos_data.matriculas( -- preencher 6°
    matricula_id serial primary key,
    aluno_id integer not null,
    grade_id integer not null,
    serie_atual varchar(20) not null,
    turno varchar(10) not null,
    ano_letivo date default CURRENT_DATE,
    semestre_atual integer check(semestre_atual in (1 , 2 , 3 ,4)),
    valor decimal(10,2) not null,
    data_matricula date default CURRENT_DATE,
    Foreign Key (aluno_id) REFERENCES alunos_data.alunos (aluno_id) ON DELETE CASCADE,
    Foreign Key (grade_id) REFERENCES disciplinas_data.grade_serie(grade_id) ON DELETE CASCADE
);

create table if not exists alunos_data.frequencia_alunos( -- preencher 9° 
    frequencia_id serial primary key,
    matricula_id integer not null,
    total_aulas integer not null,
    total_presente integer not null,
    total_faltas integer not null,
    oberservacao varchar(100),
    situacao varchar(15) check(situacao in('aprovado','reprovado', 'recuperacao')),
    Foreign Key (matricula_id) REFERENCES alunos_data.matriculas(matricula_id)ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS avaliacoes ( -- preencher 8 ° 
    avaliacao_id serial primary key,
    matricula_id integer not null,
    professor_id integer not null,
    disciplina_id integer not null,
    avaliacao_1 decimal(10,2),
    avaliacao_2 decimal(10,2),
    avaliacao_3 decimal(10,2),
    avaliacao_4 decimal(10,2),
    media_final decimal(10,2),
    foreign key(matricula_id) REFERENCES alunos_data.matriculas(matricula_id) ON DELETE CASCADE,
    FOREIGN KEY(professor_id) REFERENCES professores_data.professores(professor_id) ON DELETE CASCADE,
    Foreign Key (disciplina_id) REFERENCES disciplinas_data.disciplinas(disciplina_id)ON DELETE CASCADE 
);


-- disciplinas 
create table if not exists disciplinas_data.disciplinas( -- preencher 1°
    disciplina_id serial primary key,
    nome varchar(100) not null,
    descricao varchar(100) not null
) 

create table if not exists disciplinas_data.grade_serie( -- preencher 4°
    grade_id serial primary key,
    disciplina_id integer not null,
    serie varchar(50) not null,
    ano_letivo date not null,
    carga_horaria integer not NULL,
    foreign key(disciplina_id) REFERENCES disciplinas_data.disciplinas(disciplina_id) ON DELETE CASCADE
);

-- relacionamento disciplina com professores

create table if not exists disciplinas_data.disciplinas_professores( -- preencher 7° 
    professor_id integer not null,
    disciplina_id integer not NULL,
    primary key(professor_id, disciplina_id),
    foreign key(professor_id) REFERENCES professores_data.professores(professor_id) ON DELETE CASCADE,
    Foreign Key (disciplina_id) REFERENCES disciplinas_data.disciplinas(disciplina_id) ON DELETE CASCADE
);
 
-- professors_data

create table if not exists professores_data.professores( -- preencher 3°
    professor_id serial primary key,
    cargo_id integer not null,
    nome varchar(100) not null,
    cpf varchar(14) not null unique,
    email varchar(100) not null UNIQUE,
    telefone varchar(30) not NULL UNIQUE,
    valor_extra decimal(10,2),
    Foreign Key (cargo_id) REFERENCES rh_data.cargos(cargo_id) ON DELETE CASCADE
);


-- rh_data
create table if not exists rh_data.cargos( -- preencher 2° 
    cargo_id serial primary key,
    nome varchar(100) not null,
    descricao varchar(100) not null,
    salario_base decimal(10,2)
);

-- auditor_logs_data

create table if not exists auditor_logs_data.logs(
    log_id serial primary key,
    tabela_afetada varchar(100) not null,
    dados_alterado_antigos JSONB,
    dados_novos JSONB, 
    operacao varchar(20) not null,
    usuario varchar(30) default CURRENT_USER,
    data_operacao TIMESTAMP default CURRENT_TIMESTAMP,
    sucesso BOOLEAN default TRUE
);
