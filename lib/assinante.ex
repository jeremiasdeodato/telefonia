defmodule Assinante do

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all) do
    buscar(numero, key)

    #(fn assinante -> assinante.numero == numero end) ----> (&(&1.numero == numero))
  end

  defp buscar(numero, :pospago) do
    IO.inspect "busca pospago"
    assinantes_pospago()
    |> Enum.find(assinantes(),&(&1.numero == numero))
  end

  defp buscar(numero, :prepago) do
    IO.inspect "busca prepago"
    assinantes_prepago()
    |> Enum.find(assinantes(),&(&1.numero == numero))
  end

  defp buscar(numero, :all) do
    IO.inspect "busca geral"
    assinantes()
    |> Enum.find(assinantes(),&(&1.numero == numero))
  end

  def assinantes(), do: read(:prepago) ++ read(:pospago)
  def assinantes_prepago(), do: read(:prepago)
  def assinantes_pospago(), do: read(:pospago)

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar_assinante(numero) do
      nil ->
        (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
        |> :erlang.term_to_binary()
        |> write(plano)
        {:ok, "Assinante #{nome} cadastrado com sucesso!"}
      _assinante ->
        {:error, "Assinante com este número cadastrado!"}
    end
  end

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def read(plano) do
    {:ok, assinantes} = File.read(@assinantes[plano])
    assinantes
    |> :erlang.binary_to_term()
  end

end
