require_relative 'colour/named'
require_relative 'colour/hsl'

module Milight
  class Colour

    def milight_code_for(value)
      case value
      when String
        colour_hex(value)
      when Symbol
        colour_named(value)
      when Fixnum
        colour_numbered(value)
      else
        raise invalid_colour_error
      end
    end

    def rgb(r, g, b)
      Milight::Colour::HSL.new.from_rgb(r, g, b).to_milight
    end

    private

    def colour_named(name)
      raise invalid_colour_name_error(name) unless valid_name? name
      NAMED[name]
    end

    def colour_numbered(number)
      raise invalid_colour_number_error unless valid_colour? number
      number
    end

    def colour_hex(hex)
      raise invalid_hex_colour_error unless valid_hex_colour? hex
      Milight::Colour::HSL.new.from_hex(hex).to_milight
    end

    def invalid_colour_error
      ArgumentError.new('Colours must be a name symbol, HEX string, or a MiLight colour integer between 0 and 255')
    end

    def valid_colour?(value)
      value.between?(0, 255)
    end

    def invalid_colour_number_error
      ArgumentError.new('Colours numbers must be between 0 and 255')
    end

    def valid_name?(name)
      NAMED.keys.include?(name)
    end

    def invalid_colour_name_error(name)
      ArgumentError.new("#{name} is not a known colour")
    end

    def valid_hex_colour?(value)
      value =~ /^#?([0-9a-f]{3}){,2}$/i
    end

    def invalid_hex_colour_error
      ArgumentError.new('Hex colours codes must be 3 or 6 0-9 or a-f characters')
    end

  end
end
