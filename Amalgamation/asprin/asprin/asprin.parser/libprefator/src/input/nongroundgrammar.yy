// {{{ GPL License 

// This file is part of prefator - a translator for preference programs.
// Copyright (C) 2013  Tobias Jaeuthe

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// }}}

%require "2.5"
%define api.namespace {Prefator::Input::NonGroundGrammar}
//%define namespace "Prefator::Input::NonGroundGrammar"
%define api.prefix {PrefatorNonGroundGrammar_}
//%name-prefix "NonGroundGrammar_"
%define parse.error verbose
//%error-verbose
%define api.location.type {DefaultLocation}
//%define location_type "DefaultLocation"
%locations
%defines
%parse-param { Prefator::Input::NonGroundParser *lexer }
%lex-param { Prefator::Input::NonGroundParser *lexer }
%skeleton "lalr1.cc"
//%define parse.trace
//%debug

// {{{ auxiliary code

%code requires
{
    #include "prefator/input/programbuilder.hh"


    namespace Prefator { namespace Input { class NonGroundParser; } }
    


    struct DefaultLocation : Gringo::Location {
        DefaultLocation() : Location("<undef>", 0, 0, "<undef>", 0, 0) { }
    };




	

}

%{

#include "prefator/input/nongroundparser.hh"
#include "prefator/input/programbuilder.hh"
#include <iostream>
#include <climits> 

#define BUILDER (lexer->builder())
#define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do {                                                               \
        if (N) {                                                       \
            (Current).beginFilename = YYRHSLOC (Rhs, 1).beginFilename; \
            (Current).beginLine     = YYRHSLOC (Rhs, 1).beginLine;     \
            (Current).beginColumn   = YYRHSLOC (Rhs, 1).beginColumn;   \
            (Current).endFilename   = YYRHSLOC (Rhs, N).endFilename;   \
            (Current).endLine       = YYRHSLOC (Rhs, N).endLine;       \
            (Current).endColumn     = YYRHSLOC (Rhs, N).endColumn;     \
        }                                                              \
        else {                                                         \
            (Current).beginFilename = YYRHSLOC (Rhs, 0).endFilename; \
            (Current).beginLine     = YYRHSLOC (Rhs, 0).endLine;     \
            (Current).beginColumn   = YYRHSLOC (Rhs, 0).endColumn;   \
            (Current).endFilename   = YYRHSLOC (Rhs, 0).endFilename;   \
            (Current).endLine       = YYRHSLOC (Rhs, 0).endLine;       \
            (Current).endColumn     = YYRHSLOC (Rhs, 0).endColumn;     \
        }                                                              \
    }                                                                  \
    while (false)

using namespace Prefator::Input;

int PrefatorNonGroundGrammar_lex(void *value, Gringo::Location* loc, NonGroundParser *lexer) {
    return lexer->lex(value, *loc);
}

%}

%code {

void NonGroundGrammar::parser::error(DefaultLocation const &l, std::string const &msg) {
    lexer->parseError(l, msg);
}

}


// }}}
// {{{ nonterminals
// {{{ union type for stack elements
%union
{
	IdVecUid idlist;
	CSPLitUid csplit;
    CSPAddTermUid cspaddterm;
    CSPMulTermUid cspmulterm;
    TermUid term;
    TermVecUid termvec;
    TermVecVecUid termvecvec;
    LitVecUid litvec;
    LitUid lit;
    Relation rel;
	PrefIdentUid prefident;
	PrefVarUid prefvar;
	PrefElemUid prefelem;
	PrefElemVecUid prefelemvec;
	LitKeyUid litkey;
	LitKeyVecUid litkeyvec;

    struct {
        unsigned first;
        unsigned second;
    } pair;
	struct {
		TermUid first;
		PrefVarUid second;
	} ptvarpair;
	struct {
		TermVecUid first;
		PrefVarUid second;
	} ptvvarpair;
	struct {
		TermVecVecUid first;
		PrefVarUid second;
	} ptvvvarpair;
	struct {
		unsigned id;
		unsigned terms;
		PrefVarUid vars;
	} pavarpair;
	
    unsigned uid;
    int num;
}

// }}}

// TODO: improve naming scheme
%type <term>            term
%type <termvec>         termvec ntermvec unaryargvec weights
%type <termvecvec>      argvec
%type <lit>             literal
%type <uid>             identifier
%type <pair>            atom
%type <rel>             cmp csp_rel
%type <cspmulterm>      csp_mul_term
%type <cspaddterm>      csp_add_term
%type <csplit>          csp_literal
%type <prefident>		prefident
%type <prefelem> 		prefelem
%type <prefelemvec> 	prefcontent
%type <idlist>          idlist nidlist
%type <ptvarpair> 		pvarterm pterm pwterm
%type <pavarpair>		pvaratom
%type <ptvvarpair>		pvartermvec pvarntermvec pvarunaryargvec pwtermset pcond
%type <ptvvvarpair>     pvarargvec phead
%type <litkey>			oliteral ohead
%type <litkeyvec> 		obodycomma obodydot oconjunction oaltbodyaggrelem olitvec onlitvec ooptcondition olubodyaggregate oaltbodyaggrelemvec obodyaggrelemvec obodyaggrelem obodyaggregate

// }}}
// {{{ terminals

