# ChatRoom

Api de estudo com uso de JWT para autenticação de tokens e expiração de sessão no servidor. A autenticação e o processo de gerenciamente de sessões foi construido sem o uso de gems adicionais.

## Tecnologias

- Rails
- JWT
- Postgresql
- RSpec
- Docker


## Setup

Após clonar o repositório, execute:

```sh
$ source bash_aliases.sh
$ dcu -d
```

Este comando irá carregar o arquivo de aliases, que irá simplicar os comandos de terminal, e sobe a aplicação com a construção da imagem e sua execução sem os logs.


### Comandos úteis

Para rodar os testes execute:

```sh
$ dce rspec
```

Para execução do linter:

```sh
$ dce rubocop
```

## Rotas

### Autenticação
#### Sign Up (Cadastro)

POST	/api/v1/sign_up

Parâmetros esperados (JSON):

```json
{
  "email": "usuario@exemplo.com",
  "password": "senha_segura",
  "name": "Nome do Usuário"
}
```

### Sign In (Login)

POST	/api/v1/sign_in

Parâmetros esperados (JSON):

```json
{
  "email": "usuario@exemplo.com",
  "password": "senha_segura"

}
```

### Rooms (Salas)
Listar Salas (rota raiz da API)

GET	/api/v1

### Criar Sala
POST	/api/v1/rooms

### Mensagens
Listar mensagens de uma sala

GET	/api/v1/rooms/:room_id/messages

### Enviar mensagem para uma sala

POST	/api/v1/rooms/:room_id/messages

### Histórico de mensagens por usuário

GET	/api/v1/messages

Parâmetros de Query:

```
/api/v1/messages?user_id=123
```