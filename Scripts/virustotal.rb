require "virustotalx"

# Loads the API key from ENV["VIRUSTOTAL_API_KEY"]
VTapi = VirusTotal::API.new

#print(VTapi.domain.get("mu.gl"))

print(VTapi.url.get("https://mu.gl/"))