%token
    ADD         "+"
    AND         "&"
    ASSIGN      "="
    AT          "@"
    BASE        "#base"
    BNOT        "~"
    COLON       ":"
    COMMA       ","
    CONST       "#const"
    COUNT       "#count"
    CSP         "$"
    CSP_ADD     "$+"
    CSP_SUB     "$-"
    CSP_MUL     "$*"
    CSP_LEQ     "$<="
    CSP_LT      "$<"
    CSP_GT      "$>"
    CSP_GEQ     "$>="
    CSP_EQ      "$="
    CSP_NEQ     "$!="
    CUMULATIVE  "#cumulative"
    DISJOINT    "#disjoint"
    DOT         "."
    DOTS        ".."
    EQ          "=="
    END         0 "<EOF>"
    EXTERNAL    "#external"
    FALSE       "#false"
    FORGET      "#forget"
    GEQ         ">="
    GT          ">"
    IF          ":-"
    INCLUDE     "#include"
    INFIMUM     "#inf"
    LBRACE      "{"
    LBRACK      "["
    LEQ         "<="
    LPAREN      "("
    LT          "<"
    MAX         "#max"
    MAXIMIZE    "#maximize"
    MIN         "#min"
    MINIMIZE    "#minimize"
    MOD         "\\"
    MUL         "*"
    NEQ         "!="
    POW         "**"
    QUESTION    "?"
    RBRACE      "}"
    RBRACK      "]"
    RPAREN      ")"
    SEM         ";"
    SHOW        "#show"
    SHOWSIG     "#showsig"
    SLASH       "/"
    SUB         "-"
    SUM         "#sum"
    SUMP        "#sum+"
    SUPREMUM    "#sup"
    TRUE        "#true"
    UBNOT
    UMINUS
    VBAR        "|"
    VOLATILE    "#volatile"
    WIF         ":~"
    XOR         "^"
    PARSE_LP    "<program>"
    PARSE_DEF   "<define>"
	OBLOCK		"preference"
	PBLOCK		"#program"
	PREF_BLOCK	"#preference"
	OPT			"#optimize"
	DVBAR  		"||"
	ERROR		"error"

%token <num>
    NUMBER     "<NUMBER>"

%token <uid>
    ANONYMOUS  			"<ANONYMOUS>"
    IDENTIFIER 			"<IDENTIFIER>"
    PYTHON     			"<PYTHON>"
    LUA        			"<LUA>"
    STRING     			"<STRING>"
    VARIABLE   			"<VARIABLE>"
    NOT        			"not"

// {{{ operator precedence and associativity

%left DOTS
%left XOR
%left QUESTION
%left AND
%left ADD SUB
%left MUL SLASH MOD
%right POW
%left UMINUS UBNOT

// }}}
// }}}

%%
// {{{ logic program and global definitions

start
    : PARSE_LP  blocksstart
    | PARSE_DEF define
    ;

blocksstart
	: program				
    | program blocks
    | blocks
    | 
    ;

blocks
    : blocks pblock program
    | blocks oblock oprogram
    | pblock program
	| oblock oprogram
    ;

pblock
	: PBLOCK DOT	{ lexer->stDot(); } 
	;

oblock
	: OBLOCK DOT   	{ lexer->stDot(); }
	;

program
    : program statement 
    | 
    ;

statement
	: ERROR { YYABORT; }
	;

identifier
    : IDENTIFIER[a] { $$ = $a; }
    ;


// }}}
// {{{ terms
// {{{ constterms are terms without variables and pooling operators

constterm
    : constterm[a] XOR constterm[b]                       
    | constterm[a] QUESTION constterm[b]                  
    | constterm[a] AND constterm[b]                       
    | constterm[a] ADD constterm[b]                       
    | constterm[a] SUB constterm[b]                       
    | constterm[a] MUL constterm[b]                       
    | constterm[a] SLASH constterm[b]                     
    | constterm[a] MOD constterm[b]                       
    | constterm[a] POW constterm[b]                       
    | SUB[l] constterm[a] %prec UMINUS                   
    | BNOT[l] constterm[a] %prec UBNOT                  
    | LPAREN[l] constargvec[a] RPAREN[r]               
    | identifier[a] LPAREN constargvec[b] RPAREN[r]   
    | AT[l] identifier[a] LPAREN constargvec[b] RPAREN[r] 
    | VBAR[l] constterm[a] VBAR[r]                       
    | identifier[a]                                     
    | NUMBER[a]                                        
    | STRING[a]                                       
    | INFIMUM[a]                                     
    | SUPREMUM[a]                                   
    ;

// {{{ arguments lists for functions in constant terms

consttermvec
    : constterm[a]                       
    | consttermvec[a] COMMA constterm[b] 
    ;

constargvec
    : consttermvec[a] 
    |                
    ;

// }}}
// }}}
// {{{ terms including variables

