// A Bison parser, made by GNU Bison 3.0.

// Skeleton implementation for Bison LALR(1) parsers in C++

// Copyright (C) 2002-2013 Free Software Foundation, Inc.

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

// As a special exception, you may create a larger work that contains
// part or all of the Bison parser skeleton and distribute that work
// under terms of your choice, so long as that work isn't itself a
// parser generator using the skeleton or a modified version thereof
// as a parser skeleton.  Alternatively, if you modify or redistribute
// the parser skeleton itself, you may (at your option) remove this
// special exception, which will cause the skeleton and the resulting
// Bison output files to be licensed under the GNU General Public
// License without this special exception.

// This special exception was added by the Free Software Foundation in
// version 2.2 of Bison.

// Take the name prefix into account.
#define yylex   PrefatorNonGroundGrammar_lex

// First part of user declarations.
#line 60 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:398


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


#line 75 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:398

# ifndef YY_NULL
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULL nullptr
#  else
#   define YY_NULL 0
#  endif
# endif

#include "grammar.hh"

// User implementation prologue.

#line 89 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:406
// Unqualified %code blocks.
#line 97 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:407


void NonGroundGrammar::parser::error(DefaultLocation const &l, std::string const &msg) {
    lexer->parseError(l, msg);
}


#line 99 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:407


#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> // FIXME: INFRINGES ON USER NAME SPACE.
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K].location)
/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

# ifndef YYLLOC_DEFAULT
#  define YYLLOC_DEFAULT(Current, Rhs, N)                               \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).begin  = YYRHSLOC (Rhs, 1).begin;                   \
          (Current).end    = YYRHSLOC (Rhs, N).end;                     \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).begin = (Current).end = YYRHSLOC (Rhs, 0).end;      \
        }                                                               \
    while (/*CONSTCOND*/ false)
# endif


// Suppress unused-variable warnings by "using" E.
#define YYUSE(E) ((void) (E))

// Enable debugging if requested.
#if PREFATORNONGROUNDGRAMMAR_DEBUG

// A pseudo ostream that takes yydebug_ into account.
# define YYCDEBUG if (yydebug_) (*yycdebug_)

# define YY_SYMBOL_PRINT(Title, Symbol)         \
  do {                                          \
    if (yydebug_)                               \
    {                                           \
      *yycdebug_ << Title << ' ';               \
      yy_print_ (*yycdebug_, Symbol);           \
      *yycdebug_ << std::endl;                  \
    }                                           \
  } while (false)

# define YY_REDUCE_PRINT(Rule)          \
  do {                                  \
    if (yydebug_)                       \
      yy_reduce_print_ (Rule);          \
  } while (false)

# define YY_STACK_PRINT()               \
  do {                                  \
    if (yydebug_)                       \
      yystack_print_ ();                \
  } while (false)

#else // !PREFATORNONGROUNDGRAMMAR_DEBUG

# define YYCDEBUG if (false) std::cerr
# define YY_SYMBOL_PRINT(Title, Symbol)  YYUSE(Symbol)
# define YY_REDUCE_PRINT(Rule)           static_cast<void>(0)
# define YY_STACK_PRINT()                static_cast<void>(0)

#endif // !PREFATORNONGROUNDGRAMMAR_DEBUG

#define yyerrok         (yyerrstatus_ = 0)
#define yyclearin       (yyempty = true)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYRECOVERING()  (!!yyerrstatus_)

#line 22 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:473
namespace Prefator { namespace Input { namespace NonGroundGrammar {
#line 185 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:473

  /* Return YYSTR after stripping away unnecessary quotes and
     backslashes, so that it's suitable for yyerror.  The heuristic is
     that double-quoting is unnecessary unless the string contains an
     apostrophe, a comma, or backslash (other than backslash-backslash).
     YYSTR is taken from yytname.  */
  std::string
  parser::yytnamerr_ (const char *yystr)
  {
    if (*yystr == '"')
      {
        std::string yyr = "";
        char const *yyp = yystr;

        for (;;)
          switch (*++yyp)
            {
            case '\'':
            case ',':
              goto do_not_strip_quotes;

            case '\\':
              if (*++yyp != '\\')
                goto do_not_strip_quotes;
              // Fall through.
            default:
              yyr += *yyp;
              break;

            case '"':
              return yyr;
            }
      do_not_strip_quotes: ;
      }

    return yystr;
  }


  /// Build a parser object.
  parser::parser (Prefator::Input::NonGroundParser *lexer_yyarg)
    :
#if PREFATORNONGROUNDGRAMMAR_DEBUG
      yydebug_ (false),
      yycdebug_ (&std::cerr),
#endif
      lexer (lexer_yyarg)
  {}

  parser::~parser ()
  {}


  /*---------------.
  | Symbol types.  |
  `---------------*/

  inline
  parser::syntax_error::syntax_error (const location_type& l, const std::string& m)
    : std::runtime_error (m)
    , location (l)
  {}

  // basic_symbol.
  template <typename Base>
  inline
  parser::basic_symbol<Base>::basic_symbol ()
    : value ()
  {}

  template <typename Base>
  inline
  parser::basic_symbol<Base>::basic_symbol (const basic_symbol& other)
    : Base (other)
    , value ()
    , location (other.location)
  {
    value = other.value;
  }


  template <typename Base>
  inline
  parser::basic_symbol<Base>::basic_symbol (typename Base::kind_type t, const semantic_type& v, const location_type& l)
    : Base (t)
    , value (v)
    , location (l)
  {}


  /// Constructor for valueless symbols.
  template <typename Base>
  inline
  parser::basic_symbol<Base>::basic_symbol (typename Base::kind_type t, const location_type& l)
    : Base (t)
    , value ()
    , location (l)
  {}

  template <typename Base>
  inline
  parser::basic_symbol<Base>::~basic_symbol ()
  {
  }

  template <typename Base>
  inline
  void
  parser::basic_symbol<Base>::move (basic_symbol& s)
  {
    super_type::move(s);
    value = s.value;
    location = s.location;
  }

  // by_type.
  inline
  parser::by_type::by_type ()
     : type (empty)
  {}

  inline
  parser::by_type::by_type (const by_type& other)
    : type (other.type)
  {}

  inline
  parser::by_type::by_type (token_type t)
    : type (yytranslate_ (t))
  {}

  inline
  void
  parser::by_type::move (by_type& that)
  {
    type = that.type;
    that.type = empty;
  }

  inline
  int
  parser::by_type::type_get () const
  {
    return type;
  }


  // by_state.
  inline
  parser::by_state::by_state ()
    : state (empty)
  {}

  inline
  parser::by_state::by_state (const by_state& other)
    : state (other.state)
  {}

  inline
  void
  parser::by_state::move (by_state& that)
  {
    state = that.state;
    that.state = empty;
  }

  inline
  parser::by_state::by_state (state_type s)
    : state (s)
  {}

  inline
  parser::symbol_number_type
  parser::by_state::type_get () const
  {
    return state == empty ? 0 : yystos_[state];
  }

  inline
  parser::stack_symbol_type::stack_symbol_type ()
  {}


  inline
  parser::stack_symbol_type::stack_symbol_type (state_type s, symbol_type& that)
    : super_type (s, that.location)
  {
    value = that.value;
    // that is emptied.
    that.type = empty;
  }

  inline
  parser::stack_symbol_type&
  parser::stack_symbol_type::operator= (const stack_symbol_type& that)
  {
    state = that.state;
    value = that.value;
    location = that.location;
    return *this;
  }


  template <typename Base>
  inline
  void
  parser::yy_destroy_ (const char* yymsg, basic_symbol<Base>& yysym) const
  {
    if (yymsg)
      YY_SYMBOL_PRINT (yymsg, yysym);

    // User destructor.
    YYUSE (yysym.type_get ());
  }

#if PREFATORNONGROUNDGRAMMAR_DEBUG
  template <typename Base>
  void
  parser::yy_print_ (std::ostream& yyo,
                                     const basic_symbol<Base>& yysym) const
  {
    std::ostream& yyoutput = yyo;
    YYUSE (yyoutput);
    symbol_number_type yytype = yysym.type_get ();
    yyo << (yytype < yyntokens_ ? "token" : "nterm")
        << ' ' << yytname_[yytype] << " ("
        << yysym.location << ": ";
    YYUSE (yytype);
    yyo << ')';
  }
#endif

  inline
  void
  parser::yypush_ (const char* m, state_type s, symbol_type& sym)
  {
    stack_symbol_type t (s, sym);
    yypush_ (m, t);
  }

  inline
  void
  parser::yypush_ (const char* m, stack_symbol_type& s)
  {
    if (m)
      YY_SYMBOL_PRINT (m, s);
    yystack_.push (s);
  }

  inline
  void
  parser::yypop_ (unsigned int n)
  {
    yystack_.pop (n);
  }

#if PREFATORNONGROUNDGRAMMAR_DEBUG
  std::ostream&
  parser::debug_stream () const
  {
    return *yycdebug_;
  }

  void
  parser::set_debug_stream (std::ostream& o)
  {
    yycdebug_ = &o;
  }


  parser::debug_level_type
  parser::debug_level () const
  {
    return yydebug_;
  }

  void
  parser::set_debug_level (debug_level_type l)
  {
    yydebug_ = l;
  }
#endif // PREFATORNONGROUNDGRAMMAR_DEBUG

  inline parser::state_type
  parser::yy_lr_goto_state_ (state_type yystate, int yylhs)
  {
    int yyr = yypgoto_[yylhs - yyntokens_] + yystate;
    if (0 <= yyr && yyr <= yylast_ && yycheck_[yyr] == yystate)
      return yytable_[yyr];
    else
      return yydefgoto_[yylhs - yyntokens_];
  }

  inline bool
  parser::yy_pact_value_is_default_ (int yyvalue)
  {
    return yyvalue == yypact_ninf_;
  }

  inline bool
  parser::yy_table_value_is_error_ (int yyvalue)
  {
    return yyvalue == yytable_ninf_;
  }

