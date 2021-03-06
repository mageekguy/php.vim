"==============================================================================
" Author: Frédéric Hardy - http://blog.mageekbox.net
" Date: Wed Nov 25 14:22:32 CET 2009
" Licence: BSD
"=============================================================================
" Please report any bugs to php.vim@mageekbox.net
if !exists("b:current_syntax")
  if version < 700
    echomsg 'VIM version >= 7 is required by php.vim syntax file'
  else
    if exists("g:php_highlight_html") && g:php_highlight_html
      runtime! syntax/html.vim
      unlet b:current_syntax
    endif

    if (&filetype != 'php')
      setlocal filetype=php
    endif

    setlocal commentstring-=/*%s*/
    setlocal comments-=s1:/*,mb:*,ex:*/,://,b:#
    setlocal comments+=s1:/*,mb:*,ex:*/,://,b:#

    set foldmethod=syntax

    syntax case ignore

    syntax region phpScript matchgroup=phpDelimiter start="<?php\_s" end="?>" contains=@phpScriptTopLevelElements

    syntax match phpDelimiter "[{;,([\])}]" contained display

    syntax match phpEscapeDollard "\\\$" contained

    if exists("g:php_highlight_html") && g:php_highlight_html
      syntax region phpString matchgroup=phpDelimiter start='"' skip='\\.' end='"' contained contains=@htmlTop,phpEscapeDollard,phpVariable
      syntax region phpString matchgroup=phpDelimiter start="'" skip="\\." end="'" contained contains=@htmlTop
    else
      syntax region phpString matchgroup=phpDelimiter start='"' skip='\\.' end='"' contained contains=phpEscapeDollard,phpVariable
      syntax region phpString matchgroup=phpDelimiter start="'" skip="\\." end="'" contained
    endif

    syntax keyword phpBoolean true false contained

    syntax keyword phpNull null contained

    syntax match phpInteger "\%(0\|[1-9]\d*\)" contained display
    syntax match phpInteger "0x[[:digit:]a-f]\+" contained display
    syntax match phpInteger "0b[01]\+" contained display
    syntax match phpInteger "0[0-7]\+" contained display

    syntax match phpFloat "\d\+\.\d*" contained display
    syntax match phpFloat "\d*\.\d\+" contained display
    syntax match phpFloat "\d\+e[+-]\?\d\+" contained display
    syntax match phpFloat "\d\+\.\d*e[+-]\?\d\+" contained display
    syntax match phpFloat "\d*\.\d\+e[+-]\?\d\+" contained display

    syntax keyword phpOperator and contained
    syntax keyword phpOperator or contained
    syntax keyword phpOperator new contained skipwhite skipempty
    syntax keyword phpOperator instanceof contained
    syntax keyword phpOperator parent self static contained display
    syntax keyword phpOperator as contained display

    syntax match phpOperator "->" contained display
    syntax match phpOperator "[-+*/%]=" contained display
    syntax match phpOperator "[-+*/%^&|.]" contained display
    syntax match phpOperator "&" contained display
    syntax match phpOperator "&&" contained display
    syntax match phpOperator "||" contained display
    syntax match phpOperator "=" contained display
    syntax match phpOperator "===\?" contained display
    syntax match phpOperator "!=\{0,2}" contained display
    syntax match phpOperator "<=\?" contained display
    syntax match phpOperator ">=\?" contained display
    syntax match phpOperator "=>" contained display
    syntax match phpOperator "?" contained display
    syntax match phpOperator ":" contained display
    syntax match phpOperator "::" contained display
    syntax match phpOperator "@" contained display
    syntax match phpOperator "\\" contained display
    syntax match phpOperator "\.\.\." contained display

    syntax region phpAnnotation start="@" end="\*/"me=s-1 end="$" contained containedin=phpComment
    syntax keyword phpTodo todo fixme xxx contained containedin=phpComment
    syntax region phpComment start="/\*" end="\*/" fold contained
    syntax match phpComment "\%(#\|//\).\{-}\%(?>\|$\)\@=" contained

    syntax keyword phpStatement return contained
    syntax keyword phpStatement echo contained
    syntax keyword phpStatement print contained
    syntax keyword phpStatement die contained
    syntax keyword phpStatement exit contained
    syntax keyword phpStatement isset contained
    syntax keyword phpStatement break contained
    syntax keyword phpStatement continue contained

    syntax case match

    syntax region phpNowDoc matchgroup=phpDelimiter start="<<<'\z(\h\w*\)'$" end="^\z1\%(;\=$\)\@=" contained fold

    syntax region phpHereDoc matchgroup=phpDelimiter start="<<<\z(\h\w*\)$" end="^\z1\%(;\=$\)\@=" contained fold contains=@phpVariable,phpProperty

    if exists("php_highlight_html")
       syntax region phpHereDoc matchgroup=phpDelimiter start="<<<\z(\(\I\i*\)\=\(html\)\c\(\i*\)\)$" end="^\z1\%(;\=$\)\@=" contained keepend extend fold contains=@htmlTop,@phpVariables,phpDelimiter,@phpCalls
       syntax region phpHereDoc matchgroup=phpDelimiter start="<<<\z(\(\I\i*\)\=\(javascript\)\c\(\i*\)\)$" end="^\z1\%(;\=$\)\@=" contained keepend extend fold contains=@htmlJavascript,@phpVariables,phpDelimiter,@phpCalls
    else
       syntax region phpHereDoc matchgroup=phpDelimiter start="<<<\z(\(\I\i*\)\=\(html\)\c\(\i*\)\)$" end="^\z1\%(;\=$\)\@=" contained keepend extend fold contains=@phpVariables,phpDelimiter,@phpCalls
       syntax region phpHereDoc matchgroup=phpDelimiter start="<<<\z(\(\I\i*\)\=\(javascript\)\c\(\i*\)\)$" end="^\z1\%(;\=$\)\@=" contained keepend extend fold contains=@phpVariables,phpDelimiter,@phpCalls
    endif

    syntax case ignore

    syntax match phpIdentifier "\h\w*" contained

    syntax match phpVariableSelector  "\$" contained display
    syntax match phpVariable "\$\%(\_s*\$\)*\h\w*" contained contains=phpVariableSelector
    syntax region phpVariable matchgroup=phpVariable start="\$\%(\_s*\$\)*\_s*{" end="}" contained contains=phpVariableSelector

    syntax keyword phpIf if else elseif endif contained

    syntax keyword phpSwitch switch case default endswitch contained

    syntax keyword phpGoto goto contained

    syntax keyword phpRepeat while endwhile for endfor foreach endforeach do contained

    syntax keyword phpDeclare declare enddeclare

    syntax keyword phpInclude include contained
    syntax keyword phpInclude include_once contained
    syntax keyword phpInclude require contained
    syntax keyword phpInclude require_once contained

    syntax region phpNamespaceDefinition start="namespace" matchgroup=phpDelimiter end=";" contained contains=phpNamespaceKeyword,phpNamespaceIdentifier,phpOperator
    syntax region phpNamespaceDefinition start="^\z(\s*\)namespace\(\(\s[^;}]\+\)\?$\)\@="rs=e-10 matchgroup=phpDelimiter end="^\z1}" contained contains=phpNamespaceKeyword,@phpScriptTopLevelElements fold
    syntax region phpNamespaceImporting start="\(^\|\s\+\)use\s\+" matchgroup=phpDelimiter end=";" contained contains=phpComment,phpNamespaceKeyword,phpNamespaceIdentifier,phpOperator,phpDelimiter fold
    syntax match phpNamespaceIdentifier "\h\w*" contained
    syntax keyword phpNamespaceKeyword namespace use as contained

    syntax match phpReturnType ":\h\w*" contained contains=phpOperator,phpIdentifier

    syntax match phpObjectComponent "\$\%(\_s*\$\)*\h\w*\_s*->\_s*\%(\_s*\$\)*\h\w*[^[:space:]()]" contained contains=phpVariable,phpIdentifier,phpOperator

    syntax keyword phpEncapsulation public private protected final contained

    syntax region phpTrait start="^\z(\s*\)trait\s\([^{}]*$\)\@="rs=e-6 matchgroup=phpDelimiter end="^\z1}" contained contains=phpTraitKeywords,phpTraitImporting,phpEncapsulation,phpMethod,@phpScriptElements fold

    syntax region phpTraitImporting start="\(^\|\s\+\)use\s\+" matchgroup=phpDelimiter end=";" contained contains=phpComment,phpTraitKeywords,phpTraitIdentifier,phpOperator,phpDelimiter fold
    syntax match phpTraitIdentifier "\h\w*" contained
    syntax keyword phpTraitKeywords trait use contained

    syntax keyword phpConstantDefinition const contained

    syntax keyword phpFunctionKeyword function yield from contained

    syntax region phpFunction start="^\z(\s*\)function\s\([^}]*$\)\@="rs=e-9 matchgroup=phpDelimiter end="^\z1}" contained contains=phpFunctionKeyword,phpReturnType,@phpScriptElements fold

    syntax region phpAnonymousFunction start="^\z(\s*\)function\s*(" matchgroup=phpDelimiter end="^\z1}" contained contains=phpFunctionKeyword,@phpScriptElements fold

    syntax match phpMethod "\(\s\|^\)\(\(abstract\|final\|private\|protected\|public\|static\)\s\+\)*function\(\s\+.*[;}]\)\@=" contained contains=phpEncapsulation,phpFunctionKeyword,phpMethodKeywords,@phpScriptElements,phpReturnType
    syntax region phpMethod start="^\z(\s*\)\(\(abstract\|final\|private\|protected\|public\|static\)\s\+\)*function\s\([^{};]*$\)\@="rs=e-9 matchgroup=phpDelimiter end="^\z1}" contained contains=phpEncapsulation,phpFunctionKeyword,phpMethodKeywords,phpObjectComponent,@phpScriptElements,phpReturnType fold transparent extend
    syntax keyword phpMethodKeywords abstract static contained

    syntax region phpAnonymousClass start="^\z(\s*\)new class" matchgroup=phpDelimiter end="^\z1}" contained contains=phpAnonymousClassKeywords,phpEncapsulation,phpTraitImporting,phpMethod,@phpScriptElements fold transparent
    syntax keyword phpAnonymousClassKeywords class extends implements contained

    syntax region phpClass start="^\z(\s*\)\(\(abstract\|final\)\s\+\)*class\s\([^{}]*$\)\@="rs=e-6 matchgroup=phpDelimiter end="^\z1}" contained contains=phpClassKeywords,phpTraitImporting,phpEncapsulation,phpMethod,@phpScriptElements fold
    syntax keyword phpClassKeywords abstract class extends implements contained

    syntax region phpInterface start="^\z(\s*\)\(final\s\+\)*interface\s\([^{}]*$\)\@="rs=e-10 matchgroup=phpDelimiter end="^\z1}" contained contains=phpInterfaceKeywords,phpEncapsulation,phpMethod,@phpScriptElements fold
    syntax keyword phpInterfaceKeywords interface extends implements contained

    syntax region phpExceptionTry start="^\z(\s*\)try\([^{}]*$\)\@="rs=e-3 matchgroup=phpDelimiter  end="^\z1}" contained contains=phpTryKeyword,@phpScriptElements fold
    syntax keyword phpTryKeyword try contained

    syntax region phpExceptionCatch start="^\z(\s*\)catch\([^}]*$\)\@="rs=e-5 matchgroup=phpDelimiter  end="^\z1}" contained contains=phpCatchKeyword,@phpScriptElements fold
    syntax keyword phpCatchKeyword catch contained

    syntax region phpExceptionFinally start="^\z(\s*\)finally\([^}]*$\)\@="rs=e-7 matchgroup=phpDelimiter  end="^\z1}" contained contains=phpFinallyKeyword,@phpScriptElements fold
    syntax keyword phpFinallyKeyword finally contained

    syntax keyword phpThrowKeyword throw contained

    syntax cluster phpScriptElements contains=phpComment,phpVariable,phpString,phpBoolean,phpNull,phpInteger,phpFloat,phpIdentifier,phpIf,phpRepeat,php,phpDelimiter,phpConstantDefinition,phpOperator,phpInclude,phpStatement,phpNowDoc,phpHereDoc,phpTryKeyword,phpCatchKeyword,phpExceptionTry,phpExceptionCatch,phpExceptionFinally,phpThrowKeyword,phpSwitch,phpDeclare,phpGoto,phpAnonymousFunction,phpAnonymousClass

    syntax cluster phpScriptTopLevelElements contains=phpNamespaceDefinition,phpNamespaceImporting,phpFunction,phpClass,phpTrait,phpInterface,@phpScriptElements

    highlight default link phpDelimiter Delimiter
    highlight default link phpTodo Todo
    highlight default link phpAnnotation PreProc
    highlight default link phpComment Comment
    highlight default link phpVariableSelector Identifier
    highlight default link phpVariable Identifier
    highlight default link phpString String
    highlight default link phpEscapeDollard phpString
    highlight default link phpBoolean Boolean
    highlight default link phpNull Special
    highlight default link phpInteger Number
    highlight default link phpFloat Float
    highlight default link phpIdentifier Tag
    highlight default link phpIf Conditional
    highlight default link phpSwitch Conditional
    highlight default link phpRepeat Repeat
    highlight default link phpGoto Label
    highlight default link phpDeclare Macro
    highlight default link phpEncapsulation TypeDef
    highlight default link phpFunctionKeyword TypeDef
    highlight default link phpConstantDefinition TypeDef
    highlight default link phpClassKeywords StorageClass
    highlight default link phpAnonymousClassKeywords StorageClass
    highlight default link phpInterfaceKeywords StorageClass
    highlight default link phpMethodKeywords StorageClass
    highlight default link phpNamespaceKeyword TypeDef
    highlight default link phpNamespaceIdentifier Tag
    highlight default link phpTraitKeywords TypeDef
    highlight default link phpTraitIdentifier Tag
    highlight default link phpOperator Operator
    highlight default link phpInclude Include
    highlight default link phpStatement Statement
    highlight default link phpNowDoc String
    highlight default link phpHereDoc String
    highlight default link phpTryKeyword Exception
    highlight default link phpCatchKeyword Exception
    highlight default link phpThrowKeyword Exception
    highlight default link phpFinallyKeyword Exception

    syntax sync clear
    syntax sync fromstart

    let b:current_syntax = "php"
  endif
endif

finish
" vim: ts=8 sts=2 sw=2 expandtab
