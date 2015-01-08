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

#ifndef _PREFATOR_INPUT_PROGRAMBUILDER_HH
#define _PREFATOR_INPUT_PROGRAMBUILDER_HH

//#include <gringo/input/programbuilder.hh>
#include <prefator/input/olitval.hh>
#include <gringo/flyweight.hh>
//#include <gringo/value.hh>
#include <gringo/base.hh>

#include <vector>
#include <memory>
#include <sstream>
#include <iostream>
#include <climits>
#include <unordered_map>
#include <unistd.h>


namespace Prefator { namespace Input {


// {{{ declaration of PrefNongroundProgramBuilder
using namespace Gringo;

// {{{ declaration of unique ids of program elements

enum IdVecUid         : unsigned { };
enum TermUid          : unsigned { };
enum TermVecUid       : unsigned { };
enum TermVecVecUid    : unsigned { };
enum LitUid           : unsigned { };
enum LitVecUid        : unsigned { };
enum PrefIdentUid		: unsigned { };
enum PrefElemUid        : unsigned { };
enum PrefElemVecUid     : unsigned { };
enum PrefVarUid		    : unsigned { };
enum PrefVarVecUid		: unsigned { };
enum LitKeyUid 			: unsigned { };
enum LitKeyVecUid		: unsigned { };
enum CSPAddTermUid    : unsigned { };
enum CSPMulTermUid    : unsigned { };
enum CSPLitUid        : unsigned { };
enum PROGRAM			: unsigned { SP, DO, SC, DC };
enum StStrType			: unsigned { LITNAME, LITTERMVEC, DEFAULTSTR, PBLOCK, DOT};
enum StType 			: unsigned { OCONSTRAINT, OFACT, ORULE, NEWFILE, OSELEM, OPTST, PELEM };

struct StString {
    std::string str;
    StStrType   type;
};

std::ostream &operator<<(std::ostream &out, StString const &x);

struct StStringVec {
    std::vector<StString>   strvec;
    StType                  type;
	bool contains(StStrType key) { for ( auto it : strvec) if (it.type == key) return true; return false; }
};

std::ostream &operator<<(std::ostream &out, StStringVec const &x);


class PrefNongroundProgramBuilder {
public:
	PrefNongroundProgramBuilder(char holdsopt);

    // {{{ terms
    virtual TermUid term(Value val);
    virtual TermUid term(FWString name);
    virtual TermUid term(bool anonymous);
    virtual TermUid term(UnOp op, TermUid a);
    virtual TermUid term(UnOp op, TermVecUid a);
    virtual TermUid term(BinOp op, TermUid a, TermUid b);
    virtual TermUid term(TermUid a, TermUid b);
    virtual TermUid term(FWString name, TermVecVecUid b, bool lua);
    // }}}
	
    // {{{ id vectors
    virtual IdVecUid idvec();
    virtual IdVecUid idvec(IdVecUid uid, FWString id);
    // }}}
    // {{{ csp
    virtual CSPMulTermUid cspmulterm(TermUid coe, TermUid var);
    virtual CSPMulTermUid cspmulterm(TermUid coe);
    virtual CSPAddTermUid cspaddterm(CSPAddTermUid a, CSPMulTermUid b, bool add);
    virtual CSPAddTermUid cspaddterm(CSPMulTermUid a);
    virtual LitUid csplit(CSPLitUid a);
    virtual CSPLitUid csplit(CSPLitUid a, Relation rel, CSPAddTermUid b);
    virtual CSPLitUid csplit(CSPAddTermUid a, Relation rel, CSPAddTermUid b);
    // }}}
    // {{{ term vectors
    virtual TermVecUid termvec();
    virtual TermVecUid termvec(TermVecUid uid, TermUid term);
    // }}}
    // {{{ term vector vectors
    virtual TermVecVecUid termvecvec();
    virtual TermVecVecUid termvecvec(TermVecVecUid uid, TermVecUid termvecUid);
    // }}}
    // {{{ literals
    virtual LitUid boollit(bool type);
    virtual LitUid predlit(NAF naf, bool neg, FWString name, TermVecVecUid argvecvecUid);
    virtual LitUid rellit(Relation rel, TermUid termUidLeft, TermUid termUidRight);
    // }}}
    // {{{ literal vectors
    virtual LitVecUid litvec();
    virtual LitVecUid litvec(LitVecUid uid, LitUid literalUid);
    // }}}
    // {{{ preferences
	virtual void prefmain(FWString name, bool inP);
	// {{{ preference statements S
	virtual PrefVarUid prefvar();
	virtual PrefVarUid prefvar(PrefVarUid uid, FWString var);
	virtual PrefVarUid prefvar(PrefVarUid uid, PrefVarUid mergeuid);
	virtual TermUid preflit(NAF naf, FWString name, TermVecVecUid tvvUid);
	virtual TermUid weightedterm(TermVecUid weights, TermUid term);
	virtual PrefElemUid prefelem(TermVecVecUid head, TermVecUid cond, bool hasBd, PrefVarUid vars);
	virtual PrefElemVecUid prefcontent();
	virtual PrefElemVecUid prefcontent(PrefElemVecUid uid, PrefElemUid elem);
	virtual PrefIdentUid prefident(FWString name);
	virtual void prefstatement(PrefIdentUid name,FWString type, IdVecUid args, PrefElemVecUid uid, bool inP);
	// }}}

