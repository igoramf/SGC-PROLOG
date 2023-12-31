:- consult('../Users/User.pl').
:- consult('../Ingresso/Ingresso.pl').
:- consult('../Filmes/Filme.pl').
:- consult('../Util/Util.pl').
:- consult('../Database/Database.pl').
:- consult('../Sala/Sala.pl').


menuInicial :-
    write('____________________________'), nl,
    write('SGC-GERENCIAMENTO DE CINEMAS'), nl,
    write('1 - Login'), nl,
    write('2 - Cadastro'), nl,
    write('3 - Cadastro ADM'), nl,
    write('4 - Sair'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            login
        ;
        Opcao = 2 ->
            telaCadastroUser
        ;
        Opcao = 3 ->
            telaCadastroAdm
        ;
        Opcao = 4 ->
            write('Saindo...'), nl
        ;
            write('Opcao Invalida!'), nl
    ).

login :-
    write('Username: '), nl,
    read(Login),
    write('Senha: '), nl,
    read(Senha),
    (
        loginUser(Login, Senha) ->
            getDados(Login, Dados),
            nth0(3, Dados, IsAdm),
            write('Login realizado com sucesso!'), nl,
            (
                checkUserType(IsAdm, "true") -> 
                telaLoginAdm(Login)
                ;
                telaLogin(Login)
            )
        ;
            write('Senha incorreta!'), nl,
            login
    ).

checkUserType(IsAdm, IsAdm).

telaCadastroUser :-
    write('Nome: '), nl,
    read(Name),
    write('Username: '), nl,
    read(Username),
    write('Senha: '), nl,
    read(Senha),
    createUser(Username, Name, Senha, false),
    write('Usuário cadastrado com sucesso!'), nl,
    menuInicial.

telaCadastroAdm :-
    write('Nome: '), nl,
    read(Name),
    write('Username: '), nl,
    read(Username),
    write('Senha: '), nl,
    read(Senha),
    createUser(Username, Name, Senha, true),
    write('Administrador cadastrado com sucesso!'), nl,
    menuInicial.

telaLogin(Login) :-
    write('________________________'), nl,
    write('Menu'), nl,
    write('________________________'), nl,
    write('1 - Perfil'), nl,
    write('2 - Ingressos'), nl,
    write('3 - Logout'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaPerfil(Login)
        ;
        Opcao = 2 ->
            telaUserIngressos(Login)
        ;
        Opcao = 3 ->
            menuInicial
        ;
        write('Opcao Invalida!'), nl
    ).

telaUserIngressos(Login) :-
    write('________________________'), nl,
    write('Menu>Ingressos'), nl,
    write('________________________'), nl,
    write('1 - Ver meus ingressos'), nl,
    write('2 - Comprar Ingressos'), nl,
    write('3 - Ver Filmes em Cartaz'), nl,
    write('4 - Voltar'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaListaIngressos(Login)
        ;
        Opcao = 2 ->
            telaCompraIngressos(Login)
        ;
        Opcao = 3 ->
            telaListaFilmes(Login)
        ;
        Opcao = 4 ->
            telaLogin(Login)
        ;
        write('Opcao Invalida!'), nl
    ).

telaListaIngressos(Login) :-
    directoryDatabase(Directory),
    concatenar_strings(Directory, Login, DirectoryLogin),
    concatenar_strings(DirectoryLogin, '/', DirectoryLoginBarra),
    concatenar_strings(DirectoryLoginBarra, 'ingressos', DirectoryIngressos),
    write('Menu>Ingressos>Meus Ingressos'), nl,
    write(''), nl,
    write('Meus Ingressos:'), nl,
    list_folders_ingressos(DirectoryIngressos, Login, Login).

telaCompraIngressos(Login) :-
    write('Nome do Filme: '), nl,
    read(Nome),
    write('Id do Filme: '), nl,
    read(IdFilme),
    write('Assento: '), nl,
    read(Assento),
    Valor is 10 + 10,
    createIngresso(Login, Nome, IdFilme, Valor, Assento),
    write('Ingresso comprado com sucesso!'), nl,
    telaUserIngressos(Login).

telaLoginAdm(Login) :-
    write('________________________'), nl,
    write('Menu>Administracao'), nl,
    write('________________________'), nl,
    write('1 - Perfil'), nl,
    write('2 - Cadastrar Filmes'), nl,
    write('3 - Dashboard'), nl,
    write('4 - MenuSala'), nl,
    write('5 - Logout'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaPerfil(Login)
        ;
        Opcao = 2 ->
            telaCadastraFilme(Login)
        ;
        Opcao = 3 ->
           list_dashboard(Directory, Username, Username)
        ;
        Opcao = 4 ->
           tela_menu_sala
        ;
        Opcao = 5 ->
            menuInicial
        ;
        write('Opcao Invalida!'), nl
    ).

