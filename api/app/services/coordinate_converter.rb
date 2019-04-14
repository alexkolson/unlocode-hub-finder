module CoordinateConverter
  class << self
    def lat_lng_from_locode_coord_str(locode_coord_str)
      return unless locode_coord_str.to_s.length > 0

      coord_parts = locode_coord_str.split(' ')

      lat_coord_part_str = coord_parts[0]
      lng_coord_part_str = coord_parts[1]

      [lat_coord_part_str, lng_coord_part_str].map do |part_str|
        part_dir = part_str[-1]
        part_str.chop! 
        part = part_str.sub(/^[0]+/, '').empty? ? BigDecimal(0) : BigDecimal(part_str.sub(/^[0]+/, ''))
        part_reduction = part / 100
        part_dec = part_reduction.frac / 0.60

        ['W', 'S'].include?(part_dir) ? (part_reduction.fix + part_dec) * -1 : part_reduction.fix + part_dec
      end
    end
  end
end