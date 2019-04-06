module Mutations
  class PopulateHubs < BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false


    def resolve
      locode_zip_file = open('https://www.unece.org/fileadmin/DAM/cefact/locode/loc182csv.zip')
      Zip::File.open_buffer(locode_zip_file) do |zip|
        zip.select{ |e| e.name.downcase.include? 'codelistpart' }.each do |entry|
          hub_items = []
          CSV.parse(entry.get_input_stream.read, headers: false) do |row|
            puts row.inspect
            # convert array to hash and pass it to Hub.new
          end
        end
      end

      {
        success: false,
        errors: ['Not done yet']
      }
    end
  end
end
