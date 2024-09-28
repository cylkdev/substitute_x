defmodule SubstituteX.StringTest do
  use ExUnit.Case, async: true

  describe "compare?/3: " do
    test "match list of terms" do
      left = ["a", "b", "c"]

      right = ["a", "b"]

      assert SubstituteX.compare?(left, right)
    end

    test "evaluation with ':is_binary' operator" do
      assert SubstituteX.compare?("a", :is_binary)
    end

    test "returns true when left and right are equal" do
      assert SubstituteX.compare?("a", "a")
    end

    test "evaluation with ':===' operator" do
      assert SubstituteX.compare?("a", %{===: "a"})
    end

    test "evaluation with ':!==' operator" do
      assert SubstituteX.compare?("a", %{!==: "b"})
    end

    test "evaluation with ':>' operator" do
      assert SubstituteX.compare?("b", %{>: "a"})
    end

    test "evaluation with ':<' operator" do
      assert SubstituteX.compare?("a", %{<: "b"})
    end

    test "evaluation with ':>=' operator" do
      assert SubstituteX.compare?("a", %{>=: "a"})

      assert SubstituteX.compare?("b", %{>=: "a"})
    end

    test "evaluation with ':<=' operator" do
      assert SubstituteX.compare?("a", %{<=: "a"})

      assert SubstituteX.compare?("a", %{<=: "b"})
    end

    test "evaluation with ':eq' operator" do
      assert SubstituteX.compare?("a", %{eq: "a"})
    end

    test "evaluation with ':gt' operator" do
      assert SubstituteX.compare?("b", %{gt: "a"})
    end

    test "evaluation with ':lt' operator" do
      assert SubstituteX.compare?("a", %{lt: "b"})
    end

    test "evaluation with ':gte' operator" do
      assert SubstituteX.compare?("a", %{gte: "a"})

      assert SubstituteX.compare?("b", %{gte: "a"})
    end

    test "evaluation with ':lte' operator" do
      assert SubstituteX.compare?("a", %{lte: "a"})

      assert SubstituteX.compare?("a", %{lte: "b"})
    end
  end

  describe "change/4: " do
    test "replaces with literal" do
      assert "d" = SubstituteX.change("b", %{"b" => "d"})

      assert "d" = SubstituteX.change("b", %{"b" => fn -> "d" end})
    end

    test "replaces with ':*' operator" do
      assert "d" = SubstituteX.change("b", %{:* => "d"})

      assert "d" = SubstituteX.change("b", %{:* => fn -> "d" end})
    end

    test "replaces with ':===' operator" do
      assert "d" = SubstituteX.change("b", %{"b" => %{===: "d"}})

      assert "d" = SubstituteX.change("b", %{"b" => %{===: fn -> "d" end}})
    end

    test "replaces with ':!==' operator" do
      assert "d" = SubstituteX.change("b", %{"a" => %{!==: "d"}})

      assert "d" = SubstituteX.change("b", %{"a" => %{!==: fn -> "d" end}})
    end

    test "replaces with ':>' operator" do
      assert "d" = SubstituteX.change("b", %{"a" => %{>: "d"}})

      assert "d" = SubstituteX.change("b", %{"a" => %{>: fn -> "d" end}})
    end

    test "replaces with ':<' operator" do
      assert "d" = SubstituteX.change("b", %{"c" => %{<: "d"}})

      assert "d" = SubstituteX.change("b", %{"c" => %{<: fn -> "d" end}})
    end

    test "replaces with ':>=' operator" do
      assert "d" = SubstituteX.change("b", %{"b" => %{>=: "d"}})

      assert "d" = SubstituteX.change("b", %{"b" => %{>=: fn -> "d" end}})

      assert "d" = SubstituteX.change("b", %{"a" => %{>=: "d"}})

      assert "d" = SubstituteX.change("b", %{"a" => %{>=: fn -> "d" end}})
    end

    test "replaces with ':<=' operator" do
      assert "d" = SubstituteX.change("b", %{"b" => %{<=: "d"}})

      assert "d" = SubstituteX.change("b", %{"b" => %{<=: fn -> "d" end}})

      assert "d" = SubstituteX.change("b", %{"c" => %{<=: "d"}})

      assert "d" = SubstituteX.change("b", %{"c" => %{<=: fn -> "d" end}})
    end

    test "replaces with ':eq' operator" do
      assert "d" = SubstituteX.change("b", %{"b" => %{eq: "d"}})

      assert "d" = SubstituteX.change("b", %{"b" => %{eq: fn -> "d" end}})
    end

    test "replaces with ':gt' operator" do
      assert "d" = SubstituteX.change("b", %{"a" => %{gt: "d"}})

      assert "d" = SubstituteX.change("b", %{"a" => %{gt: fn -> "d" end}})
    end

    test "replaces with ':lt' operator" do
      assert "d" = SubstituteX.change("b", %{"c" => %{lt: "d"}})

      assert "d" = SubstituteX.change("b", %{"c" => %{lt: fn -> "d" end}})
    end

    test "replaces with ':gte' operator" do
      assert "d" = SubstituteX.change("b", %{"b" => %{gte: "d"}})

      assert "d" = SubstituteX.change("b", %{"b" => %{gte: fn -> "d" end}})

      assert "d" = SubstituteX.change("b", %{"a" => %{gte: "d"}})

      assert "d" = SubstituteX.change("b", %{"a" => %{gte: fn -> "d" end}})
    end

    test "replaces with ':lte' operator" do
      assert "d" = SubstituteX.change("b", %{"b" => %{lte: "d"}})

      assert "d" = SubstituteX.change("b", %{"b" => %{lte: fn -> "d" end}})

      assert "d" = SubstituteX.change("b", %{"c" => %{lte: "d"}})

      assert "d" = SubstituteX.change("b", %{"c" => %{lte: fn -> "d" end}})
    end
  end
end
