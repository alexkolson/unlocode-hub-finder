module Mutations
  class PopulateHubs < BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve
      HubCSVImporter.import
    end
  end
end
