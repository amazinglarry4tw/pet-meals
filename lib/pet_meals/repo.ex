defmodule PetMeals.Repo do
  use Ecto.Repo,
    otp_app: :pet_meals,
    adapter: Ecto.Adapters.Postgres
end