  int
  parser::parse ()
  {
    /// Whether yyla contains a lookahead.
    bool yyempty = true;

    // State.
    int yyn;
    int yylen = 0;

    // Error handling.
    int yynerrs_ = 0;
    int yyerrstatus_ = 0;

    /// The lookahead symbol.
    symbol_type yyla;

    /// The locations where the error started and ended.
    stack_symbol_type yyerror_range[3];

    /// $$ and @$.
    stack_symbol_type yylhs;

    /// The return value of parse ().
    int yyresult;

    // FIXME: This shoud be completely indented.  It is not yet to
    // avoid gratuitous conflicts when merging into the master branch.
    try
      {
    YYCDEBUG << "Starting parse" << std::endl;


    /* Initialize the stack.  The initial state will be set in
       yynewstate, since the latter expects the semantical and the
       location values to have been already stored, initialize these
       stacks with a primary value.  */
    yystack_.clear ();
    yypush_ (YY_NULL, 0, yyla);

    // A new symbol was pushed on the stack.
  yynewstate:
    YYCDEBUG << "Entering state " << yystack_[0].state << std::endl;

    // Accept?
    if (yystack_[0].state == yyfinal_)
      goto yyacceptlab;

    goto yybackup;

    // Backup.
  yybackup:

    // Try to take a decision without lookahead.
    yyn = yypact_[yystack_[0].state];
    if (yy_pact_value_is_default_ (yyn))
      goto yydefault;

    // Read a lookahead token.
    if (yyempty)
      {
        YYCDEBUG << "Reading a token: ";
        try
          {
            yyla.type = yytranslate_ (yylex (&yyla.value, &yyla.location, lexer));
          }
        catch (const syntax_error& yyexc)
          {
            error (yyexc);
            goto yyerrlab1;
          }
        yyempty = false;
      }
    YY_SYMBOL_PRINT ("Next token is", yyla);

    /* If the proper action on seeing token YYLA.TYPE is to reduce or
       to detect an error, take that action.  */
    yyn += yyla.type_get ();
    if (yyn < 0 || yylast_ < yyn || yycheck_[yyn] != yyla.type_get ())
      goto yydefault;

    // Reduce or error.
    yyn = yytable_[yyn];
    if (yyn <= 0)
      {
        if (yy_table_value_is_error_ (yyn))
          goto yyerrlab;
        yyn = -yyn;
        goto yyreduce;
      }

    // Discard the token being shifted.
    yyempty = true;

    // Count tokens shifted since error; after three, turn off error status.
    if (yyerrstatus_)
      --yyerrstatus_;

    // Shift the lookahead token.
    yypush_ ("Shifting", yyn, yyla);
    goto yynewstate;

  /*-----------------------------------------------------------.
  | yydefault -- do the default action for the current state.  |
  `-----------------------------------------------------------*/
  yydefault:
    yyn = yydefact_[yystack_[0].state];
    if (yyn == 0)
      goto yyerrlab;
    goto yyreduce;

  /*-----------------------------.
  | yyreduce -- Do a reduction.  |
  `-----------------------------*/
  yyreduce:
    yylen = yyr2_[yyn];
    yylhs.state = yy_lr_goto_state_(yystack_[yylen].state, yyr1_[yyn]);
    /* If YYLEN is nonzero, implement the default value of the action:
       '$$ = $1'.  Otherwise, use the top of the stack.

       Otherwise, the following line sets YYLHS.VALUE to garbage.
       This behavior is undocumented and Bison
       users should not rely upon it.  */
    if (yylen)
      yylhs.value = yystack_[yylen - 1].value;
    else
      yylhs.value = yystack_[0].value;

    // Compute the default @$.
    {
      slice<stack_symbol_type, stack_type> slice (yystack_, yylen);
      YYLLOC_DEFAULT (yylhs.location, slice, yylen);
    }

    // Perform the reduction.
    YY_REDUCE_PRINT (yyn);
    try
      {
        switch (yyn)
          {
  case 12:
#line 306 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { lexer->stDot(); }
#line 634 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 13:
#line 310 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { lexer->stDot(); }
#line 640 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 16:
#line 319 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { YYABORT; }
#line 646 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 17:
#line 323 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.uid) = (yystack_[0].value.uid); }
#line 652 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 42:
#line 371 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term((yystack_[2].value.term), (yystack_[0].value.term)); }
#line 658 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 43:
#line 372 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::XOR, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 664 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 44:
#line 373 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::OR, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 670 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 45:
#line 374 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::AND, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 676 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 46:
#line 375 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::ADD, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 682 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 47:
#line 376 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::SUB, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 688 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 48:
#line 377 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::MUL, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 694 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 49:
#line 378 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::DIV, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 700 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 50:
#line 379 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::MOD, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 706 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 51:
#line 380 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(BinOp::POW, (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 712 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 52:
#line 381 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(UnOp::NEG, (yystack_[0].value.term)); }
#line 718 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 53:
#line 382 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(UnOp::NOT, (yystack_[0].value.term)); }
#line 724 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 54:
#line 383 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(FWString(""), (yystack_[1].value.termvecvec), false); }
#line 730 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 55:
#line 384 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term((yystack_[3].value.uid), (yystack_[1].value.termvecvec), false); }
#line 736 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 56:
#line 385 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term((yystack_[3].value.uid), (yystack_[1].value.termvecvec), true); }
#line 742 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 57:
#line 386 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(UnOp::ABS, (yystack_[1].value.termvec)); }
#line 748 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 58:
#line 387 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(Value(FWString((yystack_[0].value.uid)))); }
#line 754 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 59:
#line 388 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(Value((yystack_[0].value.num))); }
#line 760 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 60:
#line 389 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(Value(FWString((yystack_[0].value.uid)), false)); }
#line 766 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 61:
#line 390 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(Value(true)); }
#line 772 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 62:
#line 391 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(Value(false)); }
#line 778 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 63:
#line 392 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(FWString((yystack_[0].value.uid))); }
#line 784 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 64:
#line 393 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.term) = BUILDER.term(FWString("_")); }
#line 790 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 65:
#line 399 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvec) = BUILDER.termvec(BUILDER.termvec(), (yystack_[0].value.term)); }
#line 796 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 66:
#line 400 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvec) = BUILDER.termvec((yystack_[2].value.termvec), (yystack_[0].value.term)); }
#line 802 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 67:
#line 407 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvec) = BUILDER.termvec(BUILDER.termvec(), (yystack_[0].value.term)); }
#line 808 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 68:
#line 408 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvec) = BUILDER.termvec((yystack_[2].value.termvec), (yystack_[0].value.term)); }
#line 814 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 69:
#line 412 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvec) = (yystack_[0].value.termvec); }
#line 820 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 70:
#line 413 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvec) = BUILDER.termvec(); }
#line 826 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 71:
#line 417 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvecvec) = BUILDER.termvecvec(BUILDER.termvecvec(), (yystack_[0].value.termvec)); }
#line 832 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 72:
#line 418 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvecvec) = BUILDER.termvecvec((yystack_[2].value.termvecvec), (yystack_[0].value.termvec)); }
#line 838 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 73:
#line 427 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::GT; }
#line 844 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 74:
#line 428 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::LT; }
#line 850 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 75:
#line 429 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::GEQ; }
#line 856 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 76:
#line 430 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::LEQ; }
#line 862 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 77:
#line 431 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::EQ; }
#line 868 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 78:
#line 432 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::NEQ; }
#line 874 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 79:
#line 433 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::ASSIGN; }
#line 880 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 80:
#line 437 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.pair) = { (yystack_[0].value.uid), BUILDER.termvecvec(BUILDER.termvecvec(), BUILDER.termvec()) << 1u }; }
#line 886 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 81:
#line 438 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.pair) = { (yystack_[3].value.uid), (yystack_[1].value.termvecvec) << 1u }; }
#line 892 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 82:
#line 439 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.pair) = { (yystack_[0].value.uid), BUILDER.termvecvec(BUILDER.termvecvec(), BUILDER.termvec()) << 1u | 1u }; }
#line 898 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 83:
#line 440 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.pair) = { (yystack_[3].value.uid), (yystack_[1].value.termvecvec) << 1u | 1u }; }
#line 904 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 84:
#line 444 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.lit) = BUILDER.boollit(true); }
#line 910 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 85:
#line 445 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.lit) = BUILDER.boollit(false); }
#line 916 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 86:
#line 446 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.lit) = BUILDER.predlit(NAF::POS, (yystack_[0].value.pair).second & 1, FWString((yystack_[0].value.pair).first), TermVecVecUid((yystack_[0].value.pair).second >> 1u)); }
#line 922 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 87:
#line 447 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.lit) = BUILDER.predlit(NAF::NOT, (yystack_[0].value.pair).second & 1, FWString((yystack_[0].value.pair).first), TermVecVecUid((yystack_[0].value.pair).second >> 1u)); }
#line 928 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 88:
#line 448 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.lit) = BUILDER.predlit(NAF::NOTNOT, (yystack_[0].value.pair).second & 1, FWString((yystack_[0].value.pair).first), TermVecVecUid((yystack_[0].value.pair).second >> 1u)); }
#line 934 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 89:
#line 449 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.lit) = BUILDER.rellit((yystack_[1].value.rel), (yystack_[2].value.term), (yystack_[0].value.term)); }
#line 940 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 90:
#line 450 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.lit) = BUILDER.csplit((yystack_[0].value.csplit)); }
#line 946 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 91:
#line 454 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.cspmulterm) = BUILDER.cspmulterm((yystack_[0].value.term),                     (yystack_[2].value.term)); }
#line 952 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 92:
#line 455 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.cspmulterm) = BUILDER.cspmulterm((yystack_[3].value.term),                     (yystack_[0].value.term)); }
#line 958 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 93:
#line 456 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.cspmulterm) = BUILDER.cspmulterm( BUILDER.term(Value(1)), (yystack_[0].value.term)); }
#line 964 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 94:
#line 457 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.cspmulterm) = BUILDER.cspmulterm((yystack_[0].value.term)); }
#line 970 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 95:
#line 461 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.cspaddterm) = BUILDER.cspaddterm((yystack_[2].value.cspaddterm), (yystack_[0].value.cspmulterm), true); }
#line 976 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 96:
#line 462 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.cspaddterm) = BUILDER.cspaddterm((yystack_[2].value.cspaddterm), (yystack_[0].value.cspmulterm), false); }
#line 982 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 97:
#line 463 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.cspaddterm) = BUILDER.cspaddterm((yystack_[0].value.cspmulterm)); }
#line 988 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 98:
#line 467 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::GT; }
#line 994 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 99:
#line 468 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::LT; }
#line 1000 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 100:
#line 469 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::GEQ; }
#line 1006 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 101:
#line 470 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::LEQ; }
#line 1012 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 102:
#line 471 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::EQ; }
#line 1018 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 103:
#line 472 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.rel) = Relation::NEQ; }
#line 1024 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 104:
#line 476 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.csplit) = BUILDER.csplit((yystack_[2].value.csplit), (yystack_[1].value.rel), (yystack_[0].value.cspaddterm)); }
#line 1030 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 105:
#line 477 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.csplit) = BUILDER.csplit((yystack_[2].value.cspaddterm),   (yystack_[1].value.rel), (yystack_[0].value.cspaddterm)); }
#line 1036 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 138:
#line 568 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.holds((yystack_[1].value.lit)); }
#line 1042 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 139:
#line 569 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.holds((yystack_[1].value.lit)); }
#line 1048 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 181:
#line 664 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.holds((yystack_[0].value.lit)); }
#line 1054 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 211:
#line 732 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { lexer->include((yystack_[1].value.uid), yylhs.location, false); }
#line 1060 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 212:
#line 733 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { lexer->include((yystack_[2].value.uid), yylhs.location, true); }
#line 1066 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 213:
#line 740 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.idlist) = BUILDER.idvec((yystack_[2].value.idlist), (yystack_[0].value.uid)); }
#line 1072 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 214:
#line 741 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.idlist) = BUILDER.idvec(BUILDER.idvec(), (yystack_[0].value.uid)); }
#line 1078 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 215:
#line 745 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.idlist) = BUILDER.idvec(); }
#line 1084 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 216:
#line 746 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.idlist) = (yystack_[0].value.idlist); }
#line 1090 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 220:
#line 767 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.prefmain((yystack_[2].value.uid), true); lexer->stDot(); }
#line 1096 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 223:
#line 778 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.litkeys((yystack_[1].value.litkey), BUILDER.litkeyvec()); BUILDER.setStatementType(StType::OFACT); lexer->stDot(); }
#line 1102 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 224:
#line 779 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.litkeys((yystack_[2].value.litkey), (yystack_[0].value.litkeyvec)); BUILDER.setStatementType(StType::ORULE); lexer->stDot(); }
#line 1108 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 225:
#line 780 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.setStatementType(StType::OCONSTRAINT); lexer->stDot(); }
#line 1114 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 226:
#line 781 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.prefmain((yystack_[2].value.uid), false); lexer->stDot(); }
#line 1120 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 227:
#line 786 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[1].value.litkey)); }
#line 1126 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 228:
#line 787 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[1].value.litkey)); }
#line 1132 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 229:
#line 788 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1138 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 230:
#line 789 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1144 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 231:
#line 790 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[3].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1150 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 232:
#line 791 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[3].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1156 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 233:
#line 792 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[4].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1162 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 234:
#line 793 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[4].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1168 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 235:
#line 794 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1174 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 236:
#line 795 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec(); }
#line 1180 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 237:
#line 799 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[1].value.litkey)); }
#line 1186 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 238:
#line 800 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1192 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 239:
#line 801 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[3].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1198 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 240:
#line 802 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[4].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1204 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 241:
#line 803 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[1].value.litkeyvec)); }
#line 1210 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 242:
#line 808 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkey) = (yystack_[0].value.litkey); }
#line 1216 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 243:
#line 822 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkey) = BUILDER.litkey(); }
#line 1222 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 244:
#line 823 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkey) = BUILDER.litkey(); }
#line 1228 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 245:
#line 824 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkey) = BUILDER.litkey(FWString((yystack_[0].value.pair).first),TermVecVecUid((yystack_[0].value.pair).second >> 1u)); BUILDER.prefolit(FWString((yystack_[0].value.pair).first),TermVecVecUid((yystack_[0].value.pair).second >> 1u));lexer->deleteLit(); }
#line 1234 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 246:
#line 825 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkey) = BUILDER.litkey(FWString((yystack_[0].value.pair).first),TermVecVecUid((yystack_[0].value.pair).second >> 1u)); BUILDER.prefolit(FWString((yystack_[0].value.pair).first),TermVecVecUid((yystack_[0].value.pair).second >> 1u)); lexer->deleteLit(); }
#line 1240 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 247:
#line 826 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkey) = BUILDER.litkey(FWString((yystack_[0].value.pair).first),TermVecVecUid((yystack_[0].value.pair).second >> 1u)); BUILDER.prefolit(FWString((yystack_[0].value.pair).first),TermVecVecUid((yystack_[0].value.pair).second >> 1u)); lexer->deleteLit(); }
#line 1246 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 248:
#line 827 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkey) = BUILDER.litkey(); }
#line 1252 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 249:
#line 833 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec(BUILDER.litkeyvec(), (yystack_[0].value.litkey)); }
#line 1258 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 250:
#line 834 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[0].value.litkey)); }
#line 1264 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 251:
#line 838 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[0].value.litkeyvec); }
#line 1270 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 252:
#line 839 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec(); }
#line 1276 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 253:
#line 843 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[0].value.litkeyvec); }
#line 1282 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 254:
#line 844 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec(); }
#line 1288 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 255:
#line 852 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[0].value.litkeyvec); }
#line 1294 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 256:
#line 853 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[0].value.litkeyvec); }
#line 1300 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 257:
#line 856 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[0].value.litkeyvec); }
#line 1306 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 258:
#line 857 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[0].value.litkeyvec)); }
#line 1312 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 259:
#line 863 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[0].value.litkeyvec), (yystack_[1].value.litkey)); }
#line 1318 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 260:
#line 867 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[0].value.litkeyvec); }
#line 1324 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 261:
#line 868 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[2].value.litkeyvec), (yystack_[0].value.litkeyvec)); }
#line 1330 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 262:
#line 873 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec(); }
#line 1336 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 263:
#line 874 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[1].value.litkeyvec); }
#line 1342 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 264:
#line 875 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec(); }
#line 1348 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 265:
#line 876 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[1].value.litkeyvec); }
#line 1354 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 266:
#line 881 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[1].value.litkeyvec); }
#line 1360 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 267:
#line 882 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[1].value.litkeyvec); }
#line 1366 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 268:
#line 883 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = (yystack_[1].value.litkeyvec); }
#line 1372 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 269:
#line 890 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.litkeyvec) = BUILDER.litkeyvec((yystack_[0].value.litkeyvec), (yystack_[2].value.litkey)); }
#line 1378 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 270:
#line 898 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.prefstatement((yystack_[7].value.prefident), (yystack_[5].value.uid), BUILDER.idvec() , (yystack_[2].value.prefelemvec),true); lexer->stDot(); }
#line 1384 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 271:
#line 899 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.prefstatement((yystack_[10].value.prefident), (yystack_[8].value.uid), (yystack_[6].value.idlist) , (yystack_[2].value.prefelemvec),true); lexer->stDot(); }
#line 1390 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 272:
#line 903 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.prefstatement((yystack_[7].value.prefident), (yystack_[5].value.uid), BUILDER.idvec() , (yystack_[2].value.prefelemvec),false); lexer->stDot(); }
#line 1396 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 273:
#line 904 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { BUILDER.prefstatement((yystack_[10].value.prefident), (yystack_[8].value.uid), (yystack_[6].value.idlist) , (yystack_[2].value.prefelemvec),false); lexer->stDot(); }
#line 1402 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 274:
#line 908 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.prefident) = BUILDER.prefident((yystack_[0].value.uid)); }
#line 1408 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 275:
#line 914 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.prefelemvec) = BUILDER.prefcontent( BUILDER.prefcontent(),(yystack_[0].value.prefelem) ); }
#line 1414 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 276:
#line 915 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.prefelemvec) = BUILDER.prefcontent((yystack_[1].value.prefelemvec), (yystack_[0].value.prefelem)); }
#line 1420 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 277:
#line 920 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.prefelem) = BUILDER.prefelem((yystack_[1].value.ptvvvarpair).first,BUILDER.termvec(),false,BUILDER.prefvar((yystack_[1].value.ptvvvarpair).second,BUILDER.prefvar()) ); }
#line 1426 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 278:
#line 921 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.prefelem) = BUILDER.prefelem((yystack_[3].value.ptvvvarpair).first,(yystack_[1].value.ptvvarpair).first, false,BUILDER.prefvar((yystack_[3].value.ptvvvarpair).second, (yystack_[1].value.ptvvarpair).second) ); }
#line 1432 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 279:
#line 922 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.prefelem) = BUILDER.prefelem((yystack_[2].value.ptvvvarpair).first,BUILDER.termvec(), true, BUILDER.prefvar((yystack_[2].value.ptvvvarpair).second, BUILDER.prefvar()) ); }
#line 1438 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 280:
#line 923 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.prefelem) = BUILDER.prefelem((yystack_[4].value.ptvvvarpair).first,(yystack_[2].value.ptvvarpair).first, true, BUILDER.prefvar((yystack_[4].value.ptvvvarpair).second, (yystack_[2].value.ptvvarpair).second) ); }
#line 1444 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 281:
#line 928 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec(BUILDER.termvec(), (yystack_[0].value.ptvarpair).first), BUILDER.prefvar(BUILDER.prefvar(), (yystack_[0].value.ptvarpair).second) }; }
#line 1450 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 282:
#line 929 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec((yystack_[2].value.ptvvarpair).first,(yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1456 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 283:
#line 936 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvvarpair) = { BUILDER.termvecvec(BUILDER.termvecvec(),(yystack_[0].value.ptvvarpair).first), (yystack_[0].value.ptvvarpair).second }; }
#line 1462 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 284:
#line 937 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvvarpair) = { BUILDER.termvecvec((yystack_[2].value.ptvvvarpair).first,(yystack_[0].value.ptvvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvvvarpair).second, (yystack_[0].value.ptvvarpair).second) }; }
#line 1468 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 285:
#line 942 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec(BUILDER.termvec(),(yystack_[0].value.ptvarpair).first), (yystack_[0].value.ptvarpair).second }; }
#line 1474 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 286:
#line 943 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec((yystack_[2].value.ptvvarpair).first,(yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1480 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 287:
#line 950 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.weightedterm( BUILDER.termvec(), (yystack_[0].value.ptvarpair).first), (yystack_[0].value.ptvarpair).second }; }
#line 1486 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 288:
#line 951 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.weightedterm((yystack_[2].value.termvec),(yystack_[0].value.ptvarpair).first), (yystack_[0].value.ptvarpair).second }; }
#line 1492 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 289:
#line 955 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvec) = BUILDER.termvec( BUILDER.termvec(), (yystack_[0].value.ptvarpair).first); }
#line 1498 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 290:
#line 956 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.termvec) = BUILDER.termvec( (yystack_[2].value.termvec), (yystack_[0].value.term)); }
#line 1504 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 291:
#line 960 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.preflit(NAF::POS, FWString((yystack_[0].value.pavarpair).id), TermVecVecUid((yystack_[0].value.pavarpair).terms >> 1u)), (yystack_[0].value.pavarpair).vars }; }
#line 1510 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 292:
#line 961 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.preflit(NAF::NOT, FWString((yystack_[0].value.pavarpair).id), TermVecVecUid((yystack_[0].value.pavarpair).terms >> 1u)), (yystack_[0].value.pavarpair).vars }; }
#line 1516 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 293:
#line 968 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.pavarpair) = { (yystack_[0].value.uid), BUILDER.termvecvec(BUILDER.termvecvec(), BUILDER.termvec()) << 1u , BUILDER.prefvar()}; }
#line 1522 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 294:
#line 969 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.pavarpair) = { (yystack_[3].value.uid), (yystack_[1].value.ptvvvarpair).first << 1u , (yystack_[1].value.ptvvvarpair).second }; }
#line 1528 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 295:
#line 970 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.pavarpair) = { (yystack_[0].value.uid), BUILDER.termvecvec(BUILDER.termvecvec(), BUILDER.termvec()) << 1u | 1u , BUILDER.prefvar()}; }
#line 1534 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 296:
#line 971 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.pavarpair) = { (yystack_[3].value.uid), (yystack_[1].value.ptvvvarpair).first << 1u | 1u, BUILDER.prefvar()}; }
#line 1540 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 297:
#line 978 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term((yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1546 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 298:
#line 979 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::XOR, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1552 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 299:
#line 980 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::OR, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1558 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 300:
#line 981 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::AND, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1564 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 301:
#line 982 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::ADD, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1570 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 302:
#line 983 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::SUB, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1576 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 303:
#line 984 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::MUL, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1582 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 304:
#line 985 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::DIV, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1588 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 305:
#line 986 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::MOD, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1594 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 306:
#line 987 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(BinOp::POW, (yystack_[2].value.ptvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1600 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 307:
#line 988 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(UnOp::NEG, (yystack_[0].value.ptvarpair).first), (yystack_[0].value.ptvarpair).second }; }
#line 1606 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 308:
#line 989 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(UnOp::NOT, (yystack_[0].value.ptvarpair).first), (yystack_[0].value.ptvarpair).second }; }
#line 1612 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 309:
#line 990 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(FWString(""), (yystack_[1].value.ptvvvarpair).first, false), (yystack_[1].value.ptvvvarpair).second}; }
#line 1618 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 310:
#line 991 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term((yystack_[3].value.uid), (yystack_[1].value.ptvvvarpair).first, false), (yystack_[1].value.ptvvvarpair).second }; }
#line 1624 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 311:
#line 992 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term((yystack_[3].value.uid), (yystack_[1].value.ptvvvarpair).first, true), (yystack_[1].value.ptvvvarpair).second }; }
#line 1630 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 312:
#line 993 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(UnOp::ABS, (yystack_[1].value.ptvvarpair).first), (yystack_[1].value.ptvvarpair).second }; }
#line 1636 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 313:
#line 994 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(Value(FWString((yystack_[0].value.uid)))), BUILDER.prefvar()}; }
#line 1642 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 314:
#line 995 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(Value((yystack_[0].value.num))),BUILDER.prefvar() }; }
#line 1648 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 315:
#line 996 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(Value(FWString((yystack_[0].value.uid)), false)), BUILDER.prefvar()}; }
#line 1654 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 316:
#line 997 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(Value(true)), BUILDER.prefvar() }; }
#line 1660 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 317:
#line 998 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(Value(false)), BUILDER.prefvar()}; }
#line 1666 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 318:
#line 999 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(FWString((yystack_[0].value.uid))), BUILDER.prefvar(BUILDER.prefvar(),FWString((yystack_[0].value.uid))) }; }
#line 1672 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 319:
#line 1000 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvarpair) = { BUILDER.term(FWString("_")),BUILDER.prefvar() }; }
#line 1678 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 320:
#line 1005 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec(BUILDER.termvec(), (yystack_[0].value.ptvarpair).first), (yystack_[0].value.ptvarpair).second }; }
#line 1684 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 321:
#line 1006 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec((yystack_[2].value.ptvvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1690 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 322:
#line 1013 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec(BUILDER.termvec(), (yystack_[0].value.ptvarpair).first), (yystack_[0].value.ptvarpair).second }; }
#line 1696 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 323:
#line 1014 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec((yystack_[2].value.ptvvarpair).first, (yystack_[0].value.ptvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvvarpair).second, (yystack_[0].value.ptvarpair).second) }; }
#line 1702 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 324:
#line 1018 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = {(yystack_[0].value.ptvvarpair).first, (yystack_[0].value.ptvvarpair).second }; }
#line 1708 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 325:
#line 1019 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvarpair) = { BUILDER.termvec(),BUILDER.prefvar() }; }
#line 1714 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 326:
#line 1023 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvvarpair) = { BUILDER.termvecvec(BUILDER.termvecvec(), (yystack_[0].value.ptvvarpair).first), (yystack_[0].value.ptvvarpair).second }; }
#line 1720 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;

  case 327:
#line 1024 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:846
    { (yylhs.value.ptvvvarpair) = { BUILDER.termvecvec((yystack_[2].value.ptvvvarpair).first, (yystack_[0].value.ptvvarpair).first), BUILDER.prefvar((yystack_[2].value.ptvvvarpair).second, (yystack_[0].value.ptvvarpair).second) }; }
#line 1726 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
    break;


#line 1730 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:846
          default:
            break;
          }
      }
    catch (const syntax_error& yyexc)
      {
        error (yyexc);
        YYERROR;
      }
    YY_SYMBOL_PRINT ("-> $$ =", yylhs);
    yypop_ (yylen);
    yylen = 0;
    YY_STACK_PRINT ();

    // Shift the result of the reduction.
    yypush_ (YY_NULL, yylhs);
    goto yynewstate;

  /*--------------------------------------.
  | yyerrlab -- here on detecting error.  |
  `--------------------------------------*/
  yyerrlab:
    // If not already recovering from an error, report this error.
    if (!yyerrstatus_)
      {
        ++yynerrs_;
        error (yyla.location, yysyntax_error_ (yystack_[0].state,
                                           yyempty ? yyempty_ : yyla.type_get ()));
      }


    yyerror_range[1].location = yyla.location;
    if (yyerrstatus_ == 3)
      {
        /* If just tried and failed to reuse lookahead token after an
           error, discard it.  */

        // Return failure if at end of input.
        if (yyla.type_get () == yyeof_)
          YYABORT;
        else if (!yyempty)
          {
            yy_destroy_ ("Error: discarding", yyla);
            yyempty = true;
          }
      }

    // Else will try to reuse lookahead token after shifting the error token.
    goto yyerrlab1;


  /*---------------------------------------------------.
  | yyerrorlab -- error raised explicitly by YYERROR.  |
  `---------------------------------------------------*/
  yyerrorlab:

    /* Pacify compilers like GCC when the user code never invokes
       YYERROR and the label yyerrorlab therefore never appears in user
       code.  */
    if (false)
      goto yyerrorlab;
    yyerror_range[1].location = yystack_[yylen - 1].location;
    /* Do not reclaim the symbols of the rule whose action triggered
       this YYERROR.  */
    yypop_ (yylen);
    yylen = 0;
    goto yyerrlab1;

  /*-------------------------------------------------------------.
  | yyerrlab1 -- common code for both syntax error and YYERROR.  |
  `-------------------------------------------------------------*/
  yyerrlab1:
    yyerrstatus_ = 3;   // Each real token shifted decrements this.
    {
      stack_symbol_type error_token;
      for (;;)
        {
          yyn = yypact_[yystack_[0].state];
          if (!yy_pact_value_is_default_ (yyn))
            {
              yyn += yyterror_;
              if (0 <= yyn && yyn <= yylast_ && yycheck_[yyn] == yyterror_)
                {
                  yyn = yytable_[yyn];
                  if (0 < yyn)
                    break;
                }
            }

          // Pop the current state because it cannot handle the error token.
          if (yystack_.size () == 1)
            YYABORT;

          yyerror_range[1].location = yystack_[0].location;
          yy_destroy_ ("Error: popping", yystack_[0]);
          yypop_ ();
          YY_STACK_PRINT ();
        }

      yyerror_range[2].location = yyla.location;
      YYLLOC_DEFAULT (error_token.location, yyerror_range, 2);

      // Shift the error token.
      error_token.state = yyn;
      yypush_ ("Shifting", error_token);
    }
    goto yynewstate;

    // Accept.
  yyacceptlab:
    yyresult = 0;
    goto yyreturn;

    // Abort.
  yyabortlab:
    yyresult = 1;
    goto yyreturn;

  yyreturn:
    if (!yyempty)
      yy_destroy_ ("Cleanup: discarding lookahead", yyla);

    /* Do not reclaim the symbols of the rule whose action triggered
       this YYABORT or YYACCEPT.  */
    yypop_ (yylen);
    while (1 < yystack_.size ())
      {
        yy_destroy_ ("Cleanup: popping", yystack_[0]);
        yypop_ ();
      }

    return yyresult;
  }
    catch (...)
      {
        YYCDEBUG << "Exception caught: cleaning lookahead and stack"
                 << std::endl;
        // Do not try to display the values of the reclaimed symbols,
        // as their printer might throw an exception.
        if (!yyempty)
          yy_destroy_ (YY_NULL, yyla);

        while (1 < yystack_.size ())
          {
            yy_destroy_ (YY_NULL, yystack_[0]);
            yypop_ ();
          }
        throw;
      }
  }