	// {{{ preference program O
	virtual void prefolit(FWString name, TermVecVecUid tvvUid);
	virtual LitKeyUid litkey(FWString name, TermVecVecUid tvvUid);
	virtual LitKeyUid litkey();
	virtual LitKeyVecUid litkeyvec();
	virtual LitKeyVecUid litkeyvec(LitKeyVecUid uid, LitKeyUid key);
	virtual LitKeyVecUid litkeyvec(LitKeyVecUid uid, LitKeyVecUid mergeuid);
	virtual void litkeys(LitKeyUid hd, LitKeyVecUid bd);
	virtual void buildD();
	virtual void buildD(std::vector<OLitVal*> effectsOn);
	// }}}
	
	// {{{ logic program P
	virtual void holds(LitUid head);
	// }}}

    // }}}

    std::vector<StStringVec> getOP();
    std::string strHpr();

	virtual void lastP(PROGRAM lp);
	virtual void token(std::string tok, StStrType type);
	virtual void setStatementType(StType type);
	virtual void releaseLine(bool b);
	virtual void releaseCur(bool b);
	virtual void deleteLit();
	virtual void resetOP();
	virtual void dpostprocess(std::vector<StStringVec> input, std::vector<std::string> &fileoutret, std::string &unconret);
	virtual void processOStatement(StStringVec &st,std::stringstream &fileout, std::stringstream &uncon, bool &nfpb);

    virtual ~PrefNongroundProgramBuilder();


private:
    // {{{ typedefs
    typedef std::vector<std::string> StringVec;
    typedef std::vector<StringVec> StringVecVec;
	typedef std::vector<StringVecVec> StringVecVecVec;
    typedef std::pair<std::string, std::string> StringPair;
    typedef std::vector<StringPair> StringPairVec;
    typedef std::vector<TermVecUid> TermVecUidVec;
	typedef std::vector<PrefIdentUid> PrefIdentUidVec;

    typedef Indexed<StringVec, IdVecUid> IdVecs;
    typedef Indexed<std::string, TermUid> Terms;
    typedef Indexed<StringVec, TermVecUid> TermVecs;
    typedef Indexed<StringVecVec, TermVecVecUid> TermVecVecs;
    typedef Indexed<std::string, LitUid> Lits;
    typedef Indexed<StringVec, LitVecUid> LitVecs;
    typedef Indexed<std::string, CSPAddTermUid> CSPAddTerms;
    typedef Indexed<std::string, CSPMulTermUid> CSPMulTerms;
    typedef Indexed<std::string, CSPLitUid> CSPLits;
	typedef Indexed<std::set<std::string>, PrefVarUid> PrefVars;
	typedef Indexed<StringVec, PrefElemUid> PrefElems;
	typedef Indexed<StringVecVec, PrefElemVecUid> PrefElemVecs;
	typedef Indexed<std::string, PrefIdentUid> PrefIdents;
	typedef Indexed<std::string, LitKeyUid> LitKeys;
	typedef Indexed<StringVec, LitKeyVecUid> LitKeyVecs;

    // }}}
    // {{{ auxiliary functions
    std::string print(StringVec const &vec, char const *sep);
    std::string oprint(StringVec const &vec, char const *sep);
    std::string print(StringVecVec const &vec);
    std::string print(NAF naf);
    // }}}
    // {{{ member variables
    IdVecs idvecs_;
    Terms terms_;
    TermVecs termvecs_;
    TermVecVecs termvecvecs_;
    Lits lits_;
    LitVecs litvecs_;
    CSPAddTerms cspaddterms_;
    CSPMulTerms cspmulterms_;
    CSPLits csplits_;
	PrefIdents prefidents_;
	PrefIdentUidVec prefidentsvecs_;
	PrefElems prefelems_;
	PrefElemVecs prefelemvecs_;
	PrefVars prefvars_;
	LitKeys litkeys_;
	LitKeyVecs litkeyvecs_;

	std::vector<StStringVec> prog_;
	std::stringstream hprprog_;
	std::vector<StString> current_;
	std::vector<StString> statement_;
	StType sttype_ = PELEM;
	
	std::unordered_map<std::string,OLitVal*> litmap_;
	
	char holdsopt_;
	bool existOpt_ = false;
	bool existS_ = false;
	PROGRAM lastP_ = SP;

	
    // }}}
};


// }}}

} } // namespace Input Prefator

#endif // _PREFATOR_INPUT_PROGRAMBUILDER_HH
