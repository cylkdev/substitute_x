defmodule SubstituteXTest do
  use ExUnit.Case, async: true
  doctest SubstituteX

  describe "matches?/3: " do
    test "integer on the left is equal to integer on the right" do
      assert SubstituteX.matches?(1, :===, 1)

      assert SubstituteX.matches?(1, :eq, 1)
    end

    test "integer on the left is not equal to integer on the right" do
      refute SubstituteX.matches?(1, :===, 2)
    end

    test "integer on the left is greater than integer on the right" do
      assert SubstituteX.matches?(2, :>, 1)

      assert SubstituteX.matches?(2, :gt, 1)
    end

    test "integer on the left is less than integer on the right" do
      assert SubstituteX.matches?(1, :<, 2)

      assert SubstituteX.matches?(1, :lt, 2)
    end

    test "integer on the left is equal to or greater than integer on the right" do
      assert SubstituteX.matches?(2, :>=, 2)

      assert SubstituteX.matches?(2, :>=, 1)

      assert SubstituteX.matches?(2, :gte, 1)
    end

    test "integer on the left is equal to or less than integer on the right" do
      assert SubstituteX.matches?(2, :<=, 2)

      assert SubstituteX.matches?(1, :<=, 2)

      assert SubstituteX.matches?(1, :lte, 2)
    end

    test "string on the left is equal to string on the right" do
      assert SubstituteX.matches?("foo", :===, "foo")
    end

    test "string on the left is not equal to string on the right" do
      refute SubstituteX.matches?("foo", :===, "bar")
    end

    test "string on the left is greater than the string on the right" do
      assert SubstituteX.matches?("foo", :>, "fo")

      assert SubstituteX.matches?("foo", :gt, "fo")
    end

    test "string on the left is less than the string on the right" do
      assert SubstituteX.matches?("foo", :<, "foobar")

      assert SubstituteX.matches?("foo", :lt, "foobar")
    end

    test "string on the left is equal to or greater than the string on the right" do
      assert SubstituteX.matches?("foo", :<=, "foo")

      assert SubstituteX.matches?("foo", :>=, "fo")

      assert SubstituteX.matches?("foo", :gte, "fo")
    end

    test "string on the left is equal to or less than the string on the right" do
      assert SubstituteX.matches?("foo", :<=, "foo")

      assert SubstituteX.matches?("foo", :<=, "foobar")

      assert SubstituteX.matches?("foo", :lte, "foobar")
    end

    test "string on the left matches string on the right" do
      assert SubstituteX.matches?("foo", :=~, "fo")
    end

    test "string on the left matches regex on the right" do
      assert SubstituteX.matches?("foo", :=~, ~r|fo|)
    end

    test "datetime on the left is equal to datetime on the right" do
      assert SubstituteX.matches?(~U[2024-08-14 00:00:00Z], :===, ~U[2024-08-14 00:00:00Z])
    end

    test "datetime on the left is greater than datetime on the right" do
      assert SubstituteX.matches?(~U[2024-08-14 01:00:00Z], :>, ~U[2024-08-14 00:00:00Z])
    end

    test "datetime on the left is less than datetime on the right" do
      assert SubstituteX.matches?(~U[2024-08-14 00:00:00Z], :<, ~U[2024-08-14 01:00:00Z])
    end

    test "datetime on the left is equal to or greater than datetime on the right" do
      assert SubstituteX.matches?(~U[2024-08-14 01:00:00Z], :>=, ~U[2024-08-14 01:00:00Z])

      assert SubstituteX.matches?(~U[2024-08-14 01:00:00Z], :>=, ~U[2024-08-14 00:00:00Z])

      assert SubstituteX.matches?(~U[2024-08-14 01:00:00Z], :gte, ~U[2024-08-14 00:00:00Z])
    end

    test "datetime on the left is equal to or less than datetime on the right" do
      assert SubstituteX.matches?(~U[2024-08-14 00:00:00Z], :<=, ~U[2024-08-14 00:00:00Z])

      assert SubstituteX.matches?(~U[2024-08-14 00:00:00Z], :<=, ~U[2024-08-14 01:00:00Z])

      assert SubstituteX.matches?(~U[2024-08-14 00:00:00Z], :lte, ~U[2024-08-14 01:00:00Z])
    end

    test "naive datetime on the left is equal to naive datetime on the right" do
      assert SubstituteX.matches?(~N[2024-08-14 00:00:00], :===, ~N[2024-08-14 00:00:00])
    end

    test "naive datetime on the left is greater than naive datetime on the right" do
      assert SubstituteX.matches?(~N[2024-08-14 01:00:00], :>, ~N[2024-08-14 00:00:00])
    end

    test "naive datetime on the left is less than naive datetime on the right" do
      assert SubstituteX.matches?(~N[2024-08-14 00:00:00], :<, ~N[2024-08-14 01:00:00])
    end

    test "naive datetime on the left is equal to or greater than naive datetime on the right" do
      assert SubstituteX.matches?(~N[2024-08-14 01:00:00], :>=, ~N[2024-08-14 01:00:00])

      assert SubstituteX.matches?(~N[2024-08-14 01:00:00], :>=, ~N[2024-08-14 00:00:00])

      assert SubstituteX.matches?(~N[2024-08-14 01:00:00], :gte, ~N[2024-08-14 00:00:00])
    end

    test "naive datetime on the left is equal to or less than naive datetime on the right" do
      assert SubstituteX.matches?(~N[2024-08-14 00:00:00], :<=, ~N[2024-08-14 00:00:00])

      assert SubstituteX.matches?(~N[2024-08-14 00:00:00], :<=, ~N[2024-08-14 01:00:00])

      assert SubstituteX.matches?(~N[2024-08-14 00:00:00], :lte, ~N[2024-08-14 01:00:00])
    end
  end

  describe "change/4 - string " do
    test "replace a string with wildcard(*) operator" do
      assert "bar" = SubstituteX.change("foo", %{:* => "bar"})
    end

    test "replace a string with literal" do
      assert "bar" = SubstituteX.change("foo", %{"foo" => "bar"})
    end

    test "replace a string with operator `:!==`" do
      assert "bar" = SubstituteX.change("foo", %{"qux" => %{!==: "bar"}})
    end

    test "replace a string with operator `:=~`" do
      assert "bar" = SubstituteX.change("foo", %{"foo" => %{=~: "bar"}})
    end

    test "replace a string with operator `:<`" do
      assert "bar" = SubstituteX.change("foo", %{"foob" => %{<: "bar"}})
    end

    test "replace a string with operator `:>`" do
      assert "bar" = SubstituteX.change("foo", %{"fo" => %{>: "bar"}})
    end

    test "replace a string with operator `:<=` when equal" do
      assert "bar" = SubstituteX.change("foo", %{"foo" => %{<=: "bar"}})
    end

    test "replace a string with operator `:<=` when less than" do
      assert "bar" = SubstituteX.change("foo", %{"foob" => %{<=: "bar"}})
    end

    test "replace a string with operator `:>=` when equal" do
      assert "bar" = SubstituteX.change("foo", %{"foo" => %{>=: "bar"}})
    end

    test "replace a string with operator `:>=` when greater than" do
      assert "bar" = SubstituteX.change("foo", %{"fo" => %{>=: "bar"}})
    end

    test "replace a string with operator `:lt`" do
      assert "bar" = SubstituteX.change("foo", %{"foob" => %{lt: "bar"}})
    end

    test "replace a string with operator `:gt`" do
      assert "bar" = SubstituteX.change("foo", %{"fo" => %{gt: "bar"}})
    end

    test "replace a string with operator `:lte` when equal" do
      assert "bar" = SubstituteX.change("foo", %{"foo" => %{lte: "bar"}})
    end

    test "replace a string with operator `:lte` when less than" do
      assert "bar" = SubstituteX.change("foo", %{"foob" => %{lte: "bar"}})
    end

    test "replace a string with operator `:gte` when equal" do
      assert "bar" = SubstituteX.change("foo", %{"foo" => %{gte: "bar"}})
    end

    test "replace a string with operator `:gte` when greater than" do
      assert "bar" = SubstituteX.change("foo", %{"fo" => %{gte: "bar"}})
    end
  end

  describe "change/4 | map " do
    test "replace the value of a key with wildcard (:*) operator" do
      assert %{body: "bar"} =
        SubstituteX.change(
          %{body: "foo"},
          %{body: %{:* => "bar"}}
        )
    end

    test "replace values of a key with wildcard (:*) operator" do
      assert %{comments: [%{body: "bar"}]} =
        SubstituteX.change(
          %{comments: [%{body: "foo"}]},
          %{comments: %{body: %{:* => "bar"}}}
        )
    end

    test "replace values with literals" do
      assert %{body: "bar", count: 0, inserted_at: %Decimal{coef: 20, exp: -1, sign: 1}} =
        SubstituteX.change(
          %{
            body: "foo",
            count: 10,
            inserted_at: Decimal.new("1.0")
          },
          %{
            body: %{"foo" => "bar"},
            count: %{10 => 0},
            inserted_at: %{Decimal.new("1.0") => Decimal.new("2.0")}
          }
        )
    end

    test "replace values with operators" do
      assert %{
        body: "bar",
        count: 0,
        target_date: %Date{calendar: Calendar.ISO, day: 25, month: 9, year: 2024},
        inserted_at: %Decimal{coef: 20, exp: -1, sign: 1}
      } =
        SubstituteX.change(
          %{
            body: "foo",
            count: 10,
            target_date: ~D[2024-09-25],
            inserted_at: Decimal.new("1.0")
          },
          %{
            body: %{"foo" => "bar"},
            count: %{10 => 0},
            target_date: %{~D[2024-09-20] => %{:* => ~D[2024-09-25]}},
            inserted_at: %{Decimal.new("1.0") => %{===: Decimal.new("2.0")}}
          }
        )
    end

    test "replace a value with 0-arity function" do
      assert %{body: "bar"} =
        SubstituteX.change(
          %{body: "foo"},
          %{
            body: %{
              "foo" => %{
                =~: fn -> "bar" end
              }
            }
          }
        )
    end

    test "replace a value with 1-arity function" do
      assert %{body: "bar"} =
        SubstituteX.change(
          %{body: "foo"},
          %{
            body: %{
              "foo" => %{
                =~: fn "foo" -> "bar" end
              }
            }
          }
        )
    end

    test "replace a value with 2-arity function" do
      assert %{body: "bar"} =
        SubstituteX.change(
          %{body: "foo"},
          %{
            body: %{
              "foo" => %{
                =~: fn "foo", :=~ -> "bar" end
              }
            }
          }
        )
    end

    test "replace a value with 3-arity function" do
      assert %{body: "bar"} =
        SubstituteX.change(
          %{body: "foo"},
          %{
            body: %{
              "foo" => %{
                =~: fn "foo", :=~, "foo" -> "bar" end
              }
            }
          }
        )
    end

    test "replace a value on first match using operators" do
      assert %{body: "bux"} =
        SubstituteX.change(
          %{body: "foobar"},
          %{
            body: %{
              "foo" => %{
                ===: "qux",
                =~: "bux"
              }
            }
          }
        )
    end

    test "replace a value on first match using distinct values" do
      assert %{body: "bux"} =
        SubstituteX.change(
          %{body: "foobar"},
          %{
            body: %{
              "foo" => %{===: "qux"},
              "foob" => %{=~: "bux"}
            }
          }
        )
    end

    test "replace value on a list of maps" do
      assert [
        %{body: "bar", count: 0},
        %{body: "bar", count: 5}
      ] =
        SubstituteX.change(
          [
            %{
              body: "foo",
              count: 10
            },
            %{
              body: "foo",
              count: 5
            }
          ],
          %{
            body: %{"foo" => "bar"},
            count: %{10 => 0}
          }
        )
    end

    test "replace the value of a key where the value is a list a maps" do
      assert %{comments: [%{body: "bar"}]} =
        SubstituteX.change(
          %{comments: [%{body: "foo"}]},
          %{comments: %{body: %{"foo" => "bar"}}}
        )
    end

    test "no change when match not found" do
      assert %{body: "foo"} = SubstituteX.change(%{body: "foo"}, %{body: %{"qux" => "bux"}})
    end

    test "no change when operator not supported" do
      assert %{body: "foo"} = SubstituteX.change(%{body: "foo"}, %{body: %{"foo" => %{invalid_operator: "bar"}}})
    end

    test "no change when map does not have key" do
      assert %{body: "foo"} = SubstituteX.change(%{body: "foo"}, %{invalid_key: %{"foo" => "bar"}})
    end

    test "replace with argument {params, replacement} and all params match" do
      assert %{body: "bar", count: 0} =
        SubstituteX.change(
          %{body: "foo"},
          {%{body: "foo"}, %{body: "bar", count: 0}}
        )
    end

    test "no change with argument {params, replacement} and match not found" do
      assert %{body: "foo"} =
        SubstituteX.change(
          %{body: "foo"},
          {%{not_a_match: "foo"}, %{body: "bar", count: 0}}
        )
    end
  end

  describe "change/4 - keyword " do
    test "replace the value of a key with wildcard (:*) operator" do
      assert [body: "bar"] =
        SubstituteX.change(
          [body: "foo"],
          %{body: %{:* => "bar"}}
        )
    end

    test "replace values of a key with wildcard (:*) operator" do
      assert [comments: [%{body: "bar"}]] =
        SubstituteX.change(
          [comments: [%{body: "foo"}]],
          %{comments: %{body: %{:* => "bar"}}}
        )
    end

    test "replace values with literals" do
      assert [body: "bar", count: 0, inserted_at: %Decimal{coef: 20, exp: -1, sign: 1}] =
        SubstituteX.change(
          [
            body: "foo",
            count: 10,
            inserted_at: Decimal.new("1.0")
          ],
          %{
            body: %{"foo" => "bar"},
            count: %{10 => 0},
            inserted_at: %{Decimal.new("1.0") => Decimal.new("2.0")}
          }
        )
    end

    test "replace values with operators" do
      assert [
        body: "bar",
        count: 0,
        target_date: %Date{calendar: Calendar.ISO, day: 25, month: 9, year: 2024},
        inserted_at: %Decimal{coef: 20, exp: -1, sign: 1}
      ] =
        SubstituteX.change(
          [
            body: "foo",
            count: 10,
            target_date: ~D[2024-09-25],
            inserted_at: Decimal.new("1.0")
          ],
          %{
            body: %{"foo" => "bar"},
            count: %{10 => 0},
            target_date: %{~D[2024-09-20] => %{:* => ~D[2024-09-25]}},
            inserted_at: %{Decimal.new("1.0") => %{===: Decimal.new("2.0")}}
          }
        )
    end

    test "replace a value with 0-arity function" do
      assert [body: "bar"] =
        SubstituteX.change(
          [body: "foo"],
          %{
            body: %{
              "foo" => %{
                =~: fn -> "bar" end
              }
            }
          }
        )
    end

    test "replace a value with 1-arity function" do
      assert [body: "bar"] =
        SubstituteX.change(
          [body: "foo"],
          %{
            body: %{
              "foo" => %{
                =~: fn "foo" -> "bar" end
              }
            }
          }
        )
    end

    test "replace a value with 2-arity function" do
      assert [body: "bar"] =
        SubstituteX.change(
          [body: "foo"],
          %{
            body: %{
              "foo" => %{
                =~: fn "foo", :=~ -> "bar" end
              }
            }
          }
        )
    end

    test "replace a value with 3-arity function" do
      assert [body: "bar"] =
        SubstituteX.change(
          [body: "foo"],
          %{
            body: %{
              "foo" => %{
                =~: fn "foo", :=~, "foo" -> "bar" end
              }
            }
          }
        )
    end

    test "replace a value on first match using operators" do
      assert [body: "bux"] =
        SubstituteX.change(
          [body: "foobar"],
          %{
            body: %{
              "foo" => %{
                ===: "qux",
                =~: "bux"
              }
            }
          }
        )
    end

    test "replace a value on first match using distinct values" do
      assert [body: "bux"] =
        SubstituteX.change(
          [body: "foobar"],
          %{
            body: %{
              "foo" => %{===: "qux"},
              "foob" => %{=~: "bux"}
            }
          }
        )
    end

    test "replace value on a list of maps" do
      assert [
        [body: "bar", count: 0],
        [body: "bar", count: 5]
      ] =
        SubstituteX.change(
          [
            [
              body: "foo",
              count: 10
            ],
            [
              body: "foo",
              count: 5
            ]
          ],
          %{
            body: %{"foo" => "bar"},
            count: %{10 => 0}
          }
        )
    end

    test "replace the value of a key where the value is a list a maps" do
      assert [comments: [%{body: "bar"}]] =
        SubstituteX.change(
          [comments: [%{body: "foo"}]],
          %{comments: %{body: %{"foo" => "bar"}}}
        )
    end

    test "no change when match not found" do
      assert [body: "foo"] = SubstituteX.change([body: "foo"], %{body: %{"qux" => "bux"}})
    end

    test "no change when operator not supported" do
      assert [body: "foo"] = SubstituteX.change([body: "foo"], %{body: %{"foo" => %{invalid_operator: "bar"}}})
    end

    test "no change when map does not have key" do
      assert [body: "foo"] = SubstituteX.change([body: "foo"], %{invalid_key: %{"foo" => "bar"}})
    end

    test "replace with argument {params, replacement} and all params match" do
      assert %{body: "bar", count: 0} =
        SubstituteX.change(
          [body: "foo"],
          {[body: "foo"], %{body: "bar", count: 0}}
        )
    end

    test "no change with argument {params, replacement} and match not found" do
      assert [body: "foo"] =
        SubstituteX.change(
          [body: "foo"],
          {%{not_a_match: "foo"}, %{body: "bar", count: 0}}
        )
    end
  end

  describe "change/4 | integer " do
    test "replaces if equal" do
      assert 2 = SubstituteX.change(1, %{1 => 2})

      assert 2 = SubstituteX.change(1, %{1 => %{===: 2}})
    end

    test "replaces if less than" do
      assert 2 = SubstituteX.change(1, %{3 => %{<: 2}})
    end

    test "replaces if greater than" do
      assert 2 = SubstituteX.change(1, %{0 => %{>: 2}})
    end

    test "replaces if equal to or less than" do
      assert 2 = SubstituteX.change(1, %{3 => %{<=: 2}})
    end

    test "replaces if equal to or greater than" do
      assert 2 = SubstituteX.change(1, %{1 => %{>=: 2}})
    end

    test "operator `:eq` replaces if equal" do
      assert 2 = SubstituteX.change(1, %{1 => %{eq: 2}})
    end

    test "operator `:lt` replaces if less than" do
      assert 2 = SubstituteX.change(1, %{3 => %{lt: 2}})
    end

    test "operator `:gt` replaces if greater than" do
      assert 2 = SubstituteX.change(1, %{0 => %{gt: 2}})
    end

    test "operator `:lte` replaces if equal to or less than" do
      assert 2 = SubstituteX.change(1, %{1 => %{lte: 2}})

      assert 2 = SubstituteX.change(1, %{3 => %{lte: 2}})
    end

    test "operator `:gte` replaces if equal to or greater than" do
      assert 2 = SubstituteX.change(1, %{1 => %{gte: 2}})

      assert 2 = SubstituteX.change(1, %{0 => %{gte: 2}})
    end
  end

  describe "change/4 | float " do
    test "replaces if equal" do
      assert 2.0 = SubstituteX.change(1.0, %{1.0 => 2.0})

      assert 2.0 = SubstituteX.change(1.0, %{1.0 => %{===: 2.0}})
    end

    test "replaces if less than" do
      assert 2.0 = SubstituteX.change(1.0, %{3.0 => %{<: 2.0}})
    end

    test "replaces if greater than" do
      assert 2.0 = SubstituteX.change(1.0, %{0.0 => %{>: 2.0}})
    end

    test "replaces if equal to or less than" do
      assert 2.0 = SubstituteX.change(1.0, %{3.0 => %{<=: 2.0}})
    end

    test "replaces if equal to or greater than" do
      assert 2.0 = SubstituteX.change(1.0, %{1.0 => %{>=: 2.0}})
    end

    test "operator `:eq` replaces if equal" do
      assert 2.0 = SubstituteX.change(1.0, %{1.0 => %{eq: 2.0}})
    end

    test "operator `:lt` replaces if less than" do
      assert 2.0 = SubstituteX.change(1.0, %{3.0 => %{lt: 2.0}})
    end

    test "operator `:gt` replaces if greater than" do
      assert 2.0 = SubstituteX.change(1.0, %{0.0 => %{gt: 2.0}})
    end

    test "operator `:lte` replaces if equal to or less than" do
      assert 2.0 = SubstituteX.change(2.0, %{3.0 => %{lte: 2.0}})

      assert 2.0 = SubstituteX.change(1.0, %{3.0 => %{lte: 2.0}})
    end

    test "operator `:gte` replaces if equal to or greater than" do
      assert 2.0 = SubstituteX.change(2.0, %{1.0 => %{gte: 2.0}})

      assert 2.0 = SubstituteX.change(1.0, %{1.0 => %{gte: 2.0}})
    end
  end

  describe "change/4 | decimal " do
    test "replaces if equal" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => Decimal.new("2.0")})

      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{===: Decimal.new("2.0")}})
    end

    test "replaces if less than" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("3.0") => %{<: Decimal.new("2.0")}})
    end

    test "replaces if greater than" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{>: Decimal.new("2.0")}})
    end

    test "replaces if equal to or less than" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("3.0") => %{<=: Decimal.new("2.0")}})
    end

    test "replaces if equal to or greater than" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{>=: Decimal.new("2.0")}})
    end

    test "operator `:eq` replaces if equal" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{eq: Decimal.new("2.0")}})
    end

    test "operator `:lt` replaces if less than" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("3.0") => %{lt: Decimal.new("2.0")}})
    end

    test "operator `:gt` replaces if greater than" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{gt: Decimal.new("2.0")}})
    end

    test "operator `:lte` replaces if equal to or less than" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{lte: Decimal.new("2.0")}})

      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("3.0") => %{lte: Decimal.new("2.0")}})
    end

    test "operator `:gte` replaces if equal to or greater than" do
      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{gte: Decimal.new("2.0")}})

      assert %Decimal{sign: 1, coef: 20, exp: -1} =
        SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{gte: Decimal.new("2.0")}})
    end
  end

  describe "change/4 | datetime " do
    test "replaces if equal" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => ~U[2024-08-10 00:00:00Z]})

      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => %{===: ~U[2024-08-10 00:00:00Z]}})
    end

    test "replaces if less than" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-15 00:00:00Z] => %{<: ~U[2024-08-10 00:00:00Z]}})
    end

    test "replaces if greater than" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-13 00:00:00Z] => %{>: ~U[2024-08-10 00:00:00Z]}})
    end

    test "replaces if equal to or less than" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-15 00:00:00Z] => %{<=: ~U[2024-08-10 00:00:00Z]}})
    end

    test "replaces if equal to or greater than" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-13 00:00:00Z] => %{>=: ~U[2024-08-10 00:00:00Z]}})
    end

    test "operator `:eq` replaces if equal" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => %{eq: ~U[2024-08-10 00:00:00Z]}})
    end

    test "operator `:lt` replaces if less than" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-15 00:00:00Z] => %{lt: ~U[2024-08-10 00:00:00Z]}})
    end

    test "operator `:gt` replaces if greater than" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-13 00:00:00Z] => %{gt: ~U[2024-08-10 00:00:00Z]}})
    end

    test "operator `:lte` replaces if equal to or less than" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => %{lte: ~U[2024-08-10 00:00:00Z]}})

      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-15 00:00:00Z] => %{lte: ~U[2024-08-10 00:00:00Z]}})
    end

    test "operator `:gte` replaces if equal to or greater than" do
      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => %{gte: ~U[2024-08-10 00:00:00Z]}})

      assert ~U[2024-08-10 00:00:00Z] =
        SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-13 00:00:00Z] => %{gte: ~U[2024-08-10 00:00:00Z]}})
    end
  end

  describe "change/4 | naive datetime " do
    test "replaces if equal" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => ~N[2024-08-10 00:00:00]})

      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => %{===: ~N[2024-08-10 00:00:00]}})
    end

    test "replaces if less than" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-15 00:00:00] => %{<: ~N[2024-08-10 00:00:00]}})
    end

    test "replaces if greater than" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-13 00:00:00] => %{>: ~N[2024-08-10 00:00:00]}})
    end

    test "replaces if equal to or less than" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-15 00:00:00] => %{<=: ~N[2024-08-10 00:00:00]}})
    end

    test "replaces if equal to or greater than" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-13 00:00:00] => %{>=: ~N[2024-08-10 00:00:00]}})
    end

    test "operator `:eq` replaces if equal" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => %{eq: ~N[2024-08-10 00:00:00]}})
    end

    test "operator `:lt` replaces if less than" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-15 00:00:00] => %{lt: ~N[2024-08-10 00:00:00]}})
    end

    test "operator `:gt` replaces if greater than" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-13 00:00:00] => %{gt: ~N[2024-08-10 00:00:00]}})
    end

    test "operator `:lte` replaces if equal to or less than" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => %{lte: ~N[2024-08-10 00:00:00]}})

      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-15 00:00:00] => %{lte: ~N[2024-08-10 00:00:00]}})
    end

    test "operator `:gte` replaces if equal to or greater than" do
      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => %{gte: ~N[2024-08-10 00:00:00]}})

      assert ~N[2024-08-10 00:00:00] =
        SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-13 00:00:00] => %{gte: ~N[2024-08-10 00:00:00]}})
    end
  end
end
