defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "funcoes de ligacao" do
    test "fazer uma ligacao" do
      Assinante.cadastrar("Jeremias", "123", "123", :prepago)
      Recarga.nova(DateTime.utc_now(), 10, "123")

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35, e voce tem 5.65 de creditos"}
    end

    test "fazer uma ligacao longa e nao tem credito" do
      Assinante.cadastrar("Jeremias", "123", "123", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 10) ==
               {:error, "Voce nao tem creditos para fazer a ligacao, faca uma recarga"}
    end

    test "deve retornar estrutura de prepago" do
      assert %Prepago{creditos: 0, recargas: []}
    end
  end

  describe "Testes para impressao de contas" do
    test "deve informar valores da conta do mes" do
      Assinante.cadastrar("Jeremias", "123", "123", :prepago)
      data = DateTime.utc_now()
      data_antiga = ~U[2022-06-11 15:53:40.070914Z]
      Recarga.nova(data, 10, "123")
      Prepago.fazer_chamada("123", data, 3)

      Recarga.nova(data_antiga, 10, "123")
      Prepago.fazer_chamada("123", data_antiga, 3)

      assinante = Assinante.buscar_assinante("123", :prepago)
      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2

      assinante = Prepago.imprimir_conta(data.month, data.year, "123")

      assert assinante.numero == "123"
      assert Enum.count(assinante.chamadas) == 1
      assert Enum.count(assinante.plano.recargas) == 1
    end
  end
end
