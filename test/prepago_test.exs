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

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35, e voce tem 5.65 de creditos"}
    end

    test "fazer uma ligacao longa e nao tem credito" do
      Assinante.cadastrar("Jeremias", "123", "123", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 10) ==
               {:error, "Voce nao tem creditos para fazer a ligacao, faca uma recarga"}
    end
  end
end
