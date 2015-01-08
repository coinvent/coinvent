// {{{ GPL License 

// This file is part of prefator - a parser for preference programs.
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

#include "prefator/input/olitval.hh"

namespace Prefator { namespace Input {


void OLitVal::addEffectOn(OLitVal* newEO){
	effectsOn_.push_back(newEO);
}

void OLitVal::isElemOfD(bool b){
	elemOfD_ = b;
}

bool OLitVal::isElemOfD(){
	return elemOfD_;
}

std::vector<OLitVal*> OLitVal::getEffectsVec(){
	return effectsOn_;
}



}}
