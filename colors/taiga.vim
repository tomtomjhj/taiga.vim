if exists('g:colors_name')
  " NOTE: This does not restore default highlights (e.g. htmlBold). It only
  " restores default links...
  hi clear
  if exists('g:syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'taiga'

let s:full_special_attrs_support = get(g:, 'taiga_full_special_attrs_support', 1)

" Palette: {{{
let s:none    = ['NONE', 'NONE']

let s:gray_00 = ['#000000',  16]
let s:gray_12 = ['#121212', 233]
let s:gray_1c = ['#1c1c1c', 234]
let s:gray_26 = ['#262626', 235]
let s:gray_3a = ['#3a3a3a', 237]
let s:gray_44 = ['#444444', 238]
let s:gray_62 = ['#626262', 241]
let s:gray_6c = ['#6c6c6c', 242]
let s:gray_9e = ['#9e9e9e', 247]
let s:gray_a8 = ['#a8a8a8', 248]
let s:gray_af = ['#afafaf', 245]
let s:gray_bc = ['#bcbcbc', 250]
let s:gray_c6 = ['#c6c6c6', 251]
let s:gray_d0 = ['#d0d0d0', 252]
let s:gray_d7 = ['#d7d7d7', 188]
let s:gray_e4 = ['#e4e4e4', 254]
let s:gray_ee = ['#eeeeee', 255]
let s:gray_ff = ['#ffffff', 231]

" khaki      : semi-keywords, built-in command/functions (needs manual tuning)
" green_high : diffAdded, important definition (needs manual tuning)
" green_low  : Comment
" green_bg   : DiffAdd
" cyan_high  : info
" cyan_low   : literals, built-in constants (needs manual tuning)
" blue       : MatchParen
" purple_bg  : DiffText
" pink_high  : Todo
" pink_low   : Special, escapes, macro invocation, ..
" orange     : warning
" red        : error
" tan        : Search

if &background ==# 'dark'
  let s:fg_high    = s:gray_ff
  let s:fg         = s:gray_ee " 93%
  let s:fg_low1    = s:gray_d0 " 82%
  let s:fg_low2    = s:gray_bc " 74%
  let s:fg_low3    = s:gray_a8
  let s:bg_high    = s:gray_00
  let s:bg         = s:gray_12 " 7%
  let s:bg_low1    = s:gray_1c " 11%
  let s:bg_low2    = s:gray_26 " 15%
  let s:subtle     = s:gray_44 " 27%
  let s:selection  = s:gray_62 " 27%
  let s:hint       = s:gray_9e " 62%

  let s:khaki      = ['#afaf5f', 143] " 60°, 33%, 53%
  let s:green_high = ['#afd787', 150] " 90°, 50%, 69%
  let s:green_low  = ['#87af87', 108] " 120°, 20%, 61%
  let s:green_bg   = ['#284028',  22] " 120°, 23%, 20%

  let s:cyan_high  = ['#5fd7d7',  80] " 180°, 60%, 60%
  let s:cyan_low   = ['#afd7d7', 152] " 180°, 33%, 76%
  let s:blue       = ['#5f87af',  67] " 210°, 33%, 53%

  let s:purple_bg  = ['#4f3f5f',  60] " 270°, 20%, 31%
  let s:pink_high  = ['#ffafd7', 218] " 330°, 100%, 84%
  let s:pink_low   = ['#ffd7d7', 224] " 0°, 100%, 92%
  let s:orange     = ['#ffaf5f', 215] " 30°, 100%, 69%
  let s:red        = ['#ff5f5f', 203] " 0°, 100%, 69%
  let s:tan        = ['#d7af87', 180] " 30°, 50%, 69%
else " light
  let s:fg_high    = s:gray_00
  let s:fg         = s:gray_12 " 7%
  let s:fg_low1    = s:gray_26
  let s:fg_low2    = s:gray_3a
  let s:fg_low3    = s:gray_6c
  let s:bg_high    = s:gray_ff
  let s:bg         = s:gray_e4 " 89%
  let s:bg_low1    = s:gray_d7
  let s:bg_low2    = s:gray_c6
  let s:subtle     = s:gray_bc
  let s:selection  = s:gray_9e
  let s:hint       = s:gray_a8

  let s:khaki      = ['#666633',  58] " 60°, 33%, 30%
  let s:green_high = ['#4b770d',  64] " 85°, 80%, 26%
  let s:green_low  = ['#436b4d',  65] " 135°, 23%, 34%
  let s:green_bg   = ['#b7d2b7', 151] " 120°, 23%, 77%

  let s:cyan_high  = ['#1f9393',  30] " 180°, 65%, 35%
  let s:cyan_low   = ['#234e5c',  23] " 195°, 45%, 25%
  let s:blue       = ['#4d7399',  67] " 210°, 33%, 45%

  let s:purple_bg  = ['#a897ba', 146] " 270°, 20%, 66%
  let s:pink_high  = ['#b8005c', 125] " 330°, 100%, 36%
  let s:pink_low   = ['#610542',  53] " 320°, 90%, 20%
  let s:orange     = ['#d78700', 130] " 38°, 100%, 42%
  let s:red        = ['#af0000', 124] " 0°, 100%, 34%
  let s:tan        = ['#8f673d',  94] " 30°, 40%, 40%
endif
" }}}

" Script Helpers: {{{
function! s:h(scope, fg, ...) " bg, attr_list, special
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])

  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  " If the UI does not have full support for special attributes (like underline and
  " undercurl) and the highlight does not explicitly set the foreground color,
  " make the foreground the same as the attribute color to ensure the user will
  " get some highlight if the attribute is not supported.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !s:full_special_attrs_support
    let l:fg[0] = l:special[0]
    let l:fg[1] = l:special[1]
  endif

  let l:hl_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs,
        \ 'guisp=' . l:special[0],
        \ has('patch-8.2.0863') ? 'ctermul=' . l:special[1] : '',
        \]

  execute join(l:hl_string, ' ')
