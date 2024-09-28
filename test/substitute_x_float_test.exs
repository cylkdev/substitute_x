defmodule SubstituteX.StructTest do
  use ExUnit.Case, async: true

  describe "compare?/3: " do
    test "match list of terms" do
      left = [1.0, 2.0, 3.0]

      right = [1.0, 2.0]

      assert SubstituteX.compare?(left, right)
    end

    test "returns true when left and right are equal" do
      assert SubstituteX.compare?(1.0, 1.0)
    end

    test "evaluation with ':is_float' operator" do
      assert SubstituteX.compare?(1.0, :is_float)
    end

    test "evaluation with ':===' operator" do
      assert SubstituteX.compare?(1.0, %{===: 1.0})
    end

    test "evaluation with ':!==' operator" do
      assert SubstituteX.compare?(1.0, %{!==: "invalid_term"})
    end

    test "evaluation with ':>' operator" do
      assert SubstituteX.compare?(2.0, %{>: 1.0})
    end

    test "evaluation with ':<' operator" do
      assert SubstituteX.compare?(1.0, %{<: 2.0})
    end

    test "evaluation with ':>=' operator" do
      assert SubstituteX.compare?(1.0, %{>=: 1.0})

      assert SubstituteX.compare?(2.0, %{>=: 1.0})
    end

    test "evaluation with ':<=' operator" do
      assert SubstituteX.compare?(1.0, %{<=: 1.0})

      assert SubstituteX.compare?(1.0, %{<=: 2.0})
    end

    test "evaluation with ':eq' operator" do
      assert SubstituteX.compare?(1.0, %{eq: 1.0})
    end

    test "evaluation with ':gt' operator" do
      assert SubstituteX.compare?(2.0, %{gt: 1.0})
    end

    test "evaluation with ':lt' operator" do
      assert SubstituteX.compare?(1.0, %{lt: 2.0})
    end

    test "evaluation with ':gte' operator" do
      assert SubstituteX.compare?(1.0, %{gte: 1.0})

      assert SubstituteX.compare?(2.0, %{gte: 1.0})
    end

    test "evaluation with ':lte' operator" do
      assert SubstituteX.compare?(1.0, %{lte: 1.0})

      assert SubstituteX.compare?(1.0, %{lte: 2.0})
    end
  end

  describe "change/4: " do
    test "replaces with literal" do
      assert 5.0 = SubstituteX.change(1.0, %{1.0 => 5.0})

      assert 5.0 = SubstituteX.change(1.0, %{1.0 => fn -> 5.0 end})
    end

    test "replaces with ':*' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{:* => 5.0})

      assert 5.0 = SubstituteX.change(1.0, %{:* => fn -> 5.0 end})
    end

    test "replaces with ':===' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{===: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{===: fn -> 5.0 end}})
    end

    test "replaces with ':!==' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{!==: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{!==: fn -> 5.0 end}})
    end

    test "replaces with ':>' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{0.0 => %{>: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{0.0 => %{>: fn -> 5.0 end}})
    end

    test "replaces with ':<' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{<: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{<: fn -> 5.0 end}})
    end

    test "replaces with ':>=' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{>=: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{>=: fn -> 5.0 end}})

      assert 5.0 = SubstituteX.change(1.0, %{0.0 => %{>=: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{0.0 => %{>=: fn -> 5.0 end}})
    end

    test "replaces with ':<=' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{<=: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{<=: fn -> 5.0 end}})

      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{<=: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{<=: fn -> 5.0 end}})
    end

    test "replaces with ':eq' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{eq: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{eq: fn -> 5.0 end}})
    end

    test "replaces with ':gt' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{0.0 => %{gt: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{0.0 => %{gt: fn -> 5.0 end}})
    end

    test "replaces with ':lt' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{lt: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{lt: fn -> 5.0 end}})
    end

    test "replaces with ':gte' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{gte: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{gte: fn -> 5.0 end}})

      assert 5.0 = SubstituteX.change(1.0, %{0.0 => %{gte: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{0.0 => %{gte: fn -> 5.0 end}})
    end

    test "replaces with ':lte' operator" do
      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{lte: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{1.0 => %{lte: fn -> 5.0 end}})

      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{lte: 5.0}})

      assert 5.0 = SubstituteX.change(1.0, %{2.0 => %{lte: fn -> 5.0 end}})
    end
  end
end
