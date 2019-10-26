require 'whois'

## Domain WHOIS
# whois = Whois::Client.new
# print(whois.lookup("mu.gl"))
## => #<Whois::Record>

lookup_target = "mu.gl"

print(Whois.whois(lookup_target))