  void
  parser::error (const syntax_error& yyexc)
  {
    error (yyexc.location, yyexc.what());
  }

  // Generate an error message.
  std::string
  parser::yysyntax_error_ (state_type yystate, symbol_number_type yytoken) const
  {
    std::string yyres;
    // Number of reported tokens (one for the "unexpected", one per
    // "expected").
    size_t yycount = 0;
    // Its maximum.
    enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
    // Arguments of yyformat.
    char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];

    /* There are many possibilities here to consider:
       - If this state is a consistent state with a default action, then
         the only way this function was invoked is if the default action
         is an error action.  In that case, don't check for expected
         tokens because there are none.
       - The only way there can be no lookahead present (in yytoken) is
         if this state is a consistent state with a default action.
         Thus, detecting the absence of a lookahead is sufficient to
         determine that there is no unexpected or expected token to
         report.  In that case, just report a simple "syntax error".
       - Don't assume there isn't a lookahead just because this state is
         a consistent state with a default action.  There might have
         been a previous inconsistent state, consistent state with a
         non-default action, or user semantic action that manipulated
         yyla.  (However, yyla is currently not documented for users.)
       - Of course, the expected token list depends on states to have
         correct lookahead information, and it depends on the parser not
         to perform extra reductions after fetching a lookahead from the
         scanner and before detecting a syntax error.  Thus, state
         merging (from LALR or IELR) and default reductions corrupt the
         expected token list.  However, the list is correct for
         canonical LR with one exception: it will still contain any
         token that will not be accepted due to an error action in a
         later state.
    */
    if (yytoken != yyempty_)
      {
        yyarg[yycount++] = yytname_[yytoken];
        int yyn = yypact_[yystate];
        if (!yy_pact_value_is_default_ (yyn))
          {
            /* Start YYX at -YYN if negative to avoid negative indexes in
               YYCHECK.  In other words, skip the first -YYN actions for
               this state because they are default actions.  */
            int yyxbegin = yyn < 0 ? -yyn : 0;
            // Stay within bounds of both yycheck and yytname.
            int yychecklim = yylast_ - yyn + 1;
            int yyxend = yychecklim < yyntokens_ ? yychecklim : yyntokens_;
            for (int yyx = yyxbegin; yyx < yyxend; ++yyx)
              if (yycheck_[yyx + yyn] == yyx && yyx != yyterror_
                  && !yy_table_value_is_error_ (yytable_[yyx + yyn]))
                {
                  if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                    {
                      yycount = 1;
                      break;
                    }
                  else
                    yyarg[yycount++] = yytname_[yyx];
                }
          }
      }