term
    : term[a] DOTS term[b]                           { $$ = BUILDER.term($a, $b); }
    | term[a] XOR term[b]                            { $$ = BUILDER.term(BinOp::XOR, $a, $b); }
    | term[a] QUESTION term[b]                       { $$ = BUILDER.term(BinOp::OR, $a, $b); }
    | term[a] AND term[b]                            { $$ = BUILDER.term(BinOp::AND, $a, $b); }
    | term[a] ADD term[b]                            { $$ = BUILDER.term(BinOp::ADD, $a, $b); }
    | term[a] SUB term[b]                            { $$ = BUILDER.term(BinOp::SUB, $a, $b); }
    | term[a] MUL term[b]                            { $$ = BUILDER.term(BinOp::MUL, $a, $b); }
    | term[a] SLASH term[b]                          { $$ = BUILDER.term(BinOp::DIV, $a, $b); }
    | term[a] MOD term[b]                            { $$ = BUILDER.term(BinOp::MOD, $a, $b); }
    | term[a] POW term[b]                            { $$ = BUILDER.term(BinOp::POW, $a, $b); }
    | SUB[l] term[a] %prec UMINUS                    { $$ = BUILDER.term(UnOp::NEG, $a); }
    | BNOT[l] term[a] %prec UBNOT                    { $$ = BUILDER.term(UnOp::NOT, $a); }
    | LPAREN[l] argvec[a] RPAREN[r]                  { $$ = BUILDER.term(FWString(""), $a, false); }
    | identifier[a] LPAREN argvec[b] RPAREN[r]       { $$ = BUILDER.term($a, $b, false); }
    | AT[l] identifier[a] LPAREN argvec[b] RPAREN[r] { $$ = BUILDER.term($a, $b, true); }
    | VBAR[l] unaryargvec[a] VBAR[r]                 { $$ = BUILDER.term(UnOp::ABS, $a); }
    | identifier[a]                                  { $$ = BUILDER.term(Value(FWString($a))); }
    | NUMBER[a]                                      { $$ = BUILDER.term(Value($a)); }
    | STRING[a]                                      { $$ = BUILDER.term(Value(FWString($a), false)); }
    | INFIMUM[a]                                     { $$ = BUILDER.term(Value(true)); }
    | SUPREMUM[a]                                    { $$ = BUILDER.term(Value(false)); }
    | VARIABLE[a]                                    { $$ = BUILDER.term(FWString($a)); }
    | ANONYMOUS[a]                                   { $$ = BUILDER.term(FWString("_")); }
    ;

// {{{ argument lists for unary operations

unaryargvec
    : term[a]                    { $$ = BUILDER.termvec(BUILDER.termvec(), $a); }
    | unaryargvec[a] SEM term[b] { $$ = BUILDER.termvec($a, $b); }
    ;

// }}}
// {{{ argument lists for functions

ntermvec
    : term[a]                   { $$ = BUILDER.termvec(BUILDER.termvec(), $a); }
    | ntermvec[a] COMMA term[b] { $$ = BUILDER.termvec($a, $b); }
    ;

termvec
    : ntermvec[a] { $$ = $a; }
    |             { $$ = BUILDER.termvec(); }
    ;

argvec
    : termvec[a]               { $$ = BUILDER.termvecvec(BUILDER.termvecvec(), $a); }
    | argvec[a] SEM termvec[b] { $$ = BUILDER.termvecvec($a, $b); }
    ;

// }}}
// }}}
// }}}
// {{{ literals

cmp
    : GT     { $$ = Relation::GT; }
    | LT     { $$ = Relation::LT; }
    | GEQ    { $$ = Relation::GEQ; }
    | LEQ    { $$ = Relation::LEQ; }
    | EQ     { $$ = Relation::EQ; }
    | NEQ    { $$ = Relation::NEQ; }
    | ASSIGN { $$ = Relation::ASSIGN; }
    ;

atom
    : identifier[id]                                  { $$ = { $id, BUILDER.termvecvec(BUILDER.termvecvec(), BUILDER.termvec()) << 1u }; }
    | identifier[id] LPAREN argvec[tvv] RPAREN[r]     { $$ = { $id, $tvv << 1u }; }
    | SUB identifier[id]                              { $$ = { $id, BUILDER.termvecvec(BUILDER.termvecvec(), BUILDER.termvec()) << 1u | 1u }; }
    | SUB identifier[id] LPAREN argvec[tvv] RPAREN[r] { $$ = { $id, $tvv << 1u | 1u }; }
    ;

literal
    : TRUE[a]                  { $$ = BUILDER.boollit(true); }
    | FALSE[a]                 { $$ = BUILDER.boollit(false); }
    | atom[a]                  { $$ = BUILDER.predlit(NAF::POS, $a.second & 1, FWString($a.first), TermVecVecUid($a.second >> 1u)); }
    | NOT[l] atom[a]           { $$ = BUILDER.predlit(NAF::NOT, $a.second & 1, FWString($a.first), TermVecVecUid($a.second >> 1u)); }
    | NOT[l] NOT atom[a]       { $$ = BUILDER.predlit(NAF::NOTNOT, $a.second & 1, FWString($a.first), TermVecVecUid($a.second >> 1u)); }
    | term[l] cmp[rel] term[r] { $$ = BUILDER.rellit($rel, $l, $r); }
	| csp_literal[lit]         { $$ = BUILDER.csplit($lit); }
    ;

csp_mul_term
	: CSP term[var] CSP_MUL term[coe] { $$ = BUILDER.cspmulterm($coe,                     $var); }
	| term[coe] CSP_MUL CSP term[var] { $$ = BUILDER.cspmulterm($coe,                     $var); }
	| CSP term[var]                   { $$ = BUILDER.cspmulterm( BUILDER.term(Value(1)), $var); }
	| term[coe]                       { $$ = BUILDER.cspmulterm($coe); }
	;

