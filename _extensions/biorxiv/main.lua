-- main.lua
-- Main filter for bioRxiv Quarto extension
-- Orchestrates abstract parsing and footer customization

local footer = dofile(PANDOC_SCRIPT_FILE:match("(.*/)") .. "footer-options.lua")
local abstract_module = dofile(PANDOC_SCRIPT_FILE:match("(.*/)") .. "abstract.lua")

function Pandoc(doc)
  -- Process footer options
  local footer_commands = footer.process_footer_options(doc.meta)
  
  -- Process abstract and author summary
  local new_blocks = abstract_module.process_abstract(doc)
  
  -- Prepend footer commands first
  for i = #footer_commands, 1, -1 do
    new_blocks:insert(1, footer_commands[i])
  end
  
  return pandoc.Pandoc(new_blocks, doc.meta)
end
