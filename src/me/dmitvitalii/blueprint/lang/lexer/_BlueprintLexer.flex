package me.dmitvitalii.blueprint.lang.lexer;

import com.intellij.lexer.FlexLexer;
import com.intellij.psi.tree.IElementType;

import static com.intellij.psi.TokenType.BAD_CHARACTER;
import static com.intellij.psi.TokenType.WHITE_SPACE;
import static me.dmitvitalii.blueprint.lang.psi.BlueprintType.*;

%%

%{
  public BlueprintLexer() {
    this((java.io.Reader)null);
  }
%}

%public
%class BlueprintLexer
%implements FlexLexer
%function advance
%type IElementType
%unicode
%eof{  return;
%eof}

EOL=\R
WHITE_SPACE=[ \t\f]

LINE_COMMENT="//".*
MULTILINE_COMMENT="/"\*([^*]|\*+[^*/])*(\*+"/")?
STRING=\"([^\\\"\r\n]|\\[^\r\n])*\"?
NUMBER=-?(0|[1-9][0-9]*)(\.[0-9]+)?([eE][+-]?[0-9]*)?

%state MAYBE_SEMICOLON

%%

<YYINITIAL> {
  {WHITE_SPACE}            { return WHITE_SPACE; }

  "{"                      { return LEFT_BRACE; }
  "}"                      { return RIGHT_BRACE; }
  "["                      { return LEFT_BRACK; }
  "]"                      { return RIGHT_BRACK; }
  "("                      { return LEFT_PAREN; }
  ")"                      { return RIGHT_PAREN; }
  ","                      { return COMMA; }
  "="                      { return ASSIGN; }
  "!"                      { return NOT; }
  "+="                     { return PLUS_ASSIGN; }
  "+"                      { return PLUS; }
  "-="                     { return MINUS_ASSIGN; }
  "-"                      { return MINUS; }
  "<NL>"                   { return SEMICOLON_SYNTHETIC; }
  "true"                   { return TRUE; }
  "false"                  { return FALSE; }
  "COMMENT"                { return COMMENT; }
  "CRLF"                   { return CRLF; }
  "KEY"                    { return KEY; }
  "SEPARATOR"              { return SEPARATOR; }
  "VALUE"                  { return VALUE; }

  {LINE_COMMENT}           { return LINE_COMMENT; }
  {MULTILINE_COMMENT}      { return MULTILINE_COMMENT; }
  {STRING}                 { return STRING; }
  {NUMBER}                 { return NUMBER; }

}

<MAYBE_SEMICOLON> {
{WHITE_SPACE}               { return WHITE_SPACE; }
{EOL}                       { yybegin(YYINITIAL); yypushback(yytext().length()); return SEMICOLON_SYNTHETIC; }
{LINE_COMMENT}              { return LINE_COMMENT; }
{MULTILINE_COMMENT}         { return MULTILINE_COMMENT; }
.                           { yybegin(YYINITIAL); yypushback(yytext().length()); }
}

[^] { return BAD_CHARACTER; }
