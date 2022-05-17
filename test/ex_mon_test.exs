defmodule ExMonTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias ExMon.Player

  describe "create_player/4" do
    test "rteturns a player" do
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "Maestro"
      }

      assert expected_response == ExMon.create_player("Maestro", :chute, :soco, :cura)
    end
  end

  describe "start_game/1" do
    test "When the game is started, returns a message" do
      player = Player.build("Maestro", :chute, :soco, :cura)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      expected_response =
        "\n========== The Game is Started! ==========\n\n%{\n  computer: %ExMon.Player{\n    life: 100,\n    moves: %{move_avg: :kick, move_heal: :heal, move_rnd: :punch},\n    name: \"Robotinick\"\n  },\n  player: %ExMon.Player{\n    life: 100,\n    moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},\n    name: \"Maestro\"\n  },\n  status: :started,\n  turn: :player\n}\n============================================\n"

      assert messages == expected_response
      # Para não precisar copiar a string inteira como no exemplo acima podemos utilizar o =~ para procurar
      # somente um pedaço relevante da mensagem como no exemplo abaixo
      assert messages =~ "The Game is Started!"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("Maestro", :chute, :soco, :cura)
      capture_io(fn ->
          ExMon.start_game(player)
        end)
        :ok
    end

    test "when the move is valid, do the move and the computer makes a move" do
       messages =
        capture_io(fn ->
          ExMon.make_move(:chute)
        end)

      assert  messages =~ "The Player attacked computer"
      assert  messages =~ "It's computer turn"
      assert  messages =~ "The Computer attacked player"
      assert  messages =~ "It's player turn"
    end

    test "when the move is invalid, returns an error message " do
      messages =
        capture_io(fn ->
          ExMon.make_move(:fail)
        end)

      assert  messages == "\n========== Invalid Move: fail. ==========\n\n"
    end
  end
end
