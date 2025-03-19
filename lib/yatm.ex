defmodule Yatm do
  @moduledoc """
  The high-level API.
  """
  alias Yatm.Parser

  @doc """
  Merges `classes`, provided as a string or a list, returning a string with
  conflicts resolved.

  If a list is provided, anything that isn't a string is discarded. Non-string
  values might appear as the result of expressions intended to apply classes
  conditionally.

  ## Examples

  Conflicting classes that come last override the ones coming before:

      iex> Yatm.merge("p-1 p-2")
      "p-2"

  Provide a string or a list of strings:

      iex> Yatm.merge(["p-1", "p-2"])
      "p-2"

  Conditionally apply classes:

      iex> Yatm.merge(["p-1", true && "p-2", false && "p-3"])
      "p-2"

  Anything that isn't a binary is ignored:

      iex> Yatm.merge(["p-1", %{why: "do this"}, 42, "p-2"])
      "p-2"
  """
  def merge(classes) when is_list(classes) do
    classes
    |> Stream.filter(&is_binary/1)
    |> Enum.join(" ")
    |> merge()
  end

  def merge(classes) when is_binary(classes) do
    {:ok, node_list, _, _, _, _} = Parser.parse(classes)

    ast =
      for [{:variants, variants}, {keys, class}] <- Stream.chunk_every(node_list, 2),
          reduce: %{} do
        acc ->
          keys = Enum.map([MapSet.new(variants) | keys], &access_map_or_initialize/1)
          put_in(acc, keys, class)
      end

    for {group, subtree} <- ast do
      prefix = MapSet.to_list(group) |> IO.chardata_to_string()
      get_values(subtree, prefix)
    end
    |> IO.chardata_to_string()
    |> String.slice(0..-2//1)
  end

  defp access_map_or_initialize(key) do
    fn
      :get, data, next ->
        case Map.get(data, key) do
          value when is_map(value) -> next.(value)
          _ -> next.(%{})
        end

      :get_and_update, data, next ->
        value =
          case Map.get(data, key) do
            value when is_map(value) -> value
            _ -> %{}
          end

        case next.(value) do
          {get, update} -> {get, Map.put(data, key, update)}
          :pop -> {value, Map.delete(data, key)}
        end
    end
  end

  defp get_values(ast, prefix, acc \\ []) do
    new_values =
      for {_key, value} <- ast do
        case value do
          value when is_map(value) -> get_values(value, prefix, acc)
          value -> [prefix | [value | [" "]]]
        end
      end

    [acc | new_values]
  end
end