    char const* yyformat = YY_NULL;
    switch (yycount)
      {
#define YYCASE_(N, S)                         \
        case N:                               \
          yyformat = S;                       \
        break
        YYCASE_(0, YY_("syntax error"));
        YYCASE_(1, YY_("syntax error, unexpected %s"));
        YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
        YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
        YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
        YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
#undef YYCASE_
      }

    // Argument number.
    size_t yyi = 0;
    for (char const* yyp = yyformat; *yyp; ++yyp)
      if (yyp[0] == '%' && yyp[1] == 's' && yyi < yycount)
        {
          yyres += yytnamerr_ (yyarg[yyi++]);
          ++yyp;
        }
      else
        yyres += *yyp;
    return yyres;
  }


  const short int parser::yypact_ninf_ = -519;

  const short int parser::yytable_ninf_ = -297;

  const short int
  parser::yypact_[] =
  {
     394,    50,   -19,    74,    59,    71,  -519,   498,  -519,   630,
    1011,  -519,   126,  -519,  -519,  -519,  -519,  -519,   630,  1096,
     -19,  1838,  -519,  -519,  -519,  1838,   619,    72,  1838,  -519,
    -519,  1838,   138,   140,  -519,  -519,  -519,  -519,   100,   428,
     319,  -519,   630,  -519,   316,  -519,   -19,  -519,  1838,   155,
      86,  -519,   210,    11,   713,  -519,  -519,  1635,   102,  -519,
    -519,  -519,   216,   226,  -519,   268,   272,   145,   498,  -519,
    1906,  -519,   165,  -519,   851,   893,   221,  1215,  -519,   344,
    -519,   346,    31,  1096,  -519,   279,  1838,   303,  -519,   933,
    -519,  2237,   301,  -519,   519,  1838,  -519,  2122,   252,   266,
     298,   728,  -519,  2237,    14,   282,   292,   -19,    86,   335,
    -519,  1838,  1838,  1838,  -519,  1838,  -519,  -519,  -519,  -519,
    -519,  1838,  1838,  -519,  1838,  1838,  1838,  1838,  1838,  1838,
    -519,  -519,  -519,   376,   503,  1715,   114,  -519,   444,  -519,
     313,   370,  -519,   103,  2097,   413,   263,  1838,  -519,  2147,
     331,   356,   391,   282,   397,  -519,  -519,   418,    33,  -519,
     473,  1492,  1215,   924,  -519,  -519,  -519,  -519,  1724,  1724,
    -519,  -519,  -519,  -519,  -519,  -519,  1724,  1724,  1759,  2237,
    1838,  -519,  -519,   463,  -519,  -519,   -19,    31,  -519,    31,
      31,  -519,    31,  -519,  -519,   454,   163,  1838,  1838,  1305,
    1225,  2002,   461,   423,  1215,   223,    36,  1838,  -519,  1838,
    2172,  -519,  -519,   439,   453,   440,  1838,  1838,  -519,  -519,
     508,   478,   502,  -519,  1838,   525,   688,   218,  1974,   505,
     505,   505,   169,   505,   688,   291,  2237,  -519,    31,  1838,
     552,  -519,   332,   560,  -519,  1265,  1158,  1954,   646,   527,
    1215,   237,    48,   109,   570,  -519,    86,  1838,   924,  -519,
    -519,   924,  2197,  -519,  -519,   555,   567,   540,   623,   574,
    1715,   632,  -519,  1838,  2237,  1215,  -519,  -519,   143,   924,
     924,  2221,  -519,  -519,   600,   600,  -519,   661,   339,  2237,
    -519,  -519,  -519,   638,  -519,   163,   678,   587,  -519,  2252,
      31,    31,    31,    31,    31,    31,    31,    31,    31,    31,
     589,   594,  -519,   684,  -519,   343,  1518,  2002,   441,  1573,
    1215,  1658,  1345,  -519,  -519,  -519,  -519,  -519,  -519,  -519,
    -519,  -519,  2237,  -519,  -519,  -519,  -519,   641,   644,   689,
     596,  2237,   657,   718,  1838,   614,   490,  2277,  2237,  1724,
    -519,  1838,  -519,  -519,  -519,   413,  -519,   377,  1435,  2050,
     459,  1599,  1215,   924,  -519,  -519,  -519,  1692,  -519,  -519,
    -519,  -519,  -519,  -519,  -519,  -519,   722,   739,  -519,   413,
    -519,  -519,  -519,   675,   680,   729,   682,   737,   392,  1715,
    2237,  -519,   924,  -519,   643,   643,   924,  -519,  1838,    31,
      31,  -519,  -519,   716,   773,   369,   734,   734,   734,   510,
     734,   773,   561,  -519,  -519,  1345,  -519,  -519,  1345,   522,
     400,  -519,  -519,  -519,  1215,  -519,  1345,  -519,   665,  -519,
     424,  -519,   777,  -519,  -519,   768,   783,  -519,   791,    30,
    -519,   629,  -519,  -519,   393,   808,  -519,  -519,   924,   625,
     538,  -519,  -519,  -519,  1215,  -519,  -519,   924,  -519,   695,
    -519,   485,  -519,  -519,  -519,   790,   803,  -519,   286,  -519,
    -519,   492,  -519,   924,   924,  -519,    40,    40,   413,   824,
     782,   163,  -519,  -519,  -519,  -519,  -519,  -519,  -519,  -519,
    -519,  -519,  1804,  1345,  -519,  -519,   758,   807,  -519,  -519,
    1724,  -519,  -519,  -519,  -519,  -519,  -519,  -519,  -519,  1812,
    -519,  -519,   758,   809,  -519,   643,   739,  -519,  -519,   924,
    -519,  -519,  -519,  -519,   829,   794,  1128,   393,  -519,   795,
    1128,    40,   413,   772,   804,   -19,  1848,  -519,  1848,  1848,
    -519,  1848,  -519,  -519,  -519,  -519,   195,   396,   323,  -519,
     217,   805,  -519,   700,  -519,  -519,  2292,  -519,   815,   749,
    -519,  -519,   821,   820,  1848,   835,  -519,  2292,   865,  -519,
     670,   457,  -519,  2292,   160,   -19,   840,  -519,  1848,   855,
    -519,  -519,  1128,  -519,   232,  1128,   232,  1838,  1848,  1848,
    1848,  1848,  1848,  1848,  1848,  1848,  1848,  1848,   845,   859,
    1128,  1848,  1848,  1848,  -519,  1848,  1848,  1848,  -519,   846,
    1848,   687,  -519,   805,  -519,    46,  -519,  -519,  -519,  2237,
     806,   766,  2022,   838,   838,   838,   616,   838,   806,  1070,
    1128,  -519,  1385,   693,   706,  2292,  -519,   723,  2292,  1848,
     733,   235,   232,  -519,  -519,  1425,   872,  -519,  -519,   386,
     745,  -519,  -519,  -519,   873,  -519,  -519,  -519
  };

  const unsigned short int
  parser::yydefact_[] =
  {
       0,    15,     0,     0,     0,     0,     2,     6,    15,   222,
       4,    17,     0,     3,     1,    13,    12,    15,   222,    10,
       0,     0,   244,   236,    61,    70,     0,     0,     0,    62,
     243,     0,     0,     0,    59,    64,    60,    63,     0,    58,
       0,   245,   222,    11,     0,   242,     0,   118,     0,     0,
       0,    85,   174,     0,     0,   117,   116,     0,     0,   114,
     115,    84,     0,     0,    16,     0,     0,     0,     5,    14,
      94,    86,   181,    97,     0,    90,     0,   132,   183,     0,
     182,     0,     0,     8,     9,     0,     0,    58,    53,     0,
     225,    67,    69,    71,     0,     0,   201,     0,     0,     0,
       0,    58,    52,    65,     0,     0,     0,     0,     0,    80,
     246,    70,     0,     0,    79,     0,    77,    75,    73,    76,
      74,     0,     0,    78,     0,     0,     0,     0,     0,     0,
     221,   223,   236,     0,    93,   150,     0,   187,     0,   186,
       0,     0,   142,     0,    94,   111,     0,     0,   193,     0,
       0,     0,     0,     0,     0,   209,   210,     0,     0,    87,
       0,     0,   132,     0,   159,   155,   156,   159,     0,     0,
     101,    99,    98,   100,   102,   103,     0,     0,    70,   130,
       0,   146,   190,   174,   184,   174,     0,     0,    36,    41,
       0,    37,     0,    34,    35,    33,   207,    70,    70,     0,
       0,     0,     0,     0,   132,     0,     0,     0,    54,    70,
       0,   174,   203,     0,     0,     0,    70,     0,    57,   274,
       0,     0,    82,   247,    70,     0,    46,    45,    42,    50,
      48,    51,    44,    49,    47,    43,   248,   224,     0,     0,
       0,   149,     0,   174,   219,     0,     0,    94,     0,     0,
     132,     0,     0,     0,     0,   211,     0,     0,   109,   138,
     143,     0,     0,   174,   195,     0,     0,     0,     0,     0,
     150,     0,    88,     0,    89,   132,   144,   106,   163,     0,
       0,    94,    95,    96,   105,   104,   140,     0,     0,   131,
     189,   188,   185,     0,    28,    38,    40,     0,    27,     0,
      41,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   262,   254,   260,     0,     0,     0,     0,     0,
     132,     0,   252,   227,   237,   228,   268,   229,   238,   230,
     241,   235,    68,    72,   174,   206,   202,     0,     0,     0,
       0,    66,     0,     0,    70,     0,    55,     0,    91,     0,
     151,    70,   218,   217,   126,   111,   124,     0,     0,     0,
       0,     0,   132,   109,   164,   175,   165,     0,   135,   166,
     176,   167,   180,   173,   179,   172,     0,   108,   110,   111,
     174,   198,   194,     0,     0,     0,     0,     0,     0,   150,
      92,   145,     0,   159,   113,   113,     0,   141,    70,    41,
       0,    29,    32,     0,    21,    20,    25,    23,    26,    19,
      24,    22,    18,    56,    55,   252,   259,   263,     0,     0,
       0,   231,   239,   232,   132,   266,   252,   264,   254,   257,
       0,   249,   251,   269,   205,     0,     0,   199,    55,     0,
     226,     0,    81,   208,   111,     0,   123,   127,     0,     0,
       0,   168,   177,   169,   132,   133,   154,   109,   128,   111,
     121,     0,   212,   139,   197,     0,     0,   191,     0,   220,
     152,     0,   107,     0,     0,   157,   160,   161,   111,     0,
       0,    39,    30,   253,   261,   233,   240,   234,   267,   255,
     256,   265,     0,     0,   204,   200,   215,     0,    83,   147,
       0,   125,   170,   178,   171,   134,   119,   120,   129,     0,
     196,   192,   215,     0,   153,   113,   112,   158,   137,     0,
      31,   258,   250,   214,   216,     0,     0,   111,   122,     0,
       0,   162,   111,     0,     0,     0,     0,   316,   325,     0,
     317,     0,   314,   319,   315,   318,     0,   313,     0,   275,
       0,   283,   285,     0,   287,   291,   289,   148,     0,     0,
     136,   213,     0,     0,     0,   313,   308,   322,   324,   326,
       0,   313,   307,   320,     0,     0,   293,   292,   325,     0,
     276,   277,     0,   174,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   325,   325,     0,   309,   325,   325,     0,   312,   295,
     325,     0,   272,   284,   279,     0,   281,   286,   288,   290,
     301,   300,   297,   305,   303,   306,   299,   304,   302,   298,
       0,   270,     0,     0,     0,   323,   327,     0,   321,   325,
       0,   310,     0,   278,   174,     0,     0,   311,   310,   310,
       0,   294,   282,   280,     0,   273,   296,   271
  };