telaPerfil(Login) :-
    write('________________________'),nl,
    write('Menu>Perfil'), nl,
    write('________________________'), nl,
    write('1 - Exibir Perfil'), nl,
    %write('2 - Deletar Perfil'), nl,
    write('2 - Voltar'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            telaExibirPerfil(Login)
        ;
        Opcao = 2 ->
            telaLogin(Login)
        ;
            write('Opcao Invalida!'), nl
    ).

telaExibirPerfil(Login) :-
    write('___________________________________'),nl,
    write('Menu>Perfil>Menu Perfil'), nl,
    write('___________________________________'),nl,
    write('Nome: '), nl,
    getDados(Login, Dados),
    nth0(0, Dados, Nome),
    write(Nome), nl,
    write('Adm: '), nl,
    nth0(3, Dados, IsAdm),
    write(IsAdm), nl,
    write('0 - Voltar'), nl,
    read(Opcao),
    (
        Opcao = 0 ->
            telaPerfil(Login)
        ;
            write('Opcao Invalida!'), nl
    ).

telaCadastraFilme(Login) :-
    write('Nome do Filme: '), nl,
    read(Nome),
    write('Id do Filme: '), nl,
    read(IdFilme),
    write('Valor: '), nl,
    read(Valor),
    createFilme(Nome, IdFilme, Valor),
    write('Filme cadastrado com sucesso!'), nl,
    telaLoginAdm(Login).

telaListaFilmes(Login) :-
    write('Menu>Ingressos>Ver Filmes em Cartaz'), nl,
    write(''), nl,
    write('Filmes em cartaz:'), nl,
    write('Menu>Filmes'), nl,
    write(''), nl,
    write('Filmes em cartaz:'), nl,
    list_folders_filmes("Modules/Database/Filmes", Login, Login).

tela_menu_sala :-
    repeat,
    write('____________________________'), nl,
    write('SGC-GERENCIAMENTO DE SALAS'), nl,
    write('1 - Cadastrar nova sala'), nl,
    write('2 - Listar salas disponíveis'), nl,
    write('3 - Associar sala a um filme e horário'), nl,
    write('4 - Verificar a disponibilidade de um assento'), nl,
    write('5 - Exibir os assentos disponíveis em uma sala'), nl,
    write('6 - Associar um filme a uma sala'), nl,
    write('7 - Voltar ao menu inicial'), nl,
    read(Opcao),
    (
        Opcao = 1 ->
            write('Digite o número da sala: '), read(N),
            write('Digite a capacidade da sala: '), read(Capacidade),
            cadastra_sala(N, Capacidade),
            write('Sala cadastrada com sucesso!'), nl
        ;
        Opcao = 2 ->
            lista_salas_disponiveis(SalasDisponiveis),
            write('Salas Disponíveis: '), list_folders_salas("Modules/Database/Salas", Login, Login), nl
        ;
        Opcao = 3 ->
            write('Digite o número da sala: '), read(N),
            write('Digite o nome do filme: '), read(Filme),
            write('Digite o horário: '), read(Horario),
            associar_sala_filme_horario(N, Filme, Horario),
            write('Sala associada a filme e horário com sucesso!'), nl
        ;
        Opcao = 4 ->
            write('Digite o número da sala: '), read(N),
            write('Digite o número da fila: '), read(Fila),
            write('Digite o número do assento: '), read(Assento),
            (verificar_disponibilidade_assentos(N, Fila, Assento) ->
                write('Assento disponível!'), nl
            ;
                write('Assento ocupado!'), nl
            )
        ;
        Opcao = 5 ->
            write('Digite o número da sala: '), read(N),
            exibir_assentos_disponiveis(N)
        ;
        Opcao = 6 ->
            write('Digite o número da sala: '), read(N),
            write('Digite o nome do filme: '), read(Filme),
            write('Digite o gênero do filme: '), read(Genero),
            write('Digite a duração do filme: '), read(Duracao),
            associar_filme_sala(N, Filme, Genero, Duracao),
            write('Filme associado à sala com sucesso!'), nl
        ;
        Opcao = 7 ->
            menuInicial
        ;
        true 
    ),
    Opcao = 7, !. 

%Funcoes para o Dashboard
list_dashboard(Directory, Username, Username) :-
    directory_files("Modules/Database/LocalUsers", Files),
    exclude(hidden_file, Files, Folders),
    acumulador_ingressos_dashboard(Username, Folders, N),
    concatenar_strings("Valor Total de Ingressos Vendidos: ", N, Result),
    write(Result), nl,
    write("Filmes em exibicao: "), nl,
    list_filmes_dashboard("Modules/Database/Filmes", Login, Login),
    choose_folder(Folders, Username, Username).

