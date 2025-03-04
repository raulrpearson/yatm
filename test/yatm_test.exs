defmodule YatmTest do
  use ExUnit.Case
  doctest Yatm

  import Yatm, only: [merge: 1]

  defp validate(cases) do
    cases
    |> Enum.each(fn {input, expected_output} ->
      merged_classes = merge(input) |> String.split(" ") |> MapSet.new()
      expected_classes = expected_output |> String.split(" ") |> MapSet.new()
      assert merged_classes === expected_classes
    end)
  end

  describe "Layout" do
    test "aspect-ratio" do
      validate([
        {"aspect-square aspect-video", "aspect-video"},
        {"aspect-[3.141592] aspect-square", "aspect-square"},
        {"aspect-(--pi) aspect-[3.141592]", "aspect-[3.141592]"},
        {"aspect-1/2 aspect-(--pi)", "aspect-(--pi)"},
        {"aspect-auto aspect-1/2", "aspect-1/2"},
        {"aspect-1/2 aspect-[calc(4*3+1)/3]", "aspect-[calc(4*3+1)/3]"}
      ])
    end
  end

  describe "Flexbox & Grid" do
    test "`flex-basis`" do
      validate([
        {"flex basis-3 basis-1/2", "flex basis-1/2"}
      ])
    end

    test "`flex-direction`" do
    end

    test "`flex-wrap`" do
    end

    test "`flex`" do
    end

    test "`flex-grow`" do
      validate([
        {"flex grow grow-1", "flex grow-1"}
      ])
    end

    test "Combinations" do
      validate([
        {"grid flex basis-auto flex-col-reverse flex-wrap",
         "flex basis-auto flex-col-reverse flex-wrap"}
      ])
    end
  end

  describe "Spacing" do
    test "`p`" do
      validate([
        {"p-1 px-1 py-1", "px-1 py-1"},
        {"p-1 pr-1 pt-1", "pr-1 pt-1"},
        {"p-1 pe-1 pb-1", "pe-1 pb-1"},
        {"px-1 py-1 p-1", "p-1"},
        {"pr-1 pt-1 p-1", "p-1"},
        {"pe-1 pb-1 p-1", "p-1"}
      ])
    end

    test "`px` and `py`" do
      validate([
        {"px-1 pr-1 pl-1", "pr-1 pl-1"},
        {"px-1 ps-1 pe-1", "ps-1 pe-1"},
        {"px-1 pt-1 pb-1", "px-1 pt-1 pb-1"},
        {"py-1 pt-1 pb-1", "pt-1 pb-1"},
        {"py-1 pr-1 pl-1", "py-1 pr-1 pl-1"},
        {"py-1 ps-1 pe-1", "py-1 ps-1 pe-1"}
      ])
    end

    test "misc" do
      validate([
        {"py-1 m-1 m-2", "py-1 m-2"},
        {"px-4 pl-[30px] pr-(--custom-value)", "pl-[30px] pr-(--custom-value)"}
      ])
    end
  end
end
