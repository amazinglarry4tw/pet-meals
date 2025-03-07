defmodule PetMeals.Feedings do
  alias PetMeals.Feedings.Feeding

  def list_feedings do
    [
      %Feeding{
        id: 1,
        brand: "Fancy Feast",
        flavor: "Beef",
        portion: :half
      },
      %Feeding{
        id: 1,
        brand: "Fancy Feast",
        flavor: "Salmon",
        portion: :full
      },
      %Feeding{
        id: 1,
        brand: "Sheba",
        flavor: "Beef",
        portion: :quarter
      }
    ]
  end

  def create_random_feeding do
    brands = ["Fancy Feast", "Sheba", "Blue Buffalo"]
    portions = [:quarter, :half, :full]

    %Feeding{
      id: 1,
      brand: Enum.random(brands),
      flavor: ~w(Beef Salmon Chicken) |> Enum.random(),
      portion: Enum.random(portions)
    }
  end
end
