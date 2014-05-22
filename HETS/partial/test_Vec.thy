theory test_Vec
imports Main
uses "$HETS_ISABELLE_LIB/prelude.ML"
begin

setup "Header.initialize
       [\"ga_selector_x\", \"ga_selector_y\", \"ga_injective_pair\",
        \"Ax5\", \"Ax6\", \"Ax7\", \"Ax8\", \"Ax9\", \"Ax10\", \"Ax11\",
        \"Ax12\", \"Ax1\", \"Ax2\", \"Ax3\", \"Ax4\"]"

typedecl Real

datatype Vec = X_pair "Real" "Real" ("pair/'(_,/ _')" [3,3] 999)

consts
X0 :: "Real" ("0''")
XMinus__X :: "Real => Real" ("(-''/ _)" [56] 56)
X__XPlus__X :: "Real => Real => Real" ("(_/ +''/ _)" [54,54] 52)
X__vpl__X :: "Vec => Vec => Vec" ("(_/ vpl/ _)" [54,54] 52)
X_x :: "Vec => Real" ("x/'(_')" [3] 999)
X_y :: "Vec => Real" ("y/'(_')" [3] 999)
vminus__X :: "Vec => Vec" ("(vminus/ _)" [56] 56)
vzero :: "Vec"

axiomatization
where
ga_selector_x [rule_format] :
"ALL XX1. ALL XX2. x(pair(XX1, XX2)) = XX1"
and
ga_selector_y [rule_format] :
"ALL XX1. ALL XX2. y(pair(XX1, XX2)) = XX2"
and
ga_injective_pair [rule_format] :
"ALL XX1.
 ALL XX2.
 ALL Y1.
 ALL Y2. pair(XX1, XX2) = pair(Y1, Y2) = (XX1 = Y1 & XX2 = Y2)"
and
Ax5 [rule_format] : "ALL X_x. X_x +' 0' = X_x"
and
Ax6 [rule_format] : "ALL X_x. ALL X_y. X_x +' X_y = X_y +' X_x"
and
Ax77 [rule_format] :
"ALL X_x. ALL X_y. ALL z.  (X_x +' X_y) +' z = X_x +' (X_y +' z)"
and
Ax7 [rule_format] :
"ALL X_x. ALL X_y. ALL z. X_x +' (X_y +' z) = (X_x +' X_y) +' z"
and
Ax8 [rule_format] : "ALL X_x. X_x +' -' X_x = 0'"
and
Ax9 [rule_format] :
"ALL X_x.
 ALL X_y.
 ALL z.
 ALL t. pair(X_x, X_y) vpl pair(z, t) = pair(X_x +' z, X_y +' t)"
and
Ax10 [rule_format] :
"ALL X_x. ALL X_y. vminus pair(X_x, X_y) = pair(-' X_x, -' X_y)"
and
Ax11 [rule_format] : "vzero = pair(0', 0')"

declare ga_selector_x [simp]
declare ga_selector_y [simp]
declare Ax5 [simp]
declare Ax8 [simp]

theorem double_minus: "-' (-' z) = z"
proof -
have "z +' ((-' z) +' (-' (-' z))) = z +' 0'"
by (simp only: Ax8)
also have "(z +' -' z) +' (-' (-' z)) = z +' 0'"
by (simp only: Ax7)
also have "'0 +' (-' (-' z)) = ..."
by (simp only: Ax8)


theorem Ax12 : "ALL a. vminus vminus a = a"
apply safe
apply (case_tac a)
apply (auto simp add: Ax9 Ax8 Ax10 Ax11)
oops

setup "Header.record \"Ax12\""

theorem Ax1 : "ALL X_x. X_x vpl vzero = X_x"
by (auto)

setup "Header.record \"Ax1\""

theorem Ax2 : "ALL X_x. ALL X_y. X_x vpl X_y = X_y vpl X_x"
by (auto)

setup "Header.record \"Ax2\""

theorem Ax3 :
"ALL X_x.
 ALL X_y. ALL z. X_x vpl (X_y vpl z) = (X_x vpl X_y) vpl z"
by (auto)

setup "Header.record \"Ax3\""

theorem Ax4 : "ALL X_x. X_x vpl vminus X_x = vzero"
by (auto)

setup "Header.record \"Ax4\""

end
