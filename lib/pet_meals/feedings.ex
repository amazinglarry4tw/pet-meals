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
end
