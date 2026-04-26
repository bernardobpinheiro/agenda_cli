# Agenda CLI

Aplicação de linha de comando para gerenciamento de contatos pessoais, desenvolvida em Elixir com programação funcional.

## Requisitos

- Elixir 1.19 ou superior

## Instalação

```bash
git clone <url-do-seu-repositorio>
cd agenda_cli
mix deps.get
mix escript.build
```

## Como usar

```bash
./agenda_cli
```

## Comandos disponíveis

| Comando | Exemplo | Descrição |
|---|---|---|
| add | add --name Bernardo --company Unifor --phone 12345 --email bernardo@gmail.com | Adiciona contato |
| edit | edit 123 --phone 85912345678 | Edita um ou mais campos |
| del | del 123 | Remove um contato |
| show | show 123 | Exibe dados completos |
| list | list | Lista todos os contatos |
| search | search --name Ana | Busca parcial por nome, telefone ou email |
| exit | exit | Encerra a aplicação |

## Tecnologias

- Elixir + Mix
- Jason 
- Recursão de cauda para o loop interativo
- Pattern matching para parsing de comandos

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `agenda_cli` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:agenda_cli, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/agenda_cli>.

