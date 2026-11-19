CREATE DATABASE industria;

USE industria;

CREATE TABLE maquinas (
    id_maquina INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    modelo VARCHAR(50),
    fabricante VARCHAR(100),
    CONSTRAINT PK_maquinas
    PRIMARY KEY (id_maquina)
);

CREATE TABLE componentes (
    id_componente INT AUTO_INCREMENT,
    id_maquina INT,
    nome_componente VARCHAR(100),
    horas_uso_acumuladas INT,
    limite_horas_alerta INT,
    CONSTRAINT PK_componentes
    PRIMARY KEY (id_componente),
    CONSTRAINT FK_maquina
    FOREIGN KEY (id_maquina)
    REFERENCES maquinas(id_maquina),
    CHECK (horas_uso_acumuladas >= 0)
);

CREATE TABLE tecnicos (
    id_tecnico INT AUTO_INCREMENT,
    nome_tecnico VARCHAR(100),
    especialidade VARCHAR(50),
    nivel_certificacao VARCHAR(30),
    CONSTRAINT PK_tecnicos
    PRIMARY KEY (id_tecnico)
);

CREATE TABLE ordens_servico (
    id_ordem INT AUTO_INCREMENT,
    id_maquina INT,
    id_tecnico INT,
    data_abertura DATETIME,
    tipo_manutencao VARCHAR(30),
    status VARCHAR(20),
    CONSTRAINT PK_ordens
    PRIMARY KEY (id_ordem),
    CONSTRAINT FK_ordem_maquina
    FOREIGN KEY (id_maquina)
    REFERENCES maquinas(id_maquina),
    CONSTRAINT FK_ordem_tecnico
    FOREIGN KEY (id_tecnico)
    REFERENCES tecnicos(id_tecnico),
    CHECK (tipo_manutencao IN
    ('PREVENTIVA', 'CORRETIVA', 'PREDITIVA'))
);

CREATE TABLE estoque_pecas (
    id_peca INT AUTO_INCREMENT,
    codigo VARCHAR(30),
    quantidade INT,
    valor DECIMAL(10,2),
    estoque INT,
    preco_minimo DECIMAL(10,2),
    CONSTRAINT PK_pecas
    PRIMARY KEY (id_peca),
    CHECK (quantidade >= 0)
);

CREATE TABLE pecas (
    id_ordem INT,
    id_peca INT,
    quantidade INT,
    custo DECIMAL(10,2),
    CONSTRAINT PK_pecas_ordem
    PRIMARY KEY (id_ordem, id_peca),
    CONSTRAINT FK_pecas_ordem
    FOREIGN KEY (id_ordem)
    REFERENCES ordens_servico(id_ordem),
    CONSTRAINT FK_pecas_estoque
    FOREIGN KEY (id_peca)
    REFERENCES estoque_pecas(id_peca),
    CHECK (quantidade > 0)
);

CREATE TABLE leituras_sensores (
    id_leitura INT AUTO_INCREMENT,
    id_ordem INT,
    vibracao DECIMAL(5,2),
    data_hora DATETIME,
    consumo DECIMAL(10,2),
    CONSTRAINT PK_leituras
    PRIMARY KEY (id_leitura),
    CONSTRAINT FK_leituras_ordem
    FOREIGN KEY (id_ordem)
    REFERENCES ordens_servico(id_ordem)
);

CREATE TABLE alertas (
    id_alerta INT AUTO_INCREMENT,
    id_peca INT,
    codigo VARCHAR(30),
    descricao VARCHAR(150),
    nivel VARCHAR(20),
    status ENUM('ABERTO', 'EM ANDAMENTO', 'RESOLVIDO'),
    CONSTRAINT PK_alertas
    PRIMARY KEY (id_alerta),
    CONSTRAINT FK_alertas_pecas
    FOREIGN KEY (id_peca)
    REFERENCES estoque_pecas(id_peca)
);
