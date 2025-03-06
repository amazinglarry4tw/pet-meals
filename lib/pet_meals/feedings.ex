defmodule PetMeals.Feedings do
  alias PetMeals.Feedings.Feeding

  def list_feedings do
    [
      %PetMeals.Feedings.Feeding{
        id: 1,
        brand: "Fancy Feast",
        flavor: "Beef",
        portion: :half
      },
      %PetMeals.Feedings.Feeding{
        id: 1,
        brand: "Fancy Feast",
        flavor: "Salmon",
        portion: :full
      },
      %PetMeals.Feedings.Feeding{
        id: 1,
        brand: "Sheba",
        flavor: "Beef",
        portion: :quarter
      }
    ]
  end
end
