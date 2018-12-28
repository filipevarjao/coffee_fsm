defmodule Hw do

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Hw
    end
  end

  def display(str, []), do: IO.puts "Display " <> str
  def display(str, [arg]), do: IO.inspect arg, label: "Display " <> str
  def return_change(payment), do: IO.inspect payment, label: "Machine: Returned"
  def drop_cup(), do: IO.inspect "Machine:Dropped Cup."
  def prepare(type), do: IO.inspect type, label: "Machine: Preparing"
  def reboot(), do: IO.inspect "Machine:Rebooted Hardware"

end
