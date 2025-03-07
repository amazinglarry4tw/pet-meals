defmodule PetMealsWeb.FeedingController do
  use PetMealsWeb, :controller

  alias PetMeals.Feedings

  def index(conn, _params) do
    feedings = Feedings.list_feedings()

    render(conn, :index, feedings: feedings)
  end

  def add_feeding(conn, _params) do
    current_feedings = get_session(conn, :feedings)

    random_feeding = Feedings.create_random_feeding()
    updated_feedings = [random_feeding | current_feedings]

    conn
    |> put_session(:feedings, updated_feedings)
    |> render(:index, feedings: updated_feedings)
  end
end