  const short int
  parser::yypgoto_[] =
  {
    -519,  -519,  -519,   889,    35,    42,   311,  -519,    -2,   -22,
    -519,  -275,   603,  -519,  -299,   -81,   -99,   -25,     5,    -8,
     636,  -167,   828,  -519,  -162,  -331,  -326,  -371,    -6,   398,
    -519,   460,  -519,  -219,  -128,  -213,  -519,  -519,   -12,  -519,
    -519,  -243,   778,  -519,   -51,  -147,  -519,  -519,  -180,  -519,
    -519,  -519,  -519,   405,    44,  -519,   786,  -519,   -83,  -519,
    -157,   493,   432,  -519,   509,  -519,  -182,  -165,  -519,   767,
    -492,  -518,  -519,  -519,   347,   341,  -519,  -484,   382,   299,
    -519,  -519,   326,  -407
  };

  const short int
  parser::yydefgoto_[] =
  {
      -1,     3,     6,     7,     8,     9,    10,    69,    87,   295,
     296,   297,    91,   104,    92,    93,    94,   180,    71,   277,
      73,    74,   176,    75,   377,   378,   259,   476,   202,   460,
     461,   356,   357,   250,   181,   251,   288,   146,    77,    78,
     241,   242,    79,   253,   517,   279,    80,   138,   139,    81,
      42,    13,   524,   525,    43,    89,    90,    44,    45,   432,
     433,   416,   429,   430,   314,   315,   204,   205,   206,   220,
     548,   549,   615,   550,   551,   552,   553,   554,   555,   556,
     574,   568,   569,   570
  };

  const short int
  parser::yytable_[] =
  {
      12,   278,    72,   291,    76,   292,   203,    39,    39,   284,
     285,    72,   225,    76,    41,   129,    39,    39,    85,   320,
     280,   167,   428,    41,   477,   403,   101,   388,   362,   446,
     580,   336,   456,   360,   276,   318,   109,   186,   559,   187,
      39,   580,    17,   110,   133,   161,   145,    41,   109,    18,
      -7,   140,    39,   463,   240,   136,   642,   271,   162,    11,
     196,   330,    84,   353,    76,   109,   188,   217,   459,   496,
     189,   643,   159,   372,    14,    72,   326,    76,   218,   644,
     195,    39,   497,   382,    15,    98,   130,    39,   190,   331,
     107,   191,   141,   165,    41,   192,    16,   287,   310,   311,
     616,   373,   618,    17,   166,   222,   109,   193,   632,    11,
      18,    11,   194,   223,   580,   150,   313,   340,   499,   257,
       4,     5,   368,   243,   480,   345,   506,   580,   333,    99,
     248,    82,   249,   507,   374,   320,    39,   424,   645,   244,
     362,   109,   454,   107,   531,   449,   471,   391,   159,   275,
     100,   419,   518,   392,   434,    76,   109,   107,   652,   151,
     107,    39,   375,   272,    11,   294,   301,   302,   298,   157,
     299,   611,   112,   113,   163,   164,   319,   105,    11,   106,
     152,    11,   444,   108,   293,   195,   256,   195,   195,   240,
     195,   135,   425,   428,   633,   634,   165,    39,    39,   637,
     464,   557,   107,   640,    41,   110,   560,   166,   303,   304,
     459,   305,   306,   607,   121,   122,   347,   124,   165,   307,
     308,   112,   361,    11,   608,   126,   127,   393,   158,   166,
     309,   454,   650,   327,   455,   137,   195,   355,   424,   431,
     249,   249,   581,    39,    39,   441,   473,   369,   328,   582,
     583,   159,   575,   379,   109,   153,    39,   178,   483,    39,
    -294,   272,   370,   121,   122,   154,   124,  -294,  -294,   489,
     445,   394,   395,    11,   126,   127,   329,    39,    39,   404,
     405,   406,   407,   408,   409,   410,   411,   412,  -294,   575,
     371,   584,   420,   155,   112,   113,   488,   156,   195,   195,
     195,   195,   195,   195,   195,   195,   195,   195,   240,  -294,
      11,   207,   516,   260,    39,   546,   261,   479,   197,    19,
      39,   223,   112,   113,   114,   512,   505,    41,    83,   535,
     213,   536,   431,   527,   450,   313,   121,   122,   513,   124,
     125,   131,   198,   431,   214,   115,   116,   126,   127,   132,
     117,   118,   249,   249,   215,   249,    39,   119,   537,   120,
     219,    39,   538,   272,   121,   122,   123,   124,   125,   182,
     221,   184,   301,   579,   224,   126,   127,   183,   481,   185,
     539,   238,   350,   540,   472,   351,   128,   541,   478,   397,
      39,   254,   398,   417,    39,   255,   418,   195,   195,   542,
     543,    11,   258,   614,   544,   545,   546,   168,   169,   265,
     522,  -296,    47,    39,   303,   304,    39,   305,  -296,  -296,
      41,  -293,   258,    41,    39,   307,   308,   447,  -293,  -293,
     448,    41,   322,   323,   266,   578,   199,   -80,   -80,  -296,
     355,    55,   470,    56,   249,   351,    39,   267,   324,  -293,
      20,   421,    21,   -80,   270,    39,    47,    48,    59,    60,
    -296,   -80,     1,     2,   653,   515,   422,   111,    49,   451,
    -293,    39,    39,    51,   491,   269,   325,   492,   -80,    24,
     245,   -80,  -295,    25,   452,    55,   273,    56,   290,  -295,
    -295,    39,   -80,   300,   423,   337,   606,   321,    41,   -81,
     -81,    28,    59,    60,    29,    61,   112,   113,    31,   338,
    -295,   532,   453,   301,   302,   -81,   339,    39,   342,   239,
      34,    35,    11,   -81,   547,    36,    37,   246,   547,   115,
     343,  -295,   485,   563,   565,   508,   565,   571,   509,   565,
     -81,   344,   514,   -81,   576,   351,   547,   486,   121,   122,
      47,   124,   125,   124,   -81,   303,   304,   547,   305,   126,
     127,   349,   565,   367,   301,   302,   307,   308,     4,     5,
     128,   208,   209,   609,   245,   487,   565,   346,   209,    55,
     547,    56,   576,   547,   576,   352,   565,   565,   565,   565,
     565,   565,   565,   565,   565,   565,    59,    60,   547,   565,
     565,   565,   376,   565,   565,   565,   303,   304,   565,   305,
     306,   383,    40,    70,   168,   169,   385,   307,   308,   588,
     589,    40,    70,   384,    88,    20,   387,    21,   547,    97,
     547,   102,    95,   386,   103,   502,    20,   565,    21,   401,
     576,   413,   209,   547,    96,    40,   414,   209,   438,   209,
     503,   134,   474,   475,    24,   363,   364,   144,    25,    22,
     149,   591,   592,    23,   593,    24,   442,   209,   389,    25,
     396,   365,   595,   596,   415,   207,    86,   399,   504,    29,
     179,   498,   209,    31,    26,    27,    70,    28,   400,   102,
      29,    30,   201,   415,    31,    34,    35,    11,   210,   366,
      36,    37,    32,    33,   258,   207,    34,    35,    11,   586,
     587,    36,    37,    38,   437,   226,   227,   435,   228,    20,
     436,    21,   604,   605,   229,   230,    48,   231,   232,   233,
     234,   235,   236,   121,   122,   439,   124,   -82,   -82,   641,
     605,   247,    51,   440,   126,   647,   605,   462,    24,   392,
     262,   465,    25,   -82,   467,   535,   466,   536,   648,   605,
     468,   -82,   469,   142,   274,   179,   144,   216,   482,   588,
      28,   281,   281,    29,    61,   649,   605,    31,   -82,   281,
     281,   -82,   305,   289,   537,   651,   605,   493,   538,    34,
      35,    11,   -82,   494,    36,    37,   143,   656,   605,   599,
     -83,   -83,    40,   317,   282,   283,   539,   179,   495,   540,
     332,   591,   592,   541,   593,   510,   -83,   500,   303,   304,
     341,   305,   595,   596,   -83,   542,   543,    11,   511,   307,
     544,   545,   546,   519,   520,   566,   523,   567,   572,   533,
     573,   -83,   348,   526,   -83,   530,   534,   558,   144,   359,
     561,   591,   592,   179,   593,   -83,   562,   600,   585,   601,
     274,   144,   595,   572,   144,   168,   169,   598,   170,   171,
     172,   173,   174,   175,   602,   603,   390,   567,   179,   610,
     612,   630,   144,   144,   631,   639,   593,   620,   621,   622,
     623,   624,   625,   626,   627,   628,   629,   655,   657,    68,
     567,   567,   635,   177,   567,   567,   638,   528,   501,   567,
     170,   171,   172,   173,   174,   175,   252,   529,   237,   317,
     268,   490,   236,   179,   521,    40,   617,   484,   577,   613,
      20,   636,    21,     0,     0,     0,     0,    48,   567,    20,
       0,    21,     0,     0,     0,    47,     0,     0,     0,     0,
       0,     0,   281,    51,     0,     0,     0,     0,     0,    24,
       0,   359,    22,    25,   274,   179,   144,     0,    24,   199,
       0,     0,    25,     0,    55,     0,    56,     0,     0,     0,
       0,    28,     0,     0,    29,    61,     0,     0,    31,     0,
      28,    59,    60,    29,    30,   144,     0,    31,     0,   144,
      34,    35,    11,     0,     0,    36,    37,   143,     0,    34,
      35,    11,     0,     0,    36,    37,   200,    20,    40,    21,
       0,    40,    46,    47,    48,     0,     0,   179,     0,    40,
       0,     0,     0,     0,     0,    49,     0,     0,     0,    50,
      51,     0,     0,     0,    52,    53,    24,    54,     0,     0,
      25,   144,    55,     0,    56,     0,     0,   179,     0,     0,
     144,     0,     0,     0,     0,    57,    58,     0,    28,    59,
      60,    29,    61,   588,   589,    31,   144,   144,     0,     0,
       0,     4,     5,    62,    63,     0,    64,    34,    35,    11,
      65,    66,    36,    37,    67,     0,    40,     0,     0,     0,
       0,     0,    20,   281,    21,     0,     0,    46,    47,    48,
       0,     0,     0,     0,     0,   591,   592,     0,   593,   594,
      49,     0,   144,     0,    50,    51,   595,   596,     0,    52,
      53,    24,    54,     0,   535,    25,   536,    55,     0,    56,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      57,    58,     0,    28,    59,    60,    29,    61,     0,     0,
      31,     0,     0,   537,    20,     0,    21,   538,    62,    63,
      47,    64,    34,    35,    11,    65,    66,    36,    37,    67,
       0,     0,   157,     0,     0,   539,     0,     0,   540,     0,
     619,     0,   541,    24,   245,     0,     0,    25,     0,    55,
       0,    56,     0,     0,   542,   543,    11,     0,     0,   544,
     545,   546,     0,     0,     0,    28,    59,    60,    29,     0,
     114,    20,    31,    21,     0,     0,     0,     0,     0,     0,
       0,    20,     0,    21,    34,    35,    11,    47,     0,    36,
      37,   358,   116,     0,     0,     0,   117,   118,     0,     0,
      24,     0,     0,   119,    25,   120,     0,     0,     0,     0,
      24,   199,   123,     0,    25,     0,    55,     0,    56,     0,
       0,    20,    86,    21,     0,    29,     0,     0,    48,    31,
       0,     0,    28,    59,    60,    29,     0,     0,     0,    31,
       0,    34,    35,    11,    51,     0,    36,    37,     0,     0,
      24,    34,    35,    11,    25,     0,    36,    37,   316,     0,
       0,    20,     0,    21,     0,   354,     0,     0,     0,     0,
       0,     0,    28,     0,     0,    29,    61,     0,     0,    31,
       0,     0,     0,     0,    22,     0,     0,     0,     0,     0,
      24,    34,    35,    11,    25,     0,    36,    37,   143,     0,
       0,    20,     0,    21,     0,   312,     0,     0,     0,     0,
       0,     0,    28,     0,     0,    29,    30,     0,     0,    31,
       0,     0,     0,     0,    22,     0,     0,     0,     0,     0,
      24,    34,    35,    11,    25,     0,    36,    37,    38,     0,
       0,   535,     0,   536,     0,     0,     0,     0,     0,     0,
       0,     0,    28,     0,     0,    29,    30,     0,     0,    31,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     537,    34,    35,    11,   538,     0,    36,    37,    38,     0,
       0,   535,     0,   536,     0,   646,     0,     0,     0,     0,
       0,    20,   539,    21,     0,   540,     0,    47,     0,   541,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   271,
     537,   542,   543,    11,   538,     0,   544,   545,   546,     0,
      24,   245,     0,     0,    25,   654,    55,     0,    56,     0,
       0,     0,   539,     0,     0,   540,     0,     0,     0,   541,
       0,     0,    28,    59,    60,    29,     0,     0,    20,    31,
      21,   542,   543,    11,    47,     0,   544,   545,   546,     0,
       0,    34,    35,    11,     0,     0,    36,    37,     0,     0,
       0,     0,     0,     0,    20,     0,    21,    24,    54,     0,
      47,    25,     0,    55,     0,    56,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    86,
      59,    60,    29,    24,   199,     0,    31,    25,     0,    55,
       0,    56,     0,     0,     0,     0,     0,     0,    34,    35,
      11,     0,     0,    36,    37,    28,    59,    60,    29,    20,
       0,    21,    31,     0,     0,    47,     0,     0,     0,     0,
       0,     0,     0,     0,    34,    35,    11,     0,     0,    36,
      37,     0,     0,     0,     0,    20,     0,    21,    24,   199,
       0,    47,    25,     0,    55,     0,    56,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      86,    59,    60,    29,    24,   245,     0,    31,    25,     0,
      55,    20,    56,    21,     0,     0,     0,     0,   147,    34,
      35,    11,     0,     0,    36,    37,    86,    59,    60,    29,
     148,     0,     0,    31,    20,     0,    21,   426,     0,     0,
      24,     0,     0,     0,    25,    34,    35,    11,     0,     0,
      36,    37,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    86,    24,     0,    29,     0,    25,    20,    31,
      21,   457,     0,     0,     0,     0,     0,     0,   427,     0,
       0,    34,    35,    11,     0,    86,    36,    37,    29,     0,
       0,    20,    31,    21,   -70,     0,     0,    24,     0,     0,
      20,    25,    21,     0,    34,    35,    11,    48,     0,    36,
      37,     0,   458,     0,     0,     0,     0,     0,     0,    86,
      24,     0,    29,     0,    25,     0,    31,     0,     0,    24,
       0,     0,     0,    25,     0,    20,     0,    21,    34,    35,
      11,     0,    86,    36,    37,    29,     0,     0,     0,    31,
       0,    86,     0,     0,    29,     0,     0,     0,    31,     0,
       0,    34,    35,    11,    24,     0,    36,    37,    25,     0,
      34,    35,    11,     0,     0,    36,    37,     0,     0,   286,
      20,     0,    21,   426,     0,     0,    86,     0,    20,    29,
      21,   457,     0,    31,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,    34,    35,    11,     0,    24,
      36,    37,     0,    25,    20,     0,    21,    24,     0,     0,
       0,    25,     0,     0,   535,     0,   536,     0,     0,     0,
       0,    86,     0,     0,    29,     0,     0,     0,    31,    86,
       0,     0,    29,    24,     0,     0,    31,    25,     0,     0,
      34,    35,    11,   537,     0,    36,    37,   538,    34,    35,
      11,     0,     0,    36,    37,    86,     0,     0,    29,     0,
       0,     0,    31,     0,     0,   564,     0,     0,   540,   112,
     113,   114,   541,     0,    34,    35,    11,     0,    47,    36,
      37,     0,   160,     0,   542,   543,    11,     0,     0,   544,
     545,     0,   115,   116,     0,     0,     0,   117,   118,     0,
       0,     0,    54,     0,   119,     0,   120,    55,     0,    56,
       0,   121,   122,   123,   124,   125,     0,   112,   113,   114,
       0,     0,   126,   127,    59,    60,    47,     0,     0,     0,
     160,     0,     0,   128,     0,     0,     0,   112,   113,     0,
     115,   116,     0,     0,     0,   117,   118,     0,     0,     0,
     245,     0,   119,     0,   120,    55,     0,    56,     0,   121,
     122,   123,   124,   125,     0,   112,   113,   114,     0,     0,
     126,   127,    59,    60,    47,     0,     0,     0,     0,   121,
     122,   128,   124,   125,     0,   588,   589,     0,   115,   116,
     126,   127,     0,   117,   118,     0,     0,     0,   199,     0,
     119,   128,   120,    55,     0,    56,     0,   121,   122,   123,
     124,   125,     0,   112,   113,   114,     0,     0,   126,   127,
      59,    60,    47,     0,     0,     0,     0,   591,   592,   128,
     593,   594,     0,     0,     0,     0,   115,   116,   595,   596,
       0,   117,   118,     0,     0,     0,   245,     0,   119,   597,
     120,    55,     0,    56,     0,   121,   122,   123,   124,   125,
     112,   113,   114,     0,     0,     0,   126,   127,    59,    60,
       0,     0,     0,   160,     0,     0,     0,   128,     0,     0,
       0,     0,     0,   115,   116,   112,   113,     0,   117,   118,
       0,   211,     0,     0,     0,   119,     0,   120,     0,     0,
       0,     0,   121,   122,   123,   124,   125,   212,   115,     0,
     112,   113,     0,   126,   127,     0,   263,     0,     0,     0,
       0,     0,     0,     0,   128,     0,     0,   121,   122,     0,
     124,   125,   264,   115,     0,   112,   113,     0,   126,   127,
       0,   334,     0,     0,     0,     0,     0,     0,     0,   128,
       0,     0,   121,   122,     0,   124,   125,   335,   115,     0,
     112,   113,     0,   126,   127,     0,   380,     0,     0,     0,
       0,     0,     0,     0,   128,     0,     0,   121,   122,     0,
     124,   125,   381,   115,   112,   113,     0,     0,   126,   127,
       0,     0,     0,     0,     0,     0,     0,   160,     0,   128,
     112,   113,   121,   122,     0,   124,   125,   115,     0,     0,
       0,     0,     0,   126,   127,   301,   302,     0,     0,     0,
       0,     0,     0,   115,   128,     0,   121,   122,     0,   124,
     125,     0,     0,     0,     0,     0,     0,   126,   127,     0,
     301,   302,   121,   122,     0,   124,   125,     0,   128,     0,
       0,     0,     0,   126,   127,   588,   589,   303,   304,     0,
     305,   306,   443,     0,   128,     0,     0,     0,   307,   308,
       0,     0,     0,     0,     0,     0,   402,     0,   590,   309,
       0,     0,   303,   304,     0,   305,   306,     0,     0,     0,
       0,     0,     0,   307,   308,     0,     0,   591,   592,     0,
     593,   594,     0,     0,   309,     0,     0,     0,   595,   596,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   597
  };

