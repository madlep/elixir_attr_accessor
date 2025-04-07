# AttrAccessor

[Ruby style accessors](https://ruby-doc.org/docs/ruby-doc-bundle/UsersGuide/rg/accessors.html) for Elixir structs.

Provides `AttrAccessor` module provides [`attr_reader`](`AttrAccessor.attr_reader/1`), [`attr_writer`](`AttrAccessor.attr_writer/1`) and [`attr_accessor`](`AttrAccessor.attr_accessor/1`) macros to define "get" and/or "set" functions for reading/write struct field values.

## Benefits
- accessors are functions, so can be used in pipe chain
- accessors are functions, so can be passed to `Enum` etc higher order functions
- opaque structs can more easily keep implementation details separate

## Basic Usage

Say we've got an basic "todo" item struct define as:

    defmodule Todo do
      defstruct [:id, :title, :description, :created_at, :done_at]

      def done?(todo) do
        todo.done_at != nil
      end
    end

We can use `AttrAccessor` to create get/set functions.

    defmodule Todo do
      defstruct [:id, :title, :description, :created_at, :done_at]

      import AttrAccessor
      attr_accessor [:title, :description]
      attr_reader [:id, :created_at]
      attr_writer :done_at

      def done?(todo) do
        todo.done_at != nil
      end
    end

Then we can use those accessor functions to read and write data on the struct value.

    my_todo = %Todo{id: 123, created_at: DateTime.utc_now()}

    Todo.id(my_todo)
    # 123

    my_todo = Todo.title("my todo item")
    my_todo = Todo.description("do some stuff")

    Todo.title(my_todo)
    # "my todo item"

    Todo.description(my_todo)
    # "do some stuff"

    Todo.done?(my_todo)
    # false

    my_todo = Todo.done_at(my_todo, DateTime.utc_now())
    Todo.done?(my_todo)
    # true

## Mapping update functions

`AttrAccessor` also creates a "bang" method for each [`attr_writer`](`AttrAccessor.attr_writer/1`) defined on a struct to allow the current value to be passed to a function, and the resulting value set.

    my_todo = %Todo{} |> Todo.title("My todo")
    # %Todo{title: "My todo"}

    my_todo = my_todo |> Todo.title!(&String.upcase/1)
    # %Todo{title: "MY TODO"}

## Pipe friendly

On it's own `AttrAccessor` may not provide much over built in syntax for accessing struct fields, but because they are regular Elixir functions they can be used with pipe chains to incrementally build a struct.

    %Todo{id: 123, created_at: DateTime.utc_now()}
    |> Todo.title("my todo item")
    |> Todo.description("do some stuff")
    |> Todo.done_at(DateTime.utc_now())

## Using as higher order functions

Because accessors are functions, they can also be used with `Enum` etc functions

    todos = [
      %Todo{title: "do thing 1"},
      %Todo{title: "do thing 2"},
    ]

    todo_titles = todos |> Enum.map(&Todo.title/1)
    # ["do thing 1", "do thing 2"]

    now = DateTime.utc_now()
    completed_todos = todos |> Enum.map(&Todo.done_at(&1, now))

    completed_todos |> Enum.map(&Todo.done?/1)
    # [true, true]

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `attr_accessor` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:attr_accessor, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/attr_accessor>.

