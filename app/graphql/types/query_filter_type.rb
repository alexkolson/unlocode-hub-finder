module Types
  class QueryFilterType < BaseInputObject
    argument :key, String, required: true
    argument :value, String, required: true
  end
end