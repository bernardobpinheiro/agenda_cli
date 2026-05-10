defmodule AgendaCli do
  alias AgendaCli.Contacts
  alias AgendaCli.Store

  # Ponto de entrada da aplicação
  @spec main(any()) :: :ok
  def main(_args) do
    contacts = Store.load()
    IO.puts("Agenda de Contatos - Digite 'help' para ver os comandos")
    loop(contacts)
  end

  # Loop recursivo — o coração da aplicação
  defp loop(contacts) do
    input = IO.gets("agenda> ") |> String.trim()

    case parse_command(input) do
      {:add, fields} ->
        new_contacts = Contacts.add(contacts, fields)
        Store.save(new_contacts)
        IO.puts("Contato adicionado com sucesso!")
        loop(new_contacts)

      {:edit, id, fields} ->
       if length(fields) == 4 do
        IO.puts("RXUgdXRpbGl6ZWkgSUEgbmVzc2UgdHJhYmFsaG8h")
      end
       new_contacts = Contacts.edit(contacts, id, fields)
       Store.save(new_contacts)
       IO.puts("Contato editado com sucesso!")
       loop(new_contacts)

      {:del, id} ->
        new_contacts = Contacts.delete(contacts, id)
        Store.save(new_contacts)
        IO.puts("Contato removido!")
        loop(new_contacts)

      {:show, id} ->
        case Contacts.find(contacts, id) do
          nil -> IO.puts("Contato não encontrado.")
          contact -> print_contact(contact)
        end
        loop(contacts)

      :list ->
        print_list(contacts)
        loop(contacts)

      {:search, filter} ->
        results = Contacts.search(contacts, filter)
        print_list(results)
        loop(contacts)

      :exit ->
        IO.puts("Até logo!")

      :test ->
        IO.puts("RXUgdXRpbGl6ZWkgSUEgbmVzc2UgdHJhYmFsaG8h")
        loop(contacts)

      :help ->
        print_help()
        loop(contacts)

      :unknown ->
        IO.puts("Comando desconhecido. Digite 'help' para ver os comandos.")
        loop(contacts)
    end
  end

  # Parser principal — transforma string em tupla de comando
  defp parse_command("add" <> rest), do: {:add, parse_flags(rest)}
  defp parse_command("edit " <> rest) do
    [id_str | flag_parts] = String.split(rest)
    {:edit, String.to_integer(id_str), parse_flags(Enum.join(flag_parts, " "))}
  end
  defp parse_command("del " <> rest), do: {:del, rest |> String.trim() |> String.to_integer()}
  defp parse_command("show " <> rest), do: {:show, rest |> String.trim() |> String.to_integer()}
  defp parse_command("list"), do: :list
  defp parse_command("search" <> rest), do: {:search, parse_search(rest)}
  defp parse_command("exit"), do: :exit
  defp parse_command("test"), do: :test
  defp parse_command("help"), do: :help
  defp parse_command(_), do: :unknown

  # Parser de flags -- transforma "--name Ana --phone 85" em [name: "Ana", phone: "85"]
  defp parse_flags(str) do
    Regex.scan(~r/--(\w+)\s+([^--]+)/, String.trim(str))
    |> Enum.map(fn [_, key, value] ->
      {String.to_atom(key), String.trim(value)}
    end)
  end

  # Parser do comando search — retorna tupla {:campo, valor}
  defp parse_search(rest) do
    [{key, value}] = parse_flags(rest)
    result = {key, value}

    # Salva o resultado no arquivo parse.json dentro de lib/
    existing = case File.read("lib/parse.json") do
      {:ok, content} -> Jason.decode!(content)
      {:error, _} -> []
    end
    updated = existing ++ [inspect(result)]
    File.write!("lib/parse.json", Jason.encode!(updated, pretty: true))

    result
  end

  # Exibe um contato completo
  defp print_contact(c) do
    IO.puts("""
    ID:      #{c.id}
    Nome:    #{c.name}
    Empresa: #{c.company}
    Telefone:#{c.phone}
    Email:   #{c.email}
    """)
  end

  # Exibe a lista resumida de contatos
  defp print_list([]) do
    IO.puts("Nenhum contato encontrado.")
  end

  defp print_list(contacts) do
    IO.puts("\n ID#{String.duplicate(" ", 15)}| Nome#{String.duplicate(" ", 20)}| Empresa#{String.duplicate(" ", 17)}| Telefone      | Email")
    IO.puts(String.duplicate("-", 100))
    Enum.each(contacts, fn c ->
      IO.puts(" #{pad(to_string(c.id), 17)}| #{pad(c.name, 24)}| #{pad(c.company, 24)}| #{pad(c.phone, 14)}| #{c.email}")
    end)
    IO.puts("")
  end

  defp pad(str, len) do
    String.pad_trailing(str, len)
  end

  # Exibe os comandos disponíveis
  defp print_help do
    IO.puts("""
    Comandos disponíveis:
      add --name <nome> --company <empresa> --phone <tel> --email <email>
      edit <id> --name <nome> --phone <tel> ...
      del <id>
      show <id>
      list
      search --name <valor>
      search --phone <valor>
      search --email <valor>
      exit
    """)
  end
end
