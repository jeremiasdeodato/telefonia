defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "testes responsaveis para cadastro de assinantes" do
    test "criar uma conta prepago" do
      assert Assinante.cadastrar("Jeremias", "123", "123", :prepago) ==
               {:ok, "Assinante Jeremias cadastrado com sucesso!"}
    end

    test "deve retornar erro dizendo que assinante ja esta cadastrado" do
      Assinante.cadastrar("Jeremias", "123", "123", :prepago)

      assert Assinante.cadastrar("Jeremias", "123", "123", :prepago) ==
               {:error, "Assinante com este número cadastrado!"}
    end
  end

  describe "testes responsaveis por busca de assinantes" do
    test "deve retornar estrutura de assinante" do
      assert %Assinante{nome: "teste", numero: "123", cpf: "123", plano: "plano"}.nome == "teste"
    end

    test "busca pospago" do
      Assinante.cadastrar("Jeremias", "123", "123", :pospago)

      assert Assinante.buscar_assinante("123", :pospago).nome == "Jeremias"
      assert Assinante.buscar_assinante("123", :pospago).plano.__struct__ == Pospago
    end

    test "busca prepago" do
      Assinante.cadastrar("Jeremias", "123", "123", :prepago)

      assert Assinante.buscar_assinante("123", :prepago).nome == "Jeremias"
    end
  end

  describe "delete" do
    test "deve deletar um assinante" do
      Assinante.cadastrar("Jeremias", "123", "123", :prepago)
      Assinante.cadastrar("Joao", "333", "78456", :prepago)
      assert Assinante.deletar("123") == {:ok, "Assinante Jeremias deletado!"}
    end
  end
end
