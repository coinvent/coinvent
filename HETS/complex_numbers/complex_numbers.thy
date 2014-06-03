theory complex_numbers_Complex_Field
imports Main
uses "$HETS_ISABELLE_LIB/prelude.ML"
begin

setup "Header.initialize
       [\"ga_selector_real\", \"ga_selector_complex\",
        \"ga_injective_pair\", \"Ax5\", \"Ax6\", \"Ax7\", \"Ax8\", \"Ax9\",
        \"Ax10\", \"Ax11\", \"Ax12\", \"Ax13\", \"Ax14\", \"Ax15\",
        \"Ax16\", \"Ax17\", \"Ax18\", \"Ax19\", \"Ax20\", \"Ax21\",
        \"Ax22\", \"Ax23\", \"Ax24\", \"Ax25\", \"Ax26\", \"Ax27\",
        \"Ax28\", \"Ax1\", \"Ax2\", \"Ax3\", \"Ax4\", \"Ax5_31\",
        \"Ax6_32\", \"Ax7_33\", \"Ax8_34\", \"Ax9_35\", \"Ax10_29\",
        \"Ax11_30\", \"Ax19_49\", \"Ax20_50\", \"Ax21_51\", \"Ax22_52\",
        \"Ax23_53\", \"Ax24_54\", \"Ax25_55\", \"Ax26_56\", \"Ax27_57\",
        \"Ax28_58\"]"

typedecl Real

datatype Complex = X_pair "Real" "Real" ("pair/'(_,/ _')" [3,3] 999)

consts
X0 :: "Real" ("0''")
X1 :: "Real" ("1''")
XMinus__X :: "Real => Real" ("(-''/ _)" [56] 56)
X__XGtXEq__X :: "Real => Real => bool" ("(_/ >=''/ _)" [44,44] 42)
X__XGt__X :: "Real => Real => bool" ("(_/ >''/ _)" [44,44] 42)
X__XPlus__X :: "Real => Real => Real" ("(_/ +''/ _)" [54,54] 52)
X__Xx__X :: "Real => Real => Real" ("(_/ *''/ _)" [54,54] 52)
X__cpl__X :: "Complex => Complex => Complex" ("(_/ cpl/ _)" [54,54] 52)
X__cti__X :: "Real => Complex => Complex" ("(_/ cti/ _)" [54,54] 52)
X__gt__X :: "Complex => Complex => bool" ("(_/ gt/ _)" [44,44] 42)
X__gte__X :: "Complex => Complex => bool" ("(_/ gte/ _)" [44,44] 42)
X__prod__X :: "Complex => Complex => Complex" ("(_/ prod/ _)" [54,54] 52)
X_basis_complex :: "Complex" ("basis'_complex")
X_basis_real :: "Complex" ("basis'_real")
X_c_ident :: "Complex" ("c'_ident")
X_complex :: "Complex => Real" ("complex/'(_')" [3] 999)
X_complex_zero :: "Complex" ("complex'_zero")
X_real :: "Complex => Real" ("real/'(_')" [3] 999)
cmi__X :: "Complex => Complex" ("(cmi/ _)" [56] 56)
complex_norm__X :: "Complex => Real" ("(complex'_norm/ _)" [56] 56)
complex_normsq__X :: "Complex => Real" ("(complex'_normsq/ _)" [56] 56)
field_norm__X :: "Real => Real" ("(field'_norm/ _)" [56] 56)
times_inv__XX1 :: "Complex => Complex" ("(times'_inv''/ _)" [56] 56)
times_inv__XX2 :: "Real => Real" ("(times'_inv''''/ _)" [56] 56)

axiomatization
where
ga_selector_real [rule_format] :
"ALL XX1. ALL XX2. real(pair(XX1, XX2)) = XX1"
and
ga_selector_complex [rule_format] :
"ALL XX1. ALL XX2. complex(pair(XX1, XX2)) = XX2"
and
ga_injective_pair [rule_format] :
"ALL XX1.
 ALL XX2.
 ALL Y1.
 ALL Y2. pair(XX1, XX2) = pair(Y1, Y2) = (XX1 = Y1 & XX2 = Y2)"
and
Ax5 [rule_format] : "ALL x. x +' 0' = x"
and
Ax6 [rule_format] : "ALL x. ALL y. x +' y = y +' x"
and
Ax7 [rule_format] :
"ALL x. ALL y. ALL z. x +' (y +' z) = (x +' y) +' z"
and
Ax8 [rule_format] : "ALL x. x +' -' x = 0'"
and
Ax9 [rule_format] : "ALL x. ALL y. x *' y = y *' x"
and
Ax10 [rule_format] :
"ALL x. ALL y. ALL z. (x *' y) *' z = x *' (y *' z)"
and
Ax11 [rule_format] : "ALL x. ~ x = 0' --> x *' times_inv'' x = 1'"
and
Ax12 [rule_format] : "ALL x. x *' 1' = x"
and
Ax13 [rule_format] :
"ALL x. ALL y. ALL z. x *' (y +' z) = (x *' y) +' (x *' z)"
and
Ax14 [rule_format] :
"ALL x.
 ALL y. ALL z. ALL v. x >=' y & z >=' v --> x +' z >=' y +' v"
and
Ax15 [rule_format] :
"ALL x. ALL y. x >' 0' & y >' 0' --> x *' y >' 0'"
and
Ax16 [rule_format] :
"ALL x.
 ALL y.
 ALL z. ALL v. pair(x, y) cpl pair(z, v) = pair(x +' z, y +' v)"
and
Ax17 [rule_format] : "complex_zero = pair(0', 0')"
and
Ax18 [rule_format] :
"ALL x. ALL y. cmi pair(x, y) = pair(-' x, -' y)"
and
Ax19 [rule_format] :
"ALL x. ALL y. ALL z. x cti pair(y, z) = pair(x *' y, x *' z)"
and
Ax20 [rule_format] : "basis_real = pair(1', 0')"
and
Ax21 [rule_format] : "basis_complex = pair(0', 1')"
and
Ax22 [rule_format] :
"ALL x.
 ALL y.
 ALL z.
 ALL v.
 pair(x, y) prod pair(z, v) =
 pair((x *' z) +' -' (y *' v), (x *' v) +' (y *' z))"
and
Ax23 [rule_format] :
"ALL x.
 ALL y.
 times_inv' pair(x, y) =
 times_inv'' complex_normsq pair(x, y) cti pair(x, -' y)"
and
Ax24 [rule_format] :
"ALL x. ALL y. complex_normsq pair(x, y) = (x *' x) +' (y *' y)"
and
Ax25 [rule_format] :
"ALL a. complex_normsq a = complex_norm a *' complex_norm a"
and
Ax26 [rule_format] :
"ALL a. ALL b. (a gt b) = (complex_norm a >' complex_norm b)"
and
Ax27 [rule_format] :
"ALL a. ALL b. (a gte b) = (complex_norm a >=' complex_norm b)"

declare ga_selector_real [simp]
declare ga_selector_complex [simp]
declare Ax5 [simp]
declare Ax8 [simp]
declare Ax12 [simp]

theorem Ax28 :
"ALL a.
 ALL b. complex_norm (a prod b) = complex_norm a *' complex_norm b"
by (auto)

setup "Header.record \"Ax28\""

theorem Ax1 : "ALL x. x cpl complex_zero = x"
by (auto)

setup "Header.record \"Ax1\""

theorem Ax2 : "ALL x. ALL y. x cpl y = y cpl x"
by (auto)

setup "Header.record \"Ax2\""

theorem Ax3 :
"ALL x. ALL y. ALL z. x cpl (y cpl z) = (x cpl y) cpl z"
by (auto)

setup "Header.record \"Ax3\""

theorem Ax4 : "ALL x. x cpl cmi x = complex_zero"
by (auto)

setup "Header.record \"Ax4\""

theorem Ax5_31 : "ALL x. ALL y. x prod y = y prod x"
by (auto)

setup "Header.record \"Ax5_31\""

theorem Ax6_32 :
"ALL x. ALL y. ALL z. (x prod y) prod z = x prod (y prod z)"
by (auto)

setup "Header.record \"Ax6_32\""

theorem Ax7_33 :
"ALL x. ~ x = complex_zero --> x prod times_inv' x = c_ident"
by (auto)

setup "Header.record \"Ax7_33\""

theorem Ax8_34 : "ALL x. ~ x = complex_zero --> x prod c_ident = x"
by (auto)

setup "Header.record \"Ax8_34\""

theorem Ax9_35 :
"ALL x. ALL y. ALL z. x prod (y cpl z) = (x prod y) cpl (x prod z)"
by (auto)

setup "Header.record \"Ax9_35\""

theorem Ax10_29 :
"ALL x.
 ALL y. ALL z. ALL v. x gte y & z gte v --> x cpl z gte y cpl v"
by (auto)

setup "Header.record \"Ax10_29\""

theorem Ax11_30 :
"ALL x.
 ALL y.
 x gt complex_zero & y gt complex_zero --> x prod y gt complex_zero"
by (auto)

setup "Header.record \"Ax11_30\""

theorem Ax19_49 :
"ALL x. ALL a. ALL b. x cti (a cpl b) = (x cti a) cpl (x cti b)"
by (auto)

setup "Header.record \"Ax19_49\""

theorem Ax20_50 :
"ALL x. ALL y. ALL a. (x +' y) cti a = (x cti a) cpl (y cti a)"
by (auto)

setup "Header.record \"Ax20_50\""

theorem Ax21_51 :
"ALL x. ALL y. ALL a. x cti (y cti a) = (x *' y) cti a"
by (auto)

setup "Header.record \"Ax21_51\""

theorem Ax22_52 : "ALL a. 1' cti a = a"
by (auto)

setup "Header.record \"Ax22_52\""

theorem Ax23_53 : "ALL a. complex_norm a >=' 0'"
by (auto)

setup "Header.record \"Ax23_53\""

theorem Ax24_54 :
"ALL a. (complex_norm a >' 0') = (~ a = complex_zero)"
by (auto)

setup "Header.record \"Ax24_54\""

theorem Ax25_55 :
"ALL x.
 ALL a. complex_norm (x cti a) = field_norm x *' complex_norm a"
by (auto)

setup "Header.record \"Ax25_55\""

theorem Ax26_56 :
"ALL a.
 ALL b. complex_norm a +' complex_norm b >=' complex_norm (a cpl b)"
by (auto)

setup "Header.record \"Ax26_56\""

theorem Ax27_57 :
"ALL x.
 ALL y.
 (x cti basis_real) cpl (y cti basis_complex) = complex_zero =
 (x = 0' & y = 0')"
by (auto)

setup "Header.record \"Ax27_57\""

theorem Ax28_58 :
"ALL a.
 EX s. EX t. a = (s cti basis_real) cpl (t cti basis_complex)"
by (auto)

setup "Header.record \"Ax28_58\""

end
