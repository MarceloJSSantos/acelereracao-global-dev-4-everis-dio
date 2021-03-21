# **<u>O que você precisa saber para construir API's verdadeiramente Restfull</u>**

------

[slides](./slides/slides_live_13.pdf)

- arquivos:

  - [postman_collection.json](./arquivos/postman_collection.json)

- notebooks:
  - [notebook_aceleracao_everis_codigo_python_postman_code_snippet.ipynb](./notebooks/notebook_aceleracao_everis_codigo_python_postman_code_snippet.ipynb)



**O que é API (Application Programming Interface)**

- camada que esconde as regras e possibilita uma comunicação externa

- Facilita muito a integração

- Existem várias metodologias (ou arquiteturas) como:
  - SOA
  - Rest
  - uso por meio de SDK



Rest vs. Restful

- Rest: Metodologia / Arquitetura

- Restful: API que faz uso do Rest

Características

- Trafego dos dados por JSON (mas ainda podemos encontrar xml )
- Padronização de endpoint’s
- Uso de HTTP Methods ( Get, Post, Put, Delete )
- Facilita o entendimento ao iniciar uma integração



HTTP Methods

| MÉTODO | DESCRIÇÃO                              | PADRÃO DE ENDPOINT                    | ESPERADO                                             | ERROS COMUNS                                 |
| ------ | -------------------------------------- | ------------------------------------- | ---------------------------------------------------- | -------------------------------------------- |
| GET    | Sempre obtém os dados                  | /api/dev/user<br />/api/dev/user/{id} | - listar usuários<br />- retornar usuário específico |                                              |
| POST   | Cria um novo registro/recurso          | /api/dev/user                         | - criar um usuário                                   | /api/dev/user/{id}<br />/api/dev/user/create |
| PUT    | Atualiza um registro/recurso existente | /api/dev/user/{id}                    | - atualizar um usuário específico                    | /api/dev/user                                |
| DELETE | Remove um registro/recurso existente   | /api/dev/user/{id}                    | - deletar um usuário específico                      | /api/dev/user?id=2                           |





Status Code

| GRUPO | DESCRIÇÃO        | MAIS COMUNS                                                  |
| ----- | ---------------- | ------------------------------------------------------------ |
| 2xx   | Sucesso          | 200 = OK                                                     |
| 4xx   | Erro no cliente  | 401 = Unauthorized<br />403 = Forbidden<br />404 = Not found |
| 5xx   | Erro no servidor | 500 = Internal Server Error<br />504 = Gateway Timeout       |

Referência: [www.httpstatuses.com](http://www.httpstatuses.com/)



Prática com Postman (https://www.postman.com/downloads/)

- Baixar o arquivo [postman_collection.json](./arquivos/postman_collection.json)

- Importar para o Postman

- criar a estrutura no https://www.mockapi.io/
  - criado pois na realização dos exercícios o instrutor já havia apagado o recurso
- Aplicar os métodos get, post, put e delete
- Gerado código em Python usando o "Code Snipper" do Postman e executado 

neste [notebook](./notebooks/notebook_aceleracao_everis_codigo_python_postman_code_snippet.ipynb)



vídeo parado em 00:42:00