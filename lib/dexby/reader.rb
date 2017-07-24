require "dexby/connection"
require "dexby/parse"

class Dexby::Reader
  def initialize(username, password, connection_class=Dexby::Connection, parser_class=Dexby::Parse)
    @connection_class = connection_class
    @parser_class = parser_class
    @username = username
    @password = password
    @session_id = nil
  end

  def connection
    @connection_class
  end

  def parser
    @parser_class
  end

  def read
    ensure_session_id
    result = session_connection_read
    if result[1] != 200
      raise ::StandardError
    end
    parser.parse_all(result[0])
  end

  def session_connection_read
    result = connection.read(@session_id)
    if result[1] == 401 # expired session_id
      result = get_session_reread
    end
    return result
  end

  def get_session_reread
    get_session_id
    connection.read(@session_id)
  end

  def ensure_session_id
    get_session_id if @session_id.nil?
  end

  def get_session_id
    result = connection.login(@username, @password)
    if result[1] == 200
      @session_id = result[0]
    else
      raise ::StandardError
    end
  end

end
