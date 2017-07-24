require 'date'

class Dexby::Parse

  TREND_MAP = {0=>:"", 1=>:rising_quickly, 2=>:rising, 3=>:rising_slightly, 4=>:steady, 5=>:falling_slightly, 6=>:falling, 7=>:falling_quickly, 8=>:unknown, 9=>:unavailable}

  def self.parse(item)
    date = parse_date(item['DT'])
    trend = parse_trend(item['Trend'])
    value = item['Value']
    return {trend: trend, date: date, value: value}
  end

  def self.parse_trend(value)
    return TREND_MAP[value] if TREND_MAP.key? value
    raise ArgumentError
  end

  def self.parse_date(value)
    return DateTime.strptime(value, '/Date(%Q%z)/').new_offset(DateTime.now.offset)
  end

  def self.parse_all(items)
    return items.map{|i| parse(i)}
  end

end
