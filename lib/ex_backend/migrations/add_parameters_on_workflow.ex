defmodule ExBackend.Migration.AddParametersOnWorkflow do
  @moduledoc false

  use Ecto.Migration

  def change do
    alter table(:workflow) do
      add(:parameters, {:array, :map}, default: [])
    end
  end
end
