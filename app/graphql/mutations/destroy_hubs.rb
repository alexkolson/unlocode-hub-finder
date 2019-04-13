module Mutations
  class DestroyHubs < BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false


    def resolve
      errors = []
      success = true

      if Hub.all.empty?
        success = false
        errors.push('No Hubs in database to destroy.')
      else
        begin
          Hub.delete_all
        rescue => e
          Rails.logger.error e
          success = false
          errors.push(e.message)
        end
      end

      {
        success: success,
        errors: errors
      }
    end
  end
end