  const short int
  parser::yycheck_[] =
  {
       2,   163,    10,   183,    10,   185,    89,     9,    10,   176,
     177,    19,   111,    19,     9,    40,    18,    19,    20,   201,
     167,    72,   321,    18,   395,   300,    28,   270,   247,   355,
     548,   211,   363,   246,   162,   200,    38,     6,   530,     8,
      42,   559,     7,    38,    46,    70,    54,    42,    50,     7,
       0,    40,    54,   379,   135,    50,    10,    24,    70,    78,
      82,    25,    18,   243,    70,    67,    35,    53,   367,    39,
      39,    25,    67,    25,     0,    83,   204,    83,    64,    33,
      82,    83,    52,   263,    25,    13,    42,    89,    57,    53,
      57,    60,    81,    53,    89,    64,    25,   178,   197,   198,
     584,    53,   586,    68,    64,   107,   108,    76,   600,    78,
      68,    78,    81,   108,   632,    13,   199,   216,   444,   144,
      70,    71,   250,     9,   399,   224,   457,   645,   209,    57,
     138,     5,   138,   459,    25,   317,   138,   319,   630,    25,
     359,   143,   361,    57,   515,   358,   389,   275,   143,   161,
      78,   316,   478,    10,   334,   161,   158,    57,   642,    57,
      57,   163,    53,   158,    78,   187,     3,     4,   190,    24,
     192,   578,     3,     4,     9,    10,   201,    39,    78,    39,
      78,    78,   349,    83,   186,   187,    83,   189,   190,   270,
     192,    36,   320,   492,   601,   602,    53,   199,   200,   606,
     380,   527,    57,   610,   199,   200,   532,    64,    45,    46,
     509,    48,    49,    53,    45,    46,   238,    48,    53,    56,
      57,     3,   247,    78,    64,    56,    57,   278,    83,    64,
      67,   450,   639,    10,   362,    25,   238,   245,   420,   322,
     246,   247,    25,   245,   246,   344,   393,    10,    25,    32,
      33,   246,    57,   261,   256,    39,   258,    36,   415,   261,
      25,   256,    25,    45,    46,    39,    48,    32,    33,   426,
     351,   279,   280,    78,    56,    57,    53,   279,   280,   301,
     302,   303,   304,   305,   306,   307,   308,   309,    53,    57,
      53,    74,   317,    25,     3,     4,   424,    25,   300,   301,
     302,   303,   304,   305,   306,   307,   308,   309,   389,    74,
      78,    10,   474,    50,   316,    83,    53,   398,    39,     8,
     322,   316,     3,     4,     5,    39,   454,   322,    17,     6,
      78,     8,   415,   500,   359,   418,    45,    46,    52,    48,
      49,    25,    39,   426,    78,    26,    27,    56,    57,    33,
      31,    32,   358,   359,    56,   361,   358,    38,    35,    40,
      78,   363,    39,   358,    45,    46,    47,    48,    49,    25,
      78,    25,     3,    50,    39,    56,    57,    33,   400,    33,
      57,     5,    50,    60,   392,    53,    67,    64,   396,    50,
     392,    78,    53,    50,   396,    25,    53,   399,   400,    76,
      77,    78,     9,   583,    81,    82,    83,    14,    15,    78,
     493,    25,    12,   415,    45,    46,   418,    48,    32,    33,
     415,    25,     9,   418,   426,    56,    57,    50,    32,    33,
      53,   426,     9,    10,    78,    39,    36,     9,    10,    53,
     448,    41,    50,    43,   450,    53,   448,    56,    25,    53,
       6,    10,     8,    25,    36,   457,    12,    13,    58,    59,
      74,    33,    68,    69,   644,   473,    25,    39,    24,    10,
      74,   473,   474,    29,    50,    78,    53,    53,    50,    35,
      36,    53,    25,    39,    25,    41,    13,    43,    25,    32,
      33,   493,    64,    39,    53,    56,    39,    36,   493,     9,
      10,    57,    58,    59,    60,    61,     3,     4,    64,    56,
      53,   519,    53,     3,     4,    25,    76,   519,    10,    16,
      76,    77,    78,    33,   526,    81,    82,    83,   530,    26,
      52,    74,    10,   535,   536,    50,   538,   539,    53,   541,
      50,    39,    50,    53,   546,    53,   548,    25,    45,    46,
      12,    48,    49,    48,    64,    45,    46,   559,    48,    56,
      57,     9,   564,    36,     3,     4,    56,    57,    70,    71,
      67,    52,    53,   575,    36,    53,   578,    52,    53,    41,
     582,    43,   584,   585,   586,    25,   588,   589,   590,   591,
     592,   593,   594,   595,   596,   597,    58,    59,   600,   601,
     602,   603,    32,   605,   606,   607,    45,    46,   610,    48,
      49,    56,     9,    10,    14,    15,    76,    56,    57,     3,
       4,    18,    19,    56,    21,     6,    52,     8,   630,    26,
     632,    28,    13,    10,    31,    10,     6,   639,     8,    52,
     642,    52,    53,   645,    25,    42,    52,    53,    52,    53,
      25,    48,     9,    10,    35,     9,    10,    54,    39,    29,
      57,    45,    46,    33,    48,    35,    52,    53,    36,    39,
       9,    25,    56,    57,     9,    10,    57,    39,    53,    60,
      77,    52,    53,    64,    54,    55,    83,    57,    10,    86,
      60,    61,    89,     9,    64,    76,    77,    78,    95,    53,
      81,    82,    72,    73,     9,    10,    76,    77,    78,     9,
      10,    81,    82,    83,    25,   112,   113,    76,   115,     6,
      76,     8,    52,    53,   121,   122,    13,   124,   125,   126,
     127,   128,   129,    45,    46,    78,    48,     9,    10,    52,
      53,   138,    29,    25,    56,    52,    53,    25,    35,    10,
     147,    76,    39,    25,    25,     6,    76,     8,    52,    53,
      78,    33,    25,    50,   161,   162,   163,    39,    52,     3,
      57,   168,   169,    60,    61,    52,    53,    64,    50,   176,
     177,    53,    48,   180,    35,    52,    53,    10,    39,    76,
      77,    78,    64,    25,    81,    82,    83,    52,    53,    50,
       9,    10,   199,   200,   168,   169,    57,   204,    25,    60,
     207,    45,    46,    64,    48,    25,    25,     9,    45,    46,
     217,    48,    56,    57,    33,    76,    77,    78,    25,    56,
      81,    82,    83,     9,    52,   536,    78,   538,   539,    10,
     541,    50,   239,    36,    53,    36,    52,    52,   245,   246,
      78,    45,    46,   250,    48,    64,    52,    36,    53,    39,
     257,   258,    56,   564,   261,    14,    15,    52,    17,    18,
      19,    20,    21,    22,    39,    10,   273,   578,   275,    39,
      25,    36,   279,   280,    25,    39,    48,   588,   589,   590,
     591,   592,   593,   594,   595,   596,   597,    25,    25,    10,
     601,   602,   603,    75,   605,   606,   607,   509,   448,   610,
      17,    18,    19,    20,    21,    22,   138,   512,   132,   316,
     153,   428,   319,   320,   492,   322,   585,   418,   546,   582,
       6,   605,     8,    -1,    -1,    -1,    -1,    13,   639,     6,
      -1,     8,    -1,    -1,    -1,    12,    -1,    -1,    -1,    -1,
      -1,    -1,   349,    29,    -1,    -1,    -1,    -1,    -1,    35,
      -1,   358,    29,    39,   361,   362,   363,    -1,    35,    36,
      -1,    -1,    39,    -1,    41,    -1,    43,    -1,    -1,    -1,
      -1,    57,    -1,    -1,    60,    61,    -1,    -1,    64,    -1,
      57,    58,    59,    60,    61,   392,    -1,    64,    -1,   396,
      76,    77,    78,    -1,    -1,    81,    82,    83,    -1,    76,
      77,    78,    -1,    -1,    81,    82,    83,     6,   415,     8,
      -1,   418,    11,    12,    13,    -1,    -1,   424,    -1,   426,
      -1,    -1,    -1,    -1,    -1,    24,    -1,    -1,    -1,    28,
      29,    -1,    -1,    -1,    33,    34,    35,    36,    -1,    -1,
      39,   448,    41,    -1,    43,    -1,    -1,   454,    -1,    -1,
     457,    -1,    -1,    -1,    -1,    54,    55,    -1,    57,    58,
      59,    60,    61,     3,     4,    64,   473,   474,    -1,    -1,
      -1,    70,    71,    72,    73,    -1,    75,    76,    77,    78,
      79,    80,    81,    82,    83,    -1,   493,    -1,    -1,    -1,
      -1,    -1,     6,   500,     8,    -1,    -1,    11,    12,    13,
      -1,    -1,    -1,    -1,    -1,    45,    46,    -1,    48,    49,
      24,    -1,   519,    -1,    28,    29,    56,    57,    -1,    33,
      34,    35,    36,    -1,     6,    39,     8,    41,    -1,    43,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      54,    55,    -1,    57,    58,    59,    60,    61,    -1,    -1,
      64,    -1,    -1,    35,     6,    -1,     8,    39,    72,    73,
      12,    75,    76,    77,    78,    79,    80,    81,    82,    83,
      -1,    -1,    24,    -1,    -1,    57,    -1,    -1,    60,    -1,
     587,    -1,    64,    35,    36,    -1,    -1,    39,    -1,    41,
      -1,    43,    -1,    -1,    76,    77,    78,    -1,    -1,    81,
      82,    83,    -1,    -1,    -1,    57,    58,    59,    60,    -1,
       5,     6,    64,     8,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,     6,    -1,     8,    76,    77,    78,    12,    -1,    81,
      82,    83,    27,    -1,    -1,    -1,    31,    32,    -1,    -1,
      35,    -1,    -1,    38,    39,    40,    -1,    -1,    -1,    -1,
      35,    36,    47,    -1,    39,    -1,    41,    -1,    43,    -1,
      -1,     6,    57,     8,    -1,    60,    -1,    -1,    13,    64,
      -1,    -1,    57,    58,    59,    60,    -1,    -1,    -1,    64,
      -1,    76,    77,    78,    29,    -1,    81,    82,    -1,    -1,
      35,    76,    77,    78,    39,    -1,    81,    82,    83,    -1,
      -1,     6,    -1,     8,    -1,    50,    -1,    -1,    -1,    -1,
      -1,    -1,    57,    -1,    -1,    60,    61,    -1,    -1,    64,
      -1,    -1,    -1,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      35,    76,    77,    78,    39,    -1,    81,    82,    83,    -1,
      -1,     6,    -1,     8,    -1,    50,    -1,    -1,    -1,    -1,
      -1,    -1,    57,    -1,    -1,    60,    61,    -1,    -1,    64,
      -1,    -1,    -1,    -1,    29,    -1,    -1,    -1,    -1,    -1,
      35,    76,    77,    78,    39,    -1,    81,    82,    83,    -1,
      -1,     6,    -1,     8,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    57,    -1,    -1,    60,    61,    -1,    -1,    64,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      35,    76,    77,    78,    39,    -1,    81,    82,    83,    -1,
      -1,     6,    -1,     8,    -1,    50,    -1,    -1,    -1,    -1,
      -1,     6,    57,     8,    -1,    60,    -1,    12,    -1,    64,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    24,
      35,    76,    77,    78,    39,    -1,    81,    82,    83,    -1,
      35,    36,    -1,    -1,    39,    50,    41,    -1,    43,    -1,
      -1,    -1,    57,    -1,    -1,    60,    -1,    -1,    -1,    64,
      -1,    -1,    57,    58,    59,    60,    -1,    -1,     6,    64,
       8,    76,    77,    78,    12,    -1,    81,    82,    83,    -1,
      -1,    76,    77,    78,    -1,    -1,    81,    82,    -1,    -1,
      -1,    -1,    -1,    -1,     6,    -1,     8,    35,    36,    -1,
      12,    39,    -1,    41,    -1,    43,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    57,
      58,    59,    60,    35,    36,    -1,    64,    39,    -1,    41,
      -1,    43,    -1,    -1,    -1,    -1,    -1,    -1,    76,    77,
      78,    -1,    -1,    81,    82,    57,    58,    59,    60,     6,
      -1,     8,    64,    -1,    -1,    12,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    76,    77,    78,    -1,    -1,    81,
      82,    -1,    -1,    -1,    -1,     6,    -1,     8,    35,    36,
      -1,    12,    39,    -1,    41,    -1,    43,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      57,    58,    59,    60,    35,    36,    -1,    64,    39,    -1,
      41,     6,    43,     8,    -1,    -1,    -1,    -1,    13,    76,
      77,    78,    -1,    -1,    81,    82,    57,    58,    59,    60,
      25,    -1,    -1,    64,     6,    -1,     8,     9,    -1,    -1,
      35,    -1,    -1,    -1,    39,    76,    77,    78,    -1,    -1,
      81,    82,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    57,    35,    -1,    60,    -1,    39,     6,    64,
       8,     9,    -1,    -1,    -1,    -1,    -1,    -1,    50,    -1,
      -1,    76,    77,    78,    -1,    57,    81,    82,    60,    -1,
      -1,     6,    64,     8,     9,    -1,    -1,    35,    -1,    -1,
       6,    39,     8,    -1,    76,    77,    78,    13,    -1,    81,
      82,    -1,    50,    -1,    -1,    -1,    -1,    -1,    -1,    57,
      35,    -1,    60,    -1,    39,    -1,    64,    -1,    -1,    35,
      -1,    -1,    -1,    39,    -1,     6,    -1,     8,    76,    77,
      78,    -1,    57,    81,    82,    60,    -1,    -1,    -1,    64,
      -1,    57,    -1,    -1,    60,    -1,    -1,    -1,    64,    -1,
      -1,    76,    77,    78,    35,    -1,    81,    82,    39,    -1,
      76,    77,    78,    -1,    -1,    81,    82,    -1,    -1,    50,
       6,    -1,     8,     9,    -1,    -1,    57,    -1,     6,    60,
       8,     9,    -1,    64,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    76,    77,    78,    -1,    35,
      81,    82,    -1,    39,     6,    -1,     8,    35,    -1,    -1,
      -1,    39,    -1,    -1,     6,    -1,     8,    -1,    -1,    -1,
      -1,    57,    -1,    -1,    60,    -1,    -1,    -1,    64,    57,
      -1,    -1,    60,    35,    -1,    -1,    64,    39,    -1,    -1,
      76,    77,    78,    35,    -1,    81,    82,    39,    76,    77,
      78,    -1,    -1,    81,    82,    57,    -1,    -1,    60,    -1,
      -1,    -1,    64,    -1,    -1,    57,    -1,    -1,    60,     3,
       4,     5,    64,    -1,    76,    77,    78,    -1,    12,    81,
      82,    -1,    16,    -1,    76,    77,    78,    -1,    -1,    81,
      82,    -1,    26,    27,    -1,    -1,    -1,    31,    32,    -1,
      -1,    -1,    36,    -1,    38,    -1,    40,    41,    -1,    43,
      -1,    45,    46,    47,    48,    49,    -1,     3,     4,     5,
      -1,    -1,    56,    57,    58,    59,    12,    -1,    -1,    -1,
      16,    -1,    -1,    67,    -1,    -1,    -1,     3,     4,    -1,
      26,    27,    -1,    -1,    -1,    31,    32,    -1,    -1,    -1,
      36,    -1,    38,    -1,    40,    41,    -1,    43,    -1,    45,
      46,    47,    48,    49,    -1,     3,     4,     5,    -1,    -1,
      56,    57,    58,    59,    12,    -1,    -1,    -1,    -1,    45,
      46,    67,    48,    49,    -1,     3,     4,    -1,    26,    27,
      56,    57,    -1,    31,    32,    -1,    -1,    -1,    36,    -1,
      38,    67,    40,    41,    -1,    43,    -1,    45,    46,    47,
      48,    49,    -1,     3,     4,     5,    -1,    -1,    56,    57,
      58,    59,    12,    -1,    -1,    -1,    -1,    45,    46,    67,
      48,    49,    -1,    -1,    -1,    -1,    26,    27,    56,    57,
      -1,    31,    32,    -1,    -1,    -1,    36,    -1,    38,    67,
      40,    41,    -1,    43,    -1,    45,    46,    47,    48,    49,
       3,     4,     5,    -1,    -1,    -1,    56,    57,    58,    59,
      -1,    -1,    -1,    16,    -1,    -1,    -1,    67,    -1,    -1,
      -1,    -1,    -1,    26,    27,     3,     4,    -1,    31,    32,
      -1,     9,    -1,    -1,    -1,    38,    -1,    40,    -1,    -1,
      -1,    -1,    45,    46,    47,    48,    49,    25,    26,    -1,
       3,     4,    -1,    56,    57,    -1,     9,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    67,    -1,    -1,    45,    46,    -1,
      48,    49,    25,    26,    -1,     3,     4,    -1,    56,    57,
      -1,     9,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    67,
      -1,    -1,    45,    46,    -1,    48,    49,    25,    26,    -1,
       3,     4,    -1,    56,    57,    -1,     9,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    67,    -1,    -1,    45,    46,    -1,
      48,    49,    25,    26,     3,     4,    -1,    -1,    56,    57,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    16,    -1,    67,
       3,     4,    45,    46,    -1,    48,    49,    26,    -1,    -1,
      -1,    -1,    -1,    56,    57,     3,     4,    -1,    -1,    -1,
      -1,    -1,    -1,    26,    67,    -1,    45,    46,    -1,    48,
      49,    -1,    -1,    -1,    -1,    -1,    -1,    56,    57,    -1,
       3,     4,    45,    46,    -1,    48,    49,    -1,    67,    -1,
      -1,    -1,    -1,    56,    57,     3,     4,    45,    46,    -1,
      48,    49,    25,    -1,    67,    -1,    -1,    -1,    56,    57,
      -1,    -1,    -1,    -1,    -1,    -1,    64,    -1,    26,    67,
      -1,    -1,    45,    46,    -1,    48,    49,    -1,    -1,    -1,
      -1,    -1,    -1,    56,    57,    -1,    -1,    45,    46,    -1,
      48,    49,    -1,    -1,    67,    -1,    -1,    -1,    56,    57,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    67
  };

