module Mutations
  class PopulateHubs < BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve
      hub_items = []
      locode_zip_file = open('https://www.unece.org/fileadmin/DAM/cefact/locode/loc182csv.zip')
      Zip::File.open_buffer(locode_zip_file) do |zip|
        zip.select{ |e| e.name.downcase.include? 'codelistpart' }.each do |entry|
          CSV.parse(entry.get_input_stream.read, headers: false) do |row|
            if row[2].nil?
              next
            end

            puts row.inspect

            row.map! { |data| data.nil? ? data : data.encode('UTF-8', invalid: :replace, undef: :replace) }

            coordinates = row[10]

            lat_lng = CoordinateConverter.lat_lng_from_locode_coord_str(coordinates)

            hub_items << Hub.new(
              ch: row[0],
              locode: "#{row[1]}#{row[2]}",
              name: row[3],
              name_wo_diacritics: row[4],
              sub_div: row[5],
              function: row[6],
              status: row[7],
              date: row[8],
              iata: row[9],
              coordinates:  lat_lng.nil? ? nil : ActiveRecord::Point.new(lat_lng[0], lat_lng[1]),
              remarks: row[11]
            )
          end
        end
      end

      Hub.import(hub_items)

      {
        success: false,
        errors: ['Not done yet']
      }
    end
  end
end
