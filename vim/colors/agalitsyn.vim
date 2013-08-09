set background=dark
hi clear
syntax reset

let colors_name = "inkpot"

fun! SetColorLink(from_group, to_group)
    exec "hi link " . a:from_group . " " . a:to_group
endfun;

fun! SetColorFull(group, fg_color, bg_color)
    exec "hi " . a:group . " cterm=NONE " . "ctermfg=" . a:fg_color . " ctermbg=" . a:bg_color
endfun;

fun! SetColorFg(group, fg_color)
    call SetColorFull(a:group, a:fg_color, 'NONE')
endfun;

fun! SetColorBg(group, bg_color)
    call SetColorFull(a:group, 'NONE', a:bg_color)
endfun;

call SetColorFull('Normal', 231, 232)
call SetColorFull('IncSearch', 232, 215)
call SetColorFull('Search', 232, 130)
call SetColorFull('ErrorMsg', 16, 124)
call SetColorFull('WarningMsg', 16, 202)
call SetColorFg('ModeMsg', 61)
call SetColorFg('MoreMsg', 61)
call SetColorFg('Question', 130)
call SetColorFull('StatusLine', 247, 235)
call SetColorFull('User1', 46, 235)
call SetColorFull('User2', 63, 235)
call SetColorFull('StatusLineNC', 244, 235)
call SetColorFull('VertSplit', 244, 235)
call SetColorFull('WildMenu', 253, 61)
call SetColorFull('MBENormal', 247, 235)
call SetColorFull('MBEChanged', 253, 235)
call SetColorFull('MBEVisibleNormal', 247, 238)
call SetColorFull('MBEVisibleChanged', 253, 238)
call SetColorFull('DiffText', 231, 55)
call SetColorFull('DiffChange', 231, 17)
call SetColorFull('DiffDelete', 231, 52)
call SetColorFull('DiffAdd', 231, 22)
call SetColorFull('Folded', 231, 57)
call SetColorFull('FoldColumn', 63, 232)
call SetColorFg('Directory', 247)
call SetColorFg('treeDir', 247)
call SetColorFg('treeExecFile', 15)
call SetColorFg('treeOpenable', 15)
call SetColorFg('treeClosable', 15)
call SetColorFg('treePart', 15)
call SetColorFg('treePartFile', 15)
call SetColorFg('treeDirSlash', 15)
call SetColorFg('Comment', 247)
call SetColorFull('LineNr', 63, 232)
call SetColorFg('NonText', 63)
call SetColorFg('SpecialKey', 135)
call SetColorFg('Title', 124)
call SetColorFull('Visual', 231, 61)
call SetColorFg('Constant', 215)
call SetColorFg('String', 215)
call SetColorFg('SpecialChar', 111)
call SetColorFull('Error', 231, 52)
call SetColorFg('Identifier', 105)
call SetColorFull('Ignore', 'NONE', 'NONE')
call SetColorFg('Number', 203)
call SetColorFg('PreProc', 35)
call SetColorFg('Special', 135)
call SetColorFg('Statement', 69)
call SetColorFull('Todo', 16, 143)
call SetColorFg('Type', 27)
call SetColorFg('Underlined', 227)
call SetColorFg('TaglistTagName', 63)
call SetColorFull('Pmenu', 253, 238)
call SetColorFull('PmenuSel', 253, 61)
call SetColorFull('PmenuSbar', 253, 63)
call SetColorFull('PmenuThumb', 253, 63)
call SetColorBg('SpellBad', 52)
call SetColorBg('SpellRare', 53)
call SetColorBg('SpellLocal', 58)
call SetColorBg('SpellCap', 23)
call SetColorFull('MatchParen', 14, 35)

call SetColorFg('sPhpVariable', 10)
call SetColorLink('phpVarSelector', 'sPhpVarible')
call SetColorLink('phpSuperglobal', 'sPhpVarible')
call SetColorLink('phpBuiltinVar', 'sPhpVarible')
call SetColorLink('phpLongVar', 'sPhpVarible')
call SetColorLink('phpEnvVar', 'sPhpVarible')
call SetColorLink('phpIdentifier', 'sPhpVarible')

let s:green = 35
let s:functionColor = s:green

call SetColorFg('perlFunctionName', s:functionColor)

