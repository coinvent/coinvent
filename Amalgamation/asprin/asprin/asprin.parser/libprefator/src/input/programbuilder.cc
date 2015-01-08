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

#include "prefator/input/programbuilder.hh"
#include "prefator/input/nongroundparser.hh"
#include "input/nongroundgrammar/grammar.hh"

#include "tests/tests.hh"

namespace Prefator { namespace Input {

// {{{ definition of PrefNongroundProgramBuilder

using namespace Gringo::IO;

PrefNongroundProgramBuilder::PrefNongroundProgramBuilder(char holdsopt)
    : holdsopt_(holdsopt) { }


std::ostream &operator<<(std::ostream &out, StString const &x) {
    out << x.str;
	return out;
}

std::ostream &operator<<(std::ostream &out, StStringVec const &x) {
	
	for ( auto st : x.strvec ){ out << st; }
    return out;
}

// {{{ id vectors

IdVecUid PrefNongroundProgramBuilder::idvec() {
    return idvecs_.emplace();
}

IdVecUid PrefNongroundProgramBuilder::idvec(IdVecUid uid, FWString id) {
    idvecs_[uid].emplace_back(*id);
    return uid;
}

// }}}

// {{{ terms

TermUid PrefNongroundProgramBuilder::term(Value val) {

	std::stringstream ss;

    ss << val;
    return terms_.emplace(ss.str());
}

TermUid PrefNongroundProgramBuilder::term(FWString name) {

	std::stringstream ss;

    ss << *name;
    return terms_.emplace(ss.str());
}

TermUid PrefNongroundProgramBuilder::term(bool anonymous) {

	std::stringstream ss;

    ss << (anonymous ? "_" : "*");
    return terms_.emplace(ss.str());
}

TermUid PrefNongroundProgramBuilder::term(UnOp op, TermUid a) { 

	std::stringstream ss;

    if(op == UnOp::ABS) { ss << "|"; }
    else { ss << "(" << op; }
    ss << terms_.erase(a) << (op == UnOp::ABS ? "|" : ")");
    return terms_.emplace(ss.str());
}

TermUid PrefNongroundProgramBuilder::term(UnOp op, TermVecUid a) { 

	std::stringstream ss;
	
    if(op == UnOp::ABS) { ss << "|"; }
    else { ss << op << "("; }
    ss << print(termvecs_.erase(a), ";");
    ss << (op == UnOp::ABS ? "|" : ")");
    return terms_.emplace(ss.str());
}

TermUid PrefNongroundProgramBuilder::term(BinOp op, TermUid a, TermUid b) {

	std::stringstream ss;

    ss << "(" << terms_.erase(a) << op << terms_.erase(b) << ")";
    return terms_.emplace(ss.str());
}

TermUid PrefNongroundProgramBuilder::term(TermUid a, TermUid b) {

	std::stringstream ss;

    ss << "(" << terms_.erase(a) << ".." << terms_.erase(b) << ")";
    return terms_.emplace(ss.str());
}

TermUid PrefNongroundProgramBuilder::term(FWString name, TermVecVecUid a, bool lua) {

	std::stringstream ss;

    assert(!termvecvecs_[a].empty());
    bool nempty = lua || termvecvecs_[a].size() > 1 || !termvecvecs_[a].front().empty() || *name == "";
    if (lua) { ss << "@"; }
    ss << *name;
    if (nempty) { ss << "("; }
    ss << print(termvecvecs_.erase(a));
    if (nempty) { ss << ")"; }
    return terms_.emplace(ss.str());
}

// }}}
// {{{ csp
CSPMulTermUid PrefNongroundProgramBuilder::cspmulterm(TermUid coe, TermUid var) {

	std::stringstream ss;

    ss << terms_.erase(coe) << "$*$" << terms_.erase(var);
    return cspmulterms_.emplace(ss.str());
}
CSPMulTermUid PrefNongroundProgramBuilder::cspmulterm(TermUid coe) {
	
	std::stringstream ss;

    ss << terms_.erase(coe);
    return cspmulterms_.emplace(ss.str());
}
CSPAddTermUid PrefNongroundProgramBuilder::cspaddterm(CSPAddTermUid a, CSPMulTermUid b, bool add) {
    cspaddterms_[a] += (add ? "$+" : "$-") + cspmulterms_.erase(b);
    return a;
}
CSPAddTermUid PrefNongroundProgramBuilder::cspaddterm(CSPMulTermUid a) {
	
	std::stringstream ss;

    ss << cspmulterms_.erase(a);
    return cspaddterms_.emplace(ss.str());
}
LitUid PrefNongroundProgramBuilder::csplit(CSPLitUid a) {
    return lits_.emplace(csplits_.erase(a));
}
CSPLitUid PrefNongroundProgramBuilder::csplit(CSPLitUid a, Relation rel, CSPAddTermUid b) {
    csplits_[a] += "$" + IO::to_string(rel) + cspaddterms_.erase(b);
    return a;
}
CSPLitUid PrefNongroundProgramBuilder::csplit(CSPAddTermUid a, Relation rel, CSPAddTermUid b) {

	std::stringstream ss;

    ss << cspaddterms_.erase(a) << "$" << rel << cspaddterms_.erase(b);
    return csplits_.emplace(ss.str());
}
// }}}
// {{{ term vectors

TermVecUid PrefNongroundProgramBuilder::termvec() { 
    return termvecs_.emplace();
}

TermVecUid PrefNongroundProgramBuilder::termvec(TermVecUid uid, TermUid term) {
	
	std::stringstream ss;

    termvecs_[uid].emplace_back(terms_.erase(term));
    return uid;
}

// }}}
// {{{ term vector vectors

TermVecVecUid PrefNongroundProgramBuilder::termvecvec() {
    return termvecvecs_.emplace();
}

TermVecVecUid PrefNongroundProgramBuilder::termvecvec(TermVecVecUid uid, TermVecUid termvecUid) { 
    termvecvecs_[uid].push_back(termvecs_.erase(termvecUid));
    return uid;
}

// }}}
// {{{ literals

LitUid PrefNongroundProgramBuilder::boollit(bool type) { 
    return lits_.emplace(type ? "#true" : "#false");
}

LitUid PrefNongroundProgramBuilder::predlit(NAF naf, bool neg, FWString name, TermVecVecUid tvvUid) {

	std::stringstream ss;
	// only _heuristic predicate with parity of 3 is allowed
	if (*name=="_heuristic" && termvecvecs_[tvvUid].front().size() != 3){
        GRINGO_REPORT(ERROR) << "error: Only predicate _heuristic/3 is allowed to use with underscore at beginning of the identifier!\n"; 
		std::exit(1); }

    ss << print(naf);
    if (neg) { ss << "-"; }

    ss << *name;

    bool nempty = termvecvecs_[tvvUid].size() > 1 || !termvecvecs_[tvvUid].front().empty();
    if (nempty) { ss << "("; }
    ss << print(termvecvecs_.erase(tvvUid));
	
	if (nempty) { ss << ")"; }


    return lits_.emplace(ss.str());
} 

LitUid PrefNongroundProgramBuilder::rellit(Relation rel, TermUid termUidLeft, TermUid termUidRight) { 
	
	std::stringstream ss;

    ss << terms_.erase(termUidLeft) << rel << terms_.erase(termUidRight);

    return lits_.emplace(ss.str());
}

// }}}
// {{{ literal vectors

LitVecUid PrefNongroundProgramBuilder::litvec() { 
    return litvecs_.emplace();
}

LitVecUid PrefNongroundProgramBuilder::litvec(LitVecUid uid, LitUid literalUid) { 
    litvecs_[uid].emplace_back(lits_.erase(literalUid));
    return uid;
}

// }}}
// {{{ preference program O

LitKeyUid PrefNongroundProgramBuilder::litkey(){
	return litkeys_.emplace("");
}
LitKeyUid PrefNongroundProgramBuilder::litkey(FWString name, TermVecVecUid tvvUid){
	
	std::stringstream hash;
	std::string nstr;
	unsigned size = 0;

	nstr = *name;

	StringVecVec const &vec = termvecvecs_[tvvUid];

    auto it = vec.begin(), itend = vec.end();

    if (it != itend) {
        StringVec const &v = *it++;
        size = v.size();
    }
	hash << nstr << "/" << size;

	litmap_.insert(std::make_pair(hash.str(),new OLitVal()));

	return litkeys_.emplace(hash.str());

}

LitKeyVecUid PrefNongroundProgramBuilder::litkeyvec(){

    return litkeyvecs_.emplace();
}

LitKeyVecUid PrefNongroundProgramBuilder::litkeyvec(LitKeyVecUid uid, LitKeyUid key){

	std::string litkey = litkeys_.erase(key);
	if (litkey != ""){
	    litkeyvecs_[uid].emplace_back(litkey);
	}

    return uid;
}

LitKeyVecUid PrefNongroundProgramBuilder::litkeyvec(LitKeyVecUid uid, LitKeyVecUid mergeuid){

    auto it = litkeyvecs_[mergeuid].begin(), end = litkeyvecs_[mergeuid].end();
	
    for (; it != end ;){
	
		
        litkeyvecs_[uid].emplace_back(*it++);
    }
	

    litkeyvecs_.erase(mergeuid);
    return uid;

}

void PrefNongroundProgramBuilder::litkeys(LitKeyUid hd, LitKeyVecUid bd){

	std::string hdstr = litkeys_.erase(hd);

	OLitVal* hdptr = litmap_[hdstr];

	StringVec const &vec = litkeyvecs_.erase(bd);
	auto it = vec.begin(), end = vec.end();

	for (;it != end;){

		OLitVal* bdptr = litmap_[*it];
		bdptr->addEffectOn(hdptr);
			
		it++;
	}

}


void PrefNongroundProgramBuilder::buildD(){
	/*
        get literals from D 
    */


    for( auto it : litmap_ ) {
        std::string key = it.first;
		OLitVal* val = it.second;


		// if literal == holds'/1 or literal == holds/1 --> literal is elem of D
		if ( ( key.size() == 8 && key.compare (0,8,"holds'/1" ) == 0) || ( key.size() == 7 && key.compare (0,7,"holds/1") == 0) ) {
			val->isElemOfD(true);
		}

		// if lit is elem of D
		if (val->isElemOfD()){
			buildD(val->getEffectsVec());
		}


    }

}

void PrefNongroundProgramBuilder::buildD(std::vector<OLitVal*> effectsOn){
	
	for ( auto it : effectsOn )	{
		
		if (!it->isElemOfD()){
			it->isElemOfD(true);
			buildD(it->getEffectsVec());
		}
	}

}

void PrefNongroundProgramBuilder::prefolit(FWString name, TermVecVecUid tvvUid) {
	
	std::stringstream ss, swap, end, hash;
	std::string nstr;
	unsigned size;

	// only _heuristic predicate with parity of 3 is allowed
	if (*name=="_heuristic" && termvecvecs_[tvvUid].front().size() != 3){ 
        GRINGO_REPORT(ERROR) << "error: Only predicate _heuristic/3 is allowed to use with underscore at beginning of the identifier!\n"; 
		std::exit(1);
		}


    nstr = *name;    
    bool nempty = termvecvecs_[tvvUid].size() > 1 || !termvecvecs_[tvvUid].front().empty();
    if (nempty) { swap << "("; }

	StringVecVec const &vec = termvecvecs_.erase(tvvUid);

	auto it = vec.begin(), itend = vec.end();

    if (it != itend) {
        StringVec const &v = *it++;
		size = v.size();
        swap << print(v, ",");
    }
	
	statement_.push_back( { ss.str(), DEFAULTSTR });
	ss.str("");
	
    ss << nstr << "/" << size;
	statement_.push_back( { ss.str(), LITNAME } );
	
	statement_.push_back( { swap.str(), LITTERMVEC } );


}

// }}}
// {{{ preference statements S

PrefIdentUid PrefNongroundProgramBuilder::prefident(FWString name){

	PrefIdentUid uid = prefidents_.emplace(*name);
	prefidentsvecs_.emplace_back(uid);

	return uid;

}

PrefVarUid PrefNongroundProgramBuilder::prefvar(){

	return prefvars_.emplace();
}

PrefVarUid PrefNongroundProgramBuilder::prefvar(PrefVarUid uid, FWString var){

	prefvars_[uid].insert(*var);
	return uid;
}

PrefVarUid PrefNongroundProgramBuilder::prefvar(PrefVarUid uid, PrefVarUid mergeuid){

	auto it = prefvars_[mergeuid].begin(), end = prefvars_[mergeuid].end();

	for (; it != end ;){
	prefvars_[uid].insert(*it++);
	}

	prefvars_.erase(mergeuid);
	return uid;

}



TermUid PrefNongroundProgramBuilder::preflit(NAF naf, FWString name, TermVecVecUid tvvUid){

	std::stringstream ss, tvec, swap;
	std::string nstr = *name;
	bool neg = false;
	bool isLit = false;

	if (naf == NAF::NOT) { neg = true; }


	if (neg) { ss << "lit(f," << *name; }
	else {
		if ( termvecvecs_[tvvUid].size() == 1 && nstr.size() == 4 && nstr.compare (0,4,"name" ) == 0 ) { ss << nstr; } 
		else { 	isLit = true; ss << "lit(t," << nstr; }
	}

	bool nempty = termvecvecs_[tvvUid].size() > 1 || !termvecvecs_[tvvUid].front().empty();

	swap << nstr;
	if (nempty) { ss << "("; swap << "("; }

	tvec << print(termvecvecs_.erase(tvvUid));
	ss << tvec.str();
	swap << tvec.str();


	if (nempty) { ss << ")"; swap << ")";  }



	if (isLit){ 
		ss << ")"; 
		if (holdsopt_ == 0) { hprprog_ << "_holds("<<swap.str() << ",0)" << ":-" << swap.str() << "." << std::endl; } 
	}

	return terms_.emplace(ss.str());

}



TermUid PrefNongroundProgramBuilder::weightedterm(TermVecUid weights, TermUid term){

	std::stringstream ss;

	ss << terms_.erase(term) << ",";
	ss << "(" << print(termvecs_.erase(weights),",") << ")";

	return terms_.emplace(ss.str());

}




PrefElemUid PrefNongroundProgramBuilder::prefelem(TermVecVecUid head, TermVecUid cond, bool hasBd,PrefVarUid vars){

	PrefElemUid uid = prefelems_.emplace();

	std::stringstream ss, bdss, vss;

	// body of rule
	if (hasBd){
		for (auto ststr : statement_)
			ss << ststr.str;
		size_t pos = ss.str().find(":-");
		bdss << " " << ss.str().substr(pos);
		for (auto ststr : current_){ bdss << ststr.str; }
		ss.str("");
	} else { bdss << "."; }

	// variables of head
	std::set<std::string> sset(prefvars_.erase(vars));
	auto sit = sset.begin(), send = sset.end();
	
	if (sit != send){ if (!(*sit).empty()) { vss << *sit++; } }

	for (; sit != send ;){
		if (!(*sit).empty()){ vss << "," << *sit++; }
	}
	unsigned int hdelemix = 1;

	// elems of head of rule
	for (auto hdelem : termvecvecs_.erase(head)){
	
		// for weighted literals sets in head elem
		for (auto wset : hdelem){

				ss << ",(" << vss.str() << ")";
				ss << ")," << hdelemix << "," << wset << ")" << bdss.str(); 
				prefelems_[uid].emplace_back(ss.str());
				ss.str("");
			
		}
		hdelemix++ ;
	}

	// conds of head
	StringVec &cvec = termvecs_[cond];
	auto cit = cvec.begin(), cend = cvec.end();

	for (; (cit != cend) ;) {

		ss << ",(" << vss.str() << ")";
		ss << ")," << 0 << "," << *cit++ << ",())" << bdss.str();
		prefelems_[uid].emplace_back(ss.str());
		ss.str("");
	}
	termvecs_.erase(cond);

	return uid;
}

PrefElemVecUid PrefNongroundProgramBuilder::prefcontent(){
	return prefelemvecs_.emplace();
}

PrefElemVecUid PrefNongroundProgramBuilder::prefcontent(PrefElemVecUid uid, PrefElemUid elem){

	prefelemvecs_[uid].emplace_back(prefelems_.erase(elem));
	return uid;

}



void PrefNongroundProgramBuilder::prefstatement(PrefIdentUid name, FWString type, IdVecUid args, PrefElemVecUid uid, bool inP){

	std::stringstream ss;

	bool nempty = !(idvecs_[args].empty());

	ss << "__preference(" << prefidents_[name] << "," << *type; 
		
	

	if ( nempty ){ ss << "(" << print(idvecs_.erase(args),",") << "))." << std::endl;}
	else { ss << ")." << std::endl; }

	if (!inP) { prog_.push_back({ { { ss.str(), DEFAULTSTR} }, OSELEM } ); }
	else { prog_.push_back({ { { ss.str(), DEFAULTSTR} }, PELEM } ); }

	ss.str("");


	StringVecVec& elems = prefelemvecs_[uid];

	unsigned int elemix = 1;
	auto elemit = elems.begin(), elemend = elems.end();
	for (; elemit != elemend; ) {

		StringVec& litvec = *elemit++;
		auto it = litvec.begin(), end = litvec.end();
		for (; it != end ;) {
			ss << "__preference(" << prefidents_[name] << ",(" << elemix;
			ss << *it++ << std::endl;

			if (!inP) { prog_.push_back({ { { ss.str(), DEFAULTSTR} }, OSELEM } ); }
			else { prog_.push_back({ { { ss.str(), DEFAULTSTR} }, PELEM } ); }

			ss.str("");
		}
		elemix++;
	}

	prefelemvecs_.erase(uid);

	existS_ = true;


}

// }}}
// {{{ prefer(ence auxiliary functions

void PrefNongroundProgramBuilder::prefmain(FWString name, bool inP){

	std::stringstream ss;


	ss << "__optimize(" << *name << ").";

	statement_.push_back( { ss.str(), DEFAULTSTR } );
	prog_.push_back( { statement_, StType::OPTST });
	statement_.clear();

	existOpt_ = true;

}


// }}}

// {{{ holds generation


void PrefNongroundProgramBuilder::holds(LitUid head){

	if (holdsopt_ == 1){
		hprprog_ << "_holds(" << lits_[head] << ",0) :- " << lits_[head] << "." << std::endl;
	}

}

// }}}

// {{{ auxiliary functions


std::string PrefNongroundProgramBuilder::print(NAF naf) {

	std::stringstream ss;

	switch (naf) {
		case NAF::NOT:    { ss << "not "; break; }
		case NAF::NOTNOT: { ss << "not not "; break; }
		case NAF::POS:    { break; }
	}
return ss.str();

}

void PrefNongroundProgramBuilder::lastP(PROGRAM lp){
	lastP_ = lp;
}

void PrefNongroundProgramBuilder::token(std::string tok, StStrType type){
	current_.push_back( { tok, type } );
}

void PrefNongroundProgramBuilder::setStatementType(StType type){
	sttype_ = type;
}

void PrefNongroundProgramBuilder::releaseLine(bool b){

	// finish last statement
	if (b) {

		// add last token stream to statement
		if (!current_.empty()){ releaseCur(true); }
		prog_.push_back( { statement_, sttype_ } );
	} 
	

	// may use pointers, instead of object copying?
	statement_.clear();
	current_.clear();	
}

void PrefNongroundProgramBuilder::releaseCur(bool b){

	// finish last statement
	if (b) { 
		statement_.insert(statement_.end(), current_.begin(), current_.end());
	}

	// may use pointers, instead of object copying?
	current_.clear();

}

void PrefNongroundProgramBuilder::deleteLit(){
		
				std::stringstream ss;
				unsigned int par = 0;
				bool litProcessed = 0;
				for ( auto ststr : current_){
					for ( auto ch : ststr.str) {
						//std::cout << "str:" << ch << ":str" << std::endl;
						if (par == 0 && litProcessed) { /*std::cout << "push1" << std::endl;*/ ss << ch; continue; }
						if (ch == '('){ par++; litProcessed = 0; }
						else if (ch == ')') { par--; if (par == 0) { litProcessed = 1; } }
						// regex does not work ...
						if ((ch == ',' || ch == ';' || ch == ':' || ch == '.' || ch == ' ' || ch == '}' || ch == ']' || ch == '\t' || ch == '\r' || ch == '\n') && par == 0)
						{ /*std::cout << "push2" << std::endl;*/ ss << ch; litProcessed = 1; }
					}
					statement_.push_back( { ss.str(), ststr.type } );
					ss.str("");
				}
				current_.clear();
}






std::vector<StStringVec> PrefNongroundProgramBuilder::getOP() {

	// validity checks
	if (existS_ && !existOpt_){
		std::cerr <<  "Warning: optimize statement is missing!" << std::endl;
	}

	// add #program base to beginning of file
		
	//	lastP_ = SP;
	//}

	return prog_;
}



std::string PrefNongroundProgramBuilder::strHpr(){

	std::stringstream ss;

	// print generated holds
	if (holdsopt_ != 2 && !hprprog_.str().empty()){
		//ss << "\n\n%------ GENERATED HOLDS H': ------%" << std::endl;
		ss << "#program base." << std::endl;
		ss << hprprog_.str() << std::endl;
	}

	hprprog_.str("");

	return ss.str();

}

std::string PrefNongroundProgramBuilder::print(StringVec const &vec, char const *sep) {

	std::stringstream ss;

	auto it = vec.begin(), end = vec.end();

	if (it != end) {
		ss << *it++;
		for (; it != end; ++it) { ss << sep << *it; }
	}

	return ss.str();
}

std::string PrefNongroundProgramBuilder::oprint(StringVec const &vec, char const *sep) {

    std::stringstream ss;
	bool nl = 0;

    auto it = vec.begin(), end = vec.end();

    if (it != end) {
        ss << *it++;
        for (; it != end; ++it) { if (nl) { ss << sep << "\n" << *it; nl = 0; } else { ss << sep << *it; nl = 1; } }
    }

    return ss.str();
}

std::string PrefNongroundProgramBuilder::print(StringVecVec const &vec) {

	std::stringstream ss;

	auto it = vec.begin(), end = vec.end();
	if (it != end) {
		StringVec const &v = *it++;
		ss << print(v, ",");
		for (; it != end; ++it) {
			ss << ";";
			ss << print(*it, ",");
		}
	}

	return ss.str();
}

void PrefNongroundProgramBuilder::resetOP(){

	// reset last state
	prog_.clear();
	statement_.clear();
	current_.clear();


}

void PrefNongroundProgramBuilder::dpostprocess(std::vector<StStringVec> input, std::vector<std::string> &result, std::string &unconret){

	std::stringstream fileout, uncon;

	// check whether '#program base.' occured in new file
	bool nfpb = 0;
	uint nfiles = 0;
	
	for ( auto st : input){
			//std::cout << "type:" << st.type << ":type" << std::endl;
			//std::cout << "statement:" << st << ":statement" << std::endl;

			switch(st.type){
				case NEWFILE:
					// recognize new file
					if (!fileout.str().empty()){ result.push_back(fileout.str()); }
					fileout.str("");
					// print comment to output
					fileout << st;
					lastP_ = SP; 
					nfpb = 0;
					nfiles++;
					// continue next iteration
					continue;
				case OPTST:
					// optimize statement
                	if (lastP_ != SP)
              		{ 
                    	fileout << "#program base." << std::endl;
                    	lastP_ = SP;
                	}
					fileout << st;
                    continue;
				case OSELEM:
					// S statements not in P
                	if (lastP_ != SP) { fileout << "#program base." << std::endl; }
                    lastP_ = SP;
					fileout << st;
                    continue;
				case PELEM:
					// statement in P
					if (nfiles > 1 && !st.contains(PBLOCK) && nfpb == 0){ fileout << "#program base." << std::endl; }

					lastP_ = SP; 
					nfpb = 1;
					
					fileout << st;
					continue;
				// postprocess O elements in special way
				case OCONSTRAINT:
					processOStatement(st, fileout, uncon,nfpb);
					continue;
				case OFACT:
					processOStatement(st, fileout, uncon,nfpb);
					continue;
				case ORULE:
					processOStatement(st, fileout, uncon,nfpb);
					continue;

				default:
					// ignore unknown statement
					continue;
            } // end type switch

	} // end statement loop

	// last file
	result.push_back(fileout.str());

	// add unsat constraints
    if (!uncon.str().empty()){
		fileout.str("");
        fileout << "\n#program unsat_constraints(m1,m2)." << std::endl;
        fileout << ":- not _unsat(m1,m2); _volatile(m1,m2)." << std::endl;
        fileout << uncon.str();
		unconret = fileout.str();
    }

	// END 
}

void PrefNongroundProgramBuilder::processOStatement(StStringVec &st, std::stringstream &fileout, std::stringstream &uncon, bool &nfpb){

	std::string hash, litname;
	std::stringstream ss, litss;
	std::string dr = ";\n\t\t_volatile(m1,m2)";
	std::string df = " :- _volatile(m1,m2)";

	// current literal is element of D
	bool dlit = 0;

	// current rule contains a literal of D
	bool hasdlit = 0;

	std::size_t pos;
		
		// iterator for statement elements
		for ( auto it : st.strvec){
		
			//std::cout << "statementstrtype:" << it.type << ":statementstrtype" << std::endl;
			//std::cout << "statementstr:" << it << ":statementstr" << std::endl;

			switch (it.type){
				
				case DEFAULTSTR:
					ss << it;
					continue;

				case LITNAME:
					hash = it.str;
					// get lit name
                    pos = it.str.find("/");
					litname = it.str.substr(0,pos);

					// check whether literal is in D
                    if ( litmap_[it.str]->isElemOfD() ){ dlit = 1; hasdlit = 1; }
					continue;

				case LITTERMVEC:
					// treat hclasp predicate in special way
                    if (hash.compare(0,12,"_heuristic/3") == 0) { 
						if (dlit){ std::cerr << "Warning: some _heuristic/3 depend on holds predicates!" << std::endl; }
					} 
					else 
					{
						// transform only D literals
	                    if (dlit){
	                    	dlit = 0;
	                        if ( it.str.empty() ) { litss << "("; } else { litss << ","; }
	                            if (hash.compare(0,8,"holds'/1") == 0) { litss << "m2"; litname = "_holds"; }
	                            else
	                            if (hash.compare(0,7,"holds/1") == 0) { litss << "m1"; litname = "_holds"; }
	                            else
                            	{ litname = "__" + litname; litss << "m1,m2"; }

                        	    if ( it.str.empty() ) { litss << ")"; }

						} else { litname = "__" + litname; }
					}
					// build transformed lit together
					ss << litname << it.str << litss.str();

					if (!it.str.empty()){ ss << ")"; }
                    litss.str("");
					continue;

				case DOT:
					if (st.type == OCONSTRAINT){ 
						uncon << "_unsat(m1,m2) " << ss.str() << dr << "." << std::endl;
                		if (lastP_ != DC) 
						{ lastP_ = DC; fileout << "#program constraints(m1,m2)." << std::endl; }
						ss << dr;
            		} else {

                		// first case rule contains lit from D
                		if (hasdlit){

                    		if (lastP_ != DO) { fileout << "#program preference(m1,m2)." << std::endl; lastP_ = DO; }
							if (st.type == OFACT) { ss << df; } else { ss << dr; }
						} else {
							// isn't element of D
                    		if (lastP_ != SP || nfpb == 0) { fileout << "#program base." << std::endl; lastP_ = SP; nfpb = 1; }
						}
                    }
					if (!ss.str().empty()) { ss << "."; }
					continue;

				default:
					continue;

			} // end of switch 

		} // end of statement token loop
		if (!ss.str().empty()) { fileout << ss.str(); }

}


// }}}




PrefNongroundProgramBuilder::~PrefNongroundProgramBuilder() { }

// }}}

} } // namespace Input Prefator
