// {{{ GPL License 

// This file is part of prefator - a preference program translator.
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

#ifndef _PREFATOR_INPUT_NONGROUNDPARSER_HH
#define _PREFATOR_INPUT_NONGROUNDPARSER_HH

#include <prefator/input/programbuilder.hh>
#include <gringo/locatable.hh>
#include <gringo/lexerstate.hh>
#include <memory>
#include <iosfwd>
#include <set>
#include <algorithm>

namespace Prefator { namespace Input {

// {{{ declaration of NonGroundParser

using StringVec = std::vector<std::string>;
using IdVec = std::vector<std::pair<Location, FWString>>;

class NonGroundParser : private LexerState<std::pair<FWString, std::pair<FWString, IdVec>>> {
public:
    NonGroundParser(PrefNongroundProgramBuilder &pb);
    void parseError(Location const &loc, std::string const &token);
    void pushFile(std::string &&filename);
    void pushStream(std::string &&name, std::unique_ptr<std::istream>);
    void pushBlocks(StringVec &&blocks);
    int lex(void *pValue, Location &loc);
    bool parseDefine(std::string const &define);
    bool parse();
    void include(unsigned sUid, Location const &loc,bool include);
    PrefNongroundProgramBuilder &builder();
	void finalprint(std::ostream &stream);
	void printfile(std::ostream &stream);
	void prt();
	void prt(int toktype);
	void prt(std::string t); 
	void prt(bool b);
	void stDot();
	void releaseLine(bool b);
	void releaseLine();
	void releaseCur(bool b);
	void deleteLit();
	void oprogram();
	

    ~NonGroundParser();

private:
    int lex_impl(void *pValue, Location &loc);
    void lexerError(std::string const &token);
    bool push(std::string const &filename, bool include = false);
    bool push(std::string const &file, std::unique_ptr<std::istream> in);
    void pop();
    FWString filename() const;

private:
    std::set<std::string> filenames_;
    unsigned not_;
    PrefNongroundProgramBuilder &pb_;
	bool pmain_ = 0;
	bool prt_ = 1;
	bool lastprt_ = 1;
	bool firstToken_ = 1;
	unsigned par_ = 0;
	unsigned brace_ = 0;

    int           _startSymbol;
    StringVec     _blocks;
    FWString      _filename;

};

// }}}

} } // namespace Input Prefator

#endif // _PREFATOR_INPUT_NONGROUNDPARSER_HH
