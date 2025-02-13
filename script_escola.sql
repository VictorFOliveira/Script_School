create database EscolaCiceroNogueira;

CREATE SCHEMA alunos_data;
CREATE SCHEMA professores_data;
CREATE SCHEMA disciplinas_data;
CREATE SCHEMA security_data;
CREATE SCHEMA auditor_logs_data;
create schema Rh_data;


-- ALUNOS 
create table if not exists alunos_data.alunos(
    aluno_id serial primary key,
    nome varchar(100) not null,
    cpf varchar(14) not null unique,
    data_nascimento date not null,
    telefone varchar(20) not null,
    email varchar(100) not null unique,
    nome_responsavel varchar(100) not null
);


create table if not exists alunos_data.matriculas(
    matricula_id serial primary key,
    aluno_id integer not null,
    grade_id integer not null,
    serie_atual varchar(20) not null,
    ano_letivo date default CURRENT_DATE,
    semestre_atual integer check(semestre_atual in (1 , 2 , 3 ,4)),
    data_matricula date default CURRENT_DATE,
    Foreign Key (aluno_id) REFERENCES alunos_data.alunos (aluno_id) ON DELETE CASCADE,
    Foreign Key (grade_id) REFERENCES disciplinas_data.grade_serie(grade_id) ON DELETE CASCADE
);

create table if not exists alunos_data.alunos_historico(
    historico_id serial primary key,
    avaliacao_id integer,


)

CREATE TABLE IF NOT EXISTS avaliacoes (
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
create table if not exists disciplinas_data.disciplinas(
    disciplina_id serial primary key,
    nome varchar(100) not null,
    descricao varchar(100) not null
) 

create table if not exists disciplinas_data.grade_serie(
    grade_id serial primary key,
    disciplina_id integer not null,
    serie varchar(50) not null,
    ano_letivo date not null,
    carga_horaria integer not NULL,
    foreign key(disciplina_id) REFERENCES disciplinas_data.disciplinas(disciplina_id) ON DELETE CASCADE
);

-- relacionamento disciplina com professores

create table if not exists disciplinas_data.disciplinas_professores(
    professor_id integer not null,
    disciplina_id integer not NULL,
    primary key(professor_id, disciplina_id),
    foreign key(professor_id) REFERENCES professores_data.professores(professor_id) ON DELETE CASCADE,
    Foreign Key (disciplina_id) REFERENCES disciplinas_data.disciplinas(disciplina_id) ON DELETE CASCADE
);
 
-- professors_data

create table if not exists professores_data.professores(
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

create table if not exists rh_data.cargos(
    cargo_id serial primary key,
    nome varchar(100) not null,
    descricao varchar(100) not null,
    salario_base decimal(10,2)
);
