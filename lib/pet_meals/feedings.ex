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
        id: 2,
        brand: "Fancy Feast",
        flavor: "Salmon",
        portion: :full
      },
      %Feeding{
        id: 3,
        brand: "Sheba",
        flavor: "Beef",
        portion: :quarter
      }
    ]
  end

  def create_random_feeding(feedings) do
    next_id =
      feedings
      |> Enum.map(& &1.id)
      |> Enum.max()
      |> Kernel.+(1)

    brands = ["Fancy Feast", "Sheba", "Blue Buffalo"]
    portions = [:quarter, :half, :full]

    %Feeding{
      id: next_id,
      brand: Enum.random(brands),
      flavor: ~w(Beef Salmon Chicken) |> Enum.random(),
      portion: Enum.random(portions)
    }
  end

  def create_feeding(feedings, brand, flavor, portion) do
    next_id =
      feedings
      |> Enum.map(& &1.id)
      |> Enum.max()
      |> Kernel.+(1)

    %Feeding{
      id: next_id,
      brand: brand,
      flavor: flavor,
      portion: portion
    }
  end

  def create_feeding(_) do
  end
end
