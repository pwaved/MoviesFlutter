# MoviesFlutter





O projeto utiliza autenticação baseada em JWT para proteger as rotas de usuário e consome a API do The Movie Database (TMDB) para obter informações sobre os filmes.

Funcionalidades

    Autenticação de Usuários: Sistema completo de registro e login com senhas criptografadas e autenticação via JWT.

    Catálogo de Filmes: Exibição de filmes populares obtidos através da API do TMDB.

    Busca de Filmes: Funcionalidade de pesquisa em tempo real no catálogo do TMDB.

    Detalhes do Filme: Tela dedicada para visualização de pôster, título e sinopse de cada filme.

    Lista de Favoritos: Os usuários podem adicionar e remover filmes de uma lista pessoal, que fica salva no banco de dados.

    Busca nos Favoritos: Funcionalidade para filtrar a lista de filmes favoritados.

# ScreenShots

Tela de Login.

<img width="648" height="680" alt="image" src="https://github.com/user-attachments/assets/e86d4219-149a-4dbb-806c-81e5bd0bb4de" />

Cards de filmes.

<img width="648" height="680" alt="image" src="https://github.com/user-attachments/assets/3ebcadd8-b804-4fe8-9986-e4afdbe011e3" />

Tecnologias Utilizadas
Frontend

    Framework: Flutter

    Linguagem: Dart

    Gerenciamento de Estado: Provider

    Navegação: go_router

    Requisições HTTP: Dio

    Variáveis de Ambiente: flutter_dotenv

Backend

    Runtime: Node.js

    Linguagem: TypeScript

    Framework: Express.js

    ORM: Sequelize

    Autenticação: JSON Web Tokens (jsonwebtoken)

    Validação/Segurança: bcrypt para hashing de senhas

Banco de Dados & Infraestrutura

    Banco de Dados: PostgreSQL

    Containerização: Docker & Docker Compose

Pré-requisitos

Antes de começar, certifique-se de ter as seguintes ferramentas instaladas em sua máquina:

    Docker e Docker Compose

    Flutter SDK (versão 3.x ou superior)

    Um emulador Android, simulador iOS ou um dispositivo físico conectado.


Como Executar a Aplicação

Siga os passos abaixo para configurar e rodar o ambiente de desenvolvimento completo.
1. Clonar o Repositório

git clone https://github.com/pwaved/MoviesFlutter
cd movies_fullstack

2. Configuração do Backend (Docker)

O backend e o banco de dados rodam em contêineres Docker, simplificando a configuração.

A. Crie o arquivo de ambiente:
Na pasta raiz do projeto (movies_fullstack), crie um arquivo chamado .env e adicione as seguintes variáveis:

# Variáveis do Backend e Banco de Dados
DB_HOST=db
DB_PORT=5432
DB_USER=user
DB_PASSWORD=password
DB_NAME=cineflutterdb
DB_DIALECT=postgres

# Variáveis da Aplicação
PORT=3000
JWT_SECRET=SEU_SEGREDO_SUPER_SECRETO_PARA_O_JWT

 Suba os contêineres:
Ainda na pasta raiz, execute o seguinte comando. Ele irá construir a imagem da API e iniciar os contêineres do backend e do PostgreSQL.

docker-compose up --build

O backend estará rodando e acessível em http://localhost:3000.
3. Configuração do Frontend (Flutter)

A. Crie o arquivo de ambiente:
Dentro da pasta frontend, crie um arquivo chamado .env e adicione sua chave da API do TMDB:

TMDB_API_KEY=SUA_CHAVE_DE_API_DO_TMDB_AQUI

B. Configure o IP do Backend:
Para que o aplicativo no emulador/dispositivo consiga se comunicar com o backend rodando na sua máquina, você precisa usar o IP da sua rede local.

    Abra o arquivo frontend/lib/api/dio_client.dart.

    Altere a baseUrl para o IP da sua máquina na rede local.

        Windows: Encontre seu IP rodando ipconfig no CMD.

        Mac/Linux: Encontre seu IP rodando ifconfig ou ip a no terminal.

    // Exemplo:
    baseUrl: 'http://192.168.1.10:3000/api', // <-- TROQUE PELO SEU IP

C. Instale as dependências:
Navegue até a pasta do frontend e instale os pacotes Dart.

cd frontend
flutter pub get

D. Rode o aplicativo:
Certifique-se de que um emulador está rodando ou um dispositivo está conectado e execute:

flutter run