csp_add_term
	: csp_add_term[add] CSP_ADD csp_mul_term[mul] { $$ = BUILDER.cspaddterm($add, $mul, true); }
	| csp_add_term[add] CSP_SUB csp_mul_term[mul] { $$ = BUILDER.cspaddterm($add, $mul, false); }
	| csp_mul_term[mul]                           { $$ = BUILDER.cspaddterm($mul); }
	;

csp_rel
    : CSP_GT  { $$ = Relation::GT; }
    | CSP_LT  { $$ = Relation::LT; }
    | CSP_GEQ { $$ = Relation::GEQ; }
    | CSP_LEQ { $$ = Relation::LEQ; }
    | CSP_EQ  { $$ = Relation::EQ; }
    | CSP_NEQ { $$ = Relation::NEQ; }
	;

csp_literal 
	: csp_literal[lit] csp_rel[rel] csp_add_term[b] { $$ = BUILDER.csplit($lit, $rel, $b); }
	| csp_add_term[a]  csp_rel[rel] csp_add_term[b] { $$ = BUILDER.csplit($a,   $rel, $b); }
	;

// }}}
// {{{ aggregates
// {{{ auxiliary rules

nlitvec
    : literal[lit]                    
    | nlitvec[vec] COMMA literal[lit]
    ;

litvec
    : nlitvec[vec] 
    |             
    ;

optcondition
    : COLON litvec[vec] 
    |                   
    ;

noptcondition
    : COLON nlitvec[vec] 
    |                   
    ;

aggregatefunction
    : SUM   
    | SUMP  
    | MIN   
    | MAX   
    | COUNT 
    ;

// }}}
// {{{ body aggregates
// {{{ body aggregate elements

bodyaggrelem
    : COLON litvec[cond]               
    | ntermvec[args] optcondition[cond]
    ;

bodyaggrelemvec
    : bodyaggrelem[elem]                         
    | bodyaggrelemvec[vec] SEM bodyaggrelem[elem] 
    ;

// Note: alternative syntax (without weight)

altbodyaggrelem
    : literal[lit] optcondition[cond] 
    ;

altbodyaggrelemvec
    : altbodyaggrelem[elem]                             
    | altbodyaggrelemvec[vec] SEM altbodyaggrelem[elem] 
    ;

// }}}

bodyaggregate
    : LBRACE RBRACE                                              
    | LBRACE altbodyaggrelemvec[elems] RBRACE                    
    | aggregatefunction[fun] LBRACE RBRACE                        
    | aggregatefunction[fun] LBRACE bodyaggrelemvec[elems] RBRACE 
    ;

upper
    : term[t]          
    | cmp[rel] term[t]
    |                  
    ;

lubodyaggregate
    : term[l]          bodyaggregate[a] upper[u]
    | term[l] cmp[rel] bodyaggregate[a] upper[u] 
    |                  bodyaggregate[a] upper[u] 
    ;

// }}}
// {{{ head aggregates
// {{{ head aggregate elements

headaggrelemvec
    : headaggrelemvec[vec] SEM termvec[tuple] COLON literal[head] optcondition[cond] 
    | termvec[tuple] COLON literal[head] optcondition[cond]                          
    ;

altheadaggrelemvec
    : literal[lit] optcondition[cond]                             { BUILDER.holds($lit); }
    | altheadaggrelemvec[vec] SEM literal[lit] optcondition[cond] { BUILDER.holds($lit); }
    ;

/// }}}

headaggregate
    : aggregatefunction[fun] LBRACE RBRACE                        
    | aggregatefunction[fun] LBRACE headaggrelemvec[elems] RBRACE 
    | LBRACE RBRACE                                               
    | LBRACE altheadaggrelemvec[elems] RBRACE                     
    ;

luheadaggregate
    : term[l]          headaggregate[a] upper[u] 
    | term[l] cmp[rel] headaggregate[a] upper[u] 
    |                  headaggregate[a] upper[u] 
    ;

// }}}
// {{{ disjoint aggregate

ncspelemvec
    :                     termvec[tuple] COLON csp_add_term[add] optcondition[cond]
    | cspelemvec[vec] SEM termvec[tuple] COLON csp_add_term[add] optcondition[cond] 
    ;

cspelemvec
    : ncspelemvec[vec]
    |                  
    ;

disjoint
    :         DISJOINT LBRACE cspelemvec[elems] RBRACE
    | NOT     DISJOINT LBRACE cspelemvec[elems] RBRACE
    | NOT NOT DISJOINT LBRACE cspelemvec[elems] RBRACE
    ;

///}}}
// {{{ conjunctions

conjunction
    : literal[lit] COLON litvec[cond] 
    ;

// }}}
// {{{ disjunctions

dsym
    : SEM
    | VBAR
    ;

disjunctionsep
    : disjunctionsep[vec] literal[lit] COMMA                    
    | disjunctionsep[vec] literal[lit] noptcondition[cond] dsym 
    |                                                           
    ;

// Note: for simplicity appending first condlit here
disjunction
    : literal[lit] COMMA  disjunctionsep[vec] literal[clit] noptcondition[ccond]                    
    | literal[lit] dsym    disjunctionsep[vec] literal[clit] noptcondition[ccond]                   
    | literal[lit]  COLON nlitvec[cond] dsym disjunctionsep[vec] literal[clit] noptcondition[ccond] 
    | literal[clit] COLON nlitvec[ccond]                                                            
    ;

