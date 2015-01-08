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

#ifndef PREFATOR_OLITVAL_HH
#define _PREFATOR_OLITVAL_HH

#include <vector>

namespace Prefator { namespace Input {

class OLitVal {
public:
	void addEffectOn(OLitVal* newEO);
	void isElemOfD(bool b);
	bool isElemOfD();
	std::vector<OLitVal*> getEffectsVec();
private:
	bool elemOfD_ = 0;
	std::vector<OLitVal*> effectsOn_;

};

} // end namespace Input
} // end namespace Prefator

#endif  // _PREFATOR_OLITVAL_HH