  const unsigned char
  parser::yystos_[] =
  {
       0,    68,    69,    85,    70,    71,    86,    87,    88,    89,
      90,    78,    92,   135,     0,    25,    25,    88,    89,    90,
       6,     8,    29,    33,    35,    39,    54,    55,    57,    60,
      61,    64,    72,    73,    76,    77,    81,    82,    83,    92,
      96,   102,   134,   138,   141,   142,    11,    12,    13,    24,
      28,    29,    33,    34,    36,    41,    43,    54,    55,    58,
      59,    61,    72,    73,    75,    79,    80,    83,    87,    91,
      96,   102,   103,   104,   105,   107,   112,   122,   123,   126,
     130,   133,     5,    90,   138,    92,    57,    92,    96,   139,
     140,    96,    98,    99,   100,    13,    25,    96,    13,    57,
      78,    92,    96,    96,    97,    39,    39,    57,    83,    92,
     102,    39,     3,     4,     5,    26,    27,    31,    32,    38,
      40,    45,    46,    47,    48,    49,    56,    57,    67,   101,
     138,    25,    33,    92,    96,    36,   102,    25,   131,   132,
      40,    81,    50,    83,    96,   103,   121,    13,    25,    96,
      13,    57,    78,    39,    39,    25,    25,    24,    83,   102,
      16,   101,   122,     9,    10,    53,    64,   128,    14,    15,
      17,    18,    19,    20,    21,    22,   106,   106,    36,    96,
     101,   118,    25,    33,    25,    33,     6,     8,    35,    39,
      57,    60,    64,    76,    81,    92,    93,    39,    39,    36,
      83,    96,   112,   142,   150,   151,   152,    10,    52,    53,
      96,     9,    25,    78,    78,    56,    39,    53,    64,    78,
     153,    78,    92,   102,    39,   100,    96,    96,    96,    96,
      96,    96,    96,    96,    96,    96,    96,   140,     5,    16,
      99,   124,   125,     9,    25,    36,    83,    96,   103,   112,
     117,   119,   126,   127,    78,    25,    83,   101,     9,   110,
      50,    53,    96,     9,    25,    78,    78,    56,   153,    78,
      36,    24,   102,    13,    96,   122,   118,   103,   108,   129,
     129,    96,   104,   104,   105,   105,    50,    99,   120,    96,
      25,   132,   132,    92,    93,    93,    94,    95,    93,    93,
      39,     3,     4,    45,    46,    48,    49,    56,    57,    67,
     100,   100,    50,   142,   148,   149,    83,    96,   151,   101,
     150,    36,     9,    10,    25,    53,   118,    10,    25,    53,
      25,    53,    96,    99,     9,    25,   132,    56,    56,    76,
     100,    96,    10,    52,    39,   100,    52,    93,    96,     9,
      50,    53,    25,   132,    50,   103,   115,   116,    83,    96,
     119,   101,   117,     9,    10,    25,    53,    36,   118,    10,
      25,    53,    25,    53,    25,    53,    32,   108,   109,   103,
       9,    25,   132,    56,    56,    76,    10,    52,   125,    36,
      96,   118,    10,   128,   103,   103,     9,    50,    53,    39,
      10,    52,    64,    95,    93,    93,    93,    93,    93,    93,
      93,    93,    93,    52,    52,     9,   145,    50,    53,   151,
     101,    10,    25,    53,   150,   118,     9,    50,    98,   146,
     147,   142,   143,   144,   132,    76,    76,    25,    52,    78,
      25,   100,    52,    25,   105,    99,   110,    50,    53,   119,
     101,    10,    25,    53,   117,   118,   109,     9,    50,    98,
     113,   114,    25,   110,   132,    76,    76,    25,    78,    25,
      50,   125,   103,   129,     9,    10,   111,   111,   103,    99,
      95,    93,    52,   144,   148,    10,    25,    53,   118,   144,
     145,    50,    53,    10,    25,    25,    39,    52,    52,   110,
       9,   115,    10,    25,    53,   118,   109,   110,    50,    53,
      25,    25,    39,    52,    50,   103,   108,   128,   110,     9,
      52,   146,   142,    78,   136,   137,    36,   105,   113,   137,
      36,   111,   103,    10,    52,     6,     8,    35,    39,    57,
      60,    64,    76,    77,    81,    82,    83,    92,   154,   155,
     157,   158,   159,   160,   161,   162,   163,   110,    52,   154,
     110,    78,    52,    92,    57,    92,   163,   163,   165,   166,
     167,    92,   163,   163,   164,    57,    92,   162,    39,    50,
     155,    25,    32,    33,    74,    53,     9,    10,     3,     4,
      26,    45,    46,    48,    49,    56,    57,    67,    52,    50,
      36,    39,    39,    10,    52,    53,    39,    53,    64,    92,
      39,   167,    25,   158,   132,   156,   161,   159,   161,    96,
     163,   163,   163,   163,   163,   163,   163,   163,   163,   163,
      36,    25,   154,   167,   167,   163,   166,   167,   163,    39,
     167,    52,    10,    25,    33,   154,    50,    52,    52,    52,
     167,    52,   161,   132,    50,    25,    52,    25
  };

