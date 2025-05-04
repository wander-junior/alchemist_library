# 📚 ALchemist Library

## 📖 Sobre o Projeto

Este é um projeto educacional em Elixir com o objetivo de desenvolver uma API RESTful para uma livraria fictícia. A aplicação irá expor informações de livros, autores e categorias, utilizando a biblioteca `Plug` para o gerenciamento das rotas, sem o uso do framework Phoenix.

A API seguirá o padrão arquitetural MVC e retornará dados formatados em JSON, realizando operações CRUD sobre um banco de dados relacional.

---

## ⚙️ Tecnologias Utilizadas

- **Elixir**
- **Plug**
- **PostgreSQL**
- **Docker**
- **Git/GitHub**

---

## 🗂️ Funcionalidades

### 📚 Livros

- `GET /api/books/get_all` — Lista todos os livros (com filtros `minPrice` e `maxPrice` via query string)
- `GET /api/book/get/:id` — Retorna um livro pelo seu ID
- `POST /api/book/add` — Adiciona um novo livro (via body)
- `PUT /api/book/change` — Atualiza informações de um livro (via body)
- `DELETE /api/book/remove/:id` — Remove um livro
- `GET /api/book/author/:author` — Retorna livros por autor (filtro de preço disponível)
- `GET /api/book/title` — Retorna livros com o título ou parte dele
- `GET /api/book/category/:category` — Retorna livros por categoria (filtro de preço disponível)

### 👤 Autores

- `POST /api/author/add/:author_name` — Cadastra um novo autor
- `PUT /api/author/change` — Atualiza dados de um autor (via body)
- `DELETE /api/author/remove/:author_name` — Remove um autor
- `GET /api/author/get/:author_name` — Retorna dados de um autor
- `GET /api/author/get_all` — Lista todos os autores

### 🏷️ Categorias

- `POST /api/category/add/:category_name` — Cadastra uma nova categoria
- `PUT /api/category/change` — Atualiza uma categoria (via body)
- `DELETE /api/category/remove/:category_name` — Remove uma categoria
- `GET /api/category/get/:category_name` — Retorna uma categoria
- `GET /api/category/get_all` — Lista todas as categorias

---

## 🔎 Regras de Negócio

- Um **livro só pode ser cadastrado** se o autor e a categoria já existirem no sistema.
- Os **status HTTP** devem seguir as boas práticas:
  - `201 Created` para inserções bem-sucedidas
  - `404 Not Found` para recursos inexistentes
  - `200 OK` para buscas e atualizações
  - `400 Bad Request` para erros de validação

---

## 📦 Instruções de Uso

### Pré-requisitos

- [Elixir](https://elixir-lang.org/install.html)
- [Docker](https://www.docker.com/)
- [Git](https://git-scm.com/)

### Clonando o repositório

```bash
git clone https://github.com/wander-junior/alchemist_library
cd alchemist_library
