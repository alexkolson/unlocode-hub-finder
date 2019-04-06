module Types
  class QueryType < BaseObject
    field :hubs, [HubType], null: false

    def hubs
      Hub.all
    end
  end
end
