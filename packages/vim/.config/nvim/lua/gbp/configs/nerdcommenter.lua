local go = vim.g   -- global options

-- DON'T Create default mappings
go.NERDCreateDefaultMappings = 1

-- Add spaces after comment delimiters by default
go.NERDSpaceDelims = 1

-- Use compact syntax for prettified multi-line comments
go.NERDCompactSexyComs = 1

-- Align line-wise comment delimiters flush left instead of following code indentation
go.NERDDefaultAlign = 'left'

-- Set a language to use its alternate delimiters by default
go.NERDAltDelims_java = 1

-- Add your own custom formats or override the defaults
-- go.NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

-- Allow commenting and inverting empty lines (useful when commenting a region)
go.NERDCommentEmptyLines = 1

-- Enable trimming of trailing whitespace when uncommenting
go.NERDTrimTrailingWhitespace = 1

-- Enable NERDCommenterToggle to check all selected lines is commented or not 
go.NERDToggleCheckAllLines = 1

-- Set key mappings
require("gbp.mappings")
set_mappings_nerdcommenter()
