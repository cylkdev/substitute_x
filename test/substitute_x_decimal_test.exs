defmodule SubstituteX.DecimalTest do
  use ExUnit.Case, async: true

  describe "compare?/3: " do
    test "match list of terms" do
      left = [Decimal.new("1.0"), Decimal.new("2.0"), Decimal.new("3.0")]

      right = [Decimal.new("1.0"), Decimal.new("2.0")]

      assert SubstituteX.compare?(left, right)
    end

    test "returns true when left and right are equal" do
      assert SubstituteX.compare?(Decimal.new("1.0"), Decimal.new("1.0"))
    end

    test "evaluation with ':is_struct' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), {:is_struct, Decimal})

      assert SubstituteX.compare?(Decimal.new("1.0"), %{is_struct: Decimal})

      refute SubstituteX.compare?(1, %{is_struct: Decimal})
    end

    test "evaluation with ':===' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{===: Decimal.new("1.0")})
    end

    test "evaluation with ':!==' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{!==: "invalid_term"})
    end

    test "evaluation with ':>' operator" do
      assert SubstituteX.compare?(Decimal.new("2.0"), %{>: Decimal.new("1.0")})
    end

    test "evaluation with ':<' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{<: Decimal.new("2.0")})
    end

    test "evaluation with ':>=' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{>=: Decimal.new("1.0")})

      assert SubstituteX.compare?(Decimal.new("2.0"), %{>=: Decimal.new("1.0")})
    end

    test "evaluation with ':<=' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{<=: Decimal.new("1.0")})

      assert SubstituteX.compare?(Decimal.new("1.0"), %{<=: Decimal.new("2.0")})
    end

    test "evaluation with ':eq' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{eq: Decimal.new("1.0")})
    end

    test "evaluation with ':gt' operator" do
      assert SubstituteX.compare?(Decimal.new("2.0"), %{gt: Decimal.new("1.0")})
    end

    test "evaluation with ':lt' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{lt: Decimal.new("2.0")})
    end

    test "evaluation with ':gte' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{gte: Decimal.new("1.0")})

      assert SubstituteX.compare?(Decimal.new("2.0"), %{gte: Decimal.new("1.0")})
    end

    test "evaluation with ':lte' operator" do
      assert SubstituteX.compare?(Decimal.new("1.0"), %{lte: Decimal.new("1.0")})

      assert SubstituteX.compare?(Decimal.new("1.0"), %{lte: Decimal.new("2.0")})
    end
  end

  describe "change/4: " do
    test "replaces with literal" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => Decimal.new("2.0")})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => fn -> Decimal.new("2.0") end})
    end

    test "replaces with ':*' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{:* => Decimal.new("2.0")})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{:* => fn -> Decimal.new("2.0") end})
    end

    test "replaces with ':===' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{===: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{===: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':!==' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{!==: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{!==: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':>' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{>: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{>: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':<' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{<: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{<: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':>=' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{>=: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{>=: fn -> Decimal.new("2.0") end}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{>=: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{>=: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':<=' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{<=: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{<=: fn -> Decimal.new("2.0") end}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{<=: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{<=: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':eq' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{eq: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{eq: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':gt' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{gt: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{gt: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':lt' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{lt: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{lt: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':gte' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{gte: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{gte: fn -> Decimal.new("2.0") end}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{gte: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{gte: fn -> Decimal.new("2.0") end}})
    end

    test "replaces with ':lte' operator" do
      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{lte: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{lte: fn -> Decimal.new("2.0") end}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{lte: Decimal.new("2.0")}})

      assert Decimal.new("2.0") === SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("2.0") => %{lte: fn -> Decimal.new("2.0") end}})
    end
  end
end
