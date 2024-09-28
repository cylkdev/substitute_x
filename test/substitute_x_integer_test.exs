defmodule SubstituteX.IntegerTest do
  use ExUnit.Case, async: true

  describe "compare?/3: " do
    test "match list of terms" do
      left = [1, 2, 3]

      right = [1, 2]

      assert SubstituteX.compare?(left, right)
    end

    test "returns true when left and right are equal" do
      assert SubstituteX.compare?(1, 1)
    end

    test "evaluation with ':is_integer' operator" do
      assert SubstituteX.compare?(1, :is_integer)
    end

    test "evaluation with ':===' operator" do
      assert SubstituteX.compare?(1, %{===: 1})
    end

    test "evaluation with ':!==' operator" do
      assert SubstituteX.compare?(1, %{!==: "invalid_term"})
    end

    test "evaluation with ':>' operator" do
      assert SubstituteX.compare?(2, %{>: 1})
    end

    test "evaluation with ':<' operator" do
      assert SubstituteX.compare?(1, %{<: 2})
    end

    test "evaluation with ':>=' operator" do
      assert SubstituteX.compare?(1, %{>=: 1})

      assert SubstituteX.compare?(2, %{>=: 1})
    end

    test "evaluation with ':<=' operator" do
      assert SubstituteX.compare?(1, %{<=: 1})

      assert SubstituteX.compare?(1, %{<=: 2})
    end

    test "evaluation with ':eq' operator" do
      assert SubstituteX.compare?(1, %{eq: 1})
    end

    test "evaluation with ':gt' operator" do
      assert SubstituteX.compare?(2, %{gt: 1})
    end

    test "evaluation with ':lt' operator" do
      assert SubstituteX.compare?(1, %{lt: 2})
    end

    test "evaluation with ':gte' operator" do
      assert SubstituteX.compare?(1, %{gte: 1})

      assert SubstituteX.compare?(2, %{gte: 1})
    end

    test "evaluation with ':lte' operator" do
      assert SubstituteX.compare?(1, %{lte: 1})

      assert SubstituteX.compare?(1, %{lte: 2})
    end
  end

  describe "change/4: " do
    test "replaces with literal" do
      assert 5 = SubstituteX.change(1, %{1 => 5})

      assert 5 = SubstituteX.change(1, %{1 => fn -> 5 end})
    end

    test "replaces with ':*' operator" do
      assert 5 = SubstituteX.change(1, %{:* => 5})

      assert 5 = SubstituteX.change(1, %{:* => fn -> 5 end})
    end

    test "replaces with ':===' operator" do
      assert 5 = SubstituteX.change(1, %{1 => %{===: 5}})

      assert 5 = SubstituteX.change(1, %{1 => %{===: fn -> 5 end}})
    end

    test "replaces with ':!==' operator" do
      assert 5 = SubstituteX.change(1, %{2 => %{!==: 5}})

      assert 5 = SubstituteX.change(1, %{2 => %{!==: fn -> 5 end}})
    end

    test "replaces with ':>' operator" do
      assert 5 = SubstituteX.change(1, %{0 => %{>: 5}})

      assert 5 = SubstituteX.change(1, %{0 => %{>: fn -> 5 end}})
    end

    test "replaces with ':<' operator" do
      assert 5 = SubstituteX.change(1, %{2 => %{<: 5}})

      assert 5 = SubstituteX.change(1, %{2 => %{<: fn -> 5 end}})
    end

    test "replaces with ':>=' operator" do
      assert 5 = SubstituteX.change(1, %{1 => %{>=: 5}})

      assert 5 = SubstituteX.change(1, %{1 => %{>=: fn -> 5 end}})

      assert 5 = SubstituteX.change(1, %{0 => %{>=: 5}})

      assert 5 = SubstituteX.change(1, %{0 => %{>=: fn -> 5 end}})
    end

    test "replaces with ':<=' operator" do
      assert 5 = SubstituteX.change(1, %{1 => %{<=: 5}})

      assert 5 = SubstituteX.change(1, %{1 => %{<=: fn -> 5 end}})

      assert 5 = SubstituteX.change(1, %{2 => %{<=: 5}})

      assert 5 = SubstituteX.change(1, %{2 => %{<=: fn -> 5 end}})
    end

    test "replaces with ':eq' operator" do
      assert 5 = SubstituteX.change(1, %{1 => %{eq: 5}})

      assert 5 = SubstituteX.change(1, %{1 => %{eq: fn -> 5 end}})
    end

    test "replaces with ':gt' operator" do
      assert 5 = SubstituteX.change(1, %{0 => %{gt: 5}})

      assert 5 = SubstituteX.change(1, %{0 => %{gt: fn -> 5 end}})
    end

    test "replaces with ':lt' operator" do
      assert 5 = SubstituteX.change(1, %{2 => %{lt: 5}})

      assert 5 = SubstituteX.change(1, %{2 => %{lt: fn -> 5 end}})
    end

    test "replaces with ':gte' operator" do
      assert 5 = SubstituteX.change(1, %{1 => %{gte: 5}})

      assert 5 = SubstituteX.change(1, %{1 => %{gte: fn -> 5 end}})

      assert 5 = SubstituteX.change(1, %{0 => %{gte: 5}})

      assert 5 = SubstituteX.change(1, %{0 => %{gte: fn -> 5 end}})
    end

    test "replaces with ':lte' operator" do
      assert 5 = SubstituteX.change(1, %{1 => %{lte: 5}})

      assert 5 = SubstituteX.change(1, %{1 => %{lte: fn -> 5 end}})

      assert 5 = SubstituteX.change(1, %{2 => %{lte: 5}})

      assert 5 = SubstituteX.change(1, %{2 => %{lte: fn -> 5 end}})
    end
  end
end
