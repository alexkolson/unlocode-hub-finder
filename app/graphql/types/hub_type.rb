module Types
  class HubType < BaseObject
    field :id, ID, null: false
    field :ch, String, null: true
    field :locode, String, null: false
    field :name, String, null: false
    field :name_wo_diacritics, String, null: false
    field :sub_div, String, null: true
    field :function, String, null: true
    field :status, String, null: true
    field :date, ISO8601DateType, null: true
    field :iata, String, null: true
    field :coordinates, PointType, null: true
    field :remarks, String, null: true
  end
end