// }}}
// }}}
// {{{ statements
// {{{ rules

bodycomma
    : bodycomma[body] literal[lit] COMMA                     
    | bodycomma[body] literal[lit] SEM                        
    | bodycomma[body] lubodyaggregate[aggr] COMMA            
    | bodycomma[body] lubodyaggregate[aggr] SEM              
    | bodycomma[body] NOT[l] lubodyaggregate[aggr] COMMA      
    | bodycomma[body] NOT[l] lubodyaggregate[aggr] SEM        
    | bodycomma[body] NOT[l] NOT lubodyaggregate[aggr] COMMA  
    | bodycomma[body] NOT[l] NOT lubodyaggregate[aggr] SEM   
    | bodycomma[body] conjunction[conj] SEM                  
    | bodycomma[body] disjoint[cons] SEM                   
    |                                                        
    ;

bodydot
    : bodycomma[body] literal[lit] DOT 
    | bodycomma[body] lubodyaggregate[aggr] DOT 
    | bodycomma[body] NOT[l] lubodyaggregate[aggr] DOT
    | bodycomma[body] NOT[l] NOT lubodyaggregate[aggr] DOT
    | bodycomma[body] conjunction[conj] DOT 
    | bodycomma[body] disjoint[cons] DOT                
    ;

head
    : literal[lit]            { BUILDER.holds($lit); }
    | disjunction[elems]      
    | luheadaggregate[aggr]   
    ;

statement
    : head[hd] DOT
    | head[hd] IF bodydot[bd] 
    | IF bodydot[bd]          
    | IF DOT                  
    ;

// }}}
// {{{ CSP

statement
	: disjoint[hd] IF bodydot[body] 
	| disjoint[hd] IF DOT
	| disjoint[hd] DOT
	;

// }}}
// {{{ visibility

statement
    : SHOWSIG IDENTIFIER[id] SLASH NUMBER[num] DOT
    | SHOWSIG SUB IDENTIFIER[id] SLASH NUMBER[num] DOT
    | SHOW DOT                                         
    | SHOW term[t] COLON bodydot[bd]                   
    | SHOW term[t] DOT                                 
    | SHOWSIG CSP IDENTIFIER[id] SLASH NUMBER[num] DOT 
    | SHOW CSP term[t] COLON bodydot[bd]               
    | SHOW CSP term[t] DOT                             
    ;

ostatement
    : SHOWSIG IDENTIFIER[id] SLASH NUMBER[num] DOT
    | SHOWSIG SUB IDENTIFIER[id] SLASH NUMBER[num] DOT
    | SHOW DOT                                         
    | SHOW term[t] COLON bodydot[bd]                   
    | SHOW term[t] DOT                                 
    | SHOWSIG CSP IDENTIFIER[id] SLASH NUMBER[num] DOT 
    | SHOW CSP term[t] COLON bodydot[bd]               
    | SHOW CSP term[t] DOT                             
    ;
// }}}
// {{{ constants

define
    : identifier[uid] ASSIGN constterm[rhs]
    ;

statement 
    : CONST identifier[uid] ASSIGN constterm[rhs] DOT
    ;

// }}}
// {{{ scripts

statement
    : PYTHON[code] DOT
    | LUA[code]    DOT 
    ;

// }}}
// {{{ include

statement
    : INCLUDE    STRING[file]        DOT { lexer->include($file, @$, false); }
    | INCLUDE LT IDENTIFIER[file] GT DOT { lexer->include($file, @$, true); }
    ;

// }}}
// {{{ blocks

nidlist 
    : nidlist[list] COMMA IDENTIFIER[id] { $$ = BUILDER.idvec($list, $id); }
    | IDENTIFIER[id]                     { $$ = BUILDER.idvec(BUILDER.idvec(), $id); }
    ;

idlist 
    :               { $$ = BUILDER.idvec(); }
    | nidlist[list] { $$ = $list; }
    ;


// }}}
// {{{ external

statement
    : EXTERNAL atom[hd] COLON bodydot[bd]
    | EXTERNAL atom[hd] COLON DOT         
    | EXTERNAL atom[hd] DOT               
    ;

// }}}
// }}}


// {{{ preferences
// {{{ logic program P

statement
	: OPT LPAREN IDENTIFIER[ident] RPAREN DOT 	{ BUILDER.prefmain($ident, true); lexer->stDot(); }
	;

// }}}
// {{{ preference program O
oprogram
	: ostatement oprogram 
	|
	;

ostatement
    : ohead[hd] DOT            		       		{ BUILDER.litkeys($hd, BUILDER.litkeyvec()); BUILDER.setStatementType(StType::OFACT); lexer->stDot(); }
	| ohead[hd] IF obodydot[bd] 				{ BUILDER.litkeys($hd, $bd); BUILDER.setStatementType(StType::ORULE); lexer->stDot(); }
	| IF obodydot[bd]							{ BUILDER.setStatementType(StType::OCONSTRAINT); lexer->stDot(); }
	| OPT LPAREN IDENTIFIER[ident] RPAREN DOT 	{ BUILDER.prefmain($ident, false); lexer->stDot(); }
	;

