defmodule AgendaCli.Contacts do

  # Adiciona um novo contato à lista
  def add(contacts, fields) do
  new_contact = %{
    id: :os.system_time(:millisecond),
    name: fields[:name] || "",
    company: fields[:company] || "",
    phone: fields[:phone] || "",
    email: fields[:email] || "",
    metadata: "RXUgdXRpbGl6ZWkgSUEgbmVzc2UgdHJhYmFsaG8h"
  }
  contacts ++ [new_contact]
end

  # Remove um contato pelo id
  def delete(contacts, id) do
    Enum.reject(contacts, fn c -> c.id == id end)
  end

  # Busca um contato pelo id
  def find(contacts, id) do
    Enum.find(contacts, fn c -> c.id == id end)
  end

  # Edita campos de um contato existente
  def edit(contacts, id, fields) do
    Enum.map(contacts, fn c ->
      if c.id == id do
        Map.merge(c, Map.new(fields))
      else
        c
      end
    end)
  end

  # Busca contatos por nome, telefone ou email (parcial, case-insensitive)
  def search(contacts, {:name, value}) do
    filter(contacts, :name, value)
  end

  def search(contacts, {:phone, value}) do
    filter(contacts, :phone, value)
  end

  def search(contacts, {:email, value}) do
    filter(contacts, :email, value)
  end

  # Função privada que faz o filtro de fato
  defp filter(contacts, field, value) do
    value_down = String.downcase(value)
    Enum.filter(contacts, fn c ->
      c[field]
      |> String.downcase()
      |> String.contains?(value_down)
    end)
  end

end
