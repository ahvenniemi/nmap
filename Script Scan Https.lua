local nmap = require "nmap"
local http = require "http"

local target = "192.168.0.1"  -- Target IP address
local output_file = "/path/to/desired/folder/script_scan_results.txt"  -- Output file name

-- Define the HTTPS server summary object
local https_summary = {}

-- Discover and store the HTTPS server summary
function https_summary.discover(host, port)
    local response = http.get(host, port, "/", { ssl = true })
    https_summary.version = response.http_version
    https_summary.methods = response.supported_methods
    https_summary.mime_types = response.supported_mime_types
end

-- Print the HTTPS server summary
function https_summary.print()
    print("HTTPS version: " .. https_summary.version)
    print("Supported methods: " .. table.concat(https_summary.methods, ", "))
    print("Supported MIME types: " .. table.concat(https_summary.mime_types, ", "))
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
    
    -- Perform the HTTPS server summary discovery
    https_summary.discover(target, 443)
    
    -- Print the HTTPS server summary
    https_summary.print()
else
    -- Print an error message if the script scan failed
    print("Script scan failed: " .. result)
end
