// {{{ GPL License 

// This file is part of prefator - a translator for logic preference programs.
// Copyright (C) 2013  Tobias Jaeuthe, Roland Kaminski

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

#ifndef _PREFATOR_IO_HH
#define _PREFATOR_IO_HH

//#include <cppunit/TestFixture.h>
//#include <cppunit/TestAssert.h>
//#include <cppunit/extensions/HelperMacros.h>
//#include "gringo/utility.hh"
//#include "gringo/logger.hh"
//#include <algorithm>
#include <unordered_map>

namespace Gringo {

// {{{ declaration of helpers to print containers

namespace IO {

template <class T>
std::ostream &operator<<(std::ostream &out, std::unique_ptr<T> const &x);
template <class... T>
std::ostream &operator<<(std::ostream &out, std::vector<T...> const &x);
template <class... T>
std::ostream &operator<<(std::ostream &out, std::set<T...> const &x);
template <class T, class U>
std::ostream &operator<<(std::ostream &out, std::pair<T, U> const &x);
template <class... T>
std::ostream &operator<<(std::ostream &out, std::tuple<T...> const &x);
template <class... T>
std::ostream &operator<<(std::ostream &out, std::map<T...> const &x);
template <class... T>
std::ostream &operator<<(std::ostream &out, std::unordered_map<T...> const &x);
template <class T>
std::string to_string(T const &x);

} // namespace IO

// }}}

// {{{ definition of helpers to print containers

namespace IO {

template <class T>
std::ostream &operator<<(std::ostream &out, std::unique_ptr<T> const &x) {
    out << *x;
    return out;
}

template <class T, class U>
std::ostream &operator<<(std::ostream &out, std::pair<T, U> const &x) {
    out << "(" << x.first << "," << x.second << ")";
    return out;
}

template <class... T>
std::ostream &operator<<(std::ostream &out, std::vector<T...> const &vec) {
    out << "[";
    auto it(vec.begin()), end(vec.end());
    if (it != end) {
        out << *it;
        for (++it; it != end; ++it) { out << "," << *it; }
    }
    out << "]";
    return out;
}

template <class... T>
std::ostream &operator<<(std::ostream &out, std::set<T...> const &x) {
    out << "{";
    auto it(x.begin()), end(x.end());
    if (it != end) {
        out << *it;
        for (++it; it != end; ++it) { out << "," << *it; }
    }
    out << "}";
    return out;
}



} // namespace IO

// }}}

inline std::string &replace_all(std::string &haystack, std::string const &needle, std::string const &replace) {
    size_t index = 0;
    while (true) {
        index = haystack.find(needle, index);
        if (index == std::string::npos) break;
        haystack.replace(index, needle.length(), replace);
        index += replace.length();
    }
    return haystack;
}

inline std::string replace_all(std::string &&haystack, std::string const &needle, std::string const &replace) {
	replace_all(haystack, needle, replace);
	return std::move(haystack);
}

}


#endif // _PREFATOR_IO_HH
