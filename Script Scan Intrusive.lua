local nmap = require "nmap"

local target = "192.168.0.1"  -- Target IP address
local output_file = "/path/to/desired/folder/script_scan_results.txt"  -- Output file name

-- Perform the scan
local success, result = pcall(nmap.scan, {target}, "--script intrusive")

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

  -- Print a message indicating the scan is complete
  print("Script scan results saved to " .. output_file)
else
  -- Print an error message if the scan failed
  print("Script scan failed: " .. result)
end
