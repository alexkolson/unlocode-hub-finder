module Types
  class QueryOrderType < BaseInputObject
    argument :key, String, required: true
    argument :desc, Boolean, required: false
  end
end