endfunction
" }}}

" common highlight combinations {{{
call s:h('TaigaKeyword', s:fg, s:none, ['bold'])
call s:h('TaigaSubKeyword', s:fg, s:none, ['italic'])
call s:h('TaigaIdentBuiltin', s:khaki)
call s:h('TaigaTitle', s:green_high, s:none, ['bold'])
call s:h('TaigaLiteral', s:cyan_low)
call s:h('TaigaConstBuiltin', s:cyan_low)
call s:h('TaigaSpecial', s:pink_low)
call s:h('TaigaComment', s:green_low)
call s:h('TaigaCommentBold', s:green_low, s:none, ['bold'])

call s:h('TaigaBoundary', s:fg_low1, s:bg_high)
call s:h('TaigaNonText', s:selection)
call s:h('TaigaSelection', s:none, s:selection)
call s:h('TaigaSubtle', s:subtle)

call s:h('TaigaError', s:red, s:none, [], s:red)
call s:h('TaigaErrorLine', s:none, s:none, ['undercurl'], s:red)
call s:h('TaigaWarn', s:orange)
call s:h('TaigaWarnLine', s:none, s:none, ['undercurl'], s:orange)
call s:h('TaigaInfo', s:cyan_high)
call s:h('TaigaInfoLine', s:none, s:none, ['undercurl'], s:cyan_high)
call s:h('TaigaHint', s:hint)
call s:h('TaigaHintLine', s:none, s:none, ['undercurl'], s:hint)

call s:h('TaigaFgLow', s:fg_low2)
call s:h('TaigaBgHigh', s:none, s:bg_high)
call s:h('TaigaGreenHigh', s:green_high)
call s:h('TaigaRed', s:red)
" }}}

" :h group-name {{{
hi! link Comment TaigaComment

hi! clear Constant
hi! link String TaigaLiteral
hi! link Character TaigaLiteral
hi! link Number TaigaLiteral
hi! link Boolean TaigaLiteral
hi! link Float TaigaLiteral

hi! clear Identifier
hi! link Function NONE

hi! link Statement TaigaKeyword
hi! link Conditional TaigaKeyword
hi! link Repeat TaigaKeyword
call s:h('Label', s:pink_low, s:none, ['bold'])
hi! link Operator TaigaKeyword
hi! link Keyword TaigaKeyword
hi! link Exception TaigaKeyword

hi! link PreProc TaigaKeyword
hi! link Include TaigaKeyword
hi! link Define TaigaKeyword
hi! link Macro TaigaKeyword
hi! link PreCondit TaigaKeyword

hi! clear Type
hi! link StorageClass TaigaSubKeyword
hi! link Structure TaigaKeyword
hi! link Typedef TaigaKeyword

