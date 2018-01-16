defmodule Mime do
  # Module attribute that allows us to specify compile-time resources that our
  # module depends upon. When resources change, mix will recompile the module.
  @external_resource mimes_path = Path.join([__DIR__, "mimes.txt"])

  for line <- File.stream!(mimes_path, [], :line) do

    # Parse the file to pull type and extensions. Extensions can be one or more.
    [type, rest] = line |> String.split("\t") |> Enum.map(&String.trim(&1))
    extensions = String.split(rest, ~r/,\s?/)

    def exts_from_type(unquote(type)), do: unquote(extensions)
    def type_from_ext(ext) when ext in unquote(extensions), do: unquote(type)
  end

  # Catch-all clauses
  def exts_from_type(_type), do: []
  def type_from_ext(_ext), do: nil

  # Returns true of the type is valid
  def valid_type?(type), do: exts_from_type(type) |> Enum.any?
end