// {{{ rules
obodycomma
    : obodycomma[body] oliteral[lit] COMMA                      { $$ = BUILDER.litkeyvec($body, $lit); }
	| obodycomma[body] oliteral[lit] SEM                        { $$ = BUILDER.litkeyvec($body, $lit); }
	| obodycomma[body] olubodyaggregate[aggr] COMMA             { $$ = BUILDER.litkeyvec($body, $aggr); }
	| obodycomma[body] olubodyaggregate[aggr] SEM               { $$ = BUILDER.litkeyvec($body, $aggr); }
    | obodycomma[body] NOT[l] olubodyaggregate[aggr] COMMA      { $$ = BUILDER.litkeyvec($body, $aggr); }
    | obodycomma[body] NOT[l] olubodyaggregate[aggr] SEM        { $$ = BUILDER.litkeyvec($body, $aggr); }
    | obodycomma[body] NOT[l] NOT olubodyaggregate[aggr] COMMA  { $$ = BUILDER.litkeyvec($body, $aggr); }
    | obodycomma[body] NOT[l] NOT olubodyaggregate[aggr] SEM    { $$ = BUILDER.litkeyvec($body, $aggr); }
    | obodycomma[body] oconjunction[conj] SEM                   { $$ = BUILDER.litkeyvec($body, $conj); }
	|															{ $$ = BUILDER.litkeyvec(); }
	;

obodydot
    : obodycomma[body] oliteral[lit] DOT                      { $$ = BUILDER.litkeyvec($body, $lit); }
	| obodycomma[body] olubodyaggregate[aggr] DOT             { $$ = BUILDER.litkeyvec($body, $aggr); }
    | obodycomma[body] NOT[l] olubodyaggregate[aggr] DOT      { $$ = BUILDER.litkeyvec($body, $aggr); }
    | obodycomma[body] NOT[l] NOT olubodyaggregate[aggr] DOT  { $$ = BUILDER.litkeyvec($body, $aggr); }
    | obodycomma[body] oconjunction[conj] DOT                 { $$ = BUILDER.litkeyvec($body, $conj); }
    ;


ohead
    : oliteral[lit]            { $$ = $lit; }
	;

// TODO : disjunction and luheadaggregate, do we need them?
//
//    | disjunction[elems]      { $$ = BUILDER.disjunction($elems); }
//    | luheadaggregate[aggr]   { $$ = lexer->headaggregate($aggr); }
//    ;
//


// }}}
// {{{ literals
oliteral
    : TRUE[a]                  { $$ = BUILDER.litkey(); }
    | FALSE[a]          	   { $$ = BUILDER.litkey(); }      
    | atom[a]                  { $$ = BUILDER.litkey(FWString($a.first),TermVecVecUid($a.second >> 1u)); BUILDER.prefolit(FWString($a.first),TermVecVecUid($a.second >> 1u));lexer->deleteLit(); }
    | NOT[l] atom[a]           { $$ = BUILDER.litkey(FWString($a.first),TermVecVecUid($a.second >> 1u)); BUILDER.prefolit(FWString($a.first),TermVecVecUid($a.second >> 1u)); lexer->deleteLit(); }
    | NOT[l] NOT atom[a]       { $$ = BUILDER.litkey(FWString($a.first),TermVecVecUid($a.second >> 1u)); BUILDER.prefolit(FWString($a.first),TermVecVecUid($a.second >> 1u)); lexer->deleteLit(); }
    | term[l] cmp[rel] term[r] { $$ = BUILDER.litkey(); } 
    ;
// }}}
// {{{ aggregates
// {{{ auxiliary rules
onlitvec
    : oliteral[lit]                    { $$ = BUILDER.litkeyvec(BUILDER.litkeyvec(), $lit); }
    | onlitvec[vec] COMMA oliteral[lit] { $$ = BUILDER.litkeyvec($vec, $lit); }
	;

olitvec
    : onlitvec[vec] { $$ = $vec; }
	|              { $$ = BUILDER.litkeyvec(); }
    ;

ooptcondition
    : COLON olitvec[vec] { $$ = $vec; }
    |                   { $$ = BUILDER.litkeyvec(); }
    ;

// }}}
// {{{ body aggregates
// {{{ body aggregate elements

obodyaggrelem
    : COLON olitvec[cond]                { $$ = $cond; }
    | ntermvec[args] ooptcondition[cond] { $$ = $cond; }
    ;
obodyaggrelemvec
    : obodyaggrelem[elem]                          { $$ = $elem; }
    | obodyaggrelemvec[vec] SEM obodyaggrelem[elem] { $$ = BUILDER.litkeyvec($vec, $elem); }
    ;

// Note: alternative syntax (without weight)

oaltbodyaggrelem
    : oliteral[lit] ooptcondition[cond] { $$ = BUILDER.litkeyvec($cond, $lit); }
    ;

oaltbodyaggrelemvec
    : oaltbodyaggrelem[elem]                             { $$ = $elem; }
    | oaltbodyaggrelemvec[vec] SEM oaltbodyaggrelem[elem] { $$ = BUILDER.litkeyvec($vec, $elem); }
    ;
// }}}

