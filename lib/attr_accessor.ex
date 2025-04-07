defmodule AttrAccessor do
  @moduledoc """
  Ruby style accessors for Elixir structs. See [README](./README.md) for more example usage.

  """

  @doc ~S"""
  Creates `attr_reader/1` + `attr_updater/1` + `attr_writer/1` functions on struct module for `attr` symbol/symbols

  ## Example

      defmodule MyStruct do
        defstruct [:key1, :key2, :key3]

        import AttrAccessor
        attr_accessor :key1 # single key, or multiple is ok
        attr_accessor [:key2, :key3]
      end

      my_struct = %MyStruct{key1: "foo", key2: "bar", key3: "baz"}

      my_struct
        |> MyStruct.key1("baz")
        |> MyStruct.key1(&String.reverse/1)
        |> MyStruct.key1()
      # "zab"


  Writing something like

      defmodule MyStruct do
        defstruct [:some_key]
        attr_accessor :some_key
      end

  Is equivalent to

      defmodule MyStruct do
        defstruct [:some_key]
        attr_reader :some_key
        attr_updater :some_key
        attr_writer :some_key
      end

  Which is also equivalent to

      defmodule MyStruct do
        defstruct [:some_key]

        def some_key(st = %__MODULE__{some_key: value}) do
          value
        end

        def some_key!(st = %__MODULE__{some_key: value}, f) do
          %__MODULE__{ st | some_key: f.(value) }
        end

        def some_key(st = %__MODULE__{}, value) do
          %__MODULE__{ st | some_key: value }
        end
      end
  """
  @spec attr_accessor(atom() | [atom()]) :: Macro.t()
  defmacro attr_accessor(attrs) do
    quote do
      attr_reader(unquote(attrs))
      attr_updater(unquote(attrs))
      attr_writer(unquote(attrs))
    end
  end

  @doc ~S"""
  Creates reader functions on struct module for `attr` symbol/symbols

  ## Example

      defmodule MyStruct do
        defstruct [:key1, :key2, :key3]

        import AttrAccessor
        attr_reader :key1 # single key, or multiple is ok
        attr_reader [:key2, :key3]
      end

      my_struct = %MyStruct{key1: "foo", key2: "bar", key3: "baz"}

      MyStruct.key1(my_struct)
      # "foo"


  Writing something like

      defmodule MyStruct do
        defstruct [:some_key]
        attr_reader :some_key
      end

  Is equivalent to 

      defmodule MyStruct do
        defstruct [:some_key]

        def some_key(st = %__MODULE__{some_key: value}) do
          value
        end
      end
  """
  @spec attr_reader(atom() | [atom()]) :: Macro.t()
  defmacro attr_reader(attrs) do
    for attr <- List.wrap(attrs) do
      quote generated: true do
        def unquote(attr)(struct)

        def unquote(attr)(%__MODULE__{unquote(attr) => value}) do
          value
        end
      end
    end
  end

  @doc ~S"""
  Creates a "bang" updater functions on struct module for `attr` symbol/symbols which accept a function to read the current value, pass it to the function, and write the result back to the struct.

  ## Example

      defmodule MyStruct do
        defstruct [:key1, :key2, :key3]

        import AttrAccessor
        attr_updater :key1 # single key, or multiple is ok
        attr_updater [:key2, :key3]
      end

      my_struct =
        %MyStruct{key1: "foo"}
        |> MyStruct.key1!(&String.upcase/1)

      my_struct.key1
      # "FOO"

  Writing something like

      defmodule MyStruct do
        defstruct [:some_key]
        attr_updater :some_key
      end

  Is equivalent to 

      defmodule MyStruct do
        defstruct [:some_key]

        def some_key!(st = %__MODULE__{some_key: value}, f) do
          %__MODULE__{ st | some_key: f.(value) }
        end
      end
  """
  @spec attr_updater(atom() | [atom()]) :: Macro.t()
  defmacro attr_updater(attrs) do
    for attr <- List.wrap(attrs) do
      quote generated: true do
        def unquote(:"#{attr}!")(struct, f)

        def unquote(:"#{attr}!")(st = %__MODULE__{unquote(attr) => current_value}, f) do
          %__MODULE__{st | unquote(attr) => f.(current_value)}
        end
      end
    end
  end

  @doc ~S"""
  Creates writer functions on struct module for `attr` symbol/symbols.

  ## Example

      defmodule MyStruct do
        defstruct [:key1, :key2, :key3]

        import AttrAccessor
        attr_writer :key1 # single key, or multiple is ok
        attr_writer [:key2, :key3]
      end

      my_struct =
        %MyStruct{key1: "foo"}
        |> MyStruct.key1("bar)

      my_struct.key1
      # "bar"

  Writing something like

      defmodule MyStruct do
        defstruct [:some_key]
        attr_writer :some_key
      end

  Is equivalent to 

      defmodule MyStruct do
        defstruct [:some_key]

        def some_key(st = %__MODULE__{}, value) do
          %__MODULE__{ st | some_key: value }
        end
      end
  """
  @spec attr_writer(atom() | [atom()]) :: Macro.t()
  defmacro attr_writer(attrs) do
    for attr <- List.wrap(attrs) do
      quote generated: true do
        def unquote(attr)(struct, value)

        def unquote(attr)(st = %__MODULE__{}, value) do
          %__MODULE__{st | unquote(attr) => value}
        end
      end
    end
  end
end
