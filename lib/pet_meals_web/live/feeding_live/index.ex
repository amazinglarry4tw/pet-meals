defmodule PetMealsWeb.FeedingLive.Index do
  use PetMealsWeb, :live_view

  alias PetMeals.Feedings

  def mount(_params, _session, socket) do
    feedings = Feedings.list_feedings()
    {:ok, assign(socket, feedings: feedings)}
  end

  # def handle_params(_params, _uri, socket) do
  #   socket =
  #     socket
  #     |> stream(:feedings, Feedings.list_feedings())
  # end

  def render(assigns) do
    ~H"""
    <h1>Feedings</h1>
    <div>
      <.button phx-click="random">Random Feeding</.button>
    </div>
    <ol>
      <%= for feeding <- @feedings do %>
        <li>
          {Atom.to_string(feeding.portion) |> String.upcase()} portion of {feeding.brand} - {feeding.flavor}
        </li>
      <% end %>
    </ol>
    """
  end

  def handle_event("random", _params, socket) do
    socket = put_flash(socket, :info, "Something happened!")
    random_feeding = Feedings.create_random_feeding()
    feedings = [random_feeding | socket.assigns.feedings]

    socket = assign(socket, feedings: feedings)

    {:noreply, socket}
  end
end