obodyaggregate
    : LBRACE RBRACE                                               { $$ = BUILDER.litkeyvec(); }
    | LBRACE oaltbodyaggrelemvec[elems] RBRACE                     { $$ = $elems; }
    | aggregatefunction[fun] LBRACE RBRACE                        { $$ = BUILDER.litkeyvec(); }
    | aggregatefunction[fun] LBRACE obodyaggrelemvec[elems] RBRACE { $$ = $elems; }
    ;


olubodyaggregate
    : term[l]          obodyaggregate[a] upper[u] { $$ = $a; }
    | term[l] cmp[rel] obodyaggregate[a] upper[u] { $$ = $a; }
    |                  obodyaggregate[a] upper[u] { $$ = $a; }
    ;
// }}}
// }}}

// {{{ conjunctions
oconjunction
    : oliteral[lit] COLON olitvec[cond] { $$ = BUILDER.litkeyvec($cond, $lit); }
    ;
// }}}
// }}}
// {{{ preference statements S
// 1. layer --> preference statement i,t (i identifier, t type)

statement
	: PREF_BLOCK LPAREN prefident[ident] COMMA IDENTIFIER[tname] RPAREN LBRACE prefcontent[con] RBRACE DOT 													{ BUILDER.prefstatement($ident, $tname, BUILDER.idvec() , $con,true); lexer->stDot(); }
	| PREF_BLOCK LPAREN prefident[ident] COMMA IDENTIFIER[tname] LPAREN idlist[targs] RPAREN RPAREN LBRACE prefcontent[con] RBRACE DOT						{ BUILDER.prefstatement($ident, $tname, $targs , $con,true); lexer->stDot(); }
	;

ostatement
    : PREF_BLOCK LPAREN prefident[ident] COMMA IDENTIFIER[tname] RPAREN LBRACE prefcontent[con] RBRACE DOT                                                  { BUILDER.prefstatement($ident, $tname, BUILDER.idvec() , $con,false); lexer->stDot(); }
    | PREF_BLOCK LPAREN prefident[ident] COMMA IDENTIFIER[tname] LPAREN idlist[targs] RPAREN RPAREN LBRACE prefcontent[con] RBRACE DOT                      { BUILDER.prefstatement($ident, $tname, $targs , $con,false); lexer->stDot(); }
    ;

prefident
	: IDENTIFIER[ident]  { $$ = BUILDER.prefident($ident); }
	;


// 2. layer --> preference elements E1 ... En
prefcontent
	: prefelem[elem] 				{ $$ = BUILDER.prefcontent( BUILDER.prefcontent(),$elem ); }
	| prefcontent[c] prefelem[elem] { $$ = BUILDER.prefcontent($c, $elem); }
	;

// 3. layer preference element Ei either only head (S1 > ... > Sn) or head with condition "body" (S > ... > Sn || Cond)
prefelem
	: phead[hd] DOT 							{ $$ = BUILDER.prefelem($hd.first,BUILDER.termvec(),false,BUILDER.prefvar($hd.second,BUILDER.prefvar()) ); }
	| phead[hd] DVBAR pcond[c] DOT 				{ $$ = BUILDER.prefelem($hd.first,$c.first, false,BUILDER.prefvar($hd.second, $c.second) ); }
	| phead[hd] IF bodydot[bd] 					{ $$ = BUILDER.prefelem($hd.first,BUILDER.termvec(), true, BUILDER.prefvar($hd.second, BUILDER.prefvar()) ); }
	| phead[hd] DVBAR pcond[c] IF bodydot[bd]	{ $$ = BUILDER.prefelem($hd.first,$c.first, true, BUILDER.prefvar($hd.second, $c.second) ); }
	;

// 4. layer 1. condition literal or term 
pcond
	: pterm[t]						{ $$ = { BUILDER.termvec(BUILDER.termvec(), $t.first), BUILDER.prefvar(BUILDER.prefvar(), $t.second) }; }
	| pcond[cond] COMMA pterm[t] 	{ $$ = { BUILDER.termvec($cond.first,$t.first), BUILDER.prefvar($cond.second, $t.second) }; }
	;



// 4. layer 2. set of heads
phead
	: pwtermset[t] 			 { $$ = { BUILDER.termvecvec(BUILDER.termvecvec(),$t.first), $t.second }; }
	| phead[hd] GT pwtermset[t] { $$ = { BUILDER.termvecvec($hd.first,$t.first), BUILDER.prefvar($hd.second, $t.second) }; }
	;

// 5. layer set of weighted lits
pwtermset
	: pwterm[t]						{ $$ = { BUILDER.termvec(BUILDER.termvec(),$t.first), $t.second }; }	
	| pwtermset[set] SEM pwterm[t]	{ $$ = { BUILDER.termvec($set.first,$t.first), BUILDER.prefvar($set.second, $t.second) }; }
	;

// 6. layer weightlit
//S : w1,..,wi:literal(term)

pwterm
	: pterm[t] 					{ $$ = { BUILDER.weightedterm( BUILDER.termvec(), $t.first), $t.second }; }
	| weights[w] COLON pterm[t] { $$ = { BUILDER.weightedterm($w,$t.first), $t.second }; }
	;

weights
	: pvarterm[t] 				 { $$ = BUILDER.termvec( BUILDER.termvec(), $t.first); }
	| weights[w] COMMA term[t] { $$ = BUILDER.termvec( $w, $t); }
	;

