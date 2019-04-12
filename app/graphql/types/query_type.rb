module Types
  class QueryType < BaseObject
    field :hubs, [HubType], null: false do
      argument :filter, FilterType, required: false
    end

    # TODO: pagination, haversine, ordering
    def hubs(filter: nil)
      return Hub.all if filter.nil?
      # Prevent SQL Injection by only allowing filter keys that are column names.
      raise GraphQL::ExecutionError, 'filter key must be an attribute on a Hub!' unless Hub.column_names.include? filter[:key]
      Hub.where("#{filter[:key]} ILIKE ?", "%#{filter[:value]}%")
    end
  end
end
