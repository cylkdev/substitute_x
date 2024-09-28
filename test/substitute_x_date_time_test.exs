defmodule SubstituteX.DateTimeTest do
  use ExUnit.Case, async: true

  describe "compare?/3: " do
    test "match list of terms" do
      left = [~U[2024-09-25 00:00:00Z], ~U[2024-09-26 00:00:00Z], ~U[2024-09-27 00:00:00Z]]

      right = [~U[2024-09-25 00:00:00Z], ~U[2024-09-26 00:00:00Z]]

      assert SubstituteX.compare?(left, right)
    end

    test "returns true when map matches partial internal representation" do
      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], %{
        __struct__: DateTime,
        calendar: Calendar.ISO
      })
    end

    test "returns true when map matches entire internal representation" do
      map = %{
        __struct__: DateTime,
        calendar: Calendar.ISO,
        day: 25,
        hour: 0,
        microsecond: {0, 0},
        minute: 0,
        month: 9,
        second: 0,
        std_offset: 0,
        time_zone: "Etc/UTC",
        utc_offset: 0,
        year: 2024,
        zone_abbr: "UTC"
      }

      struct = ~U[2024-09-25 00:00:00Z]

      assert map === struct

      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], map)

      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], struct)
    end

    test "evaluation with ':is_struct' operator" do
      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], {:is_struct, DateTime})

      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], %{is_struct: DateTime})

      refute SubstituteX.compare?(1, %{is_struct: DateTime})
    end

    test "evaluation with ':===' operator" do
      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], %{===: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':!==' operator" do
      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], %{!==: "invalid_term"})

      refute SubstituteX.compare?(~U[2024-09-25 00:00:00Z], %{!==: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':>' operator" do
      assert SubstituteX.compare?(~U[2024-09-30 00:00:00Z], %{>: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':<' operator" do
      assert SubstituteX.compare?(~U[2024-09-24 00:00:00Z], %{<: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':>=' operator" do
      assert SubstituteX.compare?(~U[2024-09-30 00:00:00Z], %{>=: ~U[2024-09-30 00:00:00Z]})

      assert SubstituteX.compare?(~U[2024-09-30 00:00:00Z], %{>=: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':<=' operator" do
      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], %{<=: ~U[2024-09-25 00:00:00Z]})

      assert SubstituteX.compare?(~U[2024-09-24 00:00:00Z], %{<=: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':eq' operator" do
      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], %{eq: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':gt' operator" do
      assert SubstituteX.compare?(~U[2024-09-30 00:00:00Z], %{gt: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':lt' operator" do
      assert SubstituteX.compare?(~U[2024-09-24 00:00:00Z], %{lt: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':gte' operator" do
      assert SubstituteX.compare?(~U[2024-09-30 00:00:00Z], %{gte: ~U[2024-09-30 00:00:00Z]})

      assert SubstituteX.compare?(~U[2024-09-30 00:00:00Z], %{gte: ~U[2024-09-25 00:00:00Z]})
    end

    test "evaluation with ':lte' operator" do
      assert SubstituteX.compare?(~U[2024-09-25 00:00:00Z], %{lte: ~U[2024-09-25 00:00:00Z]})

      assert SubstituteX.compare?(~U[2024-09-24 00:00:00Z], %{lte: ~U[2024-09-25 00:00:00Z]})
    end
  end

  describe "change/4: " do
    test "replaces with literal" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => ~U[2024-09-30 00:00:00Z]})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => fn -> ~U[2024-09-30 00:00:00Z] end})
    end

    test "replaces with ':*' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{:* => ~U[2024-09-30 00:00:00Z]})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{:* => fn -> ~U[2024-09-30 00:00:00Z] end})
    end

    test "replaces with ':===' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{===: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{===: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':!==' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{!==: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{!==: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':>' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{>: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{>: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':<' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-26 00:00:00Z] => %{<: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-26 00:00:00Z] => %{<: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':>=' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{>=: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{>=: fn -> ~U[2024-09-30 00:00:00Z] end}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{>=: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{>=: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':<=' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{<=: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{<=: fn -> ~U[2024-09-30 00:00:00Z] end}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-26 00:00:00Z] => %{<=: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-26 00:00:00Z] => %{<=: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':eq' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{eq: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{eq: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':gt' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{gt: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{gt: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':lt' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-26 00:00:00Z] => %{lt: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-26 00:00:00Z] => %{lt: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':gte' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{gte: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{gte: fn -> ~U[2024-09-30 00:00:00Z] end}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{gte: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-20 00:00:00Z] => %{gte: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end

    test "replaces with ':lte' operator" do
      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{lte: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-25 00:00:00Z] => %{lte: fn -> ~U[2024-09-30 00:00:00Z] end}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-26 00:00:00Z] => %{lte: ~U[2024-09-30 00:00:00Z]}})

      assert ~U[2024-09-30 00:00:00Z] = SubstituteX.change(~U[2024-09-25 00:00:00Z], %{~U[2024-09-26 00:00:00Z] => %{lte: fn -> ~U[2024-09-30 00:00:00Z] end}})
    end
  end
end
