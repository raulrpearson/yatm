defmodule Yatm do
  alias Yatm.Parser

  def merge(class_string) do
    # IO.inspect(class_string, label: "Class String")

    {:ok, node_list, _, _, _, _} = Parser.parse(class_string)
    # IO.inspect(node_list, label: "Node List")

    ast =
      for [{:variants, variants}, {keys, class}] <- Stream.chunk_every(node_list, 2),
          reduce: %{} do
        acc ->
          keys = Enum.map([MapSet.new(variants) | keys], &access_map_or_initialize/1)
          put_in(acc, keys, class)
      end

    # |> IO.inspect(label: "AST")

    for {group, subtree} <- ast do
      prefix = MapSet.to_list(group) |> IO.chardata_to_string()
      get_values(subtree, prefix)
    end
    # |> IO.inspect(label: "Values")
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
