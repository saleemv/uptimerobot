#load 'uptimerobot.rb'
require_relative 'uptimerobot'
total_args = ARGV.length
action, name, *inputs = ARGV

uptimeclient = UptimeRobot.new

case action
  when "add"
    if inputs.length < 2
      puts "Missing argument. uptimeclient.rb add <friendly name> <site> <type>"
      exit 0
    elsif inputs.length == 2
        site = inputs[0].to_s
        type = inputs[1].to_i
      uptimeclient.addMonitor(site, name, type)
    else
        puts "Not correct no.of arguments. : uptimeclient.rb add <friendly name> <site> <type>"
    end
  when "delete"
        uptimeclient.deleteMonitor(name)
  else
        puts "Invalid action: uptimeclient.rb add/delete <friendly name> <site> <type>"
end