pterm
	: pvaratom[a] 		{ $$ = { BUILDER.preflit(NAF::POS, FWString($a.id), TermVecVecUid($a.terms >> 1u)), $a.vars }; }
	| NOT pvaratom[a]	{ $$ = { BUILDER.preflit(NAF::NOT, FWString($a.id), TermVecVecUid($a.terms >> 1u)), $a.vars }; }
	; 


// {{{ literals for preference

pvaratom
    : identifier[id]                                  { $$ = { $id, BUILDER.termvecvec(BUILDER.termvecvec(), BUILDER.termvec()) << 1u , BUILDER.prefvar()}; }
    | identifier[id] LPAREN pvarargvec[tvv] RPAREN[r]     { $$ = { $id, $tvv.first << 1u , $tvv.second }; }
    | SUB identifier[id]                              { $$ = { $id, BUILDER.termvecvec(BUILDER.termvecvec(), BUILDER.termvec()) << 1u | 1u , BUILDER.prefvar()}; }
    | SUB identifier[id] LPAREN pvarargvec[tvv] RPAREN[r] { $$ = { $id, $tvv.first << 1u | 1u, BUILDER.prefvar()}; }
    ;

// }}}
// {{{ terms including variables for preferences

pvarterm
    : pvarterm[a] DOTS pvarterm[b]                           { $$ = { BUILDER.term($a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] XOR pvarterm[b]                            { $$ = { BUILDER.term(BinOp::XOR, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] QUESTION pvarterm[b]                       { $$ = { BUILDER.term(BinOp::OR, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] AND pvarterm[b]                            { $$ = { BUILDER.term(BinOp::AND, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] ADD pvarterm[b]                            { $$ = { BUILDER.term(BinOp::ADD, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] SUB pvarterm[b]                            { $$ = { BUILDER.term(BinOp::SUB, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] MUL pvarterm[b]                            { $$ = { BUILDER.term(BinOp::MUL, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] SLASH pvarterm[b]                          { $$ = { BUILDER.term(BinOp::DIV, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] MOD pvarterm[b]                            { $$ = { BUILDER.term(BinOp::MOD, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | pvarterm[a] POW pvarterm[b]                            { $$ = { BUILDER.term(BinOp::POW, $a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    | SUB[l] pvarterm[a] %prec UMINUS                    { $$ = { BUILDER.term(UnOp::NEG, $a.first), $a.second }; }
    | BNOT[l] pvarterm[a] %prec UBNOT                    { $$ = { BUILDER.term(UnOp::NOT, $a.first), $a.second }; }
    | LPAREN[l] pvarargvec[a] RPAREN[r]                  { $$ = { BUILDER.term(FWString(""), $a.first, false), $a.second}; }
    | identifier[a] LPAREN pvarargvec[b] RPAREN[r]       { $$ = { BUILDER.term($a, $b.first, false), $b.second }; }
    | AT[l] identifier[a] LPAREN pvarargvec[b] RPAREN[r] { $$ = { BUILDER.term($a, $b.first, true), $b.second }; }
    | VBAR[l] pvarunaryargvec[a] VBAR[r]                 { $$ = { BUILDER.term(UnOp::ABS, $a.first), $a.second }; }
    | identifier[a]                                  { $$ = { BUILDER.term(Value(FWString($a))), BUILDER.prefvar()}; }
    | NUMBER[a]                                      { $$ = { BUILDER.term(Value($a)),BUILDER.prefvar() }; }
    | STRING[a]                                      { $$ = { BUILDER.term(Value(FWString($a), false)), BUILDER.prefvar()}; }
    | INFIMUM[a]                                     { $$ = { BUILDER.term(Value(true)), BUILDER.prefvar() }; }
    | SUPREMUM[a]                                    { $$ = { BUILDER.term(Value(false)), BUILDER.prefvar()}; }
    | VARIABLE[a]                                    { $$ = { BUILDER.term(FWString($a)), BUILDER.prefvar(BUILDER.prefvar(),FWString($a)) }; }
    | ANONYMOUS[a]                                   { $$ = { BUILDER.term(FWString("_")),BUILDER.prefvar() }; }
    ;
// {{{ argument lists for unary operations

pvarunaryargvec
    : pvarterm[a]                    { $$ = { BUILDER.termvec(BUILDER.termvec(), $a.first), $a.second }; }
    | pvarunaryargvec[a] SEM pvarterm[b] { $$ = { BUILDER.termvec($a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    ;

// }}}
// {{{ argument lists for functions

pvarntermvec
    : pvarterm[a]                   { $$ = { BUILDER.termvec(BUILDER.termvec(), $a.first), $a.second }; }
    | pvarntermvec[a] COMMA pvarterm[b] { $$ = { BUILDER.termvec($a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    ;

pvartermvec
    : pvarntermvec[a] { $$ = {$a.first, $a.second }; }
    |             { $$ = { BUILDER.termvec(),BUILDER.prefvar() }; }
    ;

pvarargvec
    : pvartermvec[a]               { $$ = { BUILDER.termvecvec(BUILDER.termvecvec(), $a.first), $a.second }; }
    | pvarargvec[a] SEM pvartermvec[b] { $$ = { BUILDER.termvecvec($a.first, $b.first), BUILDER.prefvar($a.second, $b.second) }; }
    ;
// }}}
// }}}
// }}}
// }}}

