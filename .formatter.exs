# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [attr_accessor: 1, attr_reader: 1, attr_updater: 1, attr_writer: 1],
  export: [
    locals_without_parens: [attr_accessor: 1, attr_reader: 1, attr_updater: 1, attr_writer: 1]
  ]
]
