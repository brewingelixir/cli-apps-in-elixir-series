defmodule CLI do
  use Application

  def start(_type, _args) do
    args = Burrito.Util.Args.get_arguments()
    WC.run(args)

    System.halt(0)
  end
end
