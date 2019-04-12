module Types
  class ISO8601DateType < GraphQL::Schema::Scalar
    def self.coerce_input(input_value, _context)
      Date.iso8601(input_value)
    rescue ArgumentError
      nil
    end

    def self.coerce_result(ruby_value, _context)
      ruby_value.iso8601
    end
  end 
end