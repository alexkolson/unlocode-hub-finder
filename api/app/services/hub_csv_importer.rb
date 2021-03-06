module HubCSVImporter
  class << self
    def import
      return { 
        success: false,
        errors: ['Hubs present in database. Database must be empty in order for this mutation to succeed.']
      } unless Hub.first.nil?

      hub_items = []

      locode_zip_file = open('https://www.unece.org/fileadmin/DAM/cefact/locode/loc182csv.zip')

      Zip::File.open_buffer(locode_zip_file) do |zip|
        zip.select{ |e| e.name.downcase.include? 'codelistpart' }.each do |entry|
          CSV.parse(entry.get_input_stream.read, headers: false) do |row|
            if row[2].nil?
              next
            end

            row.map! { |data| data.nil? ? data : data.force_encoding('iso-8859-1').encode('utf-8') }

            coordinates = row[10]

            lat, lng = CoordinateConverter.lat_lng_from_locode_coord_str(coordinates)

            hub_items << Hub.new(
              ch: row[0],
              locode: "#{row[1]} #{row[2]}",
              name: row[3],
              name_wo_diacritics: row[4],
              sub_div: row[5],
              function: row[6],
              status: row[7],
              date: parse_date(row[8]),
              iata: row[9],
              lat: lat,
              lng: lng,
              remarks: row[11]
            )
          end
        end
      end

      begin
        Hub.import!(hub_items)
      rescue => e
        return {
          success: false,
          errors: [e.message]
        }
      end

      {
        success: true,
        errors: []
      }
    end

    private

    def parse_date(date_str)
      Date.strptime(date_str, '%y%m') unless date_str.nil?
    end
  end
end