hi! link Special TaigaSpecial
hi! link SpecialChar TaigaSpecial
hi! link Tag TaigaSpecial
hi! link Delimiter TaigaFgLow
hi! link SpecialComment TaigaCommentBold
hi! link Debug TaigaIdentBuiltin

call s:h('Underlined', s:khaki, s:none, ['underline'])

" Ignore

hi! link Error TaigaError

call s:h('Todo', s:pink_high, s:none, ['bold', 'inverse'])
" }}}

" :h highlight-groups {{{
hi! link ColorColumn  TaigaBgHigh
hi! link Conceal      TaigaSpecial
" Cursor
" lCursor
" CursorIM
hi! link CursorColumn CursorLine
call s:h('CursorLine', s:none, s:bg_low2)
hi! link Directory    TaigaKeyword
call s:h('DiffAdd', s:none, s:green_bg)
call s:h('DiffChange', s:none, s:bg_low1)
call s:h('DiffDelete', s:red)
call s:h('DiffText', s:none, s:purple_bg)
" EndOfBuffer
" TermCursor
" TermCursorNC
hi! link ErrorMsg     TaigaRedInverse
hi! link VertSplit    TaigaBoundary
hi! link Folded       TaigaBoundary
hi! link FoldColumn   TaigaSubtle
hi! link SignColumn   TaigaComment
call s:h('IncSearch', s:none, s:none, ['bold', 'underline', 'inverse'])
" Substitute
hi! link LineNr       TaigaFgLow
" LineNrAbove
" LineNrBelow
call s:h('CursorLineNr', s:fg_high, s:bg_low2)
call s:h('MatchParen', s:fg_high, s:blue, ['bold', 'underline'])
" ModeMsg
" MsgArea
" MsgSeparator
hi! link MoreMsg      TaigaKeyword
hi! link NonText      TaigaNonText
call s:h('Normal', s:fg, s:bg)
call s:h('NormalFloat', s:none, s:bg_low2)
" NormalNC
hi! link Pmenu TaigaBoundary
call s:h('PmenuSel', s:fg_high, s:selection)
hi! link PmenuSbar    TaigaBgHigh
hi! link PmenuThumb   PmenuSel
hi! link Question     TaigaKeyword
" QuickFixLine
call s:h('Search', s:tan, s:subtle, ['bold', 'underline'])
" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey TaigaRed
else
  hi! link SpecialKey TaigaNonText
endif
hi! link SpellBad TaigaErrorLine
hi! link SpellCap TaigaWarnLine
hi! link SpellLocal TaigaWarnLine
hi! link SpellRare TaigaInfoLine
call s:h('StatusLine', s:bg, s:fg_low1, ['bold'])
call s:h('StatusLineNC', s:bg_high, s:selection)
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link TabLine PmenuSel
call s:h('TabLineFill', s:none, s:subtle)
hi! link TabLineSel   TaigaKeyword
hi! link Title        TaigaTitle
hi! link Visual       TaigaSelection
hi! link VisualNOS    Visual
call s:h('WarningMsg', s:bg, s:orange)
" Whitespace
call s:h('WildMenu', s:none, s:selection, ['bold'])
" Menu
" Scrollbar
" Tooltip
" }}}

" terminal {{{
if has('nvim')
  let g:terminal_color_0  = s:bg[0]
  let g:terminal_color_1  = s:red[0]
  let g:terminal_color_2  = s:green_low[0]
  let g:terminal_color_3  = s:khaki[0]
  let g:terminal_color_4  = s:blue[0]
  let g:terminal_color_5  = s:pink_high[0]
  let g:terminal_color_6  = s:cyan_high[0]
  let g:terminal_color_7  = s:fg_low3[0]
  let g:terminal_color_8  = s:selection[0]
  let g:terminal_color_9  = s:red[0]
  let g:terminal_color_10 = s:green_high[0]
  let g:terminal_color_11 = s:orange[0]
  let g:terminal_color_12 = s:blue[0]
  let g:terminal_color_13 = s:pink_low[0]
  let g:terminal_color_14 = s:cyan_low[0]
  let g:terminal_color_15 = s:fg[0]
elseif has('terminal')
  let g:terminal_ansi_colors = [s:bg[0], s:red[0], s:green_low[0], s:khaki[0], s:blue[0], s:pink_high[0], s:cyan_high[0], s:fg_low3[0], s:selection[0], s:red[0], s:green_high[0], s:orange[0], s:blue[0], s:pink_low[0], s:cyan_low[0], s:fg_high[0]]
