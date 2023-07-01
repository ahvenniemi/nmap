local nmap = require "nmap"

local target = "192.168.0.1"  -- Target IP address
local output_file = "/path/to/desired/folder/sO_results.txt"  -- Output file name

-- Perform the scan
local success, result = pcall(nmap.scan, {target}, "-O")

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
        if host.os.osclass[1] then
            local line = "IP: " .. host.ip .. " OS: " .. host.os.osclass[1].osfamily .. "\n"
            file:write(line)
        else
            local line = "IP: " .. host.ip .. " OS: Unknown\n"
            file:write(line)
        end
    end

    -- Close the output file
    file:close()

    -- Print a message indicating the scan is complete
    print("OS detection results saved to " .. output_file)
else
    -- Print an error message if the scan failed
    print("OS detection scan failed: " .. result)
end
