# SubstituteX

`SubstituteX` provides a standardized data driven API for comparing and transforming terms.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `SubstituteX` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:substitute_x, "~> 0.1.0"}
  ]
end
```

## Decimals

Support for decimals is provided out-of-the-box, just add the dependency:

```elixir
def deps do
  [
    {:decimal, "~> 1.0"}
  ]
end
```

## Configuration

The following configuration is available: 

```elixir
config :substitute_x,
  engine: SubstituteX.CommonComparison
```