local nmap = require "nmap"
local http = require "http"

local target = "192.168.0.1"  -- Target IP address
local output_file = "/path/to/desired/folder/script_scan_results.txt"  -- Output file name

-- Define the HTTP server summary object
local http_summary = {}

-- Discover and store the HTTP server summary
function http_summary.discover(host, port)
    local response = http.get(host, port, "/")
    http_summary.version = response.http_version
    http_summary.methods = response.supported_methods
    http_summary.mime_types = response.supported_mime_types
end

-- Print the HTTP server summary
function http_summary.print()
    print("HTTP version: " .. http_summary.version)
    print("Supported methods: " .. table.concat(http_summary.methods, ", "))
    print("Supported MIME types: " .. table.concat(http_summary.mime_types, ", "))
end

-- Perform the script scan
local success, result = pcall(nmap.scan, {target}, "--script default")

if success then
    -- Open the output file for writing
    local file = io.open(output_file, "a")  -- Use "a" mode to append to the file instead of overwriting
  
    -- Get the current date and time
    local date_time = os.date("%Y-%m-%d %H:%M:%S")

    -- Write the header information to the file
    file:write("Scan Date: " .. date_time .. "\n")
    file:write("Target: " .. target .. "\n\n")

    -- Write the results to the file
    for _, host in ipairs(result) do
        for _, script in ipairs(host.scripts) do
            local line = "IP: " .. host.ip .. " Script ID: " .. script.id .. " Output: " .. script.output .. "\n"
            file:write(line)
        end
    end

    -- Close the output file
    file:close()

    -- Print a message indicating the script scan is complete
    print("Script scan results saved to " .. output_file)
    
    -- Perform the HTTP server summary discovery
    http_summary.discover(target, 80)
    
    -- Print the HTTP server summary
    http_summary.print()
else
    -- Print an error message if the script scan failed
    print("Script scan failed: " .. result)
end
