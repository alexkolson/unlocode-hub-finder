module Types
  class QueryType < BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    field :hubs, [HubType], null: false

    def hubs
      Hub.all
    end
  end
end
