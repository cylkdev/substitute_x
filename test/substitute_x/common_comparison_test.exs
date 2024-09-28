defmodule SubstituteX.CommonComparisonTest do
  use ExUnit.Case, async: true
  doctest SubstituteX.CommonComparison

  describe "&operators/0: " do
    test "returns expected operators" do
      assert [
        :===,
        :!==,
        :<,
        :>,
        :<=,
        :>=,
        :=~,
        :eq,
        :lt,
        :gt,
        :lte,
        :gte,
        :is_atom,
        :is_boolean,
        :is_binary,
        :is_bitstring,
        :is_exception,
        :is_float,
        :is_function,
        :is_integer,
        :is_list,
        :is_map,
        :is_map_key,
        :is_nil,
        :is_non_struct_map,
        :is_number,
        :is_pid,
        :is_port,
        :is_reference,
        :is_struct,
        :is_tuple
      ] = SubstituteX.CommonComparison.operators()
    end
  end

  describe "&operator?/1: " do
    test "returns true for expected operators" do
      assert SubstituteX.CommonComparison.operator?(:===)
      assert SubstituteX.CommonComparison.operator?(:!==)
      assert SubstituteX.CommonComparison.operator?(:<)
      assert SubstituteX.CommonComparison.operator?(:>)
      assert SubstituteX.CommonComparison.operator?(:<=)
      assert SubstituteX.CommonComparison.operator?(:>=)
      assert SubstituteX.CommonComparison.operator?(:=~)
      assert SubstituteX.CommonComparison.operator?(:eq)
      assert SubstituteX.CommonComparison.operator?(:lt)
      assert SubstituteX.CommonComparison.operator?(:gt)
      assert SubstituteX.CommonComparison.operator?(:lte)
      assert SubstituteX.CommonComparison.operator?(:gte)
      assert SubstituteX.CommonComparison.operator?(:is_atom)
      assert SubstituteX.CommonComparison.operator?(:is_binary)
      assert SubstituteX.CommonComparison.operator?(:is_float)
      assert SubstituteX.CommonComparison.operator?(:is_integer)
      assert SubstituteX.CommonComparison.operator?(:is_struct)

      refute SubstituteX.CommonComparison.operator?(:invalid)
    end
  end
end
