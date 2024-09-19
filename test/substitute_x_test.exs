defmodule SubstituteXTest do
  use ExUnit.Case, async: true
  doctest SubstituteX

  # describe "compare?/3: " do
  #   test "integer on the left is equal to integer on the right" do
  #     assert SubstituteX.compare?(1, :===, 1)

  #     assert SubstituteX.compare?(1, :eq, 1)
  #   end

  #   test "integer on the left is not equal to integer on the right" do
  #     refute SubstituteX.compare?(1, :===, 2)
  #   end

  #   test "integer on the left is greater than integer on the right" do
  #     assert SubstituteX.compare?(2, :>, 1)

  #     assert SubstituteX.compare?(2, :gt, 1)
  #   end

  #   test "integer on the left is less than integer on the right" do
  #     assert SubstituteX.compare?(1, :<, 2)

  #     assert SubstituteX.compare?(1, :lt, 2)
  #   end

  #   test "integer on the left is equal to or greater than integer on the right" do
  #     assert SubstituteX.compare?(2, :>=, 2)

  #     assert SubstituteX.compare?(2, :>=, 1)

  #     assert SubstituteX.compare?(2, :gte, 1)
  #   end

  #   test "integer on the left is equal to or less than integer on the right" do
  #     assert SubstituteX.compare?(2, :<=, 2)

  #     assert SubstituteX.compare?(1, :<=, 2)

  #     assert SubstituteX.compare?(1, :lte, 2)
  #   end

  #   test "string on the left is equal to string on the right" do
  #     assert SubstituteX.compare?("foo", :===, "foo")
  #   end

  #   test "string on the left is not equal to string on the right" do
  #     refute SubstituteX.compare?("foo", :===, "bar")
  #   end

  #   test "string on the left is greater than the string on the right" do
  #     assert SubstituteX.compare?("foo", :>, "fo")

  #     assert SubstituteX.compare?("foo", :gt, "fo")
  #   end

  #   test "string on the left is less than the string on the right" do
  #     assert SubstituteX.compare?("foo", :<, "foobar")

  #     assert SubstituteX.compare?("foo", :lt, "foobar")
  #   end

  #   test "string on the left is equal to or greater than the string on the right" do
  #     assert SubstituteX.compare?("foo", :<=, "foo")

  #     assert SubstituteX.compare?("foo", :>=, "fo")

  #     assert SubstituteX.compare?("foo", :gte, "fo")
  #   end

  #   test "string on the left is equal to or less than the string on the right" do
  #     assert SubstituteX.compare?("foo", :<=, "foo")

  #     assert SubstituteX.compare?("foo", :<=, "foobar")

  #     assert SubstituteX.compare?("foo", :lte, "foobar")
  #   end

  #   test "string on the left matches string on the right" do
  #     assert SubstituteX.compare?("foo", :=~, "fo")
  #   end

  #   test "string on the left matches regex on the right" do
  #     assert SubstituteX.compare?("foo", :=~, ~r|fo|)
  #   end

  #   test "datetime on the left is equal to datetime on the right" do
  #     assert SubstituteX.compare?(~U[2024-08-14 00:00:00Z], :===, ~U[2024-08-14 00:00:00Z])
  #   end

  #   test "datetime on the left is greater than datetime on the right" do
  #     assert SubstituteX.compare?(~U[2024-08-14 01:00:00Z], :>, ~U[2024-08-14 00:00:00Z])
  #   end

  #   test "datetime on the left is less than datetime on the right" do
  #     assert SubstituteX.compare?(~U[2024-08-14 00:00:00Z], :<, ~U[2024-08-14 01:00:00Z])
  #   end

  #   test "datetime on the left is equal to or greater than datetime on the right" do
  #     assert SubstituteX.compare?(~U[2024-08-14 01:00:00Z], :>=, ~U[2024-08-14 01:00:00Z])

  #     assert SubstituteX.compare?(~U[2024-08-14 01:00:00Z], :>=, ~U[2024-08-14 00:00:00Z])

  #     assert SubstituteX.compare?(~U[2024-08-14 01:00:00Z], :gte, ~U[2024-08-14 00:00:00Z])
  #   end

  #   test "datetime on the left is equal to or less than datetime on the right" do
  #     assert SubstituteX.compare?(~U[2024-08-14 00:00:00Z], :<=, ~U[2024-08-14 00:00:00Z])

  #     assert SubstituteX.compare?(~U[2024-08-14 00:00:00Z], :<=, ~U[2024-08-14 01:00:00Z])

  #     assert SubstituteX.compare?(~U[2024-08-14 00:00:00Z], :lte, ~U[2024-08-14 01:00:00Z])
  #   end

  #   test "naive datetime on the left is equal to naive datetime on the right" do
  #     assert SubstituteX.compare?(~N[2024-08-14 00:00:00], :===, ~N[2024-08-14 00:00:00])
  #   end

  #   test "naive datetime on the left is greater than naive datetime on the right" do
  #     assert SubstituteX.compare?(~N[2024-08-14 01:00:00], :>, ~N[2024-08-14 00:00:00])
  #   end

  #   test "naive datetime on the left is less than naive datetime on the right" do
  #     assert SubstituteX.compare?(~N[2024-08-14 00:00:00], :<, ~N[2024-08-14 01:00:00])
  #   end

  #   test "naive datetime on the left is equal to or greater than naive datetime on the right" do
  #     assert SubstituteX.compare?(~N[2024-08-14 01:00:00], :>=, ~N[2024-08-14 01:00:00])

  #     assert SubstituteX.compare?(~N[2024-08-14 01:00:00], :>=, ~N[2024-08-14 00:00:00])

  #     assert SubstituteX.compare?(~N[2024-08-14 01:00:00], :gte, ~N[2024-08-14 00:00:00])
  #   end

  #   test "naive datetime on the left is equal to or less than naive datetime on the right" do
  #     assert SubstituteX.compare?(~N[2024-08-14 00:00:00], :<=, ~N[2024-08-14 00:00:00])

  #     assert SubstituteX.compare?(~N[2024-08-14 00:00:00], :<=, ~N[2024-08-14 01:00:00])

  #     assert SubstituteX.compare?(~N[2024-08-14 00:00:00], :lte, ~N[2024-08-14 01:00:00])
  #   end
  # end

  # describe "change/3: " do
  #   test "can transforms map values with map schema values" do
  #     assert {
  #             true,
  #             %{
  #               code: :service_unavailable,
  #               message: "an unexpected error occurred",
  #               details: %{id: 2}
  #             }
  #           } =
  #               SubstituteX.change(
  #                 %{
  #                   code: :not_found,
  #                   message: "no records found",
  #                   details: %{id: 2}
  #                 },
  #                 %{
  #                   code: %{not_found: fn :not_found -> :service_unavailable end},
  #                   message: %{*: "an unexpected error occurred"},
  #                   details: %{*: fn -> %{id: 2} end}
  #                 }
  #               )
  #   end

  #   test "can transforms map values with tuple schema values" do
  #     assert {
  #             true,
  #             %{
  #               code: :service_unavailable,
  #               message: "an unexpected error occurred",
  #               details: %{id: 2}
  #             }
  #           } =
  #               SubstituteX.change(
  #                 %{
  #                   code: :not_found,
  #                   message: "no records found",
  #                   details: %{id: 2}
  #                 },
  #                 %{
  #                   code: {:*, fn -> :service_unavailable end},
  #                   message: {:*, "an unexpected error occurred"},
  #                   details: {:*, fn -> %{id: 2} end}
  #                 }
  #               )
  #   end

  #   test "string" do
  #     # replaces if string matches
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foo" => "bar"})

  #     # replaces if string matches
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foo" => %{===: "bar"}})

  #     # replaces if string is greater than
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"fo" => %{>: "bar"}})

  #     # replaces if string is less than
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foos" => %{<: "bar"}})

  #     # replaces if string is equal to or greater than
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"fo" => %{>=: "bar"}})

  #     # replaces if string is equal to or less than
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foos" => %{<=: "bar"}})

  #     # returns given value if string does not match
  #     assert {false, "foo"} = SubstituteX.change("foo", %{"not_a_match" => "should_not_see_this"})

  #     # replaces if string matches by zero-arity function
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foo" => fn -> "bar" end})

  #     # replaces if string matches by one-arity function
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foo" => fn "foo" -> "bar" end})

  #     # replaces if string matches by two-arity function
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foo" => fn "foo", :=== -> "bar" end})

  #     # replaces if string matches by three-arity function
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foo" => fn "foo", :===, "foo" -> "bar" end})

  #     # operator `:=~` replaces on match
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foo" => %{=~: "bar"}})

  #     # operator `:=~` replaces on regex match
  #     assert {true, "bar"} = SubstituteX.change("foo", %{~r|foo| => %{=~: "bar"}})

  #     # operator `:===` fails on regex match because this is an explicit equals comparison.
  #     assert {false, "foo"} = SubstituteX.change("foo", %{~r|foo| => %{===: "bar"}})

  #     # replaces if string matches
  #     assert {true, "bar"} = SubstituteX.change("foo", %{"foo" => %{eq: "bar"}})

  #     # operator `:eq` fails on regex match because this is an explicit equals comparison.
  #     assert {false, "foo"} = SubstituteX.change("foo", %{~r|foo| => %{eq: "bar"}})
  #   end

  #   test "integer" do
  #     # replaces if equal
  #     assert {true, 2} = SubstituteX.change(1, %{1 => 2})

  #     # replaces if equal
  #     assert {true, 2} = SubstituteX.change(1, %{1 => %{===: 2}})

  #     # replaces if less than
  #     assert {true, 2} = SubstituteX.change(1, %{3 => %{<: 2}})

  #     # replaces if greater than
  #     assert {true, 2} = SubstituteX.change(1, %{0 => %{>: 2}})

  #     # replaces if equal to or less than
  #     assert {true, 2} = SubstituteX.change(1, %{3 => %{<=: 2}})

  #     # replaces if equal to or greater than
  #     assert {true, 2} = SubstituteX.change(1, %{1 => %{>=: 2}})

  #     # operator `:eq` replaces if equal
  #     assert {true, 2} = SubstituteX.change(1, %{1 => %{eq: 2}})

  #     # operator `:lt` replaces if less than
  #     assert {true, 2} = SubstituteX.change(1, %{3 => %{lt: 2}})

  #     # operator `:gt` replaces if greater than
  #     assert {true, 2} = SubstituteX.change(1, %{0 => %{gt: 2}})

  #     # operator `:lte` replaces if equal to or less than
  #     assert {true, 2} = SubstituteX.change(1, %{1 => %{lte: 2}})

  #     assert {true, 2} = SubstituteX.change(1, %{3 => %{lte: 2}})

  #     # operator `:gte` replaces if equal to or greater than
  #     assert {true, 2} = SubstituteX.change(1, %{1 => %{gte: 2}})

  #     assert {true, 2} = SubstituteX.change(1, %{0 => %{gte: 2}})
  #   end

  #   test "float" do
  #     # replaces if equal
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{1.0 => 2.0})

  #     # replaces if equal
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{1.0 => %{===: 2.0}})

  #     # replaces if less than
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{3.0 => %{<: 2.0}})

  #     # replaces if greater than
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{0.0 => %{>: 2.0}})

  #     # replaces if equal to or less than
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{3.0 => %{<=: 2.0}})

  #     # replaces if equal to or greater than
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{1.0 => %{>=: 2.0}})

  #     # operator `:eq` replaces if equal
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{1.0 => %{eq: 2.0}})

  #     # operator `:lt` replaces if less than
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{3.0 => %{lt: 2.0}})

  #     # operator `:gt` replaces if greater than
  #     assert {true, 2.0} = SubstituteX.change(1.0, %{0.0 => %{gt: 2.0}})

  #     # operator `:lte` replaces if equal to or less than
  #     assert {true, 2.0} = SubstituteX.change(2.0, %{3.0 => %{lte: 2.0}})

  #     assert {true, 2.0} = SubstituteX.change(1.0, %{3.0 => %{lte: 2.0}})

  #     # operator `:gte` replaces if equal to or greater than
  #     assert {true, 2.0} = SubstituteX.change(2.0, %{1.0 => %{gte: 2.0}})

  #     assert {true, 2.0} = SubstituteX.change(1.0, %{1.0 => %{gte: 2.0}})
  #   end

  #   test "Decimal" do
  #     # replaces if equal
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => Decimal.new("2.0")})

  #     # replaces if equal
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{===: Decimal.new("2.0")}})

  #     # replaces if less than
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("3.0") => %{<: Decimal.new("2.0")}})

  #     # replaces if greater than
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{>: Decimal.new("2.0")}})

  #     # replaces if equal to or less than
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("3.0") => %{<=: Decimal.new("2.0")}})

  #     # replaces if equal to or greater than
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{>=: Decimal.new("2.0")}})

  #     # operator `:eq` replaces if equal
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{eq: Decimal.new("2.0")}})

  #     # operator `:lt` replaces if less than
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("3.0") => %{lt: Decimal.new("2.0")}})

  #     # operator `:gt` replaces if greater than
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{gt: Decimal.new("2.0")}})

  #     # operator `:lte` replaces if equal to or less than
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{lte: Decimal.new("2.0")}})

  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("3.0") => %{lte: Decimal.new("2.0")}})

  #     # operator `:gte` replaces if equal to or greater than
  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("1.0") => %{gte: Decimal.new("2.0")}})

  #     assert {true, %Decimal{sign: 1, coef: 20, exp: -1}} =
  #       SubstituteX.change(Decimal.new("1.0"), %{Decimal.new("0.0") => %{gte: Decimal.new("2.0")}})
  #   end

  #   test "DateTime" do
  #     # replaces if equal
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => ~U[2024-08-10 00:00:00Z]})

  #     # replaces if equal
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => %{===: ~U[2024-08-10 00:00:00Z]}})

  #     # replaces if less than
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-15 00:00:00Z] => %{<: ~U[2024-08-10 00:00:00Z]}})

  #     # replaces if greater than
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-13 00:00:00Z] => %{>: ~U[2024-08-10 00:00:00Z]}})

  #     # replaces if equal to or less than
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-15 00:00:00Z] => %{<=: ~U[2024-08-10 00:00:00Z]}})

  #     # replaces if equal to or greater than
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-13 00:00:00Z] => %{>=: ~U[2024-08-10 00:00:00Z]}})

  #     # operator `:eq` replaces if equal
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => %{eq: ~U[2024-08-10 00:00:00Z]}})

  #     # operator `:lt` replaces if less than
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-15 00:00:00Z] => %{lt: ~U[2024-08-10 00:00:00Z]}})

  #     # operator `:gt` replaces if greater than
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-13 00:00:00Z] => %{gt: ~U[2024-08-10 00:00:00Z]}})

  #     # operator `:lte` replaces if equal to or less than
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => %{lte: ~U[2024-08-10 00:00:00Z]}})

  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-15 00:00:00Z] => %{lte: ~U[2024-08-10 00:00:00Z]}})

  #     # operator `:gte` replaces if equal to or greater than
  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-14 00:00:00Z] => %{gte: ~U[2024-08-10 00:00:00Z]}})

  #     assert {true, ~U[2024-08-10 00:00:00Z]} =
  #       SubstituteX.change(~U[2024-08-14 00:00:00Z], %{~U[2024-08-13 00:00:00Z] => %{gte: ~U[2024-08-10 00:00:00Z]}})
  #   end

  #   test "NaiveDateTime" do
  #     # replaces if equal
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => ~N[2024-08-10 00:00:00]})

  #     # replaces if equal
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => %{===: ~N[2024-08-10 00:00:00]}})

  #     # replaces if less than
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-15 00:00:00] => %{<: ~N[2024-08-10 00:00:00]}})

  #     # replaces if greater than
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-13 00:00:00] => %{>: ~N[2024-08-10 00:00:00]}})

  #     # replaces if equal to or less than
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-15 00:00:00] => %{<=: ~N[2024-08-10 00:00:00]}})

  #     # replaces if equal to or greater than
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-13 00:00:00] => %{>=: ~N[2024-08-10 00:00:00]}})

  #     # operator `:eq` replaces if equal
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => %{eq: ~N[2024-08-10 00:00:00]}})

  #     # operator `:lt` replaces if less than
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-15 00:00:00] => %{lt: ~N[2024-08-10 00:00:00]}})

  #     # operator `:gt` replaces if greater than
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-13 00:00:00] => %{gt: ~N[2024-08-10 00:00:00]}})

  #     # operator `:lte` replaces if equal to or less than
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => %{lte: ~N[2024-08-10 00:00:00]}})

  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-15 00:00:00] => %{lte: ~N[2024-08-10 00:00:00]}})

  #     # operator `:gte` replaces if equal to or greater than
  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-14 00:00:00] => %{gte: ~N[2024-08-10 00:00:00]}})

  #     assert {true, ~N[2024-08-10 00:00:00]} =
  #       SubstituteX.change(~N[2024-08-14 00:00:00], %{~N[2024-08-13 00:00:00] => %{gte: ~N[2024-08-10 00:00:00]}})
  #   end
  # end
end
