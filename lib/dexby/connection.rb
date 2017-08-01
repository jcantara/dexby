require 'httparty'
require 'json'

class Dexby::Connection
  include ::HTTParty
  base_uri 'https://share1.dexcom.com'
  headers ({
            "User-Agent" => "Dexcom Share/3.0.2.11 CFNetwork/711.2.23 Darwin/14.0.0",
            "Content-Type" => "application/json",
            "Accept" => "application/json",
          })
  format :json

  APPLICATION_ID = "d8665ade-9673-4e27-9ff6-92db4ce13d13" # not sure where this comes from, might just be internal versioning for legit dexcom app?
  LOGIN_ENDPOINT = "/ShareWebServices/Services/General/LoginPublisherAccountByName"
  READ_ENDPOINT = "/ShareWebServices/Services/Publisher/ReadPublisherLatestGlucoseValues"

  def self.login_body(user, pass)
    {"accountName" => user, "password" => pass, "applicationId" => APPLICATION_ID}
  end

  def self.read_query(session_id, minutes, count)
    {"sessionId" => session_id, "minutes" => minutes, "maxCount" => count}
  end

  def self.login(user, pass)
    response = self.post(LOGIN_ENDPOINT, body: login_body(user, pass).to_json)
    [response.body.tr('"',''), response.code]
  end

  def self.read(session_id, minutes, count)
    response = self.post(READ_ENDPOINT, query: read_query(session_id, minutes, count))
    [response.parsed_response, response.code]
  end

end
