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

#include <prefator/input/nongroundparser.hh>
#include <prefator/input/programbuilder.hh>
#include <prefator/version.hh>
//#include <gringo/version.hh>
//#include <gringo/input/program.hh>
#include <gringo/logger.hh>
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <cstring>
#include <vector>

bool g_verbose = false;
bool parsemode = 0;
#define LOG if (g_verbose) std::cerr


void parseTo(std::vector<char const *>& files, char holdsopt, std::vector<std::string> &fileout, std::string &unconout, std::string &holdsout) {
    using namespace Prefator::Input;

    PrefNongroundProgramBuilder pb(holdsopt);
	NonGroundParser parser(pb);

	std::stringstream 			ss;
	std::vector<StStringVec>	out, vs;

    for (auto &x : files) {
        LOG << "file: " << x << std::endl;
        parser.pushFile(x);
		ss << "\n%file:\t" << x << std::endl;
		out.push_back( { { { ss.str(), DEFAULTSTR } }, NEWFILE });
		ss.str("");

        if (parser.parse()){ vs = pb.getOP(); out.insert( out.end(), vs.begin(), vs.end()); };
    }

    if (files.empty()) {
        LOG << "reading from stdin" << std::endl;
        parser.pushFile("-");
		out.push_back( { { { "\n%file:\tstdin\n", DEFAULTSTR } }, NEWFILE });

        if (parser.parse()){ vs = pb.getOP(); out.insert( out.end(), vs.begin(), vs.end()); };
    }

	// build set D
	pb.buildD();

	// post processing
	pb.dpostprocess(out, fileout, unconout);

	// H'
	ss << "\n" << pb.strHpr() << std::endl;
	holdsout = ss.str();

	// that shouldn't be the case
	if (fileout.size() < files.size()){
		fileout.reserve(files.size());
	}


}

void parseToFiles(std::vector<char const *>& files, char holdsopt) {
	std::vector<std::string> fileout;
	std::string unconout, holdsout;
	std::ofstream ofs;
	std::stringstream ss;

	parseTo(files, holdsopt, fileout, unconout, holdsout);
	unsigned int i;

	for ( i = 0; i < files.size(); i++ ){ 
		ss << files[i] << ".tmp";
		ofs.open(ss.str());
		ofs << fileout[i] << std::endl;
		ofs.close();
		ss.str("");
	}

	// constraint file
	if (unconout != ""){
		ofs.open("c-prime.lp.tmp");
		ofs << unconout << std::endl;
		ofs.close();
	}

	// holds file
	if (holdsout != ""){
		ofs.open("holds.lp.tmp");
		ofs << holdsout << std::endl;
		ofs.close();
	}
	
}

void parseToStdout(std::vector<char const *>& files, char holdsopt) {
	std::vector<std::string> fileout;
    std::string unconout, holdsout;

	parseTo(files, holdsopt, fileout, unconout, holdsout);
	for ( auto parsedFile : fileout){ std::cout << parsedFile; }
	std::cout << unconout;
	std::cout << holdsout << std::endl;
}

void printVersion() {
	std::cout << "prefator version " PREFATOR_VERSION "\n";
}
void printHelp() {
    printVersion();
    std::cout << 
        "\n"
        "Usage: prefator [options] [files]\n"
        "\n"
		"Preference Parser Options:\n"
		"\n"
		"	--all-holds		: Build hold predicates from P program.\n"
		"	--no-holds		: Do not build hold predicates.\n"
		"	--to-files		: Print translation to files.\n"
		"	--disable-name-check	: Do not check whether atoms of predicate name/1 are ground inside preference statements.\n"
		"	--disable-domain-check	: Do not check whether predicates in the body of preference statements are domain."
		"\n\n"
        "Basic Options:\n"
        "\n"
        "  --help,-h    : Print help information and exit\n"
        "  --version,-v : Print version information and exit\n"
        "  --verbose,-V : Print intermediate program representations\n"
        "\n\n"
        "Usage: prefator [options] [files]\n";
}

int main(int argc, char **argv) {
   	using namespace Gringo;

	std::stringstream ss;
	char holdsopt = 0;
	bool savemode = 0;

    try {
		
        std::vector<char const *> files;
        std::vector<char const *> defines;
        std::vector<char const *> preffiles;
        //char const *ACO = "--aspcomp13-output=";
        for (; argc > 1; argc--, argv++) {

            if (!strcmp(argv[1], "-h") || !strcmp(argv[1], "--help"))    { printHelp(); std::exit(0); }
            else if (!strcmp(argv[1], "-v") || !strcmp(argv[1], "--version")) { printVersion(); std::exit(0); }
            else if (!strcmp(argv[1], "-V") || !strcmp(argv[1], "--verbose")) { g_verbose = true; }
            else if (!strcmp(argv[1], "-f") && argc > 2)                      { files.emplace_back(argv[2]); --argc; ++argv; }
            else if (!strcmp(argv[1], "-c") && argc > 2)                      { defines.emplace_back(argv[2]); --argc; ++argv; }
			else if (!strcmp(argv[1], "--all-holds"))                                { holdsopt = 1; }
			else if (!strcmp(argv[1], "--no-holds"))                                { holdsopt = 2; }
			else if (!strcmp(argv[1], "--to-files"))                        { savemode = 1; }
            else if (!strncmp(argv[1], "-", 1) && strnlen(argv[1], 2) > 1)    { printHelp(); throw std::runtime_error(std::string("unknow option: ") + argv[1]); }
            else                                                              { files.emplace_back(argv[1]); }

        }
		if (savemode){ parseToFiles(files, holdsopt); } 
		else { parseToStdout(files, holdsopt); }
		
	
    }
    catch (std::exception &e) {
        std::cerr << "\n" << "Exception: " << e.what() << std::endl;
        return 1;
    }
	
    return 0;
}

