module Types
  class HubsQueryResponseType < BaseObject
    field :page, [HubType], null: false
    field :next_page, Int, null: true
    field :total_pages, Int, null: false
    field :total_hubs, Int, null: false
  end
end