  const unsigned char
  parser::yyr1_[] =
  {
       0,    84,    85,    85,    86,    86,    86,    86,    87,    87,
      87,    87,    88,    89,    90,    90,    91,    92,    93,    93,
      93,    93,    93,    93,    93,    93,    93,    93,    93,    93,
      93,    93,    93,    93,    93,    93,    93,    93,    94,    94,
      95,    95,    96,    96,    96,    96,    96,    96,    96,    96,
      96,    96,    96,    96,    96,    96,    96,    96,    96,    96,
      96,    96,    96,    96,    96,    97,    97,    98,    98,    99,
      99,   100,   100,   101,   101,   101,   101,   101,   101,   101,
     102,   102,   102,   102,   103,   103,   103,   103,   103,   103,
     103,   104,   104,   104,   104,   105,   105,   105,   106,   106,
     106,   106,   106,   106,   107,   107,   108,   108,   109,   109,
     110,   110,   111,   111,   112,   112,   112,   112,   112,   113,
     113,   114,   114,   115,   116,   116,   117,   117,   117,   117,
     118,   118,   118,   119,   119,   119,   120,   120,   121,   121,
     122,   122,   122,   122,   123,   123,   123,   124,   124,   125,
     125,   126,   126,   126,   127,   128,   128,   129,   129,   129,
     130,   130,   130,   130,   131,   131,   131,   131,   131,   131,
     131,   131,   131,   131,   131,   132,   132,   132,   132,   132,
     132,   133,   133,   133,    91,    91,    91,    91,    91,    91,
      91,    91,    91,    91,    91,    91,    91,    91,    91,   134,
     134,   134,   134,   134,   134,   134,   134,   135,    91,    91,
      91,    91,    91,   136,   136,   137,   137,    91,    91,    91,
      91,   138,   138,   134,   134,   134,   134,   139,   139,   139,
     139,   139,   139,   139,   139,   139,   139,   140,   140,   140,
     140,   140,   141,   142,   142,   142,   142,   142,   142,   143,
     143,   144,   144,   145,   145,   146,   146,   147,   147,   148,
     149,   149,   150,   150,   150,   150,   151,   151,   151,   152,
      91,    91,   134,   134,   153,   154,   154,   155,   155,   155,
     155,   156,   156,   157,   157,   158,   158,   159,   159,   160,
     160,   161,   161,   162,   162,   162,   162,   163,   163,   163,
     163,   163,   163,   163,   163,   163,   163,   163,   163,   163,
     163,   163,   163,   163,   163,   163,   163,   163,   163,   163,
     164,   164,   165,   165,   166,   166,   167,   167
  };

  const unsigned char
  parser::yyr2_[] =
  {
       0,     2,     2,     2,     1,     2,     1,     0,     3,     3,
       2,     2,     2,     2,     2,     0,     1,     1,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     2,     2,     3,
       4,     5,     3,     1,     1,     1,     1,     1,     1,     3,
       1,     0,     3,     3,     3,     3,     3,     3,     3,     3,
       3,     3,     2,     2,     3,     4,     5,     3,     1,     1,
       1,     1,     1,     1,     1,     1,     3,     1,     3,     1,
       0,     1,     3,     1,     1,     1,     1,     1,     1,     1,
       1,     4,     2,     5,     1,     1,     1,     2,     3,     3,
       1,     4,     4,     2,     1,     3,     3,     1,     1,     1,
       1,     1,     1,     1,     3,     3,     1,     3,     1,     0,
       2,     0,     2,     0,     1,     1,     1,     1,     1,     2,
       2,     1,     3,     2,     1,     3,     2,     3,     3,     4,
       1,     2,     0,     3,     4,     2,     6,     4,     2,     4,
       3,     4,     2,     3,     3,     4,     2,     4,     6,     1,
       0,     4,     5,     6,     3,     1,     1,     3,     4,     0,
       5,     5,     7,     3,     3,     3,     3,     3,     4,     4,
       5,     5,     3,     3,     0,     3,     3,     4,     5,     3,
       3,     1,     1,     1,     2,     3,     2,     2,     3,     3,
       2,     5,     6,     2,     4,     3,     6,     5,     4,     5,
       6,     2,     4,     3,     6,     5,     4,     3,     5,     2,
       2,     3,     5,     3,     1,     0,     1,     4,     4,     3,
       5,     2,     0,     2,     3,     2,     5,     3,     3,     3,
       3,     4,     4,     5,     5,     3,     0,     3,     3,     4,
       5,     3,     1,     1,     1,     1,     2,     3,     3,     1,
       3,     1,     0,     2,     0,     2,     2,     1,     3,     2,
       1,     3,     2,     3,     3,     4,     3,     4,     2,     3,
      10,    13,    10,    13,     1,     1,     2,     2,     4,     3,
       5,     1,     3,     1,     3,     1,     3,     1,     3,     1,
       3,     1,     2,     1,     4,     2,     5,     3,     3,     3,
       3,     3,     3,     3,     3,     3,     3,     2,     2,     3,
       4,     5,     3,     1,     1,     1,     1,     1,     1,     1,
       1,     3,     1,     3,     1,     0,     1,     3
  };



  // YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
  // First, the terminals, then, starting at \a yyntokens_, nonterminals.
  const char*
  const parser::yytname_[] =
  {
  "\"<EOF>\"", "error", "$undefined", "\"+\"", "\"&\"", "\"=\"", "\"@\"",
  "\"#base\"", "\"~\"", "\":\"", "\",\"", "\"#const\"", "\"#count\"",
  "\"$\"", "\"$+\"", "\"$-\"", "\"$*\"", "\"$<=\"", "\"$<\"", "\"$>\"",
  "\"$>=\"", "\"$=\"", "\"$!=\"", "\"#cumulative\"", "\"#disjoint\"",
  "\".\"", "\"..\"", "\"==\"", "\"#external\"", "\"#false\"",
  "\"#forget\"", "\">=\"", "\">\"", "\":-\"", "\"#include\"", "\"#inf\"",
  "\"{\"", "\"[\"", "\"<=\"", "\"(\"", "\"<\"", "\"#max\"",
  "\"#maximize\"", "\"#min\"", "\"#minimize\"", "\"\\\\\"", "\"*\"",
  "\"!=\"", "\"**\"", "\"?\"", "\"}\"", "\"]\"", "\")\"", "\";\"",
  "\"#show\"", "\"#showsig\"", "\"/\"", "\"-\"", "\"#sum\"", "\"#sum+\"",
  "\"#sup\"", "\"#true\"", "UBNOT", "UMINUS", "\"|\"", "\"#volatile\"",
  "\":~\"", "\"^\"", "\"<program>\"", "\"<define>\"", "\"preference\"",
  "\"#program\"", "\"#preference\"", "\"#optimize\"", "\"||\"",
  "\"error\"", "\"<NUMBER>\"", "\"<ANONYMOUS>\"", "\"<IDENTIFIER>\"",
  "\"<PYTHON>\"", "\"<LUA>\"", "\"<STRING>\"", "\"<VARIABLE>\"", "\"not\"",
  "$accept", "start", "blocksstart", "blocks", "pblock", "oblock",
  "program", "statement", "identifier", "constterm", "consttermvec",
  "constargvec", "term", "unaryargvec", "ntermvec", "termvec", "argvec",
  "cmp", "atom", "literal", "csp_mul_term", "csp_add_term", "csp_rel",
  "csp_literal", "nlitvec", "litvec", "optcondition", "noptcondition",
  "aggregatefunction", "bodyaggrelem", "bodyaggrelemvec",
  "altbodyaggrelem", "altbodyaggrelemvec", "bodyaggregate", "upper",
  "lubodyaggregate", "headaggrelemvec", "altheadaggrelemvec",
  "headaggregate", "luheadaggregate", "ncspelemvec", "cspelemvec",
  "disjoint", "conjunction", "dsym", "disjunctionsep", "disjunction",
  "bodycomma", "bodydot", "head", "ostatement", "define", "nidlist",
  "idlist", "oprogram", "obodycomma", "obodydot", "ohead", "oliteral",
  "onlitvec", "olitvec", "ooptcondition", "obodyaggrelem",
  "obodyaggrelemvec", "oaltbodyaggrelem", "oaltbodyaggrelemvec",
  "obodyaggregate", "olubodyaggregate", "oconjunction", "prefident",
  "prefcontent", "prefelem", "pcond", "phead", "pwtermset", "pwterm",
  "weights", "pterm", "pvaratom", "pvarterm", "pvarunaryargvec",
  "pvarntermvec", "pvartermvec", "pvarargvec", YY_NULL
  };

#if PREFATORNONGROUNDGRAMMAR_DEBUG
  const unsigned short int
  parser::yyrline_[] =
  {
       0,   287,   287,   288,   292,   293,   294,   295,   299,   300,
     301,   302,   306,   310,   314,   315,   319,   323,   332,   333,
     334,   335,   336,   337,   338,   339,   340,   341,   342,   343,
     344,   345,   346,   347,   348,   349,   350,   351,   357,   358,
     362,   363,   371,   372,   373,   374,   375,   376,   377,   378,
     379,   380,   381,   382,   383,   384,   385,   386,   387,   388,
     389,   390,   391,   392,   393,   399,   400,   407,   408,   412,
     413,   417,   418,   427,   428,   429,   430,   431,   432,   433,
     437,   438,   439,   440,   444,   445,   446,   447,   448,   449,
     450,   454,   455,   456,   457,   461,   462,   463,   467,   468,
     469,   470,   471,   472,   476,   477,   485,   486,   490,   491,
     495,   496,   500,   501,   505,   506,   507,   508,   509,   517,
     518,   522,   523,   529,   533,   534,   540,   541,   542,   543,
     547,   548,   549,   553,   554,   555,   563,   564,   568,   569,
     575,   576,   577,   578,   582,   583,   584,   591,   592,   596,
     597,   601,   602,   603,   610,   617,   618,   622,   623,   624,
     629,   630,   631,   632,   641,   642,   643,   644,   645,   646,
     647,   648,   649,   650,   651,   655,   656,   657,   658,   659,
     660,   664,   665,   666,   670,   671,   672,   673,   680,   681,
     682,   689,   690,   691,   692,   693,   694,   695,   696,   700,
     701,   702,   703,   704,   705,   706,   707,   713,   717,   724,
     725,   732,   733,   740,   741,   745,   746,   754,   755,   756,
     767,   773,   774,   778,   779,   780,   781,   786,   787,   788,
     789,   790,   791,   792,   793,   794,   795,   799,   800,   801,
     802,   803,   808,   822,   823,   824,   825,   826,   827,   833,
     834,   838,   839,   843,   844,   852,   853,   856,   857,   863,
     867,   868,   873,   874,   875,   876,   881,   882,   883,   890,
     898,   899,   903,   904,   908,   914,   915,   920,   921,   922,
     923,   928,   929,   936,   937,   942,   943,   950,   951,   955,
     956,   960,   961,   968,   969,   970,   971,   978,   979,   980,
     981,   982,   983,   984,   985,   986,   987,   988,   989,   990,
     991,   992,   993,   994,   995,   996,   997,   998,   999,  1000,
    1005,  1006,  1013,  1014,  1018,  1019,  1023,  1024
  };

  // Print the state stack on the debug stream.
  void
  parser::yystack_print_ ()
  {
    *yycdebug_ << "Stack now";
    for (stack_type::const_iterator
           i = yystack_.begin (),
           i_end = yystack_.end ();
         i != i_end; ++i)
      *yycdebug_ << ' ' << i->state;
    *yycdebug_ << std::endl;
  }

  // Report on the debug stream that the rule \a yyrule is going to be reduced.
  void
  parser::yy_reduce_print_ (int yyrule)
  {
    unsigned int yylno = yyrline_[yyrule];
    int yynrhs = yyr2_[yyrule];
    // Print the symbols being reduced, and their result.
    *yycdebug_ << "Reducing stack by rule " << yyrule - 1
               << " (line " << yylno << "):" << std::endl;
    // The symbols being reduced.
    for (int yyi = 0; yyi < yynrhs; yyi++)
      YY_SYMBOL_PRINT ("   $" << yyi + 1 << " =",
                       yystack_[(yynrhs) - (yyi + 1)]);
  }
#endif // PREFATORNONGROUNDGRAMMAR_DEBUG

  // Symbol number corresponding to token number t.
  inline
  parser::token_number_type
  parser::yytranslate_ (int t)
  {
    static
    const token_number_type
    translate_table[] =
    {
     0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83
    };
    const unsigned int user_token_number_max_ = 338;
    const token_number_type undef_token_ = 2;

    if (static_cast<int>(t) <= yyeof_)
      return yyeof_;
    else if (static_cast<unsigned int> (t) <= user_token_number_max_)
      return translate_table[t];
    else
      return undef_token_;
  }

#line 22 "libprefator/src/input/nongroundgrammar.yy" // lalr1.cc:1156
} } } // Prefator::Input::NonGroundGrammar
#line 2954 "build/release/libprefator/src/input/nongroundgrammar/grammar.cc" // lalr1.cc:1156
