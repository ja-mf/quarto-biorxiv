-- footer-options.lua
-- Handles footer customization options
--
-- Options:
--   footer-logo: "biorxiv" (default) | "Custom Text" | false
--   footer-date: true (default, shows \today) | "Custom Text" | false

local function process_footer_options(meta)
  local latex_commands = pandoc.List()
  
  -- Process footer-logo option
  if meta['footer-logo'] ~= nil then
    local logo_val = meta['footer-logo']
    if type(logo_val) == "boolean" then
      if not logo_val then
        latex_commands:insert(pandoc.RawBlock('latex', '\\hidefooterlogo'))
      end
    elseif type(logo_val) == "table" then
      local logo_str = pandoc.utils.stringify(logo_val)
      if logo_str:lower() == "false" then
        latex_commands:insert(pandoc.RawBlock('latex', '\\hidefooterlogo'))
      elseif logo_str:lower() ~= "biorxiv" and logo_str ~= "" then
        latex_commands:insert(pandoc.RawBlock('latex', '\\setfooterlogo{' .. logo_str .. '}'))
      end
    end
  end
  
  -- Process footer-date option
  if meta['footer-date'] ~= nil then
    local date_val = meta['footer-date']
    if type(date_val) == "boolean" then
      if not date_val then
        latex_commands:insert(pandoc.RawBlock('latex', '\\hidefooterdate'))
      end
    elseif type(date_val) == "table" then
      local date_str = pandoc.utils.stringify(date_val)
      if date_str:lower() == "false" then
        latex_commands:insert(pandoc.RawBlock('latex', '\\hidefooterdate'))
      elseif date_str:lower() ~= "true" and date_str ~= "" then
        latex_commands:insert(pandoc.RawBlock('latex', '\\setfooterdate{' .. date_str .. '}'))
      end
    end
  end
  
  return latex_commands
end

return {
  process_footer_options = process_footer_options
}
