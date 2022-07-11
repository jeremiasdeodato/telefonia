defmodule ChamadaTest do
  use ExUnit.Case

  test "deve retornar estrutura de chamada" do
    %Chamada{data: DateTime.utc_now(), duracao: 30}.duracao == 30
  end
end