endif
" }}}

" :h lsp-highlight {{{
hi! link LspReferenceText TaigaSelection
hi! link LspReferenceRead TaigaSelection
hi! link LspReferenceWrite TaigaSelection
hi! link LspCodeLens TaigaHint
call s:h('LspCodeLensSeparator', s:hint, s:none, ['bold'])
" }}}

" :h diagnostic-highlights {{{
hi! link DiagnosticError TaigaError
hi! link DiagnosticWarn TaigaWarn
hi! link DiagnosticInfo TaigaInfo
hi! link DiagnosticHint TaigaHint
hi! link DiagnosticUnderlineError TaigaErrorLine
hi! link DiagnosticUnderlineWarn TaigaWarnLine
hi! link DiagnosticUnderlineInfo TaigaInfoLine
hi! link DiagnosticUnderlineHint TaigaHintLine
" }}}

" :h treesitter-highlight-groups {{{
if has('nvim-0.8')
  hi! link @constant.builtin TaigaConstBuiltin
  hi! link @string.regex TaigaSpecial
  hi! link @function.builtin TaigaIdentBuiltin
  hi! link @function.macro TaigaSpecial
  hi! link @constructor NONE
  hi! link @attribute TaigaSpecial
  hi! link @namespace NONE
  hi! link @type.builtin TaigaConstBuiltin
  hi! link @variable.builtin TaigaIdentBuiltin
endif
" }}}

" Plugins: {{{
" vim-fugitive: {{{
hi! link FugitiveblameUncommitted TaigaSubtle
" }}}
" vim-sneak: {{{
call s:h('Sneak', s:bg_high, s:tan, ['bold'])
call s:h('SneakScope', s:bg_high, s:fg_high, ['bold'])
" }}}
" nvim-cmp: {{{
hi! CmpItemAbbrMatch guifg=NONE ctermfg=NONE guibg=NONE ctermbg=NONE gui=bold cterm=bold
hi! link CmpItemKind NONE
" }}}
" }}}

" Filetypes: {{{
" C: {{{
hi! link cConstant TaigaLiteral
" }}}
" Coq: {{{
hi! link coqTerm              Keyword
hi! link coqTactic            TaigaIdentBuiltin
hi! link coqLtac              TaigaIdentBuiltin
hi! link coqTacticKwd         TaigaIdentBuiltin
" }}}
" Diff: {{{
hi! link diffAdded    TaigaGreenHigh
hi! link diffRemoved  TaigaRed
" }}}
" Help: {{{
hi! link helpCommand TaigaLiteral
hi! link helpExample TaigaLiteral
hi! link helpHyperTextEntry TaigaGreenHigh
hi! link helpHyperTextJump Underlined
hi! link helpOption Underlined
" }}}
" Lua: {{{
hi! link luaFunction Keyword
" }}}
" Markdown: {{{
hi! link markdownCode String
hi! link markdownCodeBlock String
hi! link markdownHeadingDelimiter Keyword
" }}}
" Ocaml: {{{
hi! link ocamlModPath NONE
hi! link ocamlFullMod NONE
hi! link ocamlOperator Operator
" }}}
" Python: {{{
hi! link pythonBuiltin TaigaIdentBuiltin
hi! link pythonExceptions NONE
" }}}
" Rust: {{{
hi! link rustCommentLineDoc Comment
hi! link rustMacro TaigaIdentBuiltin
hi! link rustModPath NONE
" }}}
" sh: {{{
hi! link shCommandSub NONE
hi! link shArithmetic NONE
hi! link shShellVariables NONE
hi! link shSpecial NONE
hi! link shSpecialDQ NONE
hi! link shSpecialSQ NONE
" }}}
" Tex: {{{
hi! link texCmd TaigaIdentBuiltin
hi! link texCmdType TaigaIdentBuiltin
hi! link texMathDelim TaigaIdentBuiltin
hi! link texMathZone TaigaLiteral
hi! link texTitleArg Title
hi! link texPartArgTitle Title
" }}}
" Vim: {{{
hi! link vimCommentTitle SpecialComment
hi! link vimAutoEvent TaigaIdentBuiltin
hi! link vimOption TaigaIdentBuiltin
" }}}
" }}}
" vim: fdm=marker sts=2 sw=2 fdl=0 et:
