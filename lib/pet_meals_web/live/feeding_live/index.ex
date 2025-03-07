defmodule PetMealsWeb.FeedingLive.Index do
  use PetMealsWeb, :live_view

  alias PetMeals.Feedings

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Feedings")
      |> assign(:feedings, Feedings.list_feedings())
      |> assign(:selected_brand, nil)
      |> assign(:selected_flavor, nil)
      |> assign(:selected_portion, nil)
      |> assign(:brands, ["Sheba", "Fancy Feast", "Blue Buffalo"])
      |> assign(:flavors, ["Beef", "Salmon", "Turkey"])
      |> assign(:portions, ["full", "half", "quarter"])
      |> stream(:feedings, Feedings.list_feedings() |> Enum.reverse())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.button phx-click={
      JS.toggle(
        to: "#add_feedings",
        in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
        out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
        time: 300
      )
    }>
      Add Feeding
    </.button>
    <div>
      <.button class="hidden" phx-click="random">Random Feeding</.button>
    </div>
    <div id="add_feedings" class="add_feedings hidden">
      <form phx-submit="add_feeding" phx-change="form_change">
        <div class="brand-row">
          <div class="options">
            <%= for brand <- @brands do %>
              <div
                class={["option", @selected_brand == brand && "selected"]}
                phx-click="select_brand"
                phx-value-brand={brand}
              >
                {brand}
              </div>
            <% end %>
          </div>
        </div>

        <div class="flavor-row">
          <div class="options">
            <%= for flavor <- @flavors do %>
              <div
                class={["option", @selected_flavor == flavor && "selected"]}
                phx-click="select_flavor"
                phx-value-flavor={flavor}
              >
                {flavor}
              </div>
            <% end %>
          </div>
        </div>

        <div class="portions-row">
          <div class="options">
            <%= for portion <- @portions do %>
              <div
                class={["option", @selected_portion == portion && "selected"]}
                phx-click="select_portion"
                phx-value-portion={portion}
              >
                {portion}
              </div>
            <% end %>
          </div>
        </div>

        <button
          type="submit"
          class="submit-btn"
          disabled={is_nil(@selected_brand) || is_nil(@selected_flavor) || is_nil(@selected_portion)}
          phx-click={
            JS.toggle(
              to: "#add_feedings",
              in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
              out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
              time: 300
            )
          }
        >
          Submit
        </button>
      </form>
    </div>

    <.header class="mt-6">
      {@page_title}
    </.header>

    <.feeding_table streams={@streams} />
    """
  end

  def feeding_table(assigns) do
    ~H"""
    <.table id="stream_feedings" rows={@streams.feedings}>
      <:col :let={{_dom_id, feedings}} label="ID">
        {feedings.id}
      </:col>
      <:col :let={{_dom_id, feedings}} label="Brand">
        {feedings.brand}
      </:col>
      <:col :let={{_dom_id, feedings}} label="Flavor">
        {feedings.flavor}
      </:col>
      <:col :let={{_dom_id, feedings}} label="Portion">
        {feedings.portion}
      </:col>
    </.table>
    """
  end

  def handle_event("random", _params, socket) do
    random_feeding = Feedings.create_random_feeding(socket.assigns.feedings)
    updated_list = [random_feeding | socket.assigns.feedings]

    socket =
      socket
      |> assign(:feedings, updated_list)
      |> stream_insert(:feedings, random_feeding, at: 0)

    {:noreply, socket}
  end

  def handle_event("select_brand", %{"brand" => brand}, socket) do
    {:noreply, assign(socket, :selected_brand, brand)}
  end

  def handle_event("select_flavor", %{"flavor" => flavor}, socket) do
    {:noreply, assign(socket, :selected_flavor, flavor)}
  end

  def handle_event("select_portion", %{"portion" => portion}, socket) do
    {:noreply, assign(socket, :selected_portion, portion)}
  end

  def handle_event(
        "form_change",
        %{"brand" => brand, "flavor" => flavor, "portion" => portion},
        socket
      ) do
    socket =
      socket
      |> assign(:selected_brand, (brand == "" && nil) || brand)
      |> assign(:selected_flavor, (flavor == "" && nil) || flavor)
      |> assign(:selected_portion, (portion == "" && nil) || portion)

    {:noreply, socket}
  end

  def handle_event("add_feeding", _params, socket) do
    case {socket.assigns.selected_brand, socket.assigns.selected_flavor,
          socket.assigns.selected_portion} do
      {nil, _, _} ->
        {:noreply, put_flash(socket, :error, "Please select a brand")}

      {_, nil, _} ->
        {:noreply, put_flash(socket, :error, "Please select a flavor")}

      {_, _, nil} ->
        {:noreply, put_flash(socket, :error, "Please select a portion")}

      {brand, flavor, portion} ->
        feeding = Feedings.create_feeding(socket.assigns.feedings, brand, flavor, portion)
        feedings = [feeding | socket.assigns.feedings]

        socket =
          socket
          |> assign(:feedings, feedings)
          |> assign(:selected_brand, nil)
          |> assign(:selected_flavor, nil)
          |> assign(:selected_portion, nil)
          |> stream_insert(:feedings, feeding, at: 0)

        {:noreply, socket}
    end
  end
end
