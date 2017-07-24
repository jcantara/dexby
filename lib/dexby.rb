require "dexby/version"
require "dexby/reader"

module Dexby
  def self.new(username, password)
    Reader.new(username, password)
  end
end