% Versão modificada da função acumulador_ingressos_dashboard/3
acumulador_ingressos_dashboard(Username, Folders, N) :-
    acumulador_ingressos_dashboard(Username, Folders, 0, N).

% Caso base: Quando a lista de pastas estiver vazia, unifica N com o resultado.
acumulador_ingressos_dashboard(_, [], N, N).

% Caso em que a pasta não é especial
acumulador_ingressos_dashboard(Username, [Folder|Rest], Acc, N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou "..",
    directoryDatabase(Directory),
    concatenar_strings(Directory, Folder, DirectoryLogin),
    concatenar_strings(DirectoryLogin, '/', DirectoryLoginBarra),
    concatenar_strings(DirectoryLoginBarra, 'ingressos', DirectoryIngressos),
    directory_files(DirectoryIngressos, Files),
    exclude(hidden_file, Files, FoldersIngressos),
    soma_ingressos(Folder, FoldersIngressos, 0, Retorno),
    NextAcc is Acc + Retorno,
    acumulador_ingressos_dashboard(Username, Rest, NextAcc, N).

% Caso em que a pasta é especial
acumulador_ingressos_dashboard(Username, [_|Rest], Acc, N) :-
    acumulador_ingressos_dashboard(Username, Rest, Acc, N).

soma_ingressos(Username, Folders, N) :-
    soma_ingressos(Username, Folders, 0, N).

% Caso base: Quando a lista de pastas estiver vazia, unifica N com o resultado.
soma_ingressos(_, [], N, N).

% Caso em que a pasta não é especial
soma_ingressos(Username, [Folder|Rest], Acc, N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou "..",
    directoryDatabase(Directory), 
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(DirectoryUser, '/ingressos', DirectoryIngressos),
    concatenar_strings(DirectoryIngressos, '/', DirectoryIngressos2),
    concatenar_strings(DirectoryIngressos2, Folder, DirectoryIngressosFolder),
    concatenar_strings(Folder, '.txt', Foldertxt),
    concatenar_strings(DirectoryIngressosFolder, '/', DirectoryIngressosFolder2),
    concatenar_strings(DirectoryIngressosFolder2, Foldertxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados),
    nth0(2, Dados, Valor),
    concatenar_strings("Valor: ", Valor, ValorStr),
    converte_string_para_inteiro(Valor, ValorInteiro),
    NextN is Acc + ValorInteiro,
    soma_ingressos(Username, Rest, NextN, N),
    !. % Corte para evitar backtracking

% Caso em que a pasta é especial
soma_ingressos(Username, [_|Rest], Acc, N) :-
    soma_ingressos(Username, Rest, Acc, N).


list_filmes_dashboard(Directory, Username, Username) :-
    directory_files(Directory, Files),
    exclude(hidden_file, Files, Folders),
    print_filmes_dashboard(Username, Folders, 1),
    choose_folder(Folders, Username, Username).

print_filmes_dashboard(Username, [], _).
print_filmes_dashboard(Username, [Folder|Rest], N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou ".."
    format('~d - ~w~n', [N, Folder]),
    concatenar_strings("Modules/Database/Filmes/", Folder, DirectoryIngressosFolder),
    concatenar_strings(Folder, '.txt', Foldertxt),
    concatenar_strings(DirectoryIngressosFolder, '/', DirectoryIngressosFolder2),
    concatenar_strings(DirectoryIngressosFolder2, Foldertxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados),
    NextN is N + 1,
    print_filmes_dashboard(Username, Rest, NextN).

print_filmes_dashboard(Username, [_|Rest], N) :-
    NextN is N + 1,
    print_filmes_dashboard(Username, Rest, NextN).


%Funções auxiliares pra listar listas
%==================================================
list_folders_filmes(Directory, Username, Username) :-
    directory_files(Directory, Files),
    exclude(hidden_file, Files, Folders),
    print_folder_filmes(Username, Folders, 1),
    choose_folder(Folders, Username, Username).

print_folder_filmes(Username, [], _).
print_folder_filmes(Username, [Folder|Rest], N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou ".."
    format('~d - ~w~n', [N, Folder]),
    concatenar_strings("Modules/Database/Filmes/", Folder, DirectoryIngressosFolder),
    concatenar_strings(Folder, '.txt', Foldertxt),
    concatenar_strings(DirectoryIngressosFolder, '/', DirectoryIngressosFolder2),
    concatenar_strings(DirectoryIngressosFolder2, Foldertxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados),
    print_filme_to_string(Dados),
    NextN is N + 1,
    print_folder_filmes(Username, Rest, NextN).

print_folder_filmes(Username, [_|Rest], N) :-
    NextN is N + 1,
    print_folder_filmes(Username, Rest, NextN).

print_filme_to_string(Dados) :-
    nth0(0, Dados, IdFilme),
    concatenar_strings("Id do Filme: ", IdFilme, IdFilmeStr),
    write(IdFilmeStr),nl,
    nth0(2, Dados, Valor),
    concatenar_strings("Valor do ingresso: ", Valor, ValorFilmeStr),
    write(ValorFilmeStr),nl.


list_folders_ingressos(Directory, Username, Username) :-
    directory_files(Directory, Files),
    exclude(hidden_file, Files, Folders),
    print_folder_ingressos(Username, Folders, 1),
    choose_folder(Folders, Username, Username).

print_folder_ingressos(Username, [], _).
print_folder_ingressos(Username, [Folder|Rest], N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou ".."
    format('~d - ~w~n', [N, Folder]),
    directoryDatabase(Directory), 
    concatenar_strings(Directory, Username, DirectoryUser),
    concatenar_strings(DirectoryUser, '/ingressos', DirectoryIngressos),
    concatenar_strings(DirectoryIngressos, '/', DirectoryIngressos2),
    concatenar_strings(DirectoryIngressos2, Folder, DirectoryIngressosFolder),
    concatenar_strings(Folder, '.txt', Foldertxt),
    concatenar_strings(DirectoryIngressosFolder, '/', DirectoryIngressosFolder2),
    concatenar_strings(DirectoryIngressosFolder2, Foldertxt, DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados),
    print_ingresso_to_string(Dados),
    NextN is N + 1,
    print_folder_ingressos(Username, Rest, NextN).

print_folder_ingressos(Username, [_|Rest], N) :-
    NextN is N + 1,
    print_folder_ingressos(Username, Rest, NextN).

print_ingresso_to_string(Dados) :-
    nth0(0, Dados, IdIngresso),
    concatenar_strings("Id do Ingresso: ", IdIngresso, IdIngressoStr),
    write(IdIngressoStr),nl,
    nth0(1, Dados, FilmeNome),
    concatenar_strings("Nome do filme: ", FilmeNome, FilmeNomeStr),
    write(FilmeNomeStr),nl,
    nth0(2, Dados, Valor),
    concatenar_strings("Valor: ", Valor, ValorStr),
    write(ValorStr),nl,
    nth0(3, Dados, Assento),
    concatenar_strings("Assento: ", Assento, AssentoStr),
    write(AssentoStr),nl.

choose_folder(Folders, Username, Username) :-
    write('Digite 0 para sair: '),
    read(Number),
    telaLogin(Username).

process_choice(0, _, _, _) :- telaListas(Username).
process_choice(Number, Folders, Username, Username) :-
    number(Number),
    nth1(Number, Folders, Folder),
    format('Você escolheu a pasta: ~w~n', [Folder]),
    telaAcessoLista(Username, Username, Folder).

hidden_file(File) :-
    sub_atom(File, 0, 1, _, '.').
    
special_folder('.').
special_folder('..').

list_folders_salas(Directory, Username, Username) :-
    directory_files(Directory, Files),
    exclude(hidden_file, Files, Folders),
    print_folder_salas(Username, Folders, 1),
    choose_folder(Folders, Username, Username).

print_folder_salas(_, [], _).
print_folder_salas(Username, [Folder|Rest], N) :-
    \+ special_folder(Folder), % Verifica se a pasta é "." ou ".."
    format('~d - ~w~n', [N, Folder]),
    atomic_list_concat(["Modules/Database/Salas/", Folder], '/', DirectoryIngressosFolder),
    atomic_list_concat([Folder, '.txt'], '', Foldertxt),
    atomic_list_concat([DirectoryIngressosFolder, Foldertxt], '/', DirectoryUserFinal),
    ler_user(DirectoryUserFinal, Dados),
    print_salas_to_string(Dados),
    NextN is N + 1,
    print_folder_salas(Username, Rest, NextN).

print_folder_salas(Username, [_|Rest], N) :-
    NextN is N + 1,
    print_folder_salas(Username, Rest, NextN).

print_salas_to_string(Dados) :-
    print_salas_to_string(Dados, 1).

print_salas_to_string([], _).
print_salas_to_string([IdFilme, Capacidade | Rest], N) :-
    format("Id da sala: ~w~n", [IdFilme]),
    format("Capacidade: ~w~n", [Capacidade]),
    NextN is N + 1,
    skip_empty_lines,
    print_salas_to_string(Rest, NextN).

skip_empty_lines :-
    at_end_of_stream,
    !.
skip_empty_lines :-
    read_line_to_codes(user_input, _),
    skip_empty_lines.


%===========================================================================
