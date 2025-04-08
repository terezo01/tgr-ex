create database exercicio2

use exercicio2

create table funcionarios(
	idFuncionario int primary key identity(1,1),
	nomeFunc varchar(100)
)

create table produtos(
	idProduto int primary key identity(1,1),
	nomeProduto varchar(100) not null,
	estoque int not null default 0,
	preco float not null,
	idFuncionario int not null
	constraint fk_produtos_func foreign key (idFuncionario) references funcionarios(idFuncionario)
)


create table historicoEstoque(
	idHistorico int primary key identity(1,1),
	idProduto int not null,
	idFuncionario int not null,
	dataAlteracao datetime not null default getdate(),
	quantidadeAnterior int,
	quantidadeNova int default 0
	constraint fk_historico_produtos foreign key (idProduto) references produtos(idProduto),
	constraint fk_historico_func foreign key (idFuncionario) references funcionarios(idFuncionario)
)


create trigger tgr_produtosAdd
on produtos after insert
as
begin
declare
	@idProduto int,
	@nomeProduto varchar(100),
	@estoque int,
	@preco float,
	@idFuncionario int,
	@quantidadeAntiga int
	select @idProduto = idProduto, @nomeProduto = nomeProduto, @estoque = estoque, @preco = preco, @idFuncionario = idFuncionario from inserted
	select @quantidadeAntiga = quantidadeNova from historicoEstoque

	IF @@ROWCOUNT = 0
        SET @quantidadeAntiga = 0

	insert into historicoEstoque
	(idProduto, idFuncionario ,quantidadeAnterior, quantidadeNova)
	values(@idProduto, @idFuncionario ,@quantidadeAntiga, @quantidadeAntiga + @estoque)

	select * from historicoEstoque

end


create procedure addProduto
@nomeProduto varchar(100),
@estoque int,
@preco float,
@idFuncionario int
as 
insert into produtos
values(@nomeProduto, @estoque, @preco, @idFuncionario)


insert into funcionarios
values('Andre santos')

exec addProduto 'Shampoo cr7', 100, 21.70, 1
