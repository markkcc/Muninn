require 'nmap/program'

timestamp = Time.new.strftime("%s")
puts timestamp

results = Nmap::Program.scan do |nmap|
  nmap.syn_scan = false
  nmap.service_scan = true
  nmap.os_fingerprint = false
  nmap.xml = "/tmp/scan-" + timestamp + ".xml"
  nmap.verbose = true

  nmap.ports = [20,22,23,25,53,80,443,3000,3306,8080]
  nmap.targets = '127.0.0.1'
end

puts results
