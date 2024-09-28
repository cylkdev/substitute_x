defmodule SubstituteX.ListTest do
  use ExUnit.Case, async: true

  describe "compare?/3: " do
    test "match any term in a list" do
      left = ["tag_one", "tag_two", "tag_three"]

      right = %{=~: "_one"}

      assert SubstituteX.compare?(left, right)
    end

    test "match many values" do
      left = [
        %{
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
          inserted_at: ~N[2024-09-25 00:00:00],
          updated_at: ~N[2024-09-25 00:00:00]
        },
        [
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
          inserted_at: ~N[2024-09-25 00:00:00],
          updated_at: ~N[2024-09-25 00:00:00]
        ]
      ]

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
        inserted_at: %{>: ~N[2024-09-24 00:00:00]},
        updated_at: %{===: ~N[2024-09-25 00:00:00]}
      }

      assert SubstituteX.compare?(left, right)
    end
  end
end
