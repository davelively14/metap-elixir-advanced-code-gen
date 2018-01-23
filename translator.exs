defmodule Translator do

  defmacro __using__(_options) do
    quote do
      # Register a module attribute @locales that will accumulate. We will store
      # the lexicon each language to be supported in this attribute.
      Module.register_attribute __MODULE__, :locales, accumulate: true, persist: false

      import unquote(__MODULE__), only: [locale: 2]
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    # Placeholder...will implement compile later
    compile(Module.get_attribute(env.module, :locales))
  end

  defmacro locale(name, mappings) do
    quote bind_quoted: [name: name, mappings: mappings] do
      # Adds a locale to the locales module attribute. Accumulates.
      @locales {name, mappings}
    end
  end

  def compile(translations) do
    translations_ast =
      # Map locales to locale and mappings
      for {locale, mappings} <- translations do
        deftranslations(locale, "", mappings)
      end

    quote do
      # I have no idea what the t function does yet
      def t(locale, path, bindings \\ [])
      unquote(translations_ast)
      def t(_locale, _path, _bindings), do: {:error, :no_translation}
    end
  end

  defp deftranslations(locale, current_path, mappings) do
    # TBD: Return an AST of the t/3 function defs for the given locale
  end
end
