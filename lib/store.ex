defmodule AgendaCli.Store do
  # Caminho do arquivo onde os contatos ficam salvos
  @file_path "contacts.json"

  # Carrega os contatos do arquivo JSON
  # Se o arquivo não existir ainda, retorna lista vazia
  def load do
    case File.read(@file_path) do
      {:ok, content} ->
        # Jason.decode! transforma a string JSON em lista de maps Elixir
        Jason.decode!(content, keys: :atoms)

      {:error, :enoent} ->
        # Arquivo ainda não existe — começa com lista vazia
        []
    end
  end

  # Salva a lista de contatos no arquivo JSON
  def save(contacts) do
    # Jason.encode! transforma a lista de maps em string JSON formatada
    content = Jason.encode!(contacts, pretty: true)
    File.write!(@file_path, content)
  end
end