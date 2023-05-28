" Format lists better:
" setlocal formatlistpat=^\\s*[\\[({]\\\?\\([0-9]\\+\\\|[iIvVxXlLcCdDmM]\\+\\\|[a-zA-Z]\\)[\\]:.)}]\\s\\+\\\|^\\s*[-+o*]\\s\\+

" Set up formatlistpat to handle various denotions of indention/ hierarchy
set formatlistpat=
" Leading whitespace
set formatlistpat+=^\\s*
" Start class
set formatlistpat+=[
" Optionially match opening punctuation
set formatlistpat+=\\[({]\\?
" Start group
set formatlistpat+=\\(
" A number
set formatlistpat+=[0-9]\\+
" Roman numerals
set formatlistpat+=\\\|[iIvVxXlLcCdDmM]\\+
" A single letter
set formatlistpat+=\\\|[a-zA-Z]
" End group
set formatlistpat+=\\)
" Closing punctuation
set formatlistpat+=[\\]:.)}
" End class
set formatlistpat+=]
" One or more spaces
set formatlistpat+=\\s\\+
" Or ASCII style bullet points
set formatlistpat+=\\\|^\\s*[-+o*]\\s\\+
