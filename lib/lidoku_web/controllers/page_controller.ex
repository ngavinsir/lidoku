defmodule LidokuWeb.PageController do
  use LidokuWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
