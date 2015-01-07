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

#include "prefator/input/nongroundparser.hh"
#include "gringo/lexerstate.hh"
#include "gringo/value.hh"
#include "gringo/logger.hh"
#include "input/nongroundgrammar/grammar.hh"
#include <cstddef>
#include <climits>
#include <memory>
#include <fstream>
#include <vector>
#include <algorithm>
#include <iostream>

namespace Prefator { namespace Input {

// {{{ defintion of NonGroundParser

NonGroundParser::NonGroundParser(PrefNongroundProgramBuilder &pb)
    : not_(FWString::uid("not"))
    , pb_(pb)
	, pmain_(0)
    , _startSymbol(0) { }
	 

void NonGroundParser::parseError(Location const &loc, std::string const &msg) {

    	GRINGO_REPORT(ERROR) << loc << ": error: " << msg << "\n";
}

void NonGroundParser::lexerError(std::string const &token) {

	GRINGO_REPORT(ERROR) << filename() << ":" << line() << ":" << column() << ": error: lexer error, unexpected " << token << "\n";
}

bool NonGroundParser::push(std::string const &filename, bool include) {
    return (include && !empty()) ? 
        LexerState::push(filename, {filename, LexerState::data().second}) : 
        LexerState::push(filename, {filename, {"base", {}}});
}

bool NonGroundParser::push(std::string const &filename, std::unique_ptr<std::istream> in) {
    FWString data = filename;
    return LexerState::push(std::move(in), {data, {"base", {}}});
}

void NonGroundParser::pop() { LexerState::pop(); }

FWString NonGroundParser::filename() const { return LexerState::data().first; }

void NonGroundParser::pushFile(std::string &&file) {
	
    auto res = filenames_.insert(std::forward<std::string>(file));
    if (!res.second) {
        GRINGO_REPORT(W_FILE_INCLUDED) << "<cmd>: warning: already included file:\n"
            << "  " << *res.first << "\n";
    }
    if (!push(*res.first)) {
        GRINGO_REPORT(ERROR) << "<cmd>: error: '" << *res.first << "' file could not be opened\n";
    }

	// reset last state
	
	prt_ = 1;
	pb_.resetOP();
}

void NonGroundParser::pushStream(std::string &&file, std::unique_ptr<std::istream> in) {
    auto res = filenames_.insert(std::move(file));
    if (!res.second) {
        GRINGO_REPORT(W_FILE_INCLUDED) << "<cmd>: warning: already included file:\n"
            << "  " << *res.first << "\n";
    }
    if (!push(*res.first, std::move(in))) {
        GRINGO_REPORT(ERROR) << "<cmd>: error: '" << *res.first << "' file could not be opened\n";
    }
}

void NonGroundParser::pushBlocks(StringVec &&blocks) {
    for (auto &block : blocks) { 
        push("<block>", make_unique<std::istringstream>(block));
    }
}

int NonGroundParser::lex(void *pValue, Location &loc) {
    if (_startSymbol) {
        auto ret = _startSymbol;
        _startSymbol = 0;
        return ret;
    }
    while (!empty()) {
        int minor = lex_impl(pValue, loc);

		// handle buffer releasing
		if (minor != NonGroundGrammar::parser::token::DOT && firstToken_) { 
				// lex_impl sets prt_, but we want to know whether last state of prt_ (lastprt_) was true
				if (lastprt_) { releaseLine(true); } 
				else { releaseLine(prt_); } 
				firstToken_ = 0; 
		}
		// print token with type of minor
		prt(minor);
		lastprt_ = prt_; 
        loc.endFilename = filename();
        loc.endLine     = line();
        loc.endColumn   = column();
        if (minor) { return minor; }
        else	   { pop(); }
    }
    return 0;
}

void NonGroundParser::include(unsigned sUid, Location const &loc, bool inbuilt) {
    if (inbuilt) {
        if (sUid == FWString("iclingo").uid()) {
            push("<iclingo>", make_unique<std::istringstream>(
R"(
#script (lua) 

function get(val, default)
    if val ~= nil then 
        return val 
    else 
        return default 
    end
end

function main(prg)
    imin   = get(prg:getConst("imin"), 1)
    imax   = prg:getConst("imax")
    istop  = get(prg:getConst("istop"), "SAT")
    iquery = get(prg:getConst("iquery"), 1)
    step   = 1

    prg:ground("base", {})
    while true do
        if imax ~= nil and step > imax then break end
        prg:ground("cumulative", {step})
        ret = gringo.SolveResult.UNKNOWN
        if step >= iquery then
            if step > iquery then
                prg:releaseExternal(gringo.Fun("query", {step-1}))
            end
            prg:assignExternal(gringo.Fun("query", {step}), true)
            prg:ground("volatile", {step})
            ret = prg:solve()
        end
        if step >= imin and ((istop == "SAT" and ret == gringo.SolveResult.SAT) or (istop == "UNSAT" and ret == gringo.SolveResult.UNSAT)) then
            break
        end
        step = step+1
    end
end
#end.
)"
            ));
        }
        else {
            GRINGO_REPORT(ERROR) << loc << ": error: '" << *FWString(sUid) << "' file could not be opened\n";
        }
    }
    else {
        auto res = filenames_.insert(*FWString(sUid));
        if (!res.second) {
            GRINGO_REPORT(W_FILE_INCLUDED) << loc << ": warning: already included file:\n"
                << "  " << *res.first << "\n";
        }
        if (!push(*res.first, true)) {
#if defined _WIN32 || defined __WIN32__ || defined __EMX__ || defined __DJGPP__
            const char *SLASH = "\\";
#else
            const char *SLASH = "/";
#endif
            size_t slash = (*loc.beginFilename).find_last_of(SLASH);
            if (slash != std::string::npos) {
                std::string path = (*loc.beginFilename).substr(0, slash + 1);
                auto res2 = filenames_.insert(path + *res.first);
                if (!res2.second) {
                    GRINGO_REPORT(W_FILE_INCLUDED) << loc << ": warning: already included file:\n"
                        << "  " << *res2.first << "\n";
                }
                if (!push(*res2.first, true)) {
                    GRINGO_REPORT(ERROR) << loc << ": error: '" << *res2.first << "' file could not be opened\n";
                }
            }
            else {
                GRINGO_REPORT(ERROR) << loc << ": error: '" << *res.first << "' file could not be opened\n";
            }
        }
    }
}

bool NonGroundParser::parseDefine(std::string const &define) {
    pushStream("<" + define + ">", make_unique<std::stringstream>(define));
    _startSymbol = NonGroundGrammar::parser::token::PARSE_DEF;
    NonGroundGrammar::parser parser(this);
    auto ret = parser.parse();
    filenames_.clear();
    return ret == 0;
}

bool NonGroundParser::parse() {

	// reset parser flags
	prt_ = 1;
	lastprt_ = 1;

	par_ = 0;	
	brace_ = 0;
	firstToken_ = 1;

    _startSymbol = NonGroundGrammar::parser::token::PARSE_LP;
    Prefator::Input::NonGroundGrammar::parser parser(this);
	auto ret = parser.parse();
	filenames_.clear();
	return ret == 0;

}

PrefNongroundProgramBuilder &NonGroundParser::builder() { return pb_; }



void NonGroundParser::prt() {
	pb_.token(string(), DEFAULTSTR);
}

void NonGroundParser::prt(int toktype){
	switch(toktype){
		case NonGroundGrammar::parser::token::PBLOCK:
			pb_.token(string(), PBLOCK);
			break;
		case NonGroundGrammar::parser::token::DOT:
			pb_.token(string(), DOT);
			break;
		default:
			prt();
	}
}

void NonGroundParser::prt(std::string t){
	pb_.token(t, DEFAULTSTR);
}

void NonGroundParser::prt(bool b){

	prt_ = b;

}

void NonGroundParser::stDot(){
	releaseLine(); prt(true); pb_.setStatementType(StType::PELEM);
}

void NonGroundParser::releaseLine() {
	pb_.releaseLine(prt_);
}

void NonGroundParser::releaseLine(bool b) {
	pb_.releaseLine(b);
}

void NonGroundParser::releaseCur(bool b) {
	pb_.releaseCur(b);
}


void NonGroundParser::deleteLit(){
	pb_.deleteLit();
}

void NonGroundParser::oprogram() {
	pb_.lastP(DO);
	pb_.token("#program preference(m1,m2).", DEFAULTSTR);
}


NonGroundParser::~NonGroundParser() { }

// }}}

} } // namespace Input Prefator


#include "input/nongroundlexer.hh"


