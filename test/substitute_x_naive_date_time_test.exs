defmodule SubstituteX.NaiveDateTimeTest do
  use ExUnit.Case, async: true

  describe "compare?/3: " do
    test "match list of terms" do
      left = [~N[2024-09-25 00:00:00], ~N[2024-09-26 00:00:00], ~N[2024-09-27 00:00:00]]

      right = [~N[2024-09-25 00:00:00], ~N[2024-09-26 00:00:00]]

      assert SubstituteX.compare?(left, right)
    end

    test "returns true when map matches partial internal representation" do
      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], %{
        __struct__: NaiveDateTime,
        calendar: Calendar.ISO
      })
    end

    test "returns true when map matches entire internal representation" do
      map = %{
        __struct__: NaiveDateTime,
        calendar: Calendar.ISO,
        day: 25,
        hour: 0,
        microsecond: {0, 0},
        minute: 0,
        month: 9,
        second: 0,
        year: 2024
      }

      struct = ~N[2024-09-25 00:00:00]

      assert map === struct

      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], map)

      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], struct)
    end

    test "evaluation with ':is_struct' operator" do
      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], {:is_struct, NaiveDateTime})

      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], %{is_struct: NaiveDateTime})

      refute SubstituteX.compare?(1, %{is_struct: NaiveDateTime})
    end

    test "evaluation with ':===' operator" do
      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], %{===: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':!==' operator" do
      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], %{!==: "invalid_term"})

      refute SubstituteX.compare?(~N[2024-09-25 00:00:00], %{!==: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':>' operator" do
      assert SubstituteX.compare?(~N[2024-09-26 00:00:00], %{>: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':<' operator" do
      assert SubstituteX.compare?(~N[2024-09-24 00:00:00], %{<: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':>=' operator" do
      assert SubstituteX.compare?(~N[2024-09-26 00:00:00], %{>=: ~N[2024-09-26 00:00:00]})

      assert SubstituteX.compare?(~N[2024-09-26 00:00:00], %{>=: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':<=' operator" do
      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], %{<=: ~N[2024-09-25 00:00:00]})

      assert SubstituteX.compare?(~N[2024-09-24 00:00:00], %{<=: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':eq' operator" do
      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], %{eq: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':gt' operator" do
      assert SubstituteX.compare?(~N[2024-09-26 00:00:00], %{gt: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':lt' operator" do
      assert SubstituteX.compare?(~N[2024-09-24 00:00:00], %{lt: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':gte' operator" do
      assert SubstituteX.compare?(~N[2024-09-26 00:00:00], %{gte: ~N[2024-09-26 00:00:00]})

      assert SubstituteX.compare?(~N[2024-09-26 00:00:00], %{gte: ~N[2024-09-25 00:00:00]})
    end

    test "evaluation with ':lte' operator" do
      assert SubstituteX.compare?(~N[2024-09-25 00:00:00], %{lte: ~N[2024-09-25 00:00:00]})

      assert SubstituteX.compare?(~N[2024-09-24 00:00:00], %{lte: ~N[2024-09-25 00:00:00]})
    end
  end

  describe "change/4: " do
    test "replaces with literal" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => ~N[2024-09-30 00:00:00]})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => fn -> ~N[2024-09-30 00:00:00] end})
    end

    test "replaces with ':*' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{:* => ~N[2024-09-30 00:00:00]})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{:* => fn -> ~N[2024-09-30 00:00:00] end})
    end

    test "replaces with ':===' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{===: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{===: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':!==' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{!==: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{!==: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':>' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{>: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{>: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':<' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-26 00:00:00] => %{<: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-26 00:00:00] => %{<: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':>=' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{>=: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{>=: fn -> ~N[2024-09-30 00:00:00] end}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{>=: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{>=: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':<=' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{<=: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{<=: fn -> ~N[2024-09-30 00:00:00] end}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-26 00:00:00] => %{<=: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-26 00:00:00] => %{<=: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':eq' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{eq: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{eq: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':gt' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{gt: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{gt: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':lt' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-26 00:00:00] => %{lt: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-26 00:00:00] => %{lt: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':gte' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{gte: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{gte: fn -> ~N[2024-09-30 00:00:00] end}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{gte: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-20 00:00:00] => %{gte: fn -> ~N[2024-09-30 00:00:00] end}})
    end

    test "replaces with ':lte' operator" do
      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{lte: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-25 00:00:00] => %{lte: fn -> ~N[2024-09-30 00:00:00] end}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-26 00:00:00] => %{lte: ~N[2024-09-30 00:00:00]}})

      assert ~N[2024-09-30 00:00:00] = SubstituteX.change(~N[2024-09-25 00:00:00], %{~N[2024-09-26 00:00:00] => %{lte: fn -> ~N[2024-09-30 00:00:00] end}})
    end
  end
end
