#!/bin/sh
#
#	megatest.sh - master test script for CRM114
#		output is normally compared to megatest_knowngood.log

# Copyright 2009 William S. Yerazunis.
# This file is under GPLv3, as described in COPYING.
#

build/crm -v
build/crm tests/bracktest.crm
build/crm tests/escapetest.crm
build/crm tests/fataltraptest.crm
build/crm tests/inserttest_a.crm
build/crm tests/matchtest.crm  <<-EOF
exact: you should see this foo ZZZ
exact: you should NOT see this FoO ZZZ
absent: There is no "f-word" here ZZZ
absent: but there's a foo here ZZZ
nocase: you should see this fOo ZZZ
nocase: and there is no "f-word" here ZZZ
nocase absent: and there is no "f-word" here ZZZ
nocase absent: and there is a foo here ZZZ
multiline:  this is a multiline test of foo
multiline-- should see both lines ZZZ
multiline:  this is a multiline test of "f-word"
multiline-- should see both lines ZZZ
nomultiline:  this is a nomultiline test of foo
nomultiline-- should NOT see both lines ZZZ
nomultiline:  this is a nomultiline test of "f-word"
nomultiline-- should NOT see both lines ZZZ
fromendchar:  should see this line foo followed by bar ZZZ
fromendchar:  should NOT see this line bar followed by foo ZZZ
fromnext: should not see foo but should see ffoooo ZZZ
fromnext: should not see foo but should see f-oooo ZZZ
newend: should not see foo but should see ffooo ZZZ
newend: should not see foo and should not see f-ooo ZZZ
indirect go to :twist:  ZZZ
indirect go to :shout2:  ZZZ
self-supplied: foo123bar
wugga
smith 123 anderson ZZZ
self-supplied: foo123bar
wugga
smith 456 anderson ZZZ
independent-start-end: foo bar 1 2 foo bar ZZZ
independent-start-end: foo bar foo 1 2 bar ZZZ
independent-start-end: foo 1 foo bar 2 bar ZZZ
independent-start-end: foo 2 bar 1 bar foo ZZZ
EOF
build/crm tests/backwardstest.crm  <<-EOF
foo bar baz
EOF
build/crm tests/backwardstest.crm  <<-EOF
bar foo baz
EOF
build/crm tests/overalterisolatedtest.crm
build/crm tests/rewritetest.crm
build/crm tests/skudtest.crm
build/crm tests/statustest.crm
build/crm tests/unionintersecttest.crm
build/crm tests/beeptest.crm
build/crm tests/defaulttest.crm
build/crm tests/defaulttest.crm --blah="command override"
build/crm tests/windowtest.crm  <<-EOF
This is the test one result A this is the test two result A this is the test three result A this is the test four result A this is the test 5 result A this is the test six result A this is extra stuff and should never be seen.
EOF
build/crm tests/windowtest_fromvar.crm  <<-EOF
This is the test one result A this is the test two result A this is the test three result A this is the test four result A this is the test 5 result A this is the test six result A this is extra stuff and should trigger exit from the loop since it doesn't have the proper delimiter.
EOF
build/crm tests/approxtest.crm  <<-EOF
(foo) {1}
(fou){~}
(foo) {1}
(fou){~0}
(foo) {1}
(fou){~1}
(foo) {1}
(fou){~2}
(fou){~3}
(fuu){~}
(fuu){~0}
(fuu){~1}
(fuu){~2}
(fuu){~3}
(fou){#}
(fou){#0}
(fou){#1}
(fou){#2}
(fou){#3}
(fou){# ~1}
(fou){#0 ~1}
(fou){#1 ~1}
(fou){#2 ~1}
(fou){#3 ~1}
(fuu){#}
(fuu){#0}
(fuu){#1}
(fuu){#2}
(fuu){#3}
(fuu){# ~1}
(fuu){#0 ~1}
(fuu){#1 ~1}
(fuu){#2 ~1}
(fuu){#3 ~1}
(fuu){# ~2}
(fuu){#0 ~2}
(fuu){#1 ~2}
(fuu){#2 ~2}
(fuu){#3 ~2}
(fuu){# ~3}
(fuu){#0 ~3}
(fuu){#1 ~3}
(fuu){#2 ~3}
(fuu){#3 ~3}
(fuu){# ~}
(fuu){#0 ~}
(fuu){#1 ~}
(fuu){#2 ~}
(fuu){#3 ~}
(fou){#}
(fou){#0}
(fou){+1 -1}
(fou){+2 -2}
(fou){+3 -3}
(fou){# ~1}
(fou){#0 ~1}
(fou){+1 -1 ~1}
(fou){+2 -2 ~1}
(fou){+3 -3 ~1}
(fou){# ~2}
(fou){#0 ~2}
(fou){+1 -1 ~2}
(fou){+2 -2 ~2}
(fou){+3 -3 ~2}
(fou){# ~3}
(fou){#0 ~3}
(fou){+1 -1 ~3}
(fou){+2 -2 ~3}
(fou){+3 -3 ~3}
(fou){# ~}
(fou){#0 ~}
(fou){+1 -1 ~}
(fou){+2 -2 ~}
(fou){+3 -3 ~}
(fuu){#}
(fuu){#0}
(fuu){+1 -1}
(fuu){+2 -2}
(fuu){+3 -3}
(fuu){# ~1}
(fuu){#0 ~1}
(fuu){+1 -1 ~1}
(fuu){+2 -2 ~1}
(fuu){+3 -3 ~1}
(fuu){# ~2}
(fuu){#0 ~2}
(fuu){+1 -1 ~2}
(fuu){+2 -2 ~2}
(fuu){+3 -3 ~2}
(fuu){# ~3}
(fuu){#0 ~3}
(fuu){+1 -1 ~3}
(fuu){+2 -2 ~3}
(fuu){+3 -3 ~3}
(fuu){# ~}
(fuu){#0 ~}
(fuu){+1 -1 ~}
(fuu){+2 -2 ~}
(fuu){+3 -3 ~}
(anaconda){~}
(anaonda){ 1i + 1d < 1 }
(anaonda){ 1i + 1d < 2 }
(ananda){ 1i + 1d < 1 }
(ananda){ 1i + 1d < 2 }
(ananda){ 1i + 1d < 3 }
(ana123conda){ 1i + 1d < 2 }
(ana123conda){ 1i + 1d < 3 }
(ana123conda){ 1i + 1d < 4 }
(ana123cona){ 1i + 1d < 4 }
(ana123cona){ 1i + 1d < 5 }
(ana123coa){ 1i + 1d < 4 }
(ana123coa){ 1i + 1d < 5 }
(ana123coa){ 1i + 1d < 6 }
(ana123ca){ 1i + 1d < 4 }
(ana123a){ 1i + 1d < 4 }
(ana123a){ 1i + 1d < 3 }
(anukeonda){~}
(anaconda){ 1i + 1d < 1}
(anaconda){ 1i + 1d < 1, #1}
(anaconda){ 1i + 1d < 1 #1 ~10 }
(anaconda){ #1, ~1, 1i + 1d < 1 }
(anaconda){ #1 ~1 1i + 1d < 1 }
(anacnda){ #1 ~1 1i + 1d < 1 }
(agentsmith){~}
(annndersen){~}
(anentemstn){~}
(anacda){~}
(anacda){ #1 ~1 1i + 1d < 1 }
(znacnda){ #1 ~1 1i + 1d < 1 }
(znacnda){ #1 ~2 1i + 1d < 1 }
(znacnda){ #1 ~3 1i + 1d < 1 }
(znacnda){ #1 ~3 1i + 1d < 2 }
(anac){~1}(onda){~1}
(aac){~1}(onda){~1}
(ac){~1}(onda){~1}
(anac){~1}(oda){~1}
(aac){~1}(oa){~1}
(ac){~1}(oa){~1}
(anac){~1}(onda){~1}
(anZac){~1}(onZda){~1}
(anZZac){~1}(onZda){~1}
(anZac){~1}(onZZda){~1}
([a-n]){3,100}
([a-n]){3,100}?
EOF
build/crm tests/mathalgtest.crm
build/crm tests/mathrpntest.crm -q 1
build/crm tests/eval_infiniteloop.crm
build/crm tests/randomiotest.crm
build/crm tests/paolo_overvars.crm
build/crm tests/paolo_ov2.crm
build/crm tests/paolo_ov3.crm
build/crm tests/paolo_ov4.crm
build/crm tests/paolo_ov5.crm
build/crm tests/match_isolate_test.crm -e
build/crm tests/match_isolate_reclaim.crm -e
build/crm tests/call_return_test.crm
build/crm tests/translate_tr.crm
build/crm tests/zz_translate_test.crm
build/crm tests/quine.crm
build/crm '-{window; isolate (:s:); syscall () (:s:) /echo one two three/; output /:*:s:/}'
build/crm '-{window; output / \n***** checking return and exit codes \n/}'
build/crm '-{window; isolate (:s:); syscall () () (:s:) /exit 123/; output / Status: :*:s: \n/}'
build/crm '-{window; output /\n***** check that failed syscalls will code right\n/}'
build/crm '-{window; isolate (:s:); syscall () () (:s:) /jibberjabber 2>&1 /; output / Status: :*:s: \n/}'

build/crm tests/indirecttest.crm
rm -f randtst.txt

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n ****  Default (SBPH Markovian) classifier \n/}'
build/crm '-{learn (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:) {classify ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:) {classify ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** OSB Markovian classifier \n/}'
build/crm '-{learn <osb> (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn <osb> (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify <osb> ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <osb> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** OSB Markov Unique classifier \n/}'
build/crm '-{learn <osb unique > (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn <osb unique > (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify <osb unique> ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <osb unique> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** OSB Markov Chisquared Unique classifier \n/}'
build/crm '-{learn <osb unique chi2> (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn <osb unique chi2> (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify <osb unique chi2 > ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <osb unique chi2> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** OSBF Local Confidence (Fidelis) classifier \n/}'
build/crm '-{learn < osbf > (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < osbf > (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify <osbf> ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <osbf> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output / \n**** OSB Winnow classifier \n/}'
build/crm '-{learn <winnow> (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn <winnow refute> (a_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{learn <winnow> (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{learn <winnow refute> (m_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{ isolate (:s:); {classify <winnow> ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }       '  <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <winnow> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}      ' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF
build/crm '-{ window; output /\n\n**** Now verify that winnow learns affect only the named file (m_test.css)\n/}'
build/crm '-{learn <winnow> (m_test.css) /[[:graph:]]+/}' < texts/Hound_of_the_Baskervilles_first_500_lines.txt
build/crm '-{ isolate (:s:); {classify <winnow> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}      ' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF
build/crm '-{window; output /\n\n and now refute-learn into a_test.css\n/}'
build/crm '-{learn <winnow refute > (a_test.css) /[[:graph:]]+/}' < texts/The_Wind_in_the_Willows_Chap_1.txt
build/crm '-{ isolate (:s:); {classify <winnow> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}      ' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** Unigram Bayesian classifier \n/}'
build/crm '-{learn <unigram> (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn <unigram> (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify <unigram> ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <unigram> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output / \n**** unigram Winnow classifier \n/}'
build/crm '-{learn <winnow unigram > (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn <winnow unigram refute> (a_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{learn <winnow unigram> (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{learn <winnow unigram refute> (m_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{ isolate (:s:); {classify <winnow unigram> ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }       '  <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <winnow unigram> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}      ' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF


rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** OSB Hyperspace classifier \n/}'
build/crm '-{learn <hyperspace unique> (a_test.css) }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn <hyperspace unique> (m_test.css) }' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify <hyperspace> ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <hyperspace> ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** OSB three-letter Hyperspace classifier \n/}'
build/crm '-{learn <hyperspace unigram> (a_test.css) /\w\w\w/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn <hyperspace unigram> (m_test.css) /\w\w\w/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify <hyperspace unigram> ( m_test.css | a_test.css ) (:s:) /\w\w\w/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <hyperspace unigram> ( m_test.css | a_test.css ) (:s:) /\w\w\w/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF


rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** Unigram Hyperspace classifier \n/}'
build/crm '-{learn < hyperspace unique unigram> (a_test.css) }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < hyperspace unique unigram> (m_test.css) }' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify < hyperspace unigram> ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <hyperspace unigram> ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** String Hyperspace classifier \n/}'
build/crm '-{learn < hyperspace string> (a_test.css) }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < hyperspace string> (m_test.css) }' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify < hyperspace string> ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <hyperspace string> ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** String Unigram Hyperspace classifier \n/}'
build/crm '-{learn < hyperspace string unigram> (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < hyperspace string unigram> (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify < hyperspace string unigram> ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <hyperspace string unigram> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** Vector 3-word-bag Hyperspace classifier \n/}'
#    the "vector: blahblah" is coded by the desired length of the pipeline,
#    then the number of iterations of the pipe, then pipelen * iters
#    integer coefficients.  Missing coefficients are taken as zero,
#    extra coefficients are disregarded.
build/crm '-{learn < hyperspace > (a_test.css) /[[:graph:]]+/ /vector: 3 1 1 1 1 / }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < hyperspace > (m_test.css) /[[:graph:]]+/ /vector: 3 1 1 1 1/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify < hyperspace > ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ /vector: 3 1 1 1 1  /; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <hyperspace > ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ /vector: 3 1 1 1 1 /; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF


rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** Bit-Entropy classifier \n/}'
build/crm '-{learn < entropy unique crosslink> (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < entropy unique crosslink> (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify < entropy unique crosslink> ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify <entropy unique crosslink> ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** Bit-Entropy Toroid classifier \n/}'
build/crm '-{learn < entropy > (a_test.css) /[[:graph:]]+/}' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < entropy > (m_test.css) /[[:graph:]]+/}' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify < entropy > ( m_test.css | a_test.css ) (:s:)/[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify < entropy > ( m_test.css | a_test.css ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
build/crm '-{window; output /\n**** Fast Substring Compression Match Classifier \n/}'
build/crm '-{learn < fscm > (a_test.css) }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < fscm > (m_test.css) }' < texts/Macbeth_Act_IV.txt
build/crm '-{ isolate (:s:); {classify < fscm > ( m_test.css | a_test.css ) (:s:)  ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:); {classify < fscm > ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css

build/crm '-{window; output /\n**** Neural Network Classifier \n/}'
build/crm '-{learn < neural append > (a_test.css) }' <<-EOF
a
EOF
build/crm '-{learn < neural append > (a_test.css) }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{learn < neural refute fromstart > (a_test.css) }' < texts/Macbeth_Act_IV.txt
build/crm '-{learn < neural append > (m_test.css) }' <<-EOF
b
EOF
build/crm '-{learn < neural append > (m_test.css) }' < texts/Macbeth_Act_IV.txt
build/crm '-{learn < neural refute fromstart > (m_test.css) }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
build/crm '-{ isolate (:s:); {classify < neural > ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
So she was considering, in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when suddenly a White Rabbit with pink eyes ran close by her.
EOF
build/crm '-{ isolate (:s:); {classify < neural > ( m_test.css | a_test.css ) (:s:) ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Fillet of a fenny snake,
    In the cauldron boil and bake;
    Eye of newt and toe of frog,
    Wool of bat and tongue of dog,
    Adder's fork and blind-worm's sting,
    Lizard's leg and owlet's wing,
    For a charm of powerful trouble,
    Like a hell-broth boil and bubble.
EOF

rm -f m_test.css
rm -f a_test.css

build/crm tests/alternating_example_neural.crm

rm -f m_test.css
rm -f a_test.css

build/crm '-{window; output /\n**** Support Vector Machine (SVM) unigram classifier \n/}'
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < svm unigram unique > (m_test.css) /[[:graph:]]+/; liaf}' < texts/Macbeth_Act_IV.txt


build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < svm unigram refute unique > (m_test.css) /[[:graph:]]+/; liaf }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt

build/crm '-{ isolate (:s:); {classify < svm unigram unique > ( m_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 1e-3 1 0.5 1/ [:_dw:]   ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF

build/crm '-{ isolate (:s:); {classify < svm unigram unique > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 1e-3 1 0.5 1/ [:_dw:] ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css

build/crm '-{window; output /\n**** Support Vector Machine (SVM) classifier \n/}'
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < svm unique > (m_test.css) /[[:graph:]]+/; liaf}' < texts/Macbeth_Act_IV.txt
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < svm unique refute > (m_test.css) /[[:graph:]]+/; liaf }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt

build/crm '-{ isolate (:s:); {classify < svm unique > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 1e-3 1 0.5 1/ [:_dw:]   ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF

build/crm '-{ isolate (:s:); {classify < svm unique > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 1e-3 1 0.5 1/ [:_dw:] ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css
rm -f m_vs_a_test.css

build/crm tests/alternating_example_svm.crm

rm -f m_test.css
rm -f a_test.css

build/crm '-{window; output /\n**** String Kernel SVM (SKS) classifier \n/}'
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < sks > (m_test.css) /[[:graph:]]+/; liaf}' < texts/Macbeth_Act_IV.txt
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < sks > (a_test.css) /[[:graph:]]+/; liaf }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
#    build the actual hyperplanes
build/crm '-{window; learn ( m_test.css | a_test.css | m_vs_a_test.css ) < sks > /[[:graph:]]+/ /0 0 100 0.001 1 1 4/ }'

build/crm '-{ isolate (:s:); {classify < sks > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 0.001 1 1 4/ [:_dw:]   ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF

build/crm '-{ isolate (:s:); {classify < sks > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 0.001 1 1 4/ [:_dw:] ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF
rm -f m_vs_a_test.css
rm -f m_test.css
rm -f a_test.css

build/crm '-{window; output /\n**** String Kernel SVM (SKS) Unique classifier \n/}'
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; translate [:one_paragraph:] (:one_paragraph:) /.,!?@#$%^&*()/; learn [:one_paragraph:] < sks unique > (m_test.css) /[[:graph:]]+/ / 0 0 100 0.001 1 1 4/; liaf}' < texts/Macbeth_Act_IV.txt
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/;  translate [:one_paragraph:] (:one_paragraph:) /.,!?@#$%^&*()/; learn [:one_paragraph:] < sks unique > (a_test.css) /[[:graph:]]+/ /0 0 100 0.001 1 1 4/ ; liaf }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt
#    build the actual hyperplanes
build/crm '-{window; learn ( m_test.css | a_test.css | m_vs_a_test.css ) < sks unique > /[[:graph:]]+/ /0 0 100 0.001 1 1 4/ }'

build/crm '-{ isolate (:s:);  translate /.,!?@#$%^&*()/; {classify < sks unique > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 0.001 1 1 4/ [:_dw:]   ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF

build/crm '-{ isolate (:s:); translate /.,!?@#$%^&*()/; {classify < sks unique > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 0.001 1 1 4/ [:_dw:] ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_vs_a_test.css
rm -f m_test.css
rm -f a_test.css


build/crm '-{window ; output /\n**** Bytewise Correlation classifier \n/}'
build/crm '-{ isolate (:s:) {classify <correlate> ( Macbeth_Act_IV.txt | Alice_In_Wonderland_Chap_1_And_2.txt ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF
build/crm '-{ isolate (:s:) {classify <correlate> ( Macbeth_Act_IV.txt | Alice_In_Wonderland_Chap_1_And_2.txt ) (:s:) /[[:graph:]]+/ ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Fillet of a fenny snake,
    In the cauldron boil and bake;
    Eye of newt and toe of frog,
    Wool of bat and tongue of dog,
    Adder's fork and blind-worm's sting,
    Lizard's leg and owlet's wing,
    For a charm of powerful trouble,
    Like a hell-broth boil and bubble.
EOF

rm -f m_test.css
rm -f a_test.css

build/crm '-{window; output /\n**** Clump \/ Pmulc Test \n/}'

build/crm '-{ match <fromend> (:one_paragraph:) /([[:graph:]]+.*?\n\n){5}/; clump <bychunk> [:one_paragraph:] (m_test.css) /[[:graph:]]+/; output /./ ; liaf}' < texts/Macbeth_Act_IV.txt

build/crm '-{ match <fromend> (:one_paragraph:) /([[:graph:]]+.*?\n\n){5}/; clump [:one_paragraph:] <bychunk> (m_test.css) /[[:graph:]]+/; output /./; liaf }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt

#    Now see where our paragraphs go to

build/crm '-{ isolate (:s:); { pmulc  ( m_test.css) (:s:) <bychunk> /[[:graph:]]+/  [:_dw:]   ; output /Likely result: \n:*:s:\n/} alius { output / Unsure result \n:*:s:\n/ } }' <<-EOF
So she was considering, in her own mind (as well as she could, for the
hot day made her feel very sleepy and stupid), whether the pleasure of
making a daisy-chain would be worth the trouble of getting up and
picking the daisies, when suddenly a White Rabbit with pink eyes ran
close by her.
EOF

build/crm '-{ isolate (:s:); { pmulc  ( m_test.css) (:s:) <bychunk> /[[:graph:]]+/  [:_dw:]   ; output /Likely result: \n:*:s:\n/} alius { output / Unsure result \n:*:s:\n/ } }' <<-EOF
    Fillet of a fenny snake,
    In the cauldron boil and bake;
    Eye of newt and toe of frog,
    Wool of bat and tongue of dog,
    Adder's fork and blind-worm's sting,
    Lizard's leg and owlet's wing,
    For a charm of powerful trouble,
    Like a hell-broth boil and bubble.
EOF

build/crm '-{ isolate (:s:); { pmulc  ( m_test.css) (:s:) <bychunk> /[[:graph:]]+/  [:_dw:]   ; output /Likely result: \n:*:s:\n/} alius { output / Unsure result \n:*:s:\n/ } }' <<-EOF
EOF

rm -f m_test.css
rm -f a_test.css

build/crm '-{window; output /\n**** Principal Component Analysis (PCA) unigram classifier \n/}'
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < pca unigram unique > (m_test.css) /[[:graph:]]+/; liaf}' < texts/Macbeth_Act_IV.txt


build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < pca unigram refute unique > (m_test.css) /[[:graph:]]+/; liaf }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt

build/crm '-{ isolate (:s:); {classify < pca unigram unique > ( m_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 1e-3 1 0.5 1/ [:_dw:]   ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF

build/crm '-{ isolate (:s:); {classify < pca unigram unique > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 1e-3 1 0.5 1/ [:_dw:] ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css

build/crm '-{window; output /\n**** Principal Component Analysis (PCA) classifier \n/}'
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < pca unique > (m_test.css) /[[:graph:]]+/; liaf}' < texts/Macbeth_Act_IV.txt
build/crm '-{ match <fromend> (:one_paragraph:) /[[:graph:]]+.*?\n\n/; learn [:one_paragraph:] < pca unique refute > (m_test.css) /[[:graph:]]+/; liaf }' < texts/Alice_In_Wonderland_Chap_1_And_2.txt

build/crm '-{ isolate (:s:); {classify < pca unique > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 1e-3 1 0.5 1/ [:_dw:]   ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ } }' <<-EOF
when suddenly a White Rabbit with pink eyes ran close to her.
EOF

build/crm '-{ isolate (:s:); {classify < pca unique > ( m_test.css | a_test.css | m_vs_a_test.css ) (:s:) /[[:graph:]]+/ /0 0 100 1e-3 1 0.5 1/ [:_dw:] ; output / type M \n:*:s:\n/} alius { output / type A \n:*:s:\n/ }}' <<-EOF
    Double, double toil and trouble;
    Fire burn, and cauldron bubble.
EOF

rm -f m_test.css
rm -f a_test.css

build/crm tests/alternating_example_pca.crm

rm -f m_test.css
rm -f a_test.css
