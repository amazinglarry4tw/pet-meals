defmodule PetMealsWeb.FeedingController do
  use PetMealsWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
