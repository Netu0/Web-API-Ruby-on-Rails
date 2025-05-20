# API de Gestão de Reservas (Ruby on Rails - API Mode)

Este projeto é uma aplicação em Ruby on Rails (modo API) desenvolvida como parte de um trabalho prático com foco em **injeção de dependência**, **tratamento de exceções via middleware**, e **boas práticas de arquitetura em camadas**.

---

## 📌 Funcionalidades

- ✅ Criar uma nova reserva (`POST /reservas`)
- ✅ Listar todas as reservas (`GET /reservas`)
- ✅ Buscar uma reserva por ID (`GET /reservas/:id`)
- ✅ Remover uma reserva (`DELETE /reservas/:id`)

---

## 📂 Estrutura do Projeto


app/
├── controllers/
│ └── reservas_controller.rb
├── models/
│ └── reserva.rb
├── repositories/
│ └── reserva_repository.rb
├── services/
│ └── reserva_service.rb
├── middlewares/
│ └── error_handler.rb

config/
├── routes.rb
├── application.rb

db/
└── migrate/


## ⚙️ Tecnologias Utilizadas

- **Ruby** 3.4
- **Rails** 8 (modo API)
- **MariaDB**
- **Middleware customizado**
- **Arquitetura em camadas (Controller, Service, Repository, Model)**

---

## 🔄 Regras de Negócio

- A **data de fim** da reserva não pode ser anterior à **data de início**.
- Não pode haver **sobreposição** de reservas no mesmo horário.

---

## 💡 Inversão de Dependência

A injeção de dependência é feita manualmente nos services, sem instanciar repositórios diretamente neles:

## 🛡️ Middleware de Erros

Todas as exceções são capturadas por um middleware genérico:

# app/middlewares/error_handler.rb

```
  500,
  { 'Content-Type' => 'application/json' },
  [{
    status: 500,
    erro: exception.message,
    timestamp: Time.now.utc
  }.to_json]
```

Adicionado ao Rails via:

### config/application.rb
```
config.middleware.use ErrorHandler
```

# DOCKER

Essa aplicação foi feita com docker, dessa forma, o banco de dados e a API ficam separados em dois containers diferentes!

# TESTES
## Acesso ao rails
```
 docker exec -it rails-api bash
```
## GETALL
```
 curl http://localhost:3000/reservas
```
## POST
```
curl -X POST http://localhost:3000/reservas \
  -H "Content-Type: application/json" \
  -d '{"reserva": {"nome": "ReservaNova", "data_inicio": "2025-05-24", "data_fim": "2025-05-22"}}'
```
## GetById
```
 curl http://localhost:3000/reservas/1
```
## DELETE
```
 curl -X DELETE http://localhost:3000/reservas/1
```
## POST com erro de data de início maior que data final
```
curl -X POST http://localhost:3000/reservas \
  -H "Content-Type: application/json" \
  -d '{"reserva": {"nome": "ReservaNova", "data_inicio": "2025-05-24", "data_fim": "2025-05-22"}}'
```
## POST com erro para barrar resrevas com mesma data de início e fim
```
curl -X POST http://localhost:3000/reservas \
  -H "Content-Type: application/json" \
  -d '{"reserva": {"nome": "ReservaNova", "data_inicio": "2025-05-24", "data_fim": "2025-05-22"}}'
```
