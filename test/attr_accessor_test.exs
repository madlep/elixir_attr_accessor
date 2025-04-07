defmodule AttrAccessorTest do
  use ExUnit.Case
  doctest AttrAccessor

  defmodule MyModule do
    import AttrAccessor

    defstruct [
      :access_me,
      :access_multiple_1,
      :access_multiple_2,
      :read_me,
      :read_multiple_1,
      :read_multiple_2,
      :update_me,
      :update_multiple_1,
      :update_multiple_2,
      :write_me,
      :write_multiple_1,
      :write_multiple_2
    ]

    attr_accessor :access_me
    attr_accessor [:access_multiple_1, :access_multiple_2]

    attr_reader :read_me
    attr_reader [:read_multiple_1, :read_multiple_2]

    attr_updater :update_me
    attr_updater [:update_multiple_1, :update_multiple_2]

    attr_writer :write_me
    attr_writer [:write_multiple_1, :write_multiple_2]
  end

  def example() do
    %MyModule{
      access_me: "a",
      access_multiple_1: "a1",
      access_multiple_2: "a2",
      read_me: "r",
      read_multiple_1: "r1",
      read_multiple_2: "r2",
      update_me: "u",
      update_multiple_1: "u1",
      update_multiple_2: "u2",
      write_me: "w",
      write_multiple_1: "w1",
      write_multiple_2: "w2"
    }
  end

  describe "attr_reader" do
    test "can read from attr_readers" do
      assert example() |> MyModule.read_me() == "r"
    end

    test "can't update attr_reader" do
      refute function_exported?(MyModule, :read_me!, 2)
    end

    test "can't write to attr_reader" do
      refute function_exported?(MyModule, :read_me, 2)
    end

    test "can define multiple attr_readers inline" do
      my_mod = %MyModule{read_multiple_1: "r1", read_multiple_2: "r2"}
      assert MyModule.read_multiple_1(my_mod) == "r1"
      assert MyModule.read_multiple_2(my_mod) == "r2"
    end
  end

  describe "attr_writer" do
    test "can't read from attr_writer" do
      refute function_exported?(MyModule, :write_me, 1)
    end

    test "can't update attr_writer" do
      refute function_exported?(MyModule, :write_!, 2)
    end

    test "can write to attr_writer" do
      my_mod = example() |> MyModule.write_me("w written")
      assert my_mod.write_me == "w written"
    end

    test "can define multiple attr_writers inline" do
      my_mod =
        example()
        |> MyModule.write_multiple_1("w1 written")
        |> MyModule.write_multiple_2("w2 written")

      assert my_mod.write_multiple_1 == "w1 written"
      assert my_mod.write_multiple_2 == "w2 written"
    end
  end

  describe "attr_accessor" do
    test "can read from attr_accessor" do
      assert example() |> MyModule.access_me() == "a"
    end

    test "can write to attr_accessor" do
      my_mod = example() |> MyModule.access_me("a written")
      assert MyModule.access_me(my_mod) == "a written"
    end

    test "can define multiple attr_writers inline" do
      assert example() |> MyModule.access_multiple_1() == "a1"
      assert example() |> MyModule.access_multiple_2() == "a2"

      my_mod =
        example()
        |> MyModule.access_multiple_1("a1 written")
        |> MyModule.access_multiple_2("a2 written")

      assert my_mod.access_multiple_1 == "a1 written"
      assert my_mod.access_multiple_2 == "a2 written"
    end
  end
end
