module Types
  class MutationType < BaseObject
    field :populate_hubs, mutation: Mutations::PopulateHubs
    field :destroy_hubs, mutation: Mutations::DestroyHubs
  end
end
