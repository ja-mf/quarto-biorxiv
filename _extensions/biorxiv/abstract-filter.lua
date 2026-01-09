-- abstract-filter.lua
-- Parses #### Abstract and #### Author Summary sections
-- Extracts them from body and formats with keywords
-- Configurable: abstract-span: true/false (default: true) controls if abstract spans columns
--
-- For column-spanning figures, use Quarto's built-in fig-env attribute:
--   ![caption](image.png){#fig-id fig-env="figure*"}

local abstract_blocks = pandoc.List()
local author_summary_blocks = pandoc.List()

function Pandoc(doc)
  local new_blocks = pandoc.List()
  local i = 1
  
  -- Check for abstract-span option (default: true for spanning)
  local span_abstract = true
  if doc.meta['abstract-span'] ~= nil then
    span_abstract = doc.meta['abstract-span']
    if type(span_abstract) == "table" then
      span_abstract = pandoc.utils.stringify(span_abstract) == "true"
    end
  end
  
  -- Get keywords from metadata
  local keywords_str = ""
  if doc.meta.keywords then
    local kw_list = {}
    for _, kw in ipairs(doc.meta.keywords) do
      table.insert(kw_list, pandoc.utils.stringify(kw))
    end
    keywords_str = table.concat(kw_list, " | ")
  end
  
  -- Get corresponding email from metadata
  local corr_email = ""
  if doc.meta['corresponding-email'] then
    corr_email = pandoc.utils.stringify(doc.meta['corresponding-email'])
  end
  
  while i <= #doc.blocks do
    local block = doc.blocks[i]
    
    -- Check for Abstract header
    if block.t == "Header" and block.level == 4 then
      local text = pandoc.utils.stringify(block.content):lower()
      
      if text == "abstract" then
        i = i + 1
        -- Collect all blocks until next header
        while i <= #doc.blocks do
          local next_block = doc.blocks[i]
          if next_block.t == "Header" then
            break
          end
          abstract_blocks:insert(next_block)
          i = i + 1
        end
      elseif text == "author summary" then
        i = i + 1
        -- Collect all blocks until next header
        while i <= #doc.blocks do
          local next_block = doc.blocks[i]
          if next_block.t == "Header" then
            break
          end
          author_summary_blocks:insert(next_block)
          i = i + 1
        end
      else
        new_blocks:insert(block)
        i = i + 1
      end
    else
      new_blocks:insert(block)
      i = i + 1
    end
  end
  
  -- Build opening block with abstract
  local opening_blocks = pandoc.List()
  
  if #abstract_blocks > 0 then
    if span_abstract then
      -- For two-column mode with spanning abstract
      opening_blocks:insert(pandoc.RawBlock('latex', '\\makeatletter\\if@tmptwocolumn\\twocolumn[\\@maketitle'))
      opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{1em}\\noindent{\\sffamily\\bfseries\\large Abstract}\\par\\vspace{0.5em}\\begin{quote}\\small'))
      for _, block in ipairs(abstract_blocks) do
        opening_blocks:insert(block)
      end
      opening_blocks:insert(pandoc.RawBlock('latex', '\\end{quote}'))
      
      if #author_summary_blocks > 0 then
        opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{0.5em}\\noindent{\\sffamily\\bfseries\\large Author Summary}\\par\\vspace{0.5em}\\begin{quote}\\small'))
        for _, block in ipairs(author_summary_blocks) do
          opening_blocks:insert(block)
        end
        opening_blocks:insert(pandoc.RawBlock('latex', '\\end{quote}'))
      end
      
      -- Add keywords inside the spanning block
      if keywords_str ~= "" then
        opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{0.5em}\\noindent{\\sffamily\\bfseries\\footnotesize Keywords:} {\\footnotesize ' .. keywords_str .. '}\\par'))
      end
      
      opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{1em}]\\else\\@maketitle'))
      -- For single column mode fallback
      opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{1em}\\noindent{\\sffamily\\bfseries\\large Abstract}\\par\\vspace{0.5em}\\begin{quote}\\small'))
      for _, block in ipairs(abstract_blocks) do
        opening_blocks:insert(block)
      end
      opening_blocks:insert(pandoc.RawBlock('latex', '\\end{quote}'))
      
      if #author_summary_blocks > 0 then
        opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{0.5em}\\noindent{\\sffamily\\bfseries\\large Author Summary}\\par\\vspace{0.5em}\\begin{quote}\\small'))
        for _, block in ipairs(author_summary_blocks) do
          opening_blocks:insert(block)
        end
        opening_blocks:insert(pandoc.RawBlock('latex', '\\end{quote}'))
      end
      
      if keywords_str ~= "" then
        opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{0.5em}\\noindent{\\sffamily\\bfseries\\footnotesize Keywords:} {\\footnotesize ' .. keywords_str .. '}\\par'))
      end
      
      opening_blocks:insert(pandoc.RawBlock('latex', '\\fi\\makeatother'))
    else
      -- Non-spanning abstract (in column)
      opening_blocks:insert(pandoc.RawBlock('latex', '\\maketitle'))
      opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{1em}\\noindent{\\sffamily\\bfseries\\large Abstract}\\par\\vspace{0.5em}\\begin{quote}\\small'))
      for _, block in ipairs(abstract_blocks) do
        opening_blocks:insert(block)
      end
      opening_blocks:insert(pandoc.RawBlock('latex', '\\end{quote}'))
      
      if #author_summary_blocks > 0 then
        opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{0.5em}\\noindent{\\sffamily\\bfseries\\large Author Summary}\\par\\vspace{0.5em}\\begin{quote}\\small'))
        for _, block in ipairs(author_summary_blocks) do
          opening_blocks:insert(block)
        end
        opening_blocks:insert(pandoc.RawBlock('latex', '\\end{quote}'))
      end
      
      if keywords_str ~= "" then
        opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{0.5em}\\noindent{\\sffamily\\bfseries\\footnotesize Keywords:} {\\footnotesize ' .. keywords_str .. '}\\par'))
      end
    end
  else
    -- No abstract, just call maketitle and add keywords after
    opening_blocks:insert(pandoc.RawBlock('latex', '\\maketitle'))
    if keywords_str ~= "" then
      opening_blocks:insert(pandoc.RawBlock('latex', '\\vspace{0.5em}\\noindent{\\sffamily\\bfseries\\footnotesize Keywords:} {\\footnotesize ' .. keywords_str .. '}\\par'))
    end
  end
  
  -- Prepend abstract blocks to document
  for i = #opening_blocks, 1, -1 do
    new_blocks:insert(1, opening_blocks[i])
  end
  
  return pandoc.Pandoc(new_blocks, doc.meta)
end
