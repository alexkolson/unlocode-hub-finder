module Types
  class QueryType < BaseObject
    field :hubs, HubsQueryResponseType, null: false do
      argument :filter, QueryFilterType, required: false
      argument :order, QueryOrderType, required: false
      argument :page, Int, required: false
      argument :page_size, Int, required: false
    end

    field :nearest_hub_to_coordinates, HubType, null: false do
      argument :lat, Float, required: true
      argument :lng, Float, required: true
    end

    field :nearest_hub_to_address, HubType, null: false do
      argument :address, String, required: true
    end

    def hubs(filter: nil, order: nil, page: 1, page_size: 10)
      if filter.nil?
        @hubs = Hub.all
      else 
        # Prevent SQL Injection by only allowing filter keys that are column names.
        error_if_not_hub_column_name key_type: 'filter', key: filter[:key]
        @hubs = Hub.where("#{filter[:key]} ILIKE ?", "%#{filter[:value]}%")
      end

      current_page = @hubs
        .page(page)
        .per(page_size)

      unless order.nil?
        error_if_not_hub_column_name key_type: 'order', key: order[:key]

        if order[:desc]
          order_hash = {}
          order_hash[order[:key]] = :desc
          current_page = current_page.order(order_hash)
        else
          current_page = current_page.order(order[:key])
        end
      end

      next_page = current_page.next_page

      total_pages = current_page.total_pages

      total_hubs = current_page.total_count

      {
        page: current_page,
        next_page: next_page,
        total_pages: total_pages,
        total_hubs: total_hubs
      }
    end

    def nearest_hub_to_coordinates(lat:, lng:)
      Hub.closest(origin: [lat, lng]).first
    end

    def nearest_hub_to_address(address:)
      Hub.closest(origin: address).first
    end

    private

    def error_if_not_hub_column_name(key_type:, key:)
      raise GraphQL::ExecutionError, "#{key_type} key (#{key}) must be an attribute on a Hub!" unless Hub.column_names.include? key
    end
  end
end
