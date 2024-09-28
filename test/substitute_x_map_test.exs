defmodule SubstituteX.MapTest do
  use ExUnit.Case, async: true
  doctest SubstituteX

  describe "compare?/3: " do
    test "match list of terms" do
      left = %{tags: ["tag_one", "tag_two", "tag_three"]}

      right = %{tags: ["tag_one", "tag_two"]}

      assert SubstituteX.compare?(left, right)
    end

    test "match many values" do
      left = %{
        title: "post",
        body: "example post",
        comments: [
          %{
            id: 1,
            body: "body",
            likes: 100,
            user: %{
              id: 1,
              ip_address: {0, 0, 0, 0}
            }
          }
        ],
        tags: ["tag_one", "tag_two"],
        inserted_at: ~N[2024-09-25 00:00:00],
        updated_at: ~N[2024-09-25 00:00:00]
      }

      right = %{
        title: "post",
        body: %{=~: "example"},
        comments: [
          %{
            id: %{>: 0},
            body: %{=~: ~r|^b.*|},
            likes: %{>=: 100},
            user: %{
              id: 1,
              ip_address: {0, 0, 0, 0}
            }
          }
        ],
        tags: ["tag_one", "tag_two"],
        inserted_at: %{>: ~N[2024-09-24 00:00:00]},
        updated_at: %{===: ~N[2024-09-25 00:00:00]}
      }

      assert SubstituteX.compare?(left, right)
    end
  end

  describe "change/4: " do
    test "replaces with literal" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => 5}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => fn -> 5 end}})
    end

    test "replaces with ':*' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{:* => 5}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{:* => fn -> 5 end}})
    end

    test "replaces with ':===' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{===: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{===: fn -> 5 end}}})
    end

    test "replaces with ':!==' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{!==: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{!==: fn -> 5 end}}})
    end

    test "replaces with ':>' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{0 => %{>: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{0 => %{>: fn -> 5 end}}})
    end

    test "replaces with ':<' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{<: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{<: fn -> 5 end}}})
    end

    test "replaces with ':>=' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{>=: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{>=: fn -> 5 end}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{0 => %{>=: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{0 => %{>=: fn -> 5 end}}})
    end

    test "replaces with ':<=' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{<=: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{<=: fn -> 5 end}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{<=: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{<=: fn -> 5 end}}})
    end

    test "replaces with ':eq' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{eq: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{eq: fn -> 5 end}}})
    end

    test "replaces with ':gt' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{0 => %{gt: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{0 => %{gt: fn -> 5 end}}})
    end

    test "replaces with ':lt' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{lt: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{lt: fn -> 5 end}}})
    end

    test "replaces with ':gte' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{gte: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{gte: fn -> 5 end}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{0 => %{gte: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{0 => %{gte: fn -> 5 end}}})
    end

    test "replaces with ':lte' operator" do
      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{lte: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{1 => %{lte: fn -> 5 end}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{lte: 5}}})

      assert %{value: 5} = SubstituteX.change(%{value: 1}, %{value: %{2 => %{lte: fn -> 5 end}}})
    end

    test "replaces nested values" do
      term =
        %{
          title: "post",
          comments: [
            %{
              id: 1,
              user: %{
                email: "foo@bar.com",
                ip_address: {0, 0, 0, 0}
              }
            }
          ],
          tags: ["tag_one", "tag_two", "tag_three"]
        }

      definition = %{
        title: %{"post" => "updated_post"},
        comments: [
          %{
            id: %{1 => 5},
            user: %{
              email: %{"foo@bar.com" => %{===: "qux@bux.com"}},
              ip_address: %{{0, 0, 0, 0} => {127, 0, 0, 1}}
            }
          }
        ],
        tags: %{"_one" => %{=~: "replaced_tag"}}
      }

      assert %{
        title: "updated_post",
        comments: [
          %{
            id: 5,
            user: %{
              email: "qux@bux.com",
              ip_address: {127, 0, 0, 1}
            }
          }
        ],
        tags: ["replaced_tag", "tag_two", "tag_three"]
      } = SubstituteX.change(term, definition)
    end
  end
end
