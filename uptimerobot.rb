require 'rubygems'
require 'net/http'
require 'json'
require 'yaml'
require 'uri'
require 'OpenSSL'

URL = "https://api.uptimerobot.com/v2/"

class UptimeRobot

  def initialize
    @api_key = read_key('api_key')
  end

public
def addMonitor(site, name, type)
# Append the action to the base url to get the url for adding
  action = "newMonitor"

# Only 3 mandatory parameters are passed while adding the site now url of the site, friendly name and type of check. More can be added.
  param = "url=#{site}&friendly_name=#{name}&type=#{type}"
  adding = run_http(action, param)
  jsonresponse = JSON.parse adding.body
  if jsonresponse["stat"] == "fail"
                        puts jsonresponse["Error"]
                elsif jsonresponse["stat"] == "ok"
                        puts jsonresponse["monitor"]
                else
                        puts jsonresponse
                end
        end

        def deleteMonitor(site)
# Append the action to the base url to get the url for adding
                action = "deleteMonitor"
# Get the id of the site that need to be deleted. get_id find the id of site that match the name.
               id = get_id(site)

                param = "format=json&id=#{id}"

                if id.nil?
                        puts "Site not in monitor"
                else
                        puts "this id will be deleted #{id}"
                        delete = run_http(action, param)
                    puts delete.body
                end
        end

        private
        def read_key(whichkey)
                all_keys = YAML.load_file('keys.yml')
                return all_keys[whichkey.to_s]
        end

#This method makes the api call to uptimeRobot and returns the response.
        def run_http(action, param)

                api_url = URI(URL + action)

                http = Net::HTTP.new(api_url.host, api_url.port)
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                request = Net::HTTP::Post.new(api_url)
                request["cache-control"] = 'no-cache'
                request["content-type"] = 'application/x-www-form-urlencoded'
                request.body = "api_key=#{@api_key}&#{param}"

                http.request(request)
        end


# This method gets the id of a site based on the friendly name. This is needed for all operation except adding.
        def get_id(name)

                param = "format=json&logs=1"
                details = run_http("getMonitors", param)
                jsonresponse = JSON.parse details.body
                # puts "_______________________________________"
                monitors = jsonresponse["monitors"]

                monitors.each do |item|
                        if item["friendly_name"] == name
                                return item["id"]
                        end
                end
                return nil
        end

end
