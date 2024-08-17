# SubstituteX

`SubstituteX` provides a standardized way to compare and change values.

It allows you to create schemas for comparisons and transformations,
making your code more organized and flexible. The main benefits are:

  * A unified approach to comparisons and transformations

  * Easy to expand functionality

  * Keeps code clear, readable, and maintainable

## Schemas

A "schema" is a map that defines how to compare or change values.
It helps you create predictable and testable transformations that
can be reused throughout your app.

Suppose you have a list of numbers `[1, 2, 1]` and want to replace
every `1` with `2`. You can represent this change with the schema
`%{1 => 2}` and re-use it each time you need to apply that
transformation.

The same principle applies to enumerables. Imagine you have a
post with several comments:

```elixir
%{
  name: "Example",
  body: "Hello world",
  comments: [
    %{body: "secret"},
    %{body: "example"}
  ]
}
```

You want to moderate the comments by filtering out specific words.
Some words are simple to replace, while others require an external
service. This can be done with the schema:

```elixir
%{
  post: %{
    comments: %{
      body: [
        {"secret", %{=~: "******"}},
        {:*, fn string -> ExternalService.process_text(string) end}
      ]
    }
  }
}
```

This will first replace the string `secret` with `******` then use
an external service at runtime to process the string.

You can also control the order of changes by using a list of key-value
pairs instead of a map as they are interchangeable:

```elixir
[
  {:post, [
    {:comments, [
      {:body, [
        {"secret", %{=~: "******"}},
        # :* matches on all cases which can be used as a fallback
        {:*, fn string -> ExternalService.process_text(string) end}
      ]}
    ]}
  ]}
]
```

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

Support for decimals is provided out-of-the-box by adding the dependency:

```elixir
def deps do
  [
    # version > 0.0.0 supported
    {:decimal, "~> 2.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/SubstituteX>.

