defmodule CLI do
  def run do
    args = System.argv()
    WC.run(args)
  end
end
