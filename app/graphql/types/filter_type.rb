module Types
  class FilterType < BaseInputObject
    argument :key, String, required: true
    argument :value, String, required: true
  end
end