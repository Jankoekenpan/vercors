(get-info :version)
; (:version "4.8.7")
; Started: 2020-09-07 16:39:34
; Silicon.version: 1.1-SNAPSHOT (0964fff4)
; Input file: elect_full.sil
; Verifier id: 00
; ------------------------------------------------------------
; Begin preamble
; ////////// Static preamble
; 
; ; /z3config.smt2
(set-option :print-success true) ; Boogie: false
(set-option :global-decls true) ; Boogie: default
(set-option :auto_config false) ; Usually a good idea
(set-option :smt.restart_strategy 0)
(set-option :smt.restart_factor |1.5|)
(set-option :smt.case_split 3)
(set-option :smt.delay_units true)
(set-option :smt.delay_units_threshold 16)
(set-option :nnf.sk_hack true)
(set-option :type_check true)
(set-option :smt.bv.reflect true)
(set-option :smt.mbqi false)
(set-option :smt.qi.eager_threshold 100)
(set-option :smt.qi.cost "(+ weight generation)")
(set-option :smt.qi.max_multi_patterns 1000)
(set-option :smt.phase_selection 0) ; default: 3, Boogie: 0
(set-option :sat.phase caching)
(set-option :sat.random_seed 0)
(set-option :nlsat.randomize true)
(set-option :nlsat.seed 0)
(set-option :nlsat.shuffle_vars false)
(set-option :fp.spacer.order_children 0) ; Not available with Z3 4.5
(set-option :fp.spacer.random_seed 0) ; Not available with Z3 4.5
(set-option :smt.arith.random_initial_value true) ; Boogie: true
(set-option :smt.random_seed 0)
(set-option :sls.random_offset true)
(set-option :sls.random_seed 0)
(set-option :sls.restart_init false)
(set-option :sls.walksat_ucb true)
(set-option :model.v2 true)
; 
; ; /preamble.smt2
(declare-datatypes () ((
    $Snap ($Snap.unit)
    ($Snap.combine ($Snap.first $Snap) ($Snap.second $Snap)))))
(declare-sort $Ref 0)
(declare-const $Ref.null $Ref)
(declare-sort $FPM)
(declare-sort $PPM)
(define-sort $Perm () Real)
(define-const $Perm.Write $Perm 1.0)
(define-const $Perm.No $Perm 0.0)
(define-fun $Perm.isValidVar ((p $Perm)) Bool
	(<= $Perm.No p))
(define-fun $Perm.isReadVar ((p $Perm) (ub $Perm)) Bool
    (and ($Perm.isValidVar p)
         (not (= p $Perm.No))
         (< p $Perm.Write)))
(define-fun $Perm.min ((p1 $Perm) (p2 $Perm)) Real
    (ite (<= p1 p2) p1 p2))
(define-fun $Math.min ((a Int) (b Int)) Int
    (ite (<= a b) a b))
(define-fun $Math.clip ((a Int)) Int
    (ite (< a 0) 0 a))
; ////////// Sorts
(declare-sort Seq<Int>)
(declare-sort Seq<Seq<Int>>)
(declare-sort Set<Seq<Seq<Int>>>)
(declare-sort Set<Seq<Int>>)
(declare-sort Set<Bool>)
(declare-sort Set<Int>)
(declare-sort Set<$Ref>)
(declare-sort Set<frac>)
(declare-sort Set<$Snap>)
(declare-sort Process)
(declare-sort zfrac)
(declare-sort frac)
(declare-sort $FVF<Seq<Seq<Int>>>)
(declare-sort $FVF<$Ref>)
(declare-sort $FVF<Seq<Int>>)
; ////////// Sort wrappers
; Declaring additional sort wrappers
(declare-fun $SortWrappers.IntTo$Snap (Int) $Snap)
(declare-fun $SortWrappers.$SnapToInt ($Snap) Int)
(assert (forall ((x Int)) (!
    (= x ($SortWrappers.$SnapToInt($SortWrappers.IntTo$Snap x)))
    :pattern (($SortWrappers.IntTo$Snap x))
    :qid |$Snap.$SnapToIntTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.IntTo$Snap($SortWrappers.$SnapToInt x)))
    :pattern (($SortWrappers.$SnapToInt x))
    :qid |$Snap.IntTo$SnapToInt|
    )))
(declare-fun $SortWrappers.BoolTo$Snap (Bool) $Snap)
(declare-fun $SortWrappers.$SnapToBool ($Snap) Bool)
(assert (forall ((x Bool)) (!
    (= x ($SortWrappers.$SnapToBool($SortWrappers.BoolTo$Snap x)))
    :pattern (($SortWrappers.BoolTo$Snap x))
    :qid |$Snap.$SnapToBoolTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.BoolTo$Snap($SortWrappers.$SnapToBool x)))
    :pattern (($SortWrappers.$SnapToBool x))
    :qid |$Snap.BoolTo$SnapToBool|
    )))
(declare-fun $SortWrappers.$RefTo$Snap ($Ref) $Snap)
(declare-fun $SortWrappers.$SnapTo$Ref ($Snap) $Ref)
(assert (forall ((x $Ref)) (!
    (= x ($SortWrappers.$SnapTo$Ref($SortWrappers.$RefTo$Snap x)))
    :pattern (($SortWrappers.$RefTo$Snap x))
    :qid |$Snap.$SnapTo$RefTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$RefTo$Snap($SortWrappers.$SnapTo$Ref x)))
    :pattern (($SortWrappers.$SnapTo$Ref x))
    :qid |$Snap.$RefTo$SnapTo$Ref|
    )))
(declare-fun $SortWrappers.$PermTo$Snap ($Perm) $Snap)
(declare-fun $SortWrappers.$SnapTo$Perm ($Snap) $Perm)
(assert (forall ((x $Perm)) (!
    (= x ($SortWrappers.$SnapTo$Perm($SortWrappers.$PermTo$Snap x)))
    :pattern (($SortWrappers.$PermTo$Snap x))
    :qid |$Snap.$SnapTo$PermTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$PermTo$Snap($SortWrappers.$SnapTo$Perm x)))
    :pattern (($SortWrappers.$SnapTo$Perm x))
    :qid |$Snap.$PermTo$SnapTo$Perm|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.Seq<Int>To$Snap (Seq<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSeq<Int> ($Snap) Seq<Int>)
(assert (forall ((x Seq<Int>)) (!
    (= x ($SortWrappers.$SnapToSeq<Int>($SortWrappers.Seq<Int>To$Snap x)))
    :pattern (($SortWrappers.Seq<Int>To$Snap x))
    :qid |$Snap.$SnapToSeq<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Seq<Int>To$Snap($SortWrappers.$SnapToSeq<Int> x)))
    :pattern (($SortWrappers.$SnapToSeq<Int> x))
    :qid |$Snap.Seq<Int>To$SnapToSeq<Int>|
    )))
(declare-fun $SortWrappers.Seq<Seq<Int>>To$Snap (Seq<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapToSeq<Seq<Int>> ($Snap) Seq<Seq<Int>>)
(assert (forall ((x Seq<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapToSeq<Seq<Int>>($SortWrappers.Seq<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.Seq<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapToSeq<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Seq<Seq<Int>>To$Snap($SortWrappers.$SnapToSeq<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapToSeq<Seq<Int>> x))
    :qid |$Snap.Seq<Seq<Int>>To$SnapToSeq<Seq<Int>>|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.Set<Seq<Seq<Int>>>To$Snap (Set<Seq<Seq<Int>>>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Seq<Seq<Int>>> ($Snap) Set<Seq<Seq<Int>>>)
(assert (forall ((x Set<Seq<Seq<Int>>>)) (!
    (= x ($SortWrappers.$SnapToSet<Seq<Seq<Int>>>($SortWrappers.Set<Seq<Seq<Int>>>To$Snap x)))
    :pattern (($SortWrappers.Set<Seq<Seq<Int>>>To$Snap x))
    :qid |$Snap.$SnapToSet<Seq<Seq<Int>>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Seq<Seq<Int>>>To$Snap($SortWrappers.$SnapToSet<Seq<Seq<Int>>> x)))
    :pattern (($SortWrappers.$SnapToSet<Seq<Seq<Int>>> x))
    :qid |$Snap.Set<Seq<Seq<Int>>>To$SnapToSet<Seq<Seq<Int>>>|
    )))
(declare-fun $SortWrappers.Set<Seq<Int>>To$Snap (Set<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Seq<Int>> ($Snap) Set<Seq<Int>>)
(assert (forall ((x Set<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapToSet<Seq<Int>>($SortWrappers.Set<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.Set<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapToSet<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Seq<Int>>To$Snap($SortWrappers.$SnapToSet<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapToSet<Seq<Int>> x))
    :qid |$Snap.Set<Seq<Int>>To$SnapToSet<Seq<Int>>|
    )))
(declare-fun $SortWrappers.Set<Bool>To$Snap (Set<Bool>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Bool> ($Snap) Set<Bool>)
(assert (forall ((x Set<Bool>)) (!
    (= x ($SortWrappers.$SnapToSet<Bool>($SortWrappers.Set<Bool>To$Snap x)))
    :pattern (($SortWrappers.Set<Bool>To$Snap x))
    :qid |$Snap.$SnapToSet<Bool>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Bool>To$Snap($SortWrappers.$SnapToSet<Bool> x)))
    :pattern (($SortWrappers.$SnapToSet<Bool> x))
    :qid |$Snap.Set<Bool>To$SnapToSet<Bool>|
    )))
(declare-fun $SortWrappers.Set<Int>To$Snap (Set<Int>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<Int> ($Snap) Set<Int>)
(assert (forall ((x Set<Int>)) (!
    (= x ($SortWrappers.$SnapToSet<Int>($SortWrappers.Set<Int>To$Snap x)))
    :pattern (($SortWrappers.Set<Int>To$Snap x))
    :qid |$Snap.$SnapToSet<Int>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<Int>To$Snap($SortWrappers.$SnapToSet<Int> x)))
    :pattern (($SortWrappers.$SnapToSet<Int> x))
    :qid |$Snap.Set<Int>To$SnapToSet<Int>|
    )))
(declare-fun $SortWrappers.Set<$Ref>To$Snap (Set<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Ref> ($Snap) Set<$Ref>)
(assert (forall ((x Set<$Ref>)) (!
    (= x ($SortWrappers.$SnapToSet<$Ref>($SortWrappers.Set<$Ref>To$Snap x)))
    :pattern (($SortWrappers.Set<$Ref>To$Snap x))
    :qid |$Snap.$SnapToSet<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Ref>To$Snap($SortWrappers.$SnapToSet<$Ref> x)))
    :pattern (($SortWrappers.$SnapToSet<$Ref> x))
    :qid |$Snap.Set<$Ref>To$SnapToSet<$Ref>|
    )))
(declare-fun $SortWrappers.Set<frac>To$Snap (Set<frac>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<frac> ($Snap) Set<frac>)
(assert (forall ((x Set<frac>)) (!
    (= x ($SortWrappers.$SnapToSet<frac>($SortWrappers.Set<frac>To$Snap x)))
    :pattern (($SortWrappers.Set<frac>To$Snap x))
    :qid |$Snap.$SnapToSet<frac>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<frac>To$Snap($SortWrappers.$SnapToSet<frac> x)))
    :pattern (($SortWrappers.$SnapToSet<frac> x))
    :qid |$Snap.Set<frac>To$SnapToSet<frac>|
    )))
(declare-fun $SortWrappers.Set<$Snap>To$Snap (Set<$Snap>) $Snap)
(declare-fun $SortWrappers.$SnapToSet<$Snap> ($Snap) Set<$Snap>)
(assert (forall ((x Set<$Snap>)) (!
    (= x ($SortWrappers.$SnapToSet<$Snap>($SortWrappers.Set<$Snap>To$Snap x)))
    :pattern (($SortWrappers.Set<$Snap>To$Snap x))
    :qid |$Snap.$SnapToSet<$Snap>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.Set<$Snap>To$Snap($SortWrappers.$SnapToSet<$Snap> x)))
    :pattern (($SortWrappers.$SnapToSet<$Snap> x))
    :qid |$Snap.Set<$Snap>To$SnapToSet<$Snap>|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.ProcessTo$Snap (Process) $Snap)
(declare-fun $SortWrappers.$SnapToProcess ($Snap) Process)
(assert (forall ((x Process)) (!
    (= x ($SortWrappers.$SnapToProcess($SortWrappers.ProcessTo$Snap x)))
    :pattern (($SortWrappers.ProcessTo$Snap x))
    :qid |$Snap.$SnapToProcessTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.ProcessTo$Snap($SortWrappers.$SnapToProcess x)))
    :pattern (($SortWrappers.$SnapToProcess x))
    :qid |$Snap.ProcessTo$SnapToProcess|
    )))
(declare-fun $SortWrappers.zfracTo$Snap (zfrac) $Snap)
(declare-fun $SortWrappers.$SnapTozfrac ($Snap) zfrac)
(assert (forall ((x zfrac)) (!
    (= x ($SortWrappers.$SnapTozfrac($SortWrappers.zfracTo$Snap x)))
    :pattern (($SortWrappers.zfracTo$Snap x))
    :qid |$Snap.$SnapTozfracTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.zfracTo$Snap($SortWrappers.$SnapTozfrac x)))
    :pattern (($SortWrappers.$SnapTozfrac x))
    :qid |$Snap.zfracTo$SnapTozfrac|
    )))
(declare-fun $SortWrappers.fracTo$Snap (frac) $Snap)
(declare-fun $SortWrappers.$SnapTofrac ($Snap) frac)
(assert (forall ((x frac)) (!
    (= x ($SortWrappers.$SnapTofrac($SortWrappers.fracTo$Snap x)))
    :pattern (($SortWrappers.fracTo$Snap x))
    :qid |$Snap.$SnapTofracTo$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.fracTo$Snap($SortWrappers.$SnapTofrac x)))
    :pattern (($SortWrappers.$SnapTofrac x))
    :qid |$Snap.fracTo$SnapTofrac|
    )))
; Declaring additional sort wrappers
(declare-fun $SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap ($FVF<Seq<Seq<Int>>>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<Seq<Seq<Int>>> ($Snap) $FVF<Seq<Seq<Int>>>)
(assert (forall ((x $FVF<Seq<Seq<Int>>>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<Seq<Seq<Int>>>($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap x)))
    :pattern (($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<Seq<Seq<Int>>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap($SortWrappers.$SnapTo$FVF<Seq<Seq<Int>>> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<Seq<Seq<Int>>> x))
    :qid |$Snap.$FVF<Seq<Seq<Int>>>To$SnapTo$FVF<Seq<Seq<Int>>>|
    )))
(declare-fun $SortWrappers.$FVF<$Ref>To$Snap ($FVF<$Ref>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<$Ref> ($Snap) $FVF<$Ref>)
(assert (forall ((x $FVF<$Ref>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<$Ref>($SortWrappers.$FVF<$Ref>To$Snap x)))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<$Ref>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<$Ref>To$Snap($SortWrappers.$SnapTo$FVF<$Ref> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<$Ref> x))
    :qid |$Snap.$FVF<$Ref>To$SnapTo$FVF<$Ref>|
    )))
(declare-fun $SortWrappers.$FVF<Seq<Int>>To$Snap ($FVF<Seq<Int>>) $Snap)
(declare-fun $SortWrappers.$SnapTo$FVF<Seq<Int>> ($Snap) $FVF<Seq<Int>>)
(assert (forall ((x $FVF<Seq<Int>>)) (!
    (= x ($SortWrappers.$SnapTo$FVF<Seq<Int>>($SortWrappers.$FVF<Seq<Int>>To$Snap x)))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap x))
    :qid |$Snap.$SnapTo$FVF<Seq<Int>>To$Snap|
    )))
(assert (forall ((x $Snap)) (!
    (= x ($SortWrappers.$FVF<Seq<Int>>To$Snap($SortWrappers.$SnapTo$FVF<Seq<Int>> x)))
    :pattern (($SortWrappers.$SnapTo$FVF<Seq<Int>> x))
    :qid |$Snap.$FVF<Seq<Int>>To$SnapTo$FVF<Seq<Int>>|
    )))
; ////////// Symbols
(declare-fun Set_in (Seq<Seq<Int>> Set<Seq<Seq<Int>>>) Bool)
(declare-fun Set_card (Set<Seq<Seq<Int>>>) Int)
(declare-const Set_empty Set<Seq<Seq<Int>>>)
(declare-fun Set_singleton (Seq<Seq<Int>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_unionone (Set<Seq<Seq<Int>>> Seq<Seq<Int>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_union (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_disjoint (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Bool)
(declare-fun Set_difference (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_intersection (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Set<Seq<Seq<Int>>>)
(declare-fun Set_subset (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Bool)
(declare-fun Set_equal (Set<Seq<Seq<Int>>> Set<Seq<Seq<Int>>>) Bool)
(declare-fun Set_in (Seq<Int> Set<Seq<Int>>) Bool)
(declare-fun Set_card (Set<Seq<Int>>) Int)
(declare-const Set_empty Set<Seq<Int>>)
(declare-fun Set_singleton (Seq<Int>) Set<Seq<Int>>)
(declare-fun Set_unionone (Set<Seq<Int>> Seq<Int>) Set<Seq<Int>>)
(declare-fun Set_union (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_disjoint (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_difference (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_intersection (Set<Seq<Int>> Set<Seq<Int>>) Set<Seq<Int>>)
(declare-fun Set_subset (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_equal (Set<Seq<Int>> Set<Seq<Int>>) Bool)
(declare-fun Set_in (Bool Set<Bool>) Bool)
(declare-fun Set_card (Set<Bool>) Int)
(declare-const Set_empty Set<Bool>)
(declare-fun Set_singleton (Bool) Set<Bool>)
(declare-fun Set_unionone (Set<Bool> Bool) Set<Bool>)
(declare-fun Set_union (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_disjoint (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_difference (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_intersection (Set<Bool> Set<Bool>) Set<Bool>)
(declare-fun Set_subset (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_equal (Set<Bool> Set<Bool>) Bool)
(declare-fun Set_in (Int Set<Int>) Bool)
(declare-fun Set_card (Set<Int>) Int)
(declare-const Set_empty Set<Int>)
(declare-fun Set_singleton (Int) Set<Int>)
(declare-fun Set_unionone (Set<Int> Int) Set<Int>)
(declare-fun Set_union (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_disjoint (Set<Int> Set<Int>) Bool)
(declare-fun Set_difference (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_intersection (Set<Int> Set<Int>) Set<Int>)
(declare-fun Set_subset (Set<Int> Set<Int>) Bool)
(declare-fun Set_equal (Set<Int> Set<Int>) Bool)
(declare-fun Set_in ($Ref Set<$Ref>) Bool)
(declare-fun Set_card (Set<$Ref>) Int)
(declare-const Set_empty Set<$Ref>)
(declare-fun Set_singleton ($Ref) Set<$Ref>)
(declare-fun Set_unionone (Set<$Ref> $Ref) Set<$Ref>)
(declare-fun Set_union (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_disjoint (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_difference (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_intersection (Set<$Ref> Set<$Ref>) Set<$Ref>)
(declare-fun Set_subset (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_equal (Set<$Ref> Set<$Ref>) Bool)
(declare-fun Set_in (frac Set<frac>) Bool)
(declare-fun Set_card (Set<frac>) Int)
(declare-const Set_empty Set<frac>)
(declare-fun Set_singleton (frac) Set<frac>)
(declare-fun Set_unionone (Set<frac> frac) Set<frac>)
(declare-fun Set_union (Set<frac> Set<frac>) Set<frac>)
(declare-fun Set_disjoint (Set<frac> Set<frac>) Bool)
(declare-fun Set_difference (Set<frac> Set<frac>) Set<frac>)
(declare-fun Set_intersection (Set<frac> Set<frac>) Set<frac>)
(declare-fun Set_subset (Set<frac> Set<frac>) Bool)
(declare-fun Set_equal (Set<frac> Set<frac>) Bool)
(declare-fun Set_in ($Snap Set<$Snap>) Bool)
(declare-fun Set_card (Set<$Snap>) Int)
(declare-const Set_empty Set<$Snap>)
(declare-fun Set_singleton ($Snap) Set<$Snap>)
(declare-fun Set_unionone (Set<$Snap> $Snap) Set<$Snap>)
(declare-fun Set_union (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_disjoint (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_difference (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_intersection (Set<$Snap> Set<$Snap>) Set<$Snap>)
(declare-fun Set_subset (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Set_equal (Set<$Snap> Set<$Snap>) Bool)
(declare-fun Seq_length (Seq<Int>) Int)
(declare-const Seq_empty Seq<Int>)
(declare-fun Seq_singleton (Int) Seq<Int>)
(declare-fun Seq_build (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_index (Seq<Int> Int) Int)
(declare-fun Seq_append (Seq<Int> Seq<Int>) Seq<Int>)
(declare-fun Seq_update (Seq<Int> Int Int) Seq<Int>)
(declare-fun Seq_contains (Seq<Int> Int) Bool)
(declare-fun Seq_take (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_drop (Seq<Int> Int) Seq<Int>)
(declare-fun Seq_equal (Seq<Int> Seq<Int>) Bool)
(declare-fun Seq_sameuntil (Seq<Int> Seq<Int> Int) Bool)
(declare-fun Seq_range (Int Int) Seq<Int>)
(declare-fun Seq_length (Seq<Seq<Int>>) Int)
(declare-const Seq_empty Seq<Seq<Int>>)
(declare-fun Seq_singleton (Seq<Int>) Seq<Seq<Int>>)
(declare-fun Seq_build (Seq<Seq<Int>> Seq<Int>) Seq<Seq<Int>>)
(declare-fun Seq_index (Seq<Seq<Int>> Int) Seq<Int>)
(declare-fun Seq_append (Seq<Seq<Int>> Seq<Seq<Int>>) Seq<Seq<Int>>)
(declare-fun Seq_update (Seq<Seq<Int>> Int Seq<Int>) Seq<Seq<Int>>)
(declare-fun Seq_contains (Seq<Seq<Int>> Seq<Int>) Bool)
(declare-fun Seq_take (Seq<Seq<Int>> Int) Seq<Seq<Int>>)
(declare-fun Seq_drop (Seq<Seq<Int>> Int) Seq<Seq<Int>>)
(declare-fun Seq_equal (Seq<Seq<Int>> Seq<Seq<Int>>) Bool)
(declare-fun Seq_sameuntil (Seq<Seq<Int>> Seq<Seq<Int>> Int) Bool)
(declare-fun zfrac_val<Perm> (zfrac) $Perm)
(declare-fun frac_val<Perm> (frac) $Perm)
(declare-fun p_is_choice<Bool> (Process Process) Bool)
(declare-const p_empty<Process> Process)
(declare-fun p_merge<Process> (Process Process) Process)
(declare-fun p_choice<Process> (Process Process) Process)
(declare-fun p_seq<Process> (Process Process) Process)
(declare-fun p_method_Future_Send__Integer__Integer<Process> (Int Int) Process)
(declare-fun p_method_Future_Recv__Integer__Integer<Process> (Int Int) Process)
(declare-fun p_method_Future_Done__Integer__Integer<Process> (Int Int) Process)
(declare-fun p_method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer<Process> (Int Int Int Int Int Int) Process)
(declare-fun p_method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer<Process> (Int Int Int Int Int Int) Process)
(declare-fun p_method_Future_Elect__Integer__Integer__Integer__Integer__Integer<Process> (Int Int Int Int Int) Process)
(declare-fun p_method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer<Process> (Int Int Seq<Int> Int) Process)
(declare-fun p_method_Future_Start__Integer__Sequence$Integer$__Integer<Process> (Int Seq<Int> Int) Process)
; /field_value_functions_declarations.smt2 [channel_hist_value: Seq[Seq[Int]]]
(declare-fun $FVF.domain_channel_hist_value ($FVF<Seq<Seq<Int>>>) Set<$Ref>)
(declare-fun $FVF.lookup_channel_hist_value ($FVF<Seq<Seq<Int>>> $Ref) Seq<Seq<Int>>)
(declare-fun $FVF.after_channel_hist_value ($FVF<Seq<Seq<Int>>> $FVF<Seq<Seq<Int>>>) Bool)
(declare-fun $FVF.loc_channel_hist_value (Seq<Seq<Int>> $Ref) Bool)
(declare-fun $FVF.perm_channel_hist_value ($FPM $Ref) $Perm)
(declare-const $fvfTOP_channel_hist_value $FVF<Seq<Seq<Int>>>)
; /field_value_functions_declarations.smt2 [field_Program_f: Ref]
(declare-fun $FVF.domain_field_Program_f ($FVF<$Ref>) Set<$Ref>)
(declare-fun $FVF.lookup_field_Program_f ($FVF<$Ref> $Ref) $Ref)
(declare-fun $FVF.after_field_Program_f ($FVF<$Ref> $FVF<$Ref>) Bool)
(declare-fun $FVF.loc_field_Program_f ($Ref $Ref) Bool)
(declare-fun $FVF.perm_field_Program_f ($FPM $Ref) $Perm)
(declare-const $fvfTOP_field_Program_f $FVF<$Ref>)
; /field_value_functions_declarations.smt2 [channel_hist_act: Seq[Seq[Int]]]
(declare-fun $FVF.domain_channel_hist_act ($FVF<Seq<Seq<Int>>>) Set<$Ref>)
(declare-fun $FVF.lookup_channel_hist_act ($FVF<Seq<Seq<Int>>> $Ref) Seq<Seq<Int>>)
(declare-fun $FVF.after_channel_hist_act ($FVF<Seq<Seq<Int>>> $FVF<Seq<Seq<Int>>>) Bool)
(declare-fun $FVF.loc_channel_hist_act (Seq<Seq<Int>> $Ref) Bool)
(declare-fun $FVF.perm_channel_hist_act ($FPM $Ref) $Perm)
(declare-const $fvfTOP_channel_hist_act $FVF<Seq<Seq<Int>>>)
; /field_value_functions_declarations.smt2 [results_hist_value: Seq[Int]]
(declare-fun $FVF.domain_results_hist_value ($FVF<Seq<Int>>) Set<$Ref>)
(declare-fun $FVF.lookup_results_hist_value ($FVF<Seq<Int>> $Ref) Seq<Int>)
(declare-fun $FVF.after_results_hist_value ($FVF<Seq<Int>> $FVF<Seq<Int>>) Bool)
(declare-fun $FVF.loc_results_hist_value (Seq<Int> $Ref) Bool)
(declare-fun $FVF.perm_results_hist_value ($FPM $Ref) $Perm)
(declare-const $fvfTOP_results_hist_value $FVF<Seq<Int>>)
; /field_value_functions_declarations.smt2 [results_hist_act: Seq[Int]]
(declare-fun $FVF.domain_results_hist_act ($FVF<Seq<Int>>) Set<$Ref>)
(declare-fun $FVF.lookup_results_hist_act ($FVF<Seq<Int>> $Ref) Seq<Int>)
(declare-fun $FVF.after_results_hist_act ($FVF<Seq<Int>> $FVF<Seq<Int>>) Bool)
(declare-fun $FVF.loc_results_hist_act (Seq<Int> $Ref) Bool)
(declare-fun $FVF.perm_results_hist_act ($FPM $Ref) $Perm)
(declare-const $fvfTOP_results_hist_act $FVF<Seq<Int>>)
; /field_value_functions_declarations.smt2 [results_hist_init: Seq[Int]]
(declare-fun $FVF.domain_results_hist_init ($FVF<Seq<Int>>) Set<$Ref>)
(declare-fun $FVF.lookup_results_hist_init ($FVF<Seq<Int>> $Ref) Seq<Int>)
(declare-fun $FVF.after_results_hist_init ($FVF<Seq<Int>> $FVF<Seq<Int>>) Bool)
(declare-fun $FVF.loc_results_hist_init (Seq<Int> $Ref) Bool)
(declare-fun $FVF.perm_results_hist_init ($FPM $Ref) $Perm)
(declare-const $fvfTOP_results_hist_init $FVF<Seq<Int>>)
; Declaring symbols related to program functions (from program analysis)
(declare-fun method_Program_update__Sequence$Integer$__Integer__Integer ($Snap Seq<Int> Int Int) Seq<Int>)
(declare-fun method_Program_update__Sequence$Integer$__Integer__Integer%limited ($Snap Seq<Int> Int Int) Seq<Int>)
(declare-fun method_Program_update__Sequence$Integer$__Integer__Integer%stateless (Seq<Int> Int Int) Bool)
(declare-fun new_frac ($Snap $Perm) frac)
(declare-fun new_frac%limited ($Snap $Perm) frac)
(declare-fun new_frac%stateless ($Perm) Bool)
(declare-fun method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer ($Snap $Ref Seq<Seq<Int>> Int Int) Seq<Seq<Int>>)
(declare-fun method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer%limited ($Snap $Ref Seq<Seq<Int>> Int Int) Seq<Seq<Int>>)
(declare-fun method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer%stateless ($Ref Seq<Seq<Int>> Int Int) Bool)
(declare-fun method_Program_maxint__Sequence$Integer$__Integer__Integer ($Snap Seq<Int> Int Int) Int)
(declare-fun method_Program_maxint__Sequence$Integer$__Integer__Integer%limited ($Snap Seq<Int> Int Int) Int)
(declare-fun method_Program_maxint__Sequence$Integer$__Integer__Integer%stateless (Seq<Int> Int Int) Bool)
(declare-fun new_zfrac ($Snap $Perm) zfrac)
(declare-fun new_zfrac%limited ($Snap $Perm) zfrac)
(declare-fun new_zfrac%stateless ($Perm) Bool)
(declare-fun method_Program_pop__Sequence$Sequence$Integer$$__Integer ($Snap $Ref Seq<Seq<Int>> Int) Seq<Seq<Int>>)
(declare-fun method_Program_pop__Sequence$Sequence$Integer$$__Integer%limited ($Snap $Ref Seq<Seq<Int>> Int) Seq<Seq<Int>>)
(declare-fun method_Program_pop__Sequence$Sequence$Integer$$__Integer%stateless ($Ref Seq<Seq<Int>> Int) Bool)
; Snapshot variable to be used during function verification
(declare-fun s@$ () $Snap)
; Declaring predicate trigger functions
(declare-fun hist_do_method_Future_Send__Integer__Integer%trigger ($Snap $Ref frac Process) Bool)
(declare-fun hist_do_method_Future_Recv__Integer__Integer%trigger ($Snap $Ref frac Process) Bool)
(declare-fun hist_do_method_Future_Done__Integer__Integer%trigger ($Snap $Ref frac Process) Bool)
(declare-fun hist_idle%trigger ($Snap $Ref frac Process) Bool)
(declare-fun method_Program_lock_held%trigger ($Snap $Ref $Ref) Bool)
(declare-fun method_Program_lock_invariant%trigger ($Snap $Ref $Ref) Bool)
(declare-fun method_Main_joinToken%trigger ($Snap $Ref $Ref) Bool)
(declare-fun method_Main_idleToken%trigger ($Snap $Ref $Ref) Bool)
; ////////// Uniqueness assumptions from domains
; ////////// Axioms
(assert (forall ((s Seq<Int>)) (!
  (<= 0 (Seq_length s))
  :pattern ((Seq_length s))
  :qid |$Seq[Int]_prog.seq_length_non_negative|)))
(assert (= (Seq_length (as Seq_empty  Seq<Int>)) 0))
(assert (forall ((s Seq<Int>)) (!
  (implies (= (Seq_length s) 0) (= s (as Seq_empty  Seq<Int>)))
  :pattern ((Seq_length s))
  :qid |$Seq[Int]_prog.only_empty_seq_length_zero|)))
(assert (forall ((e Int)) (!
  (= (Seq_length (Seq_singleton e)) 1)
  :pattern ((Seq_length (Seq_singleton e)))
  :qid |$Seq[Int]_prog.length_singleton_seq|)))
(assert (forall ((s Seq<Int>) (e Int)) (!
  (= (Seq_length (Seq_build s e)) (+ 1 (Seq_length s)))
  :pattern ((Seq_length (Seq_build s e)))
  :qid |$Seq[Int]_prog.length_seq_build_inc_by_one|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int)) (!
  (ite
    (= i (Seq_length s))
    (= (Seq_index (Seq_build s e) i) e)
    (= (Seq_index (Seq_build s e) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_build s e) i))
  :qid |$Seq[Int]_prog.seq_index_over_build|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Int>)))
      (not (= s2 (as Seq_empty  Seq<Int>))))
    (= (Seq_length (Seq_append s1 s2)) (+ (Seq_length s1) (Seq_length s2))))
  :pattern ((Seq_length (Seq_append s1 s2)))
  :qid |$Seq[Int]_prog.seq_length_over_append|)))
(assert (forall ((e Int)) (!
  (= (Seq_index (Seq_singleton e) 0) e)
  :pattern ((Seq_index (Seq_singleton e) 0))
  :qid |$Seq[Int]_prog.seq_index_over_singleton|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Seq_contains (Seq_singleton e1) e2) (= e1 e2))
  :pattern ((Seq_contains (Seq_singleton e1) e2))
  :qid |$Seq[Int]_prog.seq_contains_over_singleton|)))
(assert (forall ((s Seq<Int>)) (!
  (= (Seq_append (as Seq_empty  Seq<Int>) s) s)
  :pattern ((Seq_append (as Seq_empty  Seq<Int>) s))
  :qid |$Seq[Int]_prog.seq_append_empty_left|)))
(assert (forall ((s Seq<Int>)) (!
  (= (Seq_append s (as Seq_empty  Seq<Int>)) s)
  :pattern ((Seq_append s (as Seq_empty  Seq<Int>)))
  :qid |$Seq[Int]_prog.seq_append_empty_right|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (i Int)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Int>)))
      (not (= s2 (as Seq_empty  Seq<Int>))))
    (ite
      (< i (Seq_length s1))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s1 i))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s2 (- i (Seq_length s1))))))
  :pattern ((Seq_index (Seq_append s1 s2) i))
  :pattern ((Seq_index s1 i) (Seq_append s1 s2))
  :qid |$Seq[Int]_prog.seq_index_over_append|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int)) (!
  (implies
    (and (<= 0 i) (< i (Seq_length s)))
    (= (Seq_length (Seq_update s i e)) (Seq_length s)))
  :pattern ((Seq_length (Seq_update s i e)))
  :qid |$Seq[Int]_prog.seq_length_invariant_over_update|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (j Int)) (!
  (ite
    (implies (and (<= 0 i) (< i (Seq_length s))) (= i j))
    (= (Seq_index (Seq_update s i e) j) e)
    (= (Seq_index (Seq_update s i e) j) (Seq_index s j)))
  :pattern ((Seq_index (Seq_update s i e) j))
  :qid |$Seq[Int]_prog.seq_index_over_update|)))
(assert (forall ((s Seq<Int>) (e Int)) (!
  (=
    (Seq_contains s e)
    (exists ((i Int)) (!
      (and (<= 0 i) (and (< i (Seq_length s)) (= (Seq_index s i) e)))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains s e))
  :qid |$Seq[Int]_prog.seq_element_contains_index_exists|)))
(assert (forall ((e Int)) (!
  (not (Seq_contains (as Seq_empty  Seq<Int>) e))
  :pattern ((Seq_contains (as Seq_empty  Seq<Int>) e))
  :qid |$Seq[Int]_prog.empty_seq_contains_nothing|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (e Int)) (!
  (=
    (Seq_contains (Seq_append s1 s2) e)
    (or (Seq_contains s1 e) (Seq_contains s2 e)))
  :pattern ((Seq_contains (Seq_append s1 s2) e))
  :qid |$Seq[Int]_prog.seq_contains_over_append|)))
(assert (forall ((s Seq<Int>) (e1 Int) (e2 Int)) (!
  (= (Seq_contains (Seq_build s e1) e2) (or (= e1 e2) (Seq_contains s e2)))
  :pattern ((Seq_contains (Seq_build s e1) e2))
  :qid |$Seq[Int]_prog.seq_contains_over_build|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies (<= n 0) (= (Seq_take s n) (as Seq_empty  Seq<Int>)))
  :pattern ((Seq_take s n))
  :qid |$Seq[Int]_prog.seq_take_negative_length|)))
(assert (forall ((s Seq<Int>) (n Int) (e Int)) (!
  (=
    (Seq_contains (Seq_take s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (< i n) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_take s n) e))
  :qid |$Seq[Int]_prog.seq_contains_over_take_index_exists|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies (<= n 0) (= (Seq_drop s n) s))
  :pattern ((Seq_drop s n))
  :qid |$Seq[Int]_prog.seq_drop_negative_length|)))
(assert (forall ((s Seq<Int>) (n Int) (e Int)) (!
  (=
    (Seq_contains (Seq_drop s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (<= n i) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_drop s n) e))
  :qid |$Seq[Int]_prog.seq_contains_over_drop_index_exists|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (=
    (Seq_equal s1 s2)
    (and
      (= (Seq_length s1) (Seq_length s2))
      (forall ((i Int)) (!
        (implies
          (and (<= 0 i) (< i (Seq_length s1)))
          (= (Seq_index s1 i) (Seq_index s2 i)))
        :pattern ((Seq_index s1 i))
        :pattern ((Seq_index s2 i))
        ))))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Int]_prog.extensional_seq_equality|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>)) (!
  (implies (Seq_equal s1 s2) (= s1 s2))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Int]_prog.seq_equality_identity|)))
(assert (forall ((s1 Seq<Int>) (s2 Seq<Int>) (n Int)) (!
  (=
    (Seq_sameuntil s1 s2 n)
    (forall ((i Int)) (!
      (implies (and (<= 0 i) (< i n)) (= (Seq_index s1 i) (Seq_index s2 i)))
      :pattern ((Seq_index s1 i))
      :pattern ((Seq_index s2 i))
      )))
  :pattern ((Seq_sameuntil s1 s2 n))
  :qid |$Seq[Int]_prog.extensional_seq_equality_prefix|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_take s n)) n)
      (= (Seq_length (Seq_take s n)) (Seq_length s))))
  :pattern ((Seq_length (Seq_take s n)))
  :qid |$Seq[Int]_prog.seq_length_over_take|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< i (Seq_length s))))
    (= (Seq_index (Seq_take s n) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_take s n) i))
  :pattern ((Seq_index s i) (Seq_take s n))
  :qid |$Seq[Int]_prog.seq_index_over_take|)))
(assert (forall ((s Seq<Int>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_drop s n)) (- (Seq_length s) n))
      (= (Seq_length (Seq_drop s n)) 0)))
  :pattern ((Seq_length (Seq_drop s n)))
  :qid |$Seq[Int]_prog.seq_length_over_drop|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= 0 i) (< i (- (Seq_length s) n))))
    (= (Seq_index (Seq_drop s n) i) (Seq_index s (+ i n))))
  :pattern ((Seq_index (Seq_drop s n) i))
  :qid |$Seq[Int]_prog.seq_index_over_drop_1|)))
(assert (forall ((s Seq<Int>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_index (Seq_drop s n) (- i n)) (Seq_index s i)))
  :pattern ((Seq_index s i) (Seq_drop s n))
  :qid |$Seq[Int]_prog.seq_index_over_drop_2|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_take (Seq_update s i e) n) (Seq_update (Seq_take s n) i e)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_take_over_update_1|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= n i) (< i (Seq_length s)))
    (= (Seq_take (Seq_update s i e) n) (Seq_take s n)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_take_over_update_2|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_update (Seq_drop s n) (- i n) e)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_update_1|)))
(assert (forall ((s Seq<Int>) (i Int) (e Int) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_drop s n)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_update_2|)))
(assert (forall ((s Seq<Int>) (e Int) (n Int)) (!
  (implies
    (and (<= 0 n) (<= n (Seq_length s)))
    (= (Seq_drop (Seq_build s e) n) (Seq_build (Seq_drop s n) e)))
  :pattern ((Seq_drop (Seq_build s e) n))
  :qid |$Seq[Int]_prog.seq_drop_over_build|)))
(assert (forall ((min_ Int) (max Int)) (!
  (ite
    (< min_ max)
    (= (Seq_length (Seq_range min_ max)) (- max min_))
    (= (Seq_length (Seq_range min_ max)) 0))
  :pattern ((Seq_length (Seq_range min_ max)))
  :qid |$Seq[Int]_prog.ranged_seq_length|)))
(assert (forall ((min_ Int) (max Int) (i Int)) (!
  (implies
    (and (<= 0 i) (< i (- max min_)))
    (= (Seq_index (Seq_range min_ max) i) (+ min_ i)))
  :pattern ((Seq_index (Seq_range min_ max) i))
  :qid |$Seq[Int]_prog.ranged_seq_index|)))
(assert (forall ((min_ Int) (max Int) (e Int)) (!
  (= (Seq_contains (Seq_range min_ max) e) (and (<= min_ e) (< e max)))
  :pattern ((Seq_contains (Seq_range min_ max) e))
  :qid |$Seq[Int]_prog.ranged_seq_contains|)))
(assert (forall ((s Seq<Seq<Int>>)) (!
  (<= 0 (Seq_length s))
  :pattern ((Seq_length s))
  :qid |$Seq[Seq[Int]]_prog.seq_length_non_negative|)))
(assert (= (Seq_length (as Seq_empty  Seq<Seq<Int>>)) 0))
(assert (forall ((s Seq<Seq<Int>>)) (!
  (implies (= (Seq_length s) 0) (= s (as Seq_empty  Seq<Seq<Int>>)))
  :pattern ((Seq_length s))
  :qid |$Seq[Seq[Int]]_prog.only_empty_seq_length_zero|)))
(assert (forall ((e Seq<Int>)) (!
  (= (Seq_length (Seq_singleton e)) 1)
  :pattern ((Seq_length (Seq_singleton e)))
  :qid |$Seq[Seq[Int]]_prog.length_singleton_seq|)))
(assert (forall ((s Seq<Seq<Int>>) (e Seq<Int>)) (!
  (= (Seq_length (Seq_build s e)) (+ 1 (Seq_length s)))
  :pattern ((Seq_length (Seq_build s e)))
  :qid |$Seq[Seq[Int]]_prog.length_seq_build_inc_by_one|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>)) (!
  (ite
    (= i (Seq_length s))
    (= (Seq_index (Seq_build s e) i) e)
    (= (Seq_index (Seq_build s e) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_build s e) i))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_build|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Seq<Int>>)))
      (not (= s2 (as Seq_empty  Seq<Seq<Int>>))))
    (= (Seq_length (Seq_append s1 s2)) (+ (Seq_length s1) (Seq_length s2))))
  :pattern ((Seq_length (Seq_append s1 s2)))
  :qid |$Seq[Seq[Int]]_prog.seq_length_over_append|)))
(assert (forall ((e Seq<Int>)) (!
  (= (Seq_index (Seq_singleton e) 0) e)
  :pattern ((Seq_index (Seq_singleton e) 0))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_singleton|)))
(assert (forall ((e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Seq_contains (Seq_singleton e1) e2) (= e1 e2))
  :pattern ((Seq_contains (Seq_singleton e1) e2))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_singleton|)))
(assert (forall ((s Seq<Seq<Int>>)) (!
  (= (Seq_append (as Seq_empty  Seq<Seq<Int>>) s) s)
  :pattern ((Seq_append (as Seq_empty  Seq<Seq<Int>>) s))
  :qid |$Seq[Seq[Int]]_prog.seq_append_empty_left|)))
(assert (forall ((s Seq<Seq<Int>>)) (!
  (= (Seq_append s (as Seq_empty  Seq<Seq<Int>>)) s)
  :pattern ((Seq_append s (as Seq_empty  Seq<Seq<Int>>)))
  :qid |$Seq[Seq[Int]]_prog.seq_append_empty_right|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>) (i Int)) (!
  (implies
    (and
      (not (= s1 (as Seq_empty  Seq<Seq<Int>>)))
      (not (= s2 (as Seq_empty  Seq<Seq<Int>>))))
    (ite
      (< i (Seq_length s1))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s1 i))
      (= (Seq_index (Seq_append s1 s2) i) (Seq_index s2 (- i (Seq_length s1))))))
  :pattern ((Seq_index (Seq_append s1 s2) i))
  :pattern ((Seq_index s1 i) (Seq_append s1 s2))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_append|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>)) (!
  (implies
    (and (<= 0 i) (< i (Seq_length s)))
    (= (Seq_length (Seq_update s i e)) (Seq_length s)))
  :pattern ((Seq_length (Seq_update s i e)))
  :qid |$Seq[Seq[Int]]_prog.seq_length_invariant_over_update|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (j Int)) (!
  (ite
    (implies (and (<= 0 i) (< i (Seq_length s))) (= i j))
    (= (Seq_index (Seq_update s i e) j) e)
    (= (Seq_index (Seq_update s i e) j) (Seq_index s j)))
  :pattern ((Seq_index (Seq_update s i e) j))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_update|)))
(assert (forall ((s Seq<Seq<Int>>) (e Seq<Int>)) (!
  (=
    (Seq_contains s e)
    (exists ((i Int)) (!
      (and (<= 0 i) (and (< i (Seq_length s)) (= (Seq_index s i) e)))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains s e))
  :qid |$Seq[Seq[Int]]_prog.seq_element_contains_index_exists|)))
(assert (forall ((e Seq<Int>)) (!
  (not (Seq_contains (as Seq_empty  Seq<Seq<Int>>) e))
  :pattern ((Seq_contains (as Seq_empty  Seq<Seq<Int>>) e))
  :qid |$Seq[Seq[Int]]_prog.empty_seq_contains_nothing|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>) (e Seq<Int>)) (!
  (=
    (Seq_contains (Seq_append s1 s2) e)
    (or (Seq_contains s1 e) (Seq_contains s2 e)))
  :pattern ((Seq_contains (Seq_append s1 s2) e))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_append|)))
(assert (forall ((s Seq<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Seq_contains (Seq_build s e1) e2) (or (= e1 e2) (Seq_contains s e2)))
  :pattern ((Seq_contains (Seq_build s e1) e2))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_build|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int)) (!
  (implies (<= n 0) (= (Seq_take s n) (as Seq_empty  Seq<Seq<Int>>)))
  :pattern ((Seq_take s n))
  :qid |$Seq[Seq[Int]]_prog.seq_take_negative_length|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (e Seq<Int>)) (!
  (=
    (Seq_contains (Seq_take s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (< i n) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_take s n) e))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_take_index_exists|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int)) (!
  (implies (<= n 0) (= (Seq_drop s n) s))
  :pattern ((Seq_drop s n))
  :qid |$Seq[Seq[Int]]_prog.seq_drop_negative_length|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (e Seq<Int>)) (!
  (=
    (Seq_contains (Seq_drop s n) e)
    (exists ((i Int)) (!
      (and
        (<= 0 i)
        (and (<= n i) (and (< i (Seq_length s)) (= (Seq_index s i) e))))
      :pattern ((Seq_index s i))
      )))
  :pattern ((Seq_contains (Seq_drop s n) e))
  :qid |$Seq[Seq[Int]]_prog.seq_contains_over_drop_index_exists|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>)) (!
  (=
    (Seq_equal s1 s2)
    (and
      (= (Seq_length s1) (Seq_length s2))
      (forall ((i Int)) (!
        (implies
          (and (<= 0 i) (< i (Seq_length s1)))
          (= (Seq_index s1 i) (Seq_index s2 i)))
        :pattern ((Seq_index s1 i))
        :pattern ((Seq_index s2 i))
        ))))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Seq[Int]]_prog.extensional_seq_equality|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>)) (!
  (implies (Seq_equal s1 s2) (= s1 s2))
  :pattern ((Seq_equal s1 s2))
  :qid |$Seq[Seq[Int]]_prog.seq_equality_identity|)))
(assert (forall ((s1 Seq<Seq<Int>>) (s2 Seq<Seq<Int>>) (n Int)) (!
  (=
    (Seq_sameuntil s1 s2 n)
    (forall ((i Int)) (!
      (implies (and (<= 0 i) (< i n)) (= (Seq_index s1 i) (Seq_index s2 i)))
      :pattern ((Seq_index s1 i))
      :pattern ((Seq_index s2 i))
      )))
  :pattern ((Seq_sameuntil s1 s2 n))
  :qid |$Seq[Seq[Int]]_prog.extensional_seq_equality_prefix|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_take s n)) n)
      (= (Seq_length (Seq_take s n)) (Seq_length s))))
  :pattern ((Seq_length (Seq_take s n)))
  :qid |$Seq[Seq[Int]]_prog.seq_length_over_take|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< i (Seq_length s))))
    (= (Seq_index (Seq_take s n) i) (Seq_index s i)))
  :pattern ((Seq_index (Seq_take s n) i))
  :pattern ((Seq_index s i) (Seq_take s n))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_take|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int)) (!
  (implies
    (<= 0 n)
    (ite
      (<= n (Seq_length s))
      (= (Seq_length (Seq_drop s n)) (- (Seq_length s) n))
      (= (Seq_length (Seq_drop s n)) 0)))
  :pattern ((Seq_length (Seq_drop s n)))
  :qid |$Seq[Seq[Int]]_prog.seq_length_over_drop|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= 0 i) (< i (- (Seq_length s) n))))
    (= (Seq_index (Seq_drop s n) i) (Seq_index s (+ i n))))
  :pattern ((Seq_index (Seq_drop s n) i))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_drop_1|)))
(assert (forall ((s Seq<Seq<Int>>) (n Int) (i Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_index (Seq_drop s n) (- i n)) (Seq_index s i)))
  :pattern ((Seq_index s i) (Seq_drop s n))
  :qid |$Seq[Seq[Int]]_prog.seq_index_over_drop_2|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_take (Seq_update s i e) n) (Seq_update (Seq_take s n) i e)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_take_over_update_1|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= n i) (< i (Seq_length s)))
    (= (Seq_take (Seq_update s i e) n) (Seq_take s n)))
  :pattern ((Seq_take (Seq_update s i e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_take_over_update_2|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= 0 n) (and (<= n i) (< i (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_update (Seq_drop s n) (- i n) e)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_drop_over_update_1|)))
(assert (forall ((s Seq<Seq<Int>>) (i Int) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= 0 i) (and (< i n) (< n (Seq_length s))))
    (= (Seq_drop (Seq_update s i e) n) (Seq_drop s n)))
  :pattern ((Seq_drop (Seq_update s i e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_drop_over_update_2|)))
(assert (forall ((s Seq<Seq<Int>>) (e Seq<Int>) (n Int)) (!
  (implies
    (and (<= 0 n) (<= n (Seq_length s)))
    (= (Seq_drop (Seq_build s e) n) (Seq_build (Seq_drop s n) e)))
  :pattern ((Seq_drop (Seq_build s e) n))
  :qid |$Seq[Seq[Int]]_prog.seq_drop_over_build|)))
(assert (forall ((s Set<Seq<Seq<Int>>>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Seq[Int]]]_prog.card_non_negative|)))
(assert (forall ((e Seq<Seq<Int>>)) (!
  (not (Set_in e (as Set_empty  Set<Seq<Seq<Int>>>)))
  :pattern ((Set_in e (as Set_empty  Set<Seq<Seq<Int>>>)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_empty_set|)))
(assert (forall ((s Set<Seq<Seq<Int>>>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Seq<Seq<Int>>>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Seq<Seq<Int>>)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Seq[Int]]]_prog.empty_set_cardinality|)))
(assert (forall ((e Seq<Seq<Int>>)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_singleton_set|)))
(assert (forall ((e1 Seq<Seq<Int>>) (e2 Seq<Seq<Int>>)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_singleton_set_equality|)))
(assert (forall ((e Seq<Seq<Int>>)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Seq[Seq[Int]]]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_unionone_same|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e1 Seq<Seq<Int>>) (e2 Seq<Seq<Int>>)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_unionone_other|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e1 Seq<Seq<Int>>) (e2 Seq<Seq<Int>>)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Seq[Seq[Int]]]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Seq[Int]]]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Seq[Int]]]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.in_difference|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>) (e Seq<Seq<Int>>)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Seq<Seq<Int>>)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.subset_definition|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Seq<Seq<Int>>)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.equality_definition|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.native_equality|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Seq<Seq<Int>>)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Seq[Seq[Int]]]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Seq<Seq<Int>>>) (s2 Set<Seq<Seq<Int>>>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Seq[Seq[Int]]]_prog.cardinality_difference|)))
(assert (forall ((s Set<Seq<Int>>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Int]]_prog.card_non_negative|)))
(assert (forall ((e Seq<Int>)) (!
  (not (Set_in e (as Set_empty  Set<Seq<Int>>)))
  :pattern ((Set_in e (as Set_empty  Set<Seq<Int>>)))
  :qid |$Set[Seq[Int]]_prog.in_empty_set|)))
(assert (forall ((s Set<Seq<Int>>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Seq<Int>>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Seq<Int>)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Seq[Int]]_prog.empty_set_cardinality|)))
(assert (forall ((e Seq<Int>)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Seq[Int]]_prog.in_singleton_set|)))
(assert (forall ((e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Seq[Int]]_prog.in_singleton_set_equality|)))
(assert (forall ((e Seq<Int>)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Seq[Int]]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Seq[Int]]_prog.in_unionone_same|)))
(assert (forall ((s Set<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Seq[Int]]_prog.in_unionone_other|)))
(assert (forall ((s Set<Seq<Int>>) (e1 Seq<Int>) (e2 Seq<Int>)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Seq[Int]]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Int]]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Seq[Int]]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Seq[Int]]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Seq[Int]]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Seq[Int]]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Int]]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Seq[Int]]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Seq[Int]]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Seq[Int]]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Seq[Int]]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Seq[Int]]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Seq[Int]]_prog.in_difference|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>) (e Seq<Int>)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Seq[Int]]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Seq<Int>)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Seq[Int]]_prog.subset_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Seq<Int>)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Int]]_prog.equality_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Seq[Int]]_prog.native_equality|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Seq<Int>)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Seq[Int]]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Seq<Int>>) (s2 Set<Seq<Int>>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Seq[Int]]_prog.cardinality_difference|)))
(assert (forall ((s Set<Bool>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Bool]_prog.card_non_negative|)))
(assert (forall ((e Bool)) (!
  (not (Set_in e (as Set_empty  Set<Bool>)))
  :pattern ((Set_in e (as Set_empty  Set<Bool>)))
  :qid |$Set[Bool]_prog.in_empty_set|)))
(assert (forall ((s Set<Bool>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Bool>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Bool)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Bool]_prog.empty_set_cardinality|)))
(assert (forall ((e Bool)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Bool]_prog.in_singleton_set|)))
(assert (forall ((e1 Bool) (e2 Bool)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Bool]_prog.in_singleton_set_equality|)))
(assert (forall ((e Bool)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Bool]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Bool]_prog.in_unionone_same|)))
(assert (forall ((s Set<Bool>) (e1 Bool) (e2 Bool)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Bool]_prog.in_unionone_other|)))
(assert (forall ((s Set<Bool>) (e1 Bool) (e2 Bool)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Bool]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Bool]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Bool>) (e Bool)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Bool]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Bool]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Bool]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Bool]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Bool]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Bool]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Bool]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Bool]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Bool]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Bool]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Bool]_prog.in_difference|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>) (e Bool)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Bool]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Bool)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Bool]_prog.subset_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Bool)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Bool]_prog.equality_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Bool]_prog.native_equality|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Bool)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Bool]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Bool>) (s2 Set<Bool>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Bool]_prog.cardinality_difference|)))
(assert (forall ((s Set<Int>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.card_non_negative|)))
(assert (forall ((e Int)) (!
  (not (Set_in e (as Set_empty  Set<Int>)))
  :pattern ((Set_in e (as Set_empty  Set<Int>)))
  :qid |$Set[Int]_prog.in_empty_set|)))
(assert (forall ((s Set<Int>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<Int>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e Int)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Int]_prog.empty_set_cardinality|)))
(assert (forall ((e Int)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Int]_prog.in_singleton_set|)))
(assert (forall ((e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Int]_prog.in_singleton_set_equality|)))
(assert (forall ((e Int)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Int]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Int]_prog.in_unionone_same|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Int]_prog.in_unionone_other|)))
(assert (forall ((s Set<Int>) (e1 Int) (e2 Int)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Int]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<Int>) (e Int)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Int]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Int]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Int]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Int]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Int]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Int]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Int]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>) (e Int)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Int]_prog.not_in_difference|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e Int)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Int]_prog.subset_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e Int)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.equality_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Int]_prog.native_equality|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e Int)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Int]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<Int>) (s2 Set<Int>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Int]_prog.cardinality_difference|)))
(assert (forall ((s Set<$Ref>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.card_non_negative|)))
(assert (forall ((e $Ref)) (!
  (not (Set_in e (as Set_empty  Set<$Ref>)))
  :pattern ((Set_in e (as Set_empty  Set<$Ref>)))
  :qid |$Set[Ref]_prog.in_empty_set|)))
(assert (forall ((s Set<$Ref>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Ref>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e $Ref)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Ref]_prog.empty_set_cardinality|)))
(assert (forall ((e $Ref)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Ref]_prog.in_singleton_set|)))
(assert (forall ((e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Ref]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Ref)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Ref]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Ref]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Ref]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Ref>) (e1 $Ref) (e2 $Ref)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Ref]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Ref>) (e $Ref)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Ref]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Ref]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Ref]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Ref]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Ref]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>) (e $Ref)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Ref]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Ref)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Ref]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Ref)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Ref]_prog.native_equality|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Ref)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Ref]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Ref>) (s2 Set<$Ref>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Ref]_prog.cardinality_difference|)))
(assert (forall ((s Set<frac>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[frac]_prog.card_non_negative|)))
(assert (forall ((e frac)) (!
  (not (Set_in e (as Set_empty  Set<frac>)))
  :pattern ((Set_in e (as Set_empty  Set<frac>)))
  :qid |$Set[frac]_prog.in_empty_set|)))
(assert (forall ((s Set<frac>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<frac>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e frac)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[frac]_prog.empty_set_cardinality|)))
(assert (forall ((e frac)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[frac]_prog.in_singleton_set|)))
(assert (forall ((e1 frac) (e2 frac)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[frac]_prog.in_singleton_set_equality|)))
(assert (forall ((e frac)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[frac]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<frac>) (e frac)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[frac]_prog.in_unionone_same|)))
(assert (forall ((s Set<frac>) (e1 frac) (e2 frac)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[frac]_prog.in_unionone_other|)))
(assert (forall ((s Set<frac>) (e1 frac) (e2 frac)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[frac]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<frac>) (e frac)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[frac]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<frac>) (e frac)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[frac]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>) (e frac)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[frac]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>) (e frac)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[frac]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>) (e frac)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[frac]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>) (e frac)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[frac]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[frac]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[frac]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[frac]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[frac]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[frac]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>) (e frac)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[frac]_prog.in_difference|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>) (e frac)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[frac]_prog.not_in_difference|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e frac)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[frac]_prog.subset_definition|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e frac)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[frac]_prog.equality_definition|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[frac]_prog.native_equality|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e frac)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[frac]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<frac>) (s2 Set<frac>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[frac]_prog.cardinality_difference|)))
(assert (forall ((s Set<$Snap>)) (!
  (<= 0 (Set_card s))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.card_non_negative|)))
(assert (forall ((e $Snap)) (!
  (not (Set_in e (as Set_empty  Set<$Snap>)))
  :pattern ((Set_in e (as Set_empty  Set<$Snap>)))
  :qid |$Set[Snap]_prog.in_empty_set|)))
(assert (forall ((s Set<$Snap>)) (!
  (and
    (= (= (Set_card s) 0) (= s (as Set_empty  Set<$Snap>)))
    (implies
      (not (= (Set_card s) 0))
      (exists ((e $Snap)) (!
        (Set_in e s)
        :pattern ((Set_in e s))
        ))))
  :pattern ((Set_card s))
  :qid |$Set[Snap]_prog.empty_set_cardinality|)))
(assert (forall ((e $Snap)) (!
  (Set_in e (Set_singleton e))
  :pattern ((Set_singleton e))
  :qid |$Set[Snap]_prog.in_singleton_set|)))
(assert (forall ((e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_singleton e2)) (= e1 e2))
  :pattern ((Set_in e1 (Set_singleton e2)))
  :qid |$Set[Snap]_prog.in_singleton_set_equality|)))
(assert (forall ((e $Snap)) (!
  (= (Set_card (Set_singleton e)) 1)
  :pattern ((Set_card (Set_singleton e)))
  :qid |$Set[Snap]_prog.singleton_set_cardinality|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (Set_in e (Set_unionone s e))
  :pattern ((Set_unionone s e))
  :qid |$Set[Snap]_prog.in_unionone_same|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (= (Set_in e1 (Set_unionone s e2)) (or (= e1 e2) (Set_in e1 s)))
  :pattern ((Set_in e1 (Set_unionone s e2)))
  :qid |$Set[Snap]_prog.in_unionone_other|)))
(assert (forall ((s Set<$Snap>) (e1 $Snap) (e2 $Snap)) (!
  (implies (Set_in e1 s) (Set_in e1 (Set_unionone s e2)))
  :pattern ((Set_in e1 s) (Set_unionone s e2))
  :qid |$Set[Snap]_prog.invariance_in_unionone|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s) (= (Set_card (Set_unionone s e)) (Set_card s)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_invariant|)))
(assert (forall ((s Set<$Snap>) (e $Snap)) (!
  (implies
    (not (Set_in e s))
    (= (Set_card (Set_unionone s e)) (+ (Set_card s) 1)))
  :pattern ((Set_card (Set_unionone s e)))
  :qid |$Set[Snap]_prog.unionone_cardinality_changed|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_union s1 s2)) (or (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.in_union_in_one|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s1) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s1) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_left_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s2) (Set_in e (Set_union s1 s2)))
  :pattern ((Set_in e s2) (Set_union s1 s2))
  :qid |$Set[Snap]_prog.in_right_in_union|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_intersection s1 s2)) (and (Set_in e s1) (Set_in e s2)))
  :pattern ((Set_in e (Set_intersection s1 s2)))
  :pattern ((Set_intersection s1 s2) (Set_in e s1))
  :pattern ((Set_intersection s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.in_intersection_in_both|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union s1 (Set_union s1 s2)) (Set_union s1 s2))
  :pattern ((Set_union s1 (Set_union s1 s2)))
  :qid |$Set[Snap]_prog.union_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_union (Set_union s1 s2) s2) (Set_union s1 s2))
  :pattern ((Set_union (Set_union s1 s2) s2))
  :qid |$Set[Snap]_prog.union_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection s1 (Set_intersection s1 s2)) (Set_intersection s1 s2))
  :pattern ((Set_intersection s1 (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.intersection_left_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (= (Set_intersection (Set_intersection s1 s2) s2) (Set_intersection s1 s2))
  :pattern ((Set_intersection (Set_intersection s1 s2) s2))
  :qid |$Set[Snap]_prog.intersection_right_idempotency|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (+ (Set_card (Set_union s1 s2)) (Set_card (Set_intersection s1 s2)))
    (+ (Set_card s1) (Set_card s2)))
  :pattern ((Set_card (Set_union s1 s2)))
  :pattern ((Set_card (Set_intersection s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_sums|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (= (Set_in e (Set_difference s1 s2)) (and (Set_in e s1) (not (Set_in e s2))))
  :pattern ((Set_in e (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>) (e $Snap)) (!
  (implies (Set_in e s2) (not (Set_in e (Set_difference s1 s2))))
  :pattern ((Set_difference s1 s2) (Set_in e s2))
  :qid |$Set[Snap]_prog.not_in_difference|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_subset s1 s2)
    (forall ((e $Snap)) (!
      (implies (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_subset s1 s2))
  :qid |$Set[Snap]_prog.subset_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_equal s1 s2)
    (forall ((e $Snap)) (!
      (= (Set_in e s1) (Set_in e s2))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.equality_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (implies (Set_equal s1 s2) (= s1 s2))
  :pattern ((Set_equal s1 s2))
  :qid |$Set[Snap]_prog.native_equality|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (=
    (Set_disjoint s1 s2)
    (forall ((e $Snap)) (!
      (or (not (Set_in e s1)) (not (Set_in e s2)))
      :pattern ((Set_in e s1))
      :pattern ((Set_in e s2))
      )))
  :pattern ((Set_disjoint s1 s2))
  :qid |$Set[Snap]_prog.disjointness_definition|)))
(assert (forall ((s1 Set<$Snap>) (s2 Set<$Snap>)) (!
  (and
    (=
      (+
        (+ (Set_card (Set_difference s1 s2)) (Set_card (Set_difference s2 s1)))
        (Set_card (Set_intersection s1 s2)))
      (Set_card (Set_union s1 s2)))
    (=
      (Set_card (Set_difference s1 s2))
      (- (Set_card s1) (Set_card (Set_intersection s1 s2)))))
  :pattern ((Set_card (Set_difference s1 s2)))
  :qid |$Set[Snap]_prog.cardinality_difference|)))
(assert (forall ((a zfrac) (b zfrac)) (!
  (= (= (zfrac_val<Perm> a) (zfrac_val<Perm> b)) (= a b))
  :pattern ((zfrac_val<Perm> a) (zfrac_val<Perm> b))
  :qid |prog.zfrac_eq|)))
(assert (forall ((a zfrac)) (!
  (and (<= $Perm.No (zfrac_val<Perm> a)) (<= (zfrac_val<Perm> a) $Perm.Write))
  :pattern ((zfrac_val<Perm> a))
  :qid |prog.zfrac_bound|)))
(assert (forall ((a frac) (b frac)) (!
  (= (= (frac_val<Perm> a) (frac_val<Perm> b)) (= a b))
  :pattern ((frac_val<Perm> a) (frac_val<Perm> b))
  :qid |prog.frac_eq|)))
(assert (forall ((a frac)) (!
  (and (< $Perm.No (frac_val<Perm> a)) (<= (frac_val<Perm> a) $Perm.Write))
  :pattern ((frac_val<Perm> a))
  :qid |prog.frac_bound|)))
(assert (forall ((p Process)) (!
  (= (p_merge<Process> (as p_empty<Process>  Process) p) p)
  :pattern ((p_merge<Process> (as p_empty<Process>  Process) p))
  :qid |prog.empty_1L|)))
(assert (forall ((p Process)) (!
  (= (p_seq<Process> (as p_empty<Process>  Process) p) p)
  :pattern ((p_seq<Process> (as p_empty<Process>  Process) p))
  :qid |prog.empty_2L|)))
(assert (forall ((p Process)) (!
  (= (p_seq<Process> p (as p_empty<Process>  Process)) p)
  :pattern ((p_seq<Process> p (as p_empty<Process>  Process)))
  :qid |prog.empty_2R|)))
(assert (forall ((p1 Process) (p2 Process)) (!
  (p_is_choice<Bool> (p_choice<Process> p1 p2) p1)
  :pattern ((p_is_choice<Bool> (p_choice<Process> p1 p2) p1))
  :qid |prog.choice_L|)))
(assert (forall ((p1 Process) (p2 Process)) (!
  (p_is_choice<Bool> (p_choice<Process> p1 p2) p2)
  :pattern ((p_is_choice<Bool> (p_choice<Process> p1 p2) p2))
  :qid |prog.choice_R|)))
(assert (forall ((p1 Process) (p2 Process) (p3 Process)) (!
  (=
    (p_seq<Process> (p_choice<Process> p1 p2) p3)
    (p_choice<Process> (p_seq<Process> p1 p3) (p_seq<Process> p2 p3)))
  :pattern ((p_seq<Process> (p_choice<Process> p1 p2) p3))
  :qid |prog.choice_dist|)))
(assert (forall ((p1 Process) (p2 Process) (p3 Process)) (!
  (=
    (p_seq<Process> (p_seq<Process> p1 p2) p3)
    (p_seq<Process> p1 (p_seq<Process> p2 p3)))
  :pattern ((p_seq<Process> (p_seq<Process> p1 p2) p3))
  :qid |prog.seq_assoc|)))
(assert (forall ((p Process) (rank Int) (msg Int)) (!
  (=
    (p_seq<Process> p (p_method_Future_Send__Integer__Integer<Process> rank msg))
    (p_seq<Process> p (p_seq<Process> (p_method_Future_Send__Integer__Integer<Process> rank msg) (as p_empty<Process>  Process))))
  :pattern ((p_seq<Process> p (p_method_Future_Send__Integer__Integer<Process> rank msg)))
  :qid |prog.method_Future_Send__Integer__Integer_def_2|)))
(assert (forall ((p Process) (rank Int) (msg Int)) (!
  (=
    (p_seq<Process> p (p_method_Future_Recv__Integer__Integer<Process> rank msg))
    (p_seq<Process> p (p_seq<Process> (p_method_Future_Recv__Integer__Integer<Process> rank msg) (as p_empty<Process>  Process))))
  :pattern ((p_seq<Process> p (p_method_Future_Recv__Integer__Integer<Process> rank msg)))
  :qid |prog.method_Future_Recv__Integer__Integer_def_2|)))
(assert (forall ((p Process) (rank Int) (v Int)) (!
  (=
    (p_seq<Process> p (p_method_Future_Done__Integer__Integer<Process> rank v))
    (p_seq<Process> p (p_seq<Process> (p_method_Future_Done__Integer__Integer<Process> rank v) (as p_empty<Process>  Process))))
  :pattern ((p_seq<Process> p (p_method_Future_Done__Integer__Integer<Process> rank v)))
  :qid |prog.method_Future_Done__Integer__Integer_def_2|)))
(assert (forall ((rank Int) (size Int) (v Int) (w Int) (max Int) (n Int)) (!
  (=
    (ite
      (< 0 w)
      (p_choice<Process> (p_seq<Process> (p_method_Future_Recv__Integer__Integer<Process> (mod
        (- rank 1)
        size) w) (p_method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n)) (p_method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v (-
        w
        1) max n))
      (p_seq<Process> (p_method_Future_Recv__Integer__Integer<Process> (mod
        (- rank 1)
        size) w) (p_method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n)))
    (p_method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n))
  :pattern ((p_method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n))
  :qid |prog.method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer_def_1|)))
(assert (forall ((p Process) (rank Int) (size Int) (v Int) (w Int) (max Int) (n Int)) (!
  (=
    (p_seq<Process> p (p_method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n))
    (p_seq<Process> p (p_seq<Process> (p_method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n) (as p_empty<Process>  Process))))
  :pattern ((p_seq<Process> p (p_method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n)))
  :qid |prog.method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer_def_2|)))
(assert (forall ((rank Int) (size Int) (v Int) (w Int) (max Int) (n Int)) (!
  (=
    (p_method_Future_Elect__Integer__Integer__Integer__Integer__Integer<Process> rank size (ite
      (<= v w)
      w
      v) max (+ n 1))
    (p_method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n))
  :pattern ((p_method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n))
  :qid |prog.method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer_def_1|)))
(assert (forall ((p Process) (rank Int) (size Int) (v Int) (w Int) (max Int) (n Int)) (!
  (=
    (p_seq<Process> p (p_method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n))
    (p_seq<Process> p (p_seq<Process> (p_method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n) (as p_empty<Process>  Process))))
  :pattern ((p_seq<Process> p (p_method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v w max n)))
  :qid |prog.method_Future_Check__Integer__Integer__Integer__Integer__Integer__Integer_def_2|)))
(assert (forall ((rank Int) (size Int) (v Int) (max Int) (n Int)) (!
  (=
    (ite
      (< n size)
      (p_seq<Process> (p_method_Future_Send__Integer__Integer<Process> (mod
        (+ rank 1)
        size) v) (p_method_Future_SigmaRecv__Integer__Integer__Integer__Integer__Integer__Integer<Process> rank size v (-
        max
        1) max n))
      (p_method_Future_Done__Integer__Integer<Process> rank v))
    (p_method_Future_Elect__Integer__Integer__Integer__Integer__Integer<Process> rank size v max n))
  :pattern ((p_method_Future_Elect__Integer__Integer__Integer__Integer__Integer<Process> rank size v max n))
  :qid |prog.method_Future_Elect__Integer__Integer__Integer__Integer__Integer_def_1|)))
(assert (forall ((p Process) (rank Int) (size Int) (v Int) (max Int) (n Int)) (!
  (=
    (p_seq<Process> p (p_method_Future_Elect__Integer__Integer__Integer__Integer__Integer<Process> rank size v max n))
    (p_seq<Process> p (p_seq<Process> (p_method_Future_Elect__Integer__Integer__Integer__Integer__Integer<Process> rank size v max n) (as p_empty<Process>  Process))))
  :pattern ((p_seq<Process> p (p_method_Future_Elect__Integer__Integer__Integer__Integer__Integer<Process> rank size v max n)))
  :qid |prog.method_Future_Elect__Integer__Integer__Integer__Integer__Integer_def_2|)))
(assert (forall ((rank Int) (size Int) (xs Seq<Int>) (max Int)) (!
  (=
    (ite
      (< rank size)
      (p_merge<Process> (p_method_Future_Elect__Integer__Integer__Integer__Integer__Integer<Process> rank size (Seq_index
        xs
        rank) max 0) (p_method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer<Process> (+
        rank
        1) size xs max))
      (as p_empty<Process>  Process))
    (p_method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer<Process> rank size xs max))
  :pattern ((p_method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer<Process> rank size xs max))
  :qid |prog.method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer_def_1|)))
(assert (forall ((p Process) (rank Int) (size Int) (xs Seq<Int>) (max Int)) (!
  (=
    (p_seq<Process> p (p_method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer<Process> rank size xs max))
    (p_seq<Process> p (p_seq<Process> (p_method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer<Process> rank size xs max) (as p_empty<Process>  Process))))
  :pattern ((p_seq<Process> p (p_method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer<Process> rank size xs max)))
  :qid |prog.method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer_def_2|)))
(assert (forall ((size Int) (xs Seq<Int>) (max Int)) (!
  (=
    (p_method_Future_Spawn__Integer__Integer__Sequence$Integer$__Integer<Process> 0 size xs max)
    (p_method_Future_Start__Integer__Sequence$Integer$__Integer<Process> size xs max))
  :pattern ((p_method_Future_Start__Integer__Sequence$Integer$__Integer<Process> size xs max))
  :qid |prog.method_Future_Start__Integer__Sequence$Integer$__Integer_def_1|)))
(assert (forall ((p Process) (size Int) (xs Seq<Int>) (max Int)) (!
  (=
    (p_seq<Process> p (p_method_Future_Start__Integer__Sequence$Integer$__Integer<Process> size xs max))
    (p_seq<Process> p (p_seq<Process> (p_method_Future_Start__Integer__Sequence$Integer$__Integer<Process> size xs max) (as p_empty<Process>  Process))))
  :pattern ((p_seq<Process> p (p_method_Future_Start__Integer__Sequence$Integer$__Integer<Process> size xs max)))
  :qid |prog.method_Future_Start__Integer__Sequence$Integer$__Integer_def_2|)))
; /field_value_functions_axioms.smt2 [channel_hist_value: Seq[Seq[Int]]]
(assert (forall ((vs $FVF<Seq<Seq<Int>>>) (ws $FVF<Seq<Seq<Int>>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_channel_hist_value vs) ($FVF.domain_channel_hist_value ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_channel_hist_value vs))
            (= ($FVF.lookup_channel_hist_value vs x) ($FVF.lookup_channel_hist_value ws x)))
          :pattern (($FVF.lookup_channel_hist_value vs x) ($FVF.lookup_channel_hist_value ws x))
          :qid |qp.$FVF<Seq<Seq<Int>>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Seq<Int>>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_channel_hist_value pm r))
    :pattern ($FVF.perm_channel_hist_value pm r))))
(assert (forall ((r $Ref) (f Seq<Seq<Int>>)) (!
    (= ($FVF.loc_channel_hist_value f r) true)
    :pattern ($FVF.loc_channel_hist_value f r))))
; /field_value_functions_axioms.smt2 [field_Program_f: Ref]
(assert (forall ((vs $FVF<$Ref>) (ws $FVF<$Ref>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_field_Program_f vs) ($FVF.domain_field_Program_f ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_field_Program_f vs))
            (= ($FVF.lookup_field_Program_f vs x) ($FVF.lookup_field_Program_f ws x)))
          :pattern (($FVF.lookup_field_Program_f vs x) ($FVF.lookup_field_Program_f ws x))
          :qid |qp.$FVF<$Ref>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<$Ref>To$Snap vs)
              ($SortWrappers.$FVF<$Ref>To$Snap ws)
              )
    :qid |qp.$FVF<$Ref>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_field_Program_f pm r))
    :pattern ($FVF.perm_field_Program_f pm r))))
(assert (forall ((r $Ref) (f $Ref)) (!
    (= ($FVF.loc_field_Program_f f r) true)
    :pattern ($FVF.loc_field_Program_f f r))))
; /field_value_functions_axioms.smt2 [channel_hist_act: Seq[Seq[Int]]]
(assert (forall ((vs $FVF<Seq<Seq<Int>>>) (ws $FVF<Seq<Seq<Int>>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_channel_hist_act vs) ($FVF.domain_channel_hist_act ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_channel_hist_act vs))
            (= ($FVF.lookup_channel_hist_act vs x) ($FVF.lookup_channel_hist_act ws x)))
          :pattern (($FVF.lookup_channel_hist_act vs x) ($FVF.lookup_channel_hist_act ws x))
          :qid |qp.$FVF<Seq<Seq<Int>>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Seq<Int>>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Seq<Int>>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_channel_hist_act pm r))
    :pattern ($FVF.perm_channel_hist_act pm r))))
(assert (forall ((r $Ref) (f Seq<Seq<Int>>)) (!
    (= ($FVF.loc_channel_hist_act f r) true)
    :pattern ($FVF.loc_channel_hist_act f r))))
; /field_value_functions_axioms.smt2 [results_hist_value: Seq[Int]]
(assert (forall ((vs $FVF<Seq<Int>>) (ws $FVF<Seq<Int>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_results_hist_value vs) ($FVF.domain_results_hist_value ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_results_hist_value vs))
            (= ($FVF.lookup_results_hist_value vs x) ($FVF.lookup_results_hist_value ws x)))
          :pattern (($FVF.lookup_results_hist_value vs x) ($FVF.lookup_results_hist_value ws x))
          :qid |qp.$FVF<Seq<Int>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Int>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Int>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_results_hist_value pm r))
    :pattern ($FVF.perm_results_hist_value pm r))))
(assert (forall ((r $Ref) (f Seq<Int>)) (!
    (= ($FVF.loc_results_hist_value f r) true)
    :pattern ($FVF.loc_results_hist_value f r))))
; /field_value_functions_axioms.smt2 [results_hist_act: Seq[Int]]
(assert (forall ((vs $FVF<Seq<Int>>) (ws $FVF<Seq<Int>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_results_hist_act vs) ($FVF.domain_results_hist_act ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_results_hist_act vs))
            (= ($FVF.lookup_results_hist_act vs x) ($FVF.lookup_results_hist_act ws x)))
          :pattern (($FVF.lookup_results_hist_act vs x) ($FVF.lookup_results_hist_act ws x))
          :qid |qp.$FVF<Seq<Int>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Int>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Int>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_results_hist_act pm r))
    :pattern ($FVF.perm_results_hist_act pm r))))
(assert (forall ((r $Ref) (f Seq<Int>)) (!
    (= ($FVF.loc_results_hist_act f r) true)
    :pattern ($FVF.loc_results_hist_act f r))))
; /field_value_functions_axioms.smt2 [results_hist_init: Seq[Int]]
(assert (forall ((vs $FVF<Seq<Int>>) (ws $FVF<Seq<Int>>)) (!
    (implies
      (and
        (Set_equal ($FVF.domain_results_hist_init vs) ($FVF.domain_results_hist_init ws))
        (forall ((x $Ref)) (!
          (implies
            (Set_in x ($FVF.domain_results_hist_init vs))
            (= ($FVF.lookup_results_hist_init vs x) ($FVF.lookup_results_hist_init ws x)))
          :pattern (($FVF.lookup_results_hist_init vs x) ($FVF.lookup_results_hist_init ws x))
          :qid |qp.$FVF<Seq<Int>>-eq-inner|
          )))
      (= vs ws))
    :pattern (($SortWrappers.$FVF<Seq<Int>>To$Snap vs)
              ($SortWrappers.$FVF<Seq<Int>>To$Snap ws)
              )
    :qid |qp.$FVF<Seq<Int>>-eq-outer|
    )))
(assert (forall ((r $Ref) (pm $FPM)) (!
    ($Perm.isValidVar ($FVF.perm_results_hist_init pm r))
    :pattern ($FVF.perm_results_hist_init pm r))))
(assert (forall ((r $Ref) (f Seq<Int>)) (!
    (= ($FVF.loc_results_hist_init f r) true)
    :pattern ($FVF.loc_results_hist_init f r))))
; End preamble
; ------------------------------------------------------------
; State saturation: after preamble
(set-option :timeout 100)
(check-sat)
; unknown
; ---------- FUNCTION method_Program_update__Sequence$Integer$__Integer__Integer----------
(declare-fun xs@0@00 () Seq<Int>)
(declare-fun i@1@00 () Int)
(declare-fun v@2@00 () Int)
(declare-fun result@3@00 () Seq<Int>)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 <= i
(assert (<= 0 i@1@00))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] i < |xs|
; [eval] |xs|
(assert (< i@1@00 (Seq_length xs@0@00)))
(declare-const $t@21@00 $Snap)
(assert (= $t@21@00 ($Snap.combine ($Snap.first $t@21@00) ($Snap.second $t@21@00))))
(assert (= ($Snap.first $t@21@00) $Snap.unit))
; [eval] |result| == |xs|
; [eval] |result|
; [eval] |xs|
(assert (= (Seq_length result@3@00) (Seq_length xs@0@00)))
(assert (=
  ($Snap.second $t@21@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@21@00))
    ($Snap.second ($Snap.second $t@21@00)))))
(assert (= ($Snap.first ($Snap.second $t@21@00)) $Snap.unit))
; [eval] result[i] == v
; [eval] result[i]
(set-option :timeout 0)
(push) ; 2
(assert (not (>= i@1@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (< i@1@00 (Seq_length result@3@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_index result@3@00 i@1@00) v@2@00))
(assert (= ($Snap.second ($Snap.second $t@21@00)) $Snap.unit))
; [eval] (forall j: Int :: { result[j] } { xs[j] } 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j])
(declare-const j@22@00 Int)
(push) ; 2
; [eval] 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j]
; [eval] 0 <= j && (j < |xs| && j != i)
; [eval] 0 <= j
(push) ; 3
; [then-branch: 0 | 0 <= j@22@00 | live]
; [else-branch: 0 | !(0 <= j@22@00) | live]
(push) ; 4
; [then-branch: 0 | 0 <= j@22@00]
(assert (<= 0 j@22@00))
; [eval] j < |xs|
; [eval] |xs|
(push) ; 5
; [then-branch: 1 | j@22@00 < |xs@0@00| | live]
; [else-branch: 1 | !(j@22@00 < |xs@0@00|) | live]
(push) ; 6
; [then-branch: 1 | j@22@00 < |xs@0@00|]
(assert (< j@22@00 (Seq_length xs@0@00)))
; [eval] j != i
(pop) ; 6
(push) ; 6
; [else-branch: 1 | !(j@22@00 < |xs@0@00|)]
(assert (not (< j@22@00 (Seq_length xs@0@00))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 0 | !(0 <= j@22@00)]
(assert (not (<= 0 j@22@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 2 | j@22@00 != i@1@00 && j@22@00 < |xs@0@00| && 0 <= j@22@00 | live]
; [else-branch: 2 | !(j@22@00 != i@1@00 && j@22@00 < |xs@0@00| && 0 <= j@22@00) | live]
(push) ; 4
; [then-branch: 2 | j@22@00 != i@1@00 && j@22@00 < |xs@0@00| && 0 <= j@22@00]
(assert (and
  (and (not (= j@22@00 i@1@00)) (< j@22@00 (Seq_length xs@0@00)))
  (<= 0 j@22@00)))
; [eval] result[j] == xs[j]
; [eval] result[j]
(push) ; 5
(assert (not (>= j@22@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
(assert (not (< j@22@00 (Seq_length result@3@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 5
(assert (not (>= j@22@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 2 | !(j@22@00 != i@1@00 && j@22@00 < |xs@0@00| && 0 <= j@22@00)]
(assert (not
  (and
    (and (not (= j@22@00 i@1@00)) (< j@22@00 (Seq_length xs@0@00)))
    (<= 0 j@22@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and
    (and (not (= j@22@00 i@1@00)) (< j@22@00 (Seq_length xs@0@00)))
    (<= 0 j@22@00))
  (and (not (= j@22@00 i@1@00)) (< j@22@00 (Seq_length xs@0@00)) (<= 0 j@22@00))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((j@22@00 Int)) (!
  (implies
    (and
      (and (not (= j@22@00 i@1@00)) (< j@22@00 (Seq_length xs@0@00)))
      (<= 0 j@22@00))
    (and
      (not (= j@22@00 i@1@00))
      (< j@22@00 (Seq_length xs@0@00))
      (<= 0 j@22@00)))
  :pattern ((Seq_index result@3@00 j@22@00))
  :qid |prog.l209-aux|)))
(assert (forall ((j@22@00 Int)) (!
  (implies
    (and
      (and (not (= j@22@00 i@1@00)) (< j@22@00 (Seq_length xs@0@00)))
      (<= 0 j@22@00))
    (and
      (not (= j@22@00 i@1@00))
      (< j@22@00 (Seq_length xs@0@00))
      (<= 0 j@22@00)))
  :pattern ((Seq_index xs@0@00 j@22@00))
  :qid |prog.l209-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((j@22@00 Int)) (!
  (implies
    (and
      (and (not (= j@22@00 i@1@00)) (< j@22@00 (Seq_length xs@0@00)))
      (<= 0 j@22@00))
    (= (Seq_index result@3@00 j@22@00) (Seq_index xs@0@00 j@22@00)))
  :pattern ((Seq_index result@3@00 j@22@00))
  :pattern ((Seq_index xs@0@00 j@22@00))
  :qid |prog.l209|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (xs@0@00 Seq<Int>) (i@1@00 Int) (v@2@00 Int)) (!
  (Seq_equal
    (method_Program_update__Sequence$Integer$__Integer__Integer%limited s@$ xs@0@00 i@1@00 v@2@00)
    (method_Program_update__Sequence$Integer$__Integer__Integer s@$ xs@0@00 i@1@00 v@2@00))
  :pattern ((method_Program_update__Sequence$Integer$__Integer__Integer s@$ xs@0@00 i@1@00 v@2@00))
  )))
(assert (forall ((s@$ $Snap) (xs@0@00 Seq<Int>) (i@1@00 Int) (v@2@00 Int)) (!
  (method_Program_update__Sequence$Integer$__Integer__Integer%stateless xs@0@00 i@1@00 v@2@00)
  :pattern ((method_Program_update__Sequence$Integer$__Integer__Integer%limited s@$ xs@0@00 i@1@00 v@2@00))
  )))
(assert (forall ((s@$ $Snap) (xs@0@00 Seq<Int>) (i@1@00 Int) (v@2@00 Int)) (!
  (let ((result@3@00 (method_Program_update__Sequence$Integer$__Integer__Integer%limited s@$ xs@0@00 i@1@00 v@2@00))) (implies
    (and (<= 0 i@1@00) (< i@1@00 (Seq_length xs@0@00)))
    (and
      (= (Seq_length result@3@00) (Seq_length xs@0@00))
      (= (Seq_index result@3@00 i@1@00) v@2@00)
      (forall ((j Int)) (!
        (implies
          (and (<= 0 j) (and (< j (Seq_length xs@0@00)) (not (= j i@1@00))))
          (= (Seq_index result@3@00 j) (Seq_index xs@0@00 j)))
        :pattern ((Seq_index result@3@00 j))
        :pattern ((Seq_index xs@0@00 j))
        )))))
  :pattern ((method_Program_update__Sequence$Integer$__Integer__Integer%limited s@$ xs@0@00 i@1@00 v@2@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (<= 0 i@1@00))
(assert (= ($Snap.second s@$) $Snap.unit))
(assert (< i@1@00 (Seq_length xs@0@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (0 < i ? Seq(xs[0]) ++ method_Program_update__Sequence$Integer$__Integer__Integer(xs[1..], i - 1, v) : Seq(v) ++ xs[1..])
; [eval] 0 < i
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 i@1@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(assert (not (< 0 i@1@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 3 | 0 < i@1@00 | live]
; [else-branch: 3 | !(0 < i@1@00) | live]
(push) ; 3
; [then-branch: 3 | 0 < i@1@00]
(assert (< 0 i@1@00))
; [eval] Seq(xs[0]) ++ method_Program_update__Sequence$Integer$__Integer__Integer(xs[1..], i - 1, v)
; [eval] Seq(xs[0])
; [eval] xs[0]
(set-option :timeout 0)
(push) ; 4
(assert (not (< 0 (Seq_length xs@0@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_length (Seq_singleton (Seq_index xs@0@00 0))) 1))
; [eval] method_Program_update__Sequence$Integer$__Integer__Integer(xs[1..], i - 1, v)
; [eval] xs[1..]
; [eval] i - 1
(push) ; 4
; [eval] 0 <= i
(push) ; 5
(assert (not (<= 0 (- i@1@00 1))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(assert (<= 0 (- i@1@00 1)))
; [eval] i < |xs|
; [eval] |xs|
(push) ; 5
(assert (not (< (- i@1@00 1) (Seq_length (Seq_drop xs@0@00 1)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(assert (< (- i@1@00 1) (Seq_length (Seq_drop xs@0@00 1))))
(pop) ; 4
; Joined path conditions
(assert (and (<= 0 (- i@1@00 1)) (< (- i@1@00 1) (Seq_length (Seq_drop xs@0@00 1)))))
(pop) ; 3
(push) ; 3
; [else-branch: 3 | !(0 < i@1@00)]
(assert (not (< 0 i@1@00)))
; [eval] Seq(v) ++ xs[1..]
; [eval] Seq(v)
(assert (= (Seq_length (Seq_singleton v@2@00)) 1))
; [eval] xs[1..]
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 i@1@00)
  (and
    (< 0 i@1@00)
    (= (Seq_length (Seq_singleton (Seq_index xs@0@00 0))) 1)
    (<= 0 (- i@1@00 1))
    (< (- i@1@00 1) (Seq_length (Seq_drop xs@0@00 1))))))
; Joined path conditions
(assert (implies
  (not (< 0 i@1@00))
  (and (not (< 0 i@1@00)) (= (Seq_length (Seq_singleton v@2@00)) 1))))
(assert (Seq_equal
  result@3@00
  (ite
    (< 0 i@1@00)
    (Seq_append
      (Seq_singleton (Seq_index xs@0@00 0))
      (method_Program_update__Sequence$Integer$__Integer__Integer ($Snap.combine
        $Snap.unit
        $Snap.unit) (Seq_drop xs@0@00 1) (- i@1@00 1) v@2@00))
    (Seq_append (Seq_singleton v@2@00) (Seq_drop xs@0@00 1)))))
; [eval] |result| == |xs|
; [eval] |result|
; [eval] |xs|
(push) ; 2
(assert (not (= (Seq_length result@3@00) (Seq_length xs@0@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_length result@3@00) (Seq_length xs@0@00)))
; [eval] result[i] == v
; [eval] result[i]
(push) ; 2
(assert (not (>= i@1@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (< i@1@00 (Seq_length result@3@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (= (Seq_index result@3@00 i@1@00) v@2@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_index result@3@00 i@1@00) v@2@00))
; [eval] (forall j: Int :: { result[j] } { xs[j] } 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j])
(declare-const j@23@00 Int)
(push) ; 2
; [eval] 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j]
; [eval] 0 <= j && (j < |xs| && j != i)
; [eval] 0 <= j
(push) ; 3
; [then-branch: 4 | 0 <= j@23@00 | live]
; [else-branch: 4 | !(0 <= j@23@00) | live]
(push) ; 4
; [then-branch: 4 | 0 <= j@23@00]
(assert (<= 0 j@23@00))
; [eval] j < |xs|
; [eval] |xs|
(push) ; 5
; [then-branch: 5 | j@23@00 < |xs@0@00| | live]
; [else-branch: 5 | !(j@23@00 < |xs@0@00|) | live]
(push) ; 6
; [then-branch: 5 | j@23@00 < |xs@0@00|]
(assert (< j@23@00 (Seq_length xs@0@00)))
; [eval] j != i
(pop) ; 6
(push) ; 6
; [else-branch: 5 | !(j@23@00 < |xs@0@00|)]
(assert (not (< j@23@00 (Seq_length xs@0@00))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 4 | !(0 <= j@23@00)]
(assert (not (<= 0 j@23@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 6 | j@23@00 != i@1@00 && j@23@00 < |xs@0@00| && 0 <= j@23@00 | live]
; [else-branch: 6 | !(j@23@00 != i@1@00 && j@23@00 < |xs@0@00| && 0 <= j@23@00) | live]
(push) ; 4
; [then-branch: 6 | j@23@00 != i@1@00 && j@23@00 < |xs@0@00| && 0 <= j@23@00]
(assert (and
  (and (not (= j@23@00 i@1@00)) (< j@23@00 (Seq_length xs@0@00)))
  (<= 0 j@23@00)))
; [eval] result[j] == xs[j]
; [eval] result[j]
(push) ; 5
(assert (not (>= j@23@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
(assert (not (< j@23@00 (Seq_length result@3@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 5
(assert (not (>= j@23@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 6 | !(j@23@00 != i@1@00 && j@23@00 < |xs@0@00| && 0 <= j@23@00)]
(assert (not
  (and
    (and (not (= j@23@00 i@1@00)) (< j@23@00 (Seq_length xs@0@00)))
    (<= 0 j@23@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and
    (and (not (= j@23@00 i@1@00)) (< j@23@00 (Seq_length xs@0@00)))
    (<= 0 j@23@00))
  (and (not (= j@23@00 i@1@00)) (< j@23@00 (Seq_length xs@0@00)) (<= 0 j@23@00))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((j@23@00 Int)) (!
  (implies
    (and
      (and (not (= j@23@00 i@1@00)) (< j@23@00 (Seq_length xs@0@00)))
      (<= 0 j@23@00))
    (and
      (not (= j@23@00 i@1@00))
      (< j@23@00 (Seq_length xs@0@00))
      (<= 0 j@23@00)))
  :pattern ((Seq_index result@3@00 j@23@00))
  :qid |prog.l209-aux|)))
(assert (forall ((j@23@00 Int)) (!
  (implies
    (and
      (and (not (= j@23@00 i@1@00)) (< j@23@00 (Seq_length xs@0@00)))
      (<= 0 j@23@00))
    (and
      (not (= j@23@00 i@1@00))
      (< j@23@00 (Seq_length xs@0@00))
      (<= 0 j@23@00)))
  :pattern ((Seq_index xs@0@00 j@23@00))
  :qid |prog.l209-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(push) ; 2
(assert (not (forall ((j@23@00 Int)) (!
  (implies
    (and
      (and (not (= j@23@00 i@1@00)) (< j@23@00 (Seq_length xs@0@00)))
      (<= 0 j@23@00))
    (= (Seq_index result@3@00 j@23@00) (Seq_index xs@0@00 j@23@00)))
  :pattern ((Seq_index result@3@00 j@23@00))
  :pattern ((Seq_index xs@0@00 j@23@00))
  :qid |prog.l209|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (forall ((j@23@00 Int)) (!
  (implies
    (and
      (and (not (= j@23@00 i@1@00)) (< j@23@00 (Seq_length xs@0@00)))
      (<= 0 j@23@00))
    (= (Seq_index result@3@00 j@23@00) (Seq_index xs@0@00 j@23@00)))
  :pattern ((Seq_index result@3@00 j@23@00))
  :pattern ((Seq_index xs@0@00 j@23@00))
  :qid |prog.l209|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (xs@0@00 Seq<Int>) (i@1@00 Int) (v@2@00 Int)) (!
  (implies
    (and (<= 0 i@1@00) (< i@1@00 (Seq_length xs@0@00)))
    (Seq_equal
      (method_Program_update__Sequence$Integer$__Integer__Integer s@$ xs@0@00 i@1@00 v@2@00)
      (ite
        (< 0 i@1@00)
        (Seq_append
          (Seq_singleton (Seq_index xs@0@00 0))
          (method_Program_update__Sequence$Integer$__Integer__Integer%limited ($Snap.combine
            $Snap.unit
            $Snap.unit) (Seq_drop xs@0@00 1) (- i@1@00 1) v@2@00))
        (Seq_append (Seq_singleton v@2@00) (Seq_drop xs@0@00 1)))))
  :pattern ((method_Program_update__Sequence$Integer$__Integer__Integer s@$ xs@0@00 i@1@00 v@2@00))
  )))
; ---------- FUNCTION new_frac----------
(declare-fun x@4@00 () $Perm)
(declare-fun result@5@00 () frac)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 / 1 < x
(push) ; 2
(assert (not (not (= 1 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (< $Perm.No x@4@00))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] x <= 1 / 1
(push) ; 2
(assert (not (not (= 1 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (<= x@4@00 $Perm.Write))
(declare-const $t@24@00 $Snap)
(assert (= $t@24@00 $Snap.unit))
; [eval] frac_val(result) == x
; [eval] frac_val(result)
(assert (= (frac_val<Perm> result@5@00) x@4@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (x@4@00 $Perm)) (!
  (= (new_frac%limited s@$ x@4@00) (new_frac s@$ x@4@00))
  :pattern ((new_frac s@$ x@4@00))
  )))
(assert (forall ((s@$ $Snap) (x@4@00 $Perm)) (!
  (new_frac%stateless x@4@00)
  :pattern ((new_frac%limited s@$ x@4@00))
  )))
(assert (forall ((s@$ $Snap) (x@4@00 $Perm)) (!
  (let ((result@5@00 (new_frac%limited s@$ x@4@00))) (implies
    (and (< $Perm.No x@4@00) (<= x@4@00 $Perm.Write))
    (= (frac_val<Perm> result@5@00) x@4@00)))
  :pattern ((new_frac%limited s@$ x@4@00))
  )))
; ---------- FUNCTION method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer----------
(declare-fun diz@6@00 () $Ref)
(declare-fun xs@7@00 () Seq<Seq<Int>>)
(declare-fun i@8@00 () Int)
(declare-fun val@9@00 () Int)
(declare-fun result@10@00 () Seq<Seq<Int>>)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@6@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] 0 <= i
(assert (<= 0 i@8@00))
(assert (= ($Snap.second ($Snap.second s@$)) $Snap.unit))
; [eval] i < |xs|
; [eval] |xs|
(assert (< i@8@00 (Seq_length xs@7@00)))
(declare-const $t@25@00 $Snap)
(assert (= $t@25@00 ($Snap.combine ($Snap.first $t@25@00) ($Snap.second $t@25@00))))
(assert (= ($Snap.first $t@25@00) $Snap.unit))
; [eval] |result| == |xs|
; [eval] |result|
; [eval] |xs|
(assert (= (Seq_length result@10@00) (Seq_length xs@7@00)))
(assert (=
  ($Snap.second $t@25@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@25@00))
    ($Snap.second ($Snap.second $t@25@00)))))
(assert (= ($Snap.first ($Snap.second $t@25@00)) $Snap.unit))
; [eval] result[i] == xs[i] ++ Seq(val)
; [eval] result[i]
(push) ; 2
(assert (not (>= i@8@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (< i@8@00 (Seq_length result@10@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [eval] xs[i] ++ Seq(val)
; [eval] xs[i]
(push) ; 2
(assert (not (>= i@8@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [eval] Seq(val)
(assert (= (Seq_length (Seq_singleton val@9@00)) 1))
(assert (Seq_equal
  (Seq_index result@10@00 i@8@00)
  (Seq_append (Seq_index xs@7@00 i@8@00) (Seq_singleton val@9@00))))
(assert (= ($Snap.second ($Snap.second $t@25@00)) $Snap.unit))
; [eval] (forall j: Int :: { result[j] } { xs[j] } 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j])
(declare-const j@26@00 Int)
(push) ; 2
; [eval] 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j]
; [eval] 0 <= j && (j < |xs| && j != i)
; [eval] 0 <= j
(push) ; 3
; [then-branch: 7 | 0 <= j@26@00 | live]
; [else-branch: 7 | !(0 <= j@26@00) | live]
(push) ; 4
; [then-branch: 7 | 0 <= j@26@00]
(assert (<= 0 j@26@00))
; [eval] j < |xs|
; [eval] |xs|
(push) ; 5
; [then-branch: 8 | j@26@00 < |xs@7@00| | live]
; [else-branch: 8 | !(j@26@00 < |xs@7@00|) | live]
(push) ; 6
; [then-branch: 8 | j@26@00 < |xs@7@00|]
(assert (< j@26@00 (Seq_length xs@7@00)))
; [eval] j != i
(pop) ; 6
(push) ; 6
; [else-branch: 8 | !(j@26@00 < |xs@7@00|)]
(assert (not (< j@26@00 (Seq_length xs@7@00))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 7 | !(0 <= j@26@00)]
(assert (not (<= 0 j@26@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 9 | j@26@00 != i@8@00 && j@26@00 < |xs@7@00| && 0 <= j@26@00 | live]
; [else-branch: 9 | !(j@26@00 != i@8@00 && j@26@00 < |xs@7@00| && 0 <= j@26@00) | live]
(push) ; 4
; [then-branch: 9 | j@26@00 != i@8@00 && j@26@00 < |xs@7@00| && 0 <= j@26@00]
(assert (and
  (and (not (= j@26@00 i@8@00)) (< j@26@00 (Seq_length xs@7@00)))
  (<= 0 j@26@00)))
; [eval] result[j] == xs[j]
; [eval] result[j]
(push) ; 5
(assert (not (>= j@26@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
(assert (not (< j@26@00 (Seq_length result@10@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 5
(assert (not (>= j@26@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 9 | !(j@26@00 != i@8@00 && j@26@00 < |xs@7@00| && 0 <= j@26@00)]
(assert (not
  (and
    (and (not (= j@26@00 i@8@00)) (< j@26@00 (Seq_length xs@7@00)))
    (<= 0 j@26@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and
    (and (not (= j@26@00 i@8@00)) (< j@26@00 (Seq_length xs@7@00)))
    (<= 0 j@26@00))
  (and (not (= j@26@00 i@8@00)) (< j@26@00 (Seq_length xs@7@00)) (<= 0 j@26@00))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((j@26@00 Int)) (!
  (implies
    (and
      (and (not (= j@26@00 i@8@00)) (< j@26@00 (Seq_length xs@7@00)))
      (<= 0 j@26@00))
    (and
      (not (= j@26@00 i@8@00))
      (< j@26@00 (Seq_length xs@7@00))
      (<= 0 j@26@00)))
  :pattern ((Seq_index result@10@00 j@26@00))
  :qid |prog.l230-aux|)))
(assert (forall ((j@26@00 Int)) (!
  (implies
    (and
      (and (not (= j@26@00 i@8@00)) (< j@26@00 (Seq_length xs@7@00)))
      (<= 0 j@26@00))
    (and
      (not (= j@26@00 i@8@00))
      (< j@26@00 (Seq_length xs@7@00))
      (<= 0 j@26@00)))
  :pattern ((Seq_index xs@7@00 j@26@00))
  :qid |prog.l230-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((j@26@00 Int)) (!
  (implies
    (and
      (and (not (= j@26@00 i@8@00)) (< j@26@00 (Seq_length xs@7@00)))
      (<= 0 j@26@00))
    (Seq_equal (Seq_index result@10@00 j@26@00) (Seq_index xs@7@00 j@26@00)))
  :pattern ((Seq_index result@10@00 j@26@00))
  :pattern ((Seq_index xs@7@00 j@26@00))
  :qid |prog.l230|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (diz@6@00 $Ref) (xs@7@00 Seq<Seq<Int>>) (i@8@00 Int) (val@9@00 Int)) (!
  (Seq_equal
    (method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer%limited s@$ diz@6@00 xs@7@00 i@8@00 val@9@00)
    (method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer s@$ diz@6@00 xs@7@00 i@8@00 val@9@00))
  :pattern ((method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer s@$ diz@6@00 xs@7@00 i@8@00 val@9@00))
  )))
(assert (forall ((s@$ $Snap) (diz@6@00 $Ref) (xs@7@00 Seq<Seq<Int>>) (i@8@00 Int) (val@9@00 Int)) (!
  (method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer%stateless diz@6@00 xs@7@00 i@8@00 val@9@00)
  :pattern ((method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer%limited s@$ diz@6@00 xs@7@00 i@8@00 val@9@00))
  )))
(assert (forall ((s@$ $Snap) (diz@6@00 $Ref) (xs@7@00 Seq<Seq<Int>>) (i@8@00 Int) (val@9@00 Int)) (!
  (let ((result@10@00 (method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer%limited s@$ diz@6@00 xs@7@00 i@8@00 val@9@00))) (implies
    (and
      (not (= diz@6@00 $Ref.null))
      (and (<= 0 i@8@00) (< i@8@00 (Seq_length xs@7@00))))
    (and
      (= (Seq_length result@10@00) (Seq_length xs@7@00))
      (Seq_equal
        (Seq_index result@10@00 i@8@00)
        (Seq_append (Seq_index xs@7@00 i@8@00) (Seq_singleton val@9@00)))
      (forall ((j Int)) (!
        (implies
          (and (<= 0 j) (and (< j (Seq_length xs@7@00)) (not (= j i@8@00))))
          (Seq_equal (Seq_index result@10@00 j) (Seq_index xs@7@00 j)))
        :pattern ((Seq_index result@10@00 j))
        :pattern ((Seq_index xs@7@00 j))
        )))))
  :pattern ((method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer%limited s@$ diz@6@00 xs@7@00 i@8@00 val@9@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= diz@6@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (<= 0 i@8@00))
(assert (= ($Snap.second ($Snap.second s@$)) $Snap.unit))
(assert (< i@8@00 (Seq_length xs@7@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (0 < i ? Seq(xs[0]) ++ method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer(diz, xs[1..], i - 1, val) : Seq(xs[0] ++ Seq(val)) ++ xs[1..])
; [eval] 0 < i
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 i@8@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(assert (not (< 0 i@8@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 10 | 0 < i@8@00 | live]
; [else-branch: 10 | !(0 < i@8@00) | live]
(push) ; 3
; [then-branch: 10 | 0 < i@8@00]
(assert (< 0 i@8@00))
; [eval] Seq(xs[0]) ++ method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer(diz, xs[1..], i - 1, val)
; [eval] Seq(xs[0])
; [eval] xs[0]
(set-option :timeout 0)
(push) ; 4
(assert (not (< 0 (Seq_length xs@7@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_length (Seq_singleton (Seq_index xs@7@00 0))) 1))
; [eval] method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer(diz, xs[1..], i - 1, val)
; [eval] xs[1..]
; [eval] i - 1
(push) ; 4
; [eval] diz != null
; [eval] 0 <= i
(push) ; 5
(assert (not (<= 0 (- i@8@00 1))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(assert (<= 0 (- i@8@00 1)))
; [eval] i < |xs|
; [eval] |xs|
(push) ; 5
(assert (not (< (- i@8@00 1) (Seq_length (Seq_drop xs@7@00 1)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(assert (< (- i@8@00 1) (Seq_length (Seq_drop xs@7@00 1))))
(pop) ; 4
; Joined path conditions
(assert (and (<= 0 (- i@8@00 1)) (< (- i@8@00 1) (Seq_length (Seq_drop xs@7@00 1)))))
(pop) ; 3
(push) ; 3
; [else-branch: 10 | !(0 < i@8@00)]
(assert (not (< 0 i@8@00)))
; [eval] Seq(xs[0] ++ Seq(val)) ++ xs[1..]
; [eval] Seq(xs[0] ++ Seq(val))
; [eval] xs[0] ++ Seq(val)
; [eval] xs[0]
(push) ; 4
(assert (not (< 0 (Seq_length xs@7@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
; [eval] Seq(val)
(assert (= (Seq_length (Seq_singleton val@9@00)) 1))
(assert (=
  (Seq_length
    (Seq_singleton (Seq_append (Seq_index xs@7@00 0) (Seq_singleton val@9@00))))
  1))
; [eval] xs[1..]
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 i@8@00)
  (and
    (< 0 i@8@00)
    (= (Seq_length (Seq_singleton (Seq_index xs@7@00 0))) 1)
    (<= 0 (- i@8@00 1))
    (< (- i@8@00 1) (Seq_length (Seq_drop xs@7@00 1))))))
; Joined path conditions
(assert (implies
  (not (< 0 i@8@00))
  (and
    (not (< 0 i@8@00))
    (= (Seq_length (Seq_singleton val@9@00)) 1)
    (=
      (Seq_length
        (Seq_singleton (Seq_append
          (Seq_index xs@7@00 0)
          (Seq_singleton val@9@00))))
      1))))
(assert (Seq_equal
  result@10@00
  (ite
    (< 0 i@8@00)
    (Seq_append
      (Seq_singleton (Seq_index xs@7@00 0))
      (method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer ($Snap.combine
        $Snap.unit
        ($Snap.combine $Snap.unit $Snap.unit)) diz@6@00 (Seq_drop xs@7@00 1) (-
        i@8@00
        1) val@9@00))
    (Seq_append
      (Seq_singleton (Seq_append (Seq_index xs@7@00 0) (Seq_singleton val@9@00)))
      (Seq_drop xs@7@00 1)))))
; [eval] |result| == |xs|
; [eval] |result|
; [eval] |xs|
(push) ; 2
(assert (not (= (Seq_length result@10@00) (Seq_length xs@7@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_length result@10@00) (Seq_length xs@7@00)))
; [eval] result[i] == xs[i] ++ Seq(val)
; [eval] result[i]
(push) ; 2
(assert (not (>= i@8@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (< i@8@00 (Seq_length result@10@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [eval] xs[i] ++ Seq(val)
; [eval] xs[i]
(push) ; 2
(assert (not (>= i@8@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [eval] Seq(val)
(assert (= (Seq_length (Seq_singleton val@9@00)) 1))
(push) ; 2
(assert (not (Seq_equal
  (Seq_index result@10@00 i@8@00)
  (Seq_append (Seq_index xs@7@00 i@8@00) (Seq_singleton val@9@00)))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (Seq_equal
  (Seq_index result@10@00 i@8@00)
  (Seq_append (Seq_index xs@7@00 i@8@00) (Seq_singleton val@9@00))))
; [eval] (forall j: Int :: { result[j] } { xs[j] } 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j])
(declare-const j@27@00 Int)
(push) ; 2
; [eval] 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j]
; [eval] 0 <= j && (j < |xs| && j != i)
; [eval] 0 <= j
(push) ; 3
; [then-branch: 11 | 0 <= j@27@00 | live]
; [else-branch: 11 | !(0 <= j@27@00) | live]
(push) ; 4
; [then-branch: 11 | 0 <= j@27@00]
(assert (<= 0 j@27@00))
; [eval] j < |xs|
; [eval] |xs|
(push) ; 5
; [then-branch: 12 | j@27@00 < |xs@7@00| | live]
; [else-branch: 12 | !(j@27@00 < |xs@7@00|) | live]
(push) ; 6
; [then-branch: 12 | j@27@00 < |xs@7@00|]
(assert (< j@27@00 (Seq_length xs@7@00)))
; [eval] j != i
(pop) ; 6
(push) ; 6
; [else-branch: 12 | !(j@27@00 < |xs@7@00|)]
(assert (not (< j@27@00 (Seq_length xs@7@00))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 11 | !(0 <= j@27@00)]
(assert (not (<= 0 j@27@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 13 | j@27@00 != i@8@00 && j@27@00 < |xs@7@00| && 0 <= j@27@00 | live]
; [else-branch: 13 | !(j@27@00 != i@8@00 && j@27@00 < |xs@7@00| && 0 <= j@27@00) | live]
(push) ; 4
; [then-branch: 13 | j@27@00 != i@8@00 && j@27@00 < |xs@7@00| && 0 <= j@27@00]
(assert (and
  (and (not (= j@27@00 i@8@00)) (< j@27@00 (Seq_length xs@7@00)))
  (<= 0 j@27@00)))
; [eval] result[j] == xs[j]
; [eval] result[j]
(push) ; 5
(assert (not (>= j@27@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
(assert (not (< j@27@00 (Seq_length result@10@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 5
(assert (not (>= j@27@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 13 | !(j@27@00 != i@8@00 && j@27@00 < |xs@7@00| && 0 <= j@27@00)]
(assert (not
  (and
    (and (not (= j@27@00 i@8@00)) (< j@27@00 (Seq_length xs@7@00)))
    (<= 0 j@27@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and
    (and (not (= j@27@00 i@8@00)) (< j@27@00 (Seq_length xs@7@00)))
    (<= 0 j@27@00))
  (and (not (= j@27@00 i@8@00)) (< j@27@00 (Seq_length xs@7@00)) (<= 0 j@27@00))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((j@27@00 Int)) (!
  (implies
    (and
      (and (not (= j@27@00 i@8@00)) (< j@27@00 (Seq_length xs@7@00)))
      (<= 0 j@27@00))
    (and
      (not (= j@27@00 i@8@00))
      (< j@27@00 (Seq_length xs@7@00))
      (<= 0 j@27@00)))
  :pattern ((Seq_index result@10@00 j@27@00))
  :qid |prog.l230-aux|)))
(assert (forall ((j@27@00 Int)) (!
  (implies
    (and
      (and (not (= j@27@00 i@8@00)) (< j@27@00 (Seq_length xs@7@00)))
      (<= 0 j@27@00))
    (and
      (not (= j@27@00 i@8@00))
      (< j@27@00 (Seq_length xs@7@00))
      (<= 0 j@27@00)))
  :pattern ((Seq_index xs@7@00 j@27@00))
  :qid |prog.l230-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(push) ; 2
(assert (not (forall ((j@27@00 Int)) (!
  (implies
    (and
      (and (not (= j@27@00 i@8@00)) (< j@27@00 (Seq_length xs@7@00)))
      (<= 0 j@27@00))
    (Seq_equal (Seq_index result@10@00 j@27@00) (Seq_index xs@7@00 j@27@00)))
  :pattern ((Seq_index result@10@00 j@27@00))
  :pattern ((Seq_index xs@7@00 j@27@00))
  :qid |prog.l230|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (forall ((j@27@00 Int)) (!
  (implies
    (and
      (and (not (= j@27@00 i@8@00)) (< j@27@00 (Seq_length xs@7@00)))
      (<= 0 j@27@00))
    (Seq_equal (Seq_index result@10@00 j@27@00) (Seq_index xs@7@00 j@27@00)))
  :pattern ((Seq_index result@10@00 j@27@00))
  :pattern ((Seq_index xs@7@00 j@27@00))
  :qid |prog.l230|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (diz@6@00 $Ref) (xs@7@00 Seq<Seq<Int>>) (i@8@00 Int) (val@9@00 Int)) (!
  (implies
    (and
      (not (= diz@6@00 $Ref.null))
      (and (<= 0 i@8@00) (< i@8@00 (Seq_length xs@7@00))))
    (Seq_equal
      (method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer s@$ diz@6@00 xs@7@00 i@8@00 val@9@00)
      (ite
        (< 0 i@8@00)
        (Seq_append
          (Seq_singleton (Seq_index xs@7@00 0))
          (method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer%limited ($Snap.combine
            $Snap.unit
            ($Snap.combine $Snap.unit $Snap.unit)) diz@6@00 (Seq_drop xs@7@00 1) (-
            i@8@00
            1) val@9@00))
        (Seq_append
          (Seq_singleton (Seq_append
            (Seq_index xs@7@00 0)
            (Seq_singleton val@9@00)))
          (Seq_drop xs@7@00 1)))))
  :pattern ((method_Program_push__Sequence$Sequence$Integer$$__Integer__Integer s@$ diz@6@00 xs@7@00 i@8@00 val@9@00))
  )))
; ---------- FUNCTION method_Program_maxint__Sequence$Integer$__Integer__Integer----------
(declare-fun xs@11@00 () Seq<Int>)
(declare-fun i@12@00 () Int)
(declare-fun j@13@00 () Int)
(declare-fun result@14@00 () Int)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 <= i
(assert (<= 0 i@12@00))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] i <= |xs|
; [eval] |xs|
(assert (<= i@12@00 (Seq_length xs@11@00)))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
; [eval] 0 <= j
(assert (<= 0 j@13@00))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second s@$)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
; [eval] j < |xs|
; [eval] |xs|
(assert (< j@13@00 (Seq_length xs@11@00)))
(assert (= ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
; [eval] (forall l: Int :: { xs[l] } 0 <= l && l < i ==> xs[l] <= xs[j])
(declare-const l@28@00 Int)
(push) ; 2
; [eval] 0 <= l && l < i ==> xs[l] <= xs[j]
; [eval] 0 <= l && l < i
; [eval] 0 <= l
(push) ; 3
; [then-branch: 14 | 0 <= l@28@00 | live]
; [else-branch: 14 | !(0 <= l@28@00) | live]
(push) ; 4
; [then-branch: 14 | 0 <= l@28@00]
(assert (<= 0 l@28@00))
; [eval] l < i
(pop) ; 4
(push) ; 4
; [else-branch: 14 | !(0 <= l@28@00)]
(assert (not (<= 0 l@28@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 15 | l@28@00 < i@12@00 && 0 <= l@28@00 | live]
; [else-branch: 15 | !(l@28@00 < i@12@00 && 0 <= l@28@00) | live]
(push) ; 4
; [then-branch: 15 | l@28@00 < i@12@00 && 0 <= l@28@00]
(assert (and (< l@28@00 i@12@00) (<= 0 l@28@00)))
; [eval] xs[l] <= xs[j]
; [eval] xs[l]
(push) ; 5
(assert (not (>= l@28@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
(assert (not (< l@28@00 (Seq_length xs@11@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 5
(assert (not (>= j@13@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 15 | !(l@28@00 < i@12@00 && 0 <= l@28@00)]
(assert (not (and (< l@28@00 i@12@00) (<= 0 l@28@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((l@28@00 Int)) (!
  (implies
    (and (< l@28@00 i@12@00) (<= 0 l@28@00))
    (<= (Seq_index xs@11@00 l@28@00) (Seq_index xs@11@00 j@13@00)))
  :pattern ((Seq_index xs@11@00 l@28@00))
  :qid |prog.l217|)))
(declare-const $t@29@00 $Snap)
(assert (= $t@29@00 ($Snap.combine ($Snap.first $t@29@00) ($Snap.second $t@29@00))))
(assert (= ($Snap.first $t@29@00) $Snap.unit))
; [eval] 0 <= result
(assert (<= 0 result@14@00))
(assert (=
  ($Snap.second $t@29@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@29@00))
    ($Snap.second ($Snap.second $t@29@00)))))
(assert (= ($Snap.first ($Snap.second $t@29@00)) $Snap.unit))
; [eval] result < |xs|
; [eval] |xs|
(assert (< result@14@00 (Seq_length xs@11@00)))
(assert (=
  ($Snap.second ($Snap.second $t@29@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@29@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@29@00))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second $t@29@00))) $Snap.unit))
; [eval] xs[j] <= xs[result]
; [eval] xs[j]
(push) ; 2
(assert (not (>= j@13@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [eval] xs[result]
(push) ; 2
(assert (not (>= result@14@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 result@14@00)))
(assert (= ($Snap.second ($Snap.second ($Snap.second $t@29@00))) $Snap.unit))
; [eval] (forall l: Int :: { xs[l] } i <= l && l < |xs| ==> xs[l] <= xs[result])
(declare-const l@30@00 Int)
(push) ; 2
; [eval] i <= l && l < |xs| ==> xs[l] <= xs[result]
; [eval] i <= l && l < |xs|
; [eval] i <= l
(push) ; 3
; [then-branch: 16 | i@12@00 <= l@30@00 | live]
; [else-branch: 16 | !(i@12@00 <= l@30@00) | live]
(push) ; 4
; [then-branch: 16 | i@12@00 <= l@30@00]
(assert (<= i@12@00 l@30@00))
; [eval] l < |xs|
; [eval] |xs|
(pop) ; 4
(push) ; 4
; [else-branch: 16 | !(i@12@00 <= l@30@00)]
(assert (not (<= i@12@00 l@30@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 17 | l@30@00 < |xs@11@00| && i@12@00 <= l@30@00 | live]
; [else-branch: 17 | !(l@30@00 < |xs@11@00| && i@12@00 <= l@30@00) | live]
(push) ; 4
; [then-branch: 17 | l@30@00 < |xs@11@00| && i@12@00 <= l@30@00]
(assert (and (< l@30@00 (Seq_length xs@11@00)) (<= i@12@00 l@30@00)))
; [eval] xs[l] <= xs[result]
; [eval] xs[l]
(push) ; 5
(assert (not (>= l@30@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[result]
(push) ; 5
(assert (not (>= result@14@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 17 | !(l@30@00 < |xs@11@00| && i@12@00 <= l@30@00)]
(assert (not (and (< l@30@00 (Seq_length xs@11@00)) (<= i@12@00 l@30@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((l@30@00 Int)) (!
  (implies
    (and (< l@30@00 (Seq_length xs@11@00)) (<= i@12@00 l@30@00))
    (<= (Seq_index xs@11@00 l@30@00) (Seq_index xs@11@00 result@14@00)))
  :pattern ((Seq_index xs@11@00 l@30@00))
  :qid |prog.l220|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (xs@11@00 Seq<Int>) (i@12@00 Int) (j@13@00 Int)) (!
  (=
    (method_Program_maxint__Sequence$Integer$__Integer__Integer%limited s@$ xs@11@00 i@12@00 j@13@00)
    (method_Program_maxint__Sequence$Integer$__Integer__Integer s@$ xs@11@00 i@12@00 j@13@00))
  :pattern ((method_Program_maxint__Sequence$Integer$__Integer__Integer s@$ xs@11@00 i@12@00 j@13@00))
  )))
(assert (forall ((s@$ $Snap) (xs@11@00 Seq<Int>) (i@12@00 Int) (j@13@00 Int)) (!
  (method_Program_maxint__Sequence$Integer$__Integer__Integer%stateless xs@11@00 i@12@00 j@13@00)
  :pattern ((method_Program_maxint__Sequence$Integer$__Integer__Integer%limited s@$ xs@11@00 i@12@00 j@13@00))
  )))
(assert (forall ((s@$ $Snap) (xs@11@00 Seq<Int>) (i@12@00 Int) (j@13@00 Int)) (!
  (let ((result@14@00 (method_Program_maxint__Sequence$Integer$__Integer__Integer%limited s@$ xs@11@00 i@12@00 j@13@00))) (implies
    (and
      (and (<= 0 i@12@00) (<= i@12@00 (Seq_length xs@11@00)))
      (and (<= 0 j@13@00) (< j@13@00 (Seq_length xs@11@00)))
      (forall ((l Int)) (!
        (implies
          (and (<= 0 l) (< l i@12@00))
          (<= (Seq_index xs@11@00 l) (Seq_index xs@11@00 j@13@00)))
        :pattern ((Seq_index xs@11@00 l))
        )))
    (and
      (and (<= 0 result@14@00) (< result@14@00 (Seq_length xs@11@00)))
      (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 result@14@00))
      (forall ((l Int)) (!
        (implies
          (and (<= i@12@00 l) (< l (Seq_length xs@11@00)))
          (<= (Seq_index xs@11@00 l) (Seq_index xs@11@00 result@14@00)))
        :pattern ((Seq_index xs@11@00 l))
        )))))
  :pattern ((method_Program_maxint__Sequence$Integer$__Integer__Integer%limited s@$ xs@11@00 i@12@00 j@13@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (<= 0 i@12@00))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (<= i@12@00 (Seq_length xs@11@00)))
(assert (=
  ($Snap.second ($Snap.second s@$))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second s@$)))
    ($Snap.second ($Snap.second ($Snap.second s@$))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second s@$))) $Snap.unit))
(assert (<= 0 j@13@00))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second s@$)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))))))
(assert (= ($Snap.first ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
(assert (< j@13@00 (Seq_length xs@11@00)))
(assert (= ($Snap.second ($Snap.second ($Snap.second ($Snap.second s@$)))) $Snap.unit))
(assert (forall ((l@28@00 Int)) (!
  (implies
    (and (< l@28@00 i@12@00) (<= 0 l@28@00))
    (<= (Seq_index xs@11@00 l@28@00) (Seq_index xs@11@00 j@13@00)))
  :pattern ((Seq_index xs@11@00 l@28@00))
  :qid |prog.l217|)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (i < |xs| ? (xs[j] <= xs[i] ? method_Program_maxint__Sequence$Integer$__Integer__Integer(xs, i + 1, i) : method_Program_maxint__Sequence$Integer$__Integer__Integer(xs, i + 1, j)) : j)
; [eval] i < |xs|
; [eval] |xs|
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< i@12@00 (Seq_length xs@11@00)))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(assert (not (< i@12@00 (Seq_length xs@11@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 18 | i@12@00 < |xs@11@00| | live]
; [else-branch: 18 | !(i@12@00 < |xs@11@00|) | live]
(push) ; 3
; [then-branch: 18 | i@12@00 < |xs@11@00|]
(assert (< i@12@00 (Seq_length xs@11@00)))
; [eval] (xs[j] <= xs[i] ? method_Program_maxint__Sequence$Integer$__Integer__Integer(xs, i + 1, i) : method_Program_maxint__Sequence$Integer$__Integer__Integer(xs, i + 1, j))
; [eval] xs[j] <= xs[i]
; [eval] xs[j]
(set-option :timeout 0)
(push) ; 4
(assert (not (>= j@13@00 0)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
; [eval] xs[i]
(push) ; 4
(assert (not (>= i@12@00 0)))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(push) ; 4
(set-option :timeout 10)
(push) ; 5
(assert (not (not (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00)))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
(assert (not (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00))))
(check-sat)
; unknown
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [then-branch: 19 | xs@11@00[j@13@00] <= xs@11@00[i@12@00] | live]
; [else-branch: 19 | !(xs@11@00[j@13@00] <= xs@11@00[i@12@00]) | live]
(push) ; 5
; [then-branch: 19 | xs@11@00[j@13@00] <= xs@11@00[i@12@00]]
(assert (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00)))
; [eval] method_Program_maxint__Sequence$Integer$__Integer__Integer(xs, i + 1, i)
; [eval] i + 1
(push) ; 6
; [eval] 0 <= i
(set-option :timeout 0)
(push) ; 7
(assert (not (<= 0 (+ i@12@00 1))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(assert (<= 0 (+ i@12@00 1)))
; [eval] i <= |xs|
; [eval] |xs|
(push) ; 7
(assert (not (<= (+ i@12@00 1) (Seq_length xs@11@00))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(assert (<= (+ i@12@00 1) (Seq_length xs@11@00)))
; [eval] 0 <= j
; [eval] j < |xs|
; [eval] |xs|
; [eval] (forall l: Int :: 0 <= l && l < i ==> xs[l] <= xs[j])
(declare-const l@31@00 Int)
(push) ; 7
; [eval] 0 <= l && l < i ==> xs[l] <= xs[j]
; [eval] 0 <= l && l < i
; [eval] 0 <= l
(push) ; 8
; [then-branch: 20 | 0 <= l@31@00 | live]
; [else-branch: 20 | !(0 <= l@31@00) | live]
(push) ; 9
; [then-branch: 20 | 0 <= l@31@00]
(assert (<= 0 l@31@00))
; [eval] l < i
(pop) ; 9
(push) ; 9
; [else-branch: 20 | !(0 <= l@31@00)]
(assert (not (<= 0 l@31@00)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 21 | l@31@00 < i@12@00 + 1 && 0 <= l@31@00 | live]
; [else-branch: 21 | !(l@31@00 < i@12@00 + 1 && 0 <= l@31@00) | live]
(push) ; 9
; [then-branch: 21 | l@31@00 < i@12@00 + 1 && 0 <= l@31@00]
(assert (and (< l@31@00 (+ i@12@00 1)) (<= 0 l@31@00)))
; [eval] xs[l] <= xs[j]
; [eval] xs[l]
(push) ; 10
(assert (not (>= l@31@00 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(push) ; 10
(assert (not (< l@31@00 (Seq_length xs@11@00))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 10
(assert (not (>= i@12@00 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(pop) ; 9
(push) ; 9
; [else-branch: 21 | !(l@31@00 < i@12@00 + 1 && 0 <= l@31@00)]
(assert (not (and (< l@31@00 (+ i@12@00 1)) (<= 0 l@31@00))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 7
(assert (not (forall ((l@31@00 Int)) (!
  (implies
    (and (< l@31@00 (+ i@12@00 1)) (<= 0 l@31@00))
    (<= (Seq_index xs@11@00 l@31@00) (Seq_index xs@11@00 i@12@00)))
  
  :qid |prog.l217|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(assert (forall ((l@31@00 Int)) (!
  (implies
    (and (< l@31@00 (+ i@12@00 1)) (<= 0 l@31@00))
    (<= (Seq_index xs@11@00 l@31@00) (Seq_index xs@11@00 i@12@00)))
  
  :qid |prog.l217|)))
(pop) ; 6
; Joined path conditions
(assert (and
  (<= 0 (+ i@12@00 1))
  (<= (+ i@12@00 1) (Seq_length xs@11@00))
  (forall ((l@31@00 Int)) (!
    (implies
      (and (< l@31@00 (+ i@12@00 1)) (<= 0 l@31@00))
      (<= (Seq_index xs@11@00 l@31@00) (Seq_index xs@11@00 i@12@00)))
    
    :qid |prog.l217|))))
(pop) ; 5
(push) ; 5
; [else-branch: 19 | !(xs@11@00[j@13@00] <= xs@11@00[i@12@00])]
(assert (not (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00))))
; [eval] method_Program_maxint__Sequence$Integer$__Integer__Integer(xs, i + 1, j)
; [eval] i + 1
(push) ; 6
; [eval] 0 <= i
(push) ; 7
(assert (not (<= 0 (+ i@12@00 1))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(assert (<= 0 (+ i@12@00 1)))
; [eval] i <= |xs|
; [eval] |xs|
(push) ; 7
(assert (not (<= (+ i@12@00 1) (Seq_length xs@11@00))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(assert (<= (+ i@12@00 1) (Seq_length xs@11@00)))
; [eval] 0 <= j
; [eval] j < |xs|
; [eval] |xs|
; [eval] (forall l: Int :: 0 <= l && l < i ==> xs[l] <= xs[j])
(declare-const l@32@00 Int)
(push) ; 7
; [eval] 0 <= l && l < i ==> xs[l] <= xs[j]
; [eval] 0 <= l && l < i
; [eval] 0 <= l
(push) ; 8
; [then-branch: 22 | 0 <= l@32@00 | live]
; [else-branch: 22 | !(0 <= l@32@00) | live]
(push) ; 9
; [then-branch: 22 | 0 <= l@32@00]
(assert (<= 0 l@32@00))
; [eval] l < i
(pop) ; 9
(push) ; 9
; [else-branch: 22 | !(0 <= l@32@00)]
(assert (not (<= 0 l@32@00)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 23 | l@32@00 < i@12@00 + 1 && 0 <= l@32@00 | live]
; [else-branch: 23 | !(l@32@00 < i@12@00 + 1 && 0 <= l@32@00) | live]
(push) ; 9
; [then-branch: 23 | l@32@00 < i@12@00 + 1 && 0 <= l@32@00]
(assert (and (< l@32@00 (+ i@12@00 1)) (<= 0 l@32@00)))
; [eval] xs[l] <= xs[j]
; [eval] xs[l]
(push) ; 10
(assert (not (>= l@32@00 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(push) ; 10
(assert (not (< l@32@00 (Seq_length xs@11@00))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 10
(assert (not (>= j@13@00 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(pop) ; 9
(push) ; 9
; [else-branch: 23 | !(l@32@00 < i@12@00 + 1 && 0 <= l@32@00)]
(assert (not (and (< l@32@00 (+ i@12@00 1)) (<= 0 l@32@00))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 7
(assert (not (forall ((l@32@00 Int)) (!
  (implies
    (and (< l@32@00 (+ i@12@00 1)) (<= 0 l@32@00))
    (<= (Seq_index xs@11@00 l@32@00) (Seq_index xs@11@00 j@13@00)))
  
  :qid |prog.l217|))))
(check-sat)
; unsat
(pop) ; 7
; 0.00s
; (get-info :all-statistics)
(assert (forall ((l@32@00 Int)) (!
  (implies
    (and (< l@32@00 (+ i@12@00 1)) (<= 0 l@32@00))
    (<= (Seq_index xs@11@00 l@32@00) (Seq_index xs@11@00 j@13@00)))
  
  :qid |prog.l217|)))
(pop) ; 6
; Joined path conditions
(assert (and
  (<= 0 (+ i@12@00 1))
  (<= (+ i@12@00 1) (Seq_length xs@11@00))
  (forall ((l@32@00 Int)) (!
    (implies
      (and (< l@32@00 (+ i@12@00 1)) (<= 0 l@32@00))
      (<= (Seq_index xs@11@00 l@32@00) (Seq_index xs@11@00 j@13@00)))
    
    :qid |prog.l217|))))
(pop) ; 5
(pop) ; 4
; Joined path conditions
(assert (implies
  (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00))
  (and
    (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00))
    (<= 0 (+ i@12@00 1))
    (<= (+ i@12@00 1) (Seq_length xs@11@00))
    (forall ((l@31@00 Int)) (!
      (implies
        (and (< l@31@00 (+ i@12@00 1)) (<= 0 l@31@00))
        (<= (Seq_index xs@11@00 l@31@00) (Seq_index xs@11@00 i@12@00)))
      
      :qid |prog.l217|)))))
; Joined path conditions
(assert (implies
  (not (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00)))
  (and
    (not (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00)))
    (<= 0 (+ i@12@00 1))
    (<= (+ i@12@00 1) (Seq_length xs@11@00))
    (forall ((l@32@00 Int)) (!
      (implies
        (and (< l@32@00 (+ i@12@00 1)) (<= 0 l@32@00))
        (<= (Seq_index xs@11@00 l@32@00) (Seq_index xs@11@00 j@13@00)))
      
      :qid |prog.l217|)))))
(pop) ; 3
(push) ; 3
; [else-branch: 18 | !(i@12@00 < |xs@11@00|)]
(assert (not (< i@12@00 (Seq_length xs@11@00))))
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< i@12@00 (Seq_length xs@11@00))
  (and
    (< i@12@00 (Seq_length xs@11@00))
    (implies
      (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00))
      (and
        (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00))
        (<= 0 (+ i@12@00 1))
        (<= (+ i@12@00 1) (Seq_length xs@11@00))
        (forall ((l@31@00 Int)) (!
          (implies
            (and (< l@31@00 (+ i@12@00 1)) (<= 0 l@31@00))
            (<= (Seq_index xs@11@00 l@31@00) (Seq_index xs@11@00 i@12@00)))
          
          :qid |prog.l217|))))
    (implies
      (not (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00)))
      (and
        (not (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00)))
        (<= 0 (+ i@12@00 1))
        (<= (+ i@12@00 1) (Seq_length xs@11@00))
        (forall ((l@32@00 Int)) (!
          (implies
            (and (< l@32@00 (+ i@12@00 1)) (<= 0 l@32@00))
            (<= (Seq_index xs@11@00 l@32@00) (Seq_index xs@11@00 j@13@00)))
          
          :qid |prog.l217|)))))))
; Joined path conditions
(assert (=
  result@14@00
  (ite
    (< i@12@00 (Seq_length xs@11@00))
    (ite
      (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00))
      (method_Program_maxint__Sequence$Integer$__Integer__Integer ($Snap.combine
        $Snap.unit
        ($Snap.combine
          $Snap.unit
          ($Snap.combine $Snap.unit ($Snap.combine $Snap.unit $Snap.unit)))) xs@11@00 (+
        i@12@00
        1) i@12@00)
      (method_Program_maxint__Sequence$Integer$__Integer__Integer ($Snap.combine
        $Snap.unit
        ($Snap.combine
          $Snap.unit
          ($Snap.combine $Snap.unit ($Snap.combine $Snap.unit $Snap.unit)))) xs@11@00 (+
        i@12@00
        1) j@13@00))
    j@13@00)))
; [eval] 0 <= result
(push) ; 2
(assert (not (<= 0 result@14@00)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (<= 0 result@14@00))
; [eval] result < |xs|
; [eval] |xs|
(push) ; 2
(assert (not (< result@14@00 (Seq_length xs@11@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (< result@14@00 (Seq_length xs@11@00)))
; [eval] xs[j] <= xs[result]
; [eval] xs[j]
(push) ; 2
(assert (not (>= j@13@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [eval] xs[result]
(push) ; 2
(assert (not (>= result@14@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 result@14@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 result@14@00)))
; [eval] (forall l: Int :: { xs[l] } i <= l && l < |xs| ==> xs[l] <= xs[result])
(declare-const l@33@00 Int)
(push) ; 2
; [eval] i <= l && l < |xs| ==> xs[l] <= xs[result]
; [eval] i <= l && l < |xs|
; [eval] i <= l
(push) ; 3
; [then-branch: 24 | i@12@00 <= l@33@00 | live]
; [else-branch: 24 | !(i@12@00 <= l@33@00) | live]
(push) ; 4
; [then-branch: 24 | i@12@00 <= l@33@00]
(assert (<= i@12@00 l@33@00))
; [eval] l < |xs|
; [eval] |xs|
(pop) ; 4
(push) ; 4
; [else-branch: 24 | !(i@12@00 <= l@33@00)]
(assert (not (<= i@12@00 l@33@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 25 | l@33@00 < |xs@11@00| && i@12@00 <= l@33@00 | live]
; [else-branch: 25 | !(l@33@00 < |xs@11@00| && i@12@00 <= l@33@00) | live]
(push) ; 4
; [then-branch: 25 | l@33@00 < |xs@11@00| && i@12@00 <= l@33@00]
(assert (and (< l@33@00 (Seq_length xs@11@00)) (<= i@12@00 l@33@00)))
; [eval] xs[l] <= xs[result]
; [eval] xs[l]
(push) ; 5
(assert (not (>= l@33@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[result]
(push) ; 5
(assert (not (>= result@14@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 25 | !(l@33@00 < |xs@11@00| && i@12@00 <= l@33@00)]
(assert (not (and (< l@33@00 (Seq_length xs@11@00)) (<= i@12@00 l@33@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
; Nested auxiliary terms: non-globals (tlq)
(push) ; 2
(assert (not (forall ((l@33@00 Int)) (!
  (implies
    (and (< l@33@00 (Seq_length xs@11@00)) (<= i@12@00 l@33@00))
    (<= (Seq_index xs@11@00 l@33@00) (Seq_index xs@11@00 result@14@00)))
  :pattern ((Seq_index xs@11@00 l@33@00))
  :qid |prog.l220|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (forall ((l@33@00 Int)) (!
  (implies
    (and (< l@33@00 (Seq_length xs@11@00)) (<= i@12@00 l@33@00))
    (<= (Seq_index xs@11@00 l@33@00) (Seq_index xs@11@00 result@14@00)))
  :pattern ((Seq_index xs@11@00 l@33@00))
  :qid |prog.l220|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (xs@11@00 Seq<Int>) (i@12@00 Int) (j@13@00 Int)) (!
  (implies
    (and
      (and (<= 0 i@12@00) (<= i@12@00 (Seq_length xs@11@00)))
      (and (<= 0 j@13@00) (< j@13@00 (Seq_length xs@11@00)))
      (forall ((l Int)) (!
        (implies
          (and (<= 0 l) (< l i@12@00))
          (<= (Seq_index xs@11@00 l) (Seq_index xs@11@00 j@13@00)))
        :pattern ((Seq_index xs@11@00 l))
        )))
    (=
      (method_Program_maxint__Sequence$Integer$__Integer__Integer s@$ xs@11@00 i@12@00 j@13@00)
      (ite
        (< i@12@00 (Seq_length xs@11@00))
        (ite
          (<= (Seq_index xs@11@00 j@13@00) (Seq_index xs@11@00 i@12@00))
          (method_Program_maxint__Sequence$Integer$__Integer__Integer%limited ($Snap.combine
            $Snap.unit
            ($Snap.combine
              $Snap.unit
              ($Snap.combine $Snap.unit ($Snap.combine $Snap.unit $Snap.unit)))) xs@11@00 (+
            i@12@00
            1) i@12@00)
          (method_Program_maxint__Sequence$Integer$__Integer__Integer%limited ($Snap.combine
            $Snap.unit
            ($Snap.combine
              $Snap.unit
              ($Snap.combine $Snap.unit ($Snap.combine $Snap.unit $Snap.unit)))) xs@11@00 (+
            i@12@00
            1) j@13@00))
        j@13@00)))
  :pattern ((method_Program_maxint__Sequence$Integer$__Integer__Integer s@$ xs@11@00 i@12@00 j@13@00))
  )))
; ---------- FUNCTION new_zfrac----------
(declare-fun x@15@00 () $Perm)
(declare-fun result@16@00 () zfrac)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] 0 / 1 <= x
(push) ; 2
(assert (not (not (= 1 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (<= $Perm.No x@15@00))
(assert (= ($Snap.second s@$) $Snap.unit))
; [eval] x <= 1 / 1
(push) ; 2
(assert (not (not (= 1 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (<= x@15@00 $Perm.Write))
(declare-const $t@34@00 $Snap)
(assert (= $t@34@00 $Snap.unit))
; [eval] zfrac_val(result) == x
; [eval] zfrac_val(result)
(assert (= (zfrac_val<Perm> result@16@00) x@15@00))
(pop) ; 1
(assert (forall ((s@$ $Snap) (x@15@00 $Perm)) (!
  (= (new_zfrac%limited s@$ x@15@00) (new_zfrac s@$ x@15@00))
  :pattern ((new_zfrac s@$ x@15@00))
  )))
(assert (forall ((s@$ $Snap) (x@15@00 $Perm)) (!
  (new_zfrac%stateless x@15@00)
  :pattern ((new_zfrac%limited s@$ x@15@00))
  )))
(assert (forall ((s@$ $Snap) (x@15@00 $Perm)) (!
  (let ((result@16@00 (new_zfrac%limited s@$ x@15@00))) (implies
    (and (<= $Perm.No x@15@00) (<= x@15@00 $Perm.Write))
    (= (zfrac_val<Perm> result@16@00) x@15@00)))
  :pattern ((new_zfrac%limited s@$ x@15@00))
  )))
; ---------- FUNCTION method_Program_pop__Sequence$Sequence$Integer$$__Integer----------
(declare-fun diz@17@00 () $Ref)
(declare-fun xs@18@00 () Seq<Seq<Int>>)
(declare-fun i@19@00 () Int)
(declare-fun result@20@00 () Seq<Seq<Int>>)
; ----- Well-definedness of specifications -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@17@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
; [eval] 0 <= i
(assert (<= 0 i@19@00))
(assert (= ($Snap.second ($Snap.second s@$)) $Snap.unit))
; [eval] i < |xs|
; [eval] |xs|
(assert (< i@19@00 (Seq_length xs@18@00)))
(declare-const $t@35@00 $Snap)
(assert (= $t@35@00 ($Snap.combine ($Snap.first $t@35@00) ($Snap.second $t@35@00))))
(assert (= ($Snap.first $t@35@00) $Snap.unit))
; [eval] |result| == |xs|
; [eval] |result|
; [eval] |xs|
(assert (= (Seq_length result@20@00) (Seq_length xs@18@00)))
(assert (=
  ($Snap.second $t@35@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@35@00))
    ($Snap.second ($Snap.second $t@35@00)))))
(assert (= ($Snap.first ($Snap.second $t@35@00)) $Snap.unit))
; [eval] result[i] == xs[i][1..]
; [eval] result[i]
(push) ; 2
(assert (not (>= i@19@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (< i@19@00 (Seq_length result@20@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [eval] xs[i][1..]
; [eval] xs[i]
(push) ; 2
(assert (not (>= i@19@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (Seq_equal
  (Seq_index result@20@00 i@19@00)
  (Seq_drop (Seq_index xs@18@00 i@19@00) 1)))
(assert (= ($Snap.second ($Snap.second $t@35@00)) $Snap.unit))
; [eval] (forall j: Int :: { result[j] } { xs[j] } 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j])
(declare-const j@36@00 Int)
(push) ; 2
; [eval] 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j]
; [eval] 0 <= j && (j < |xs| && j != i)
; [eval] 0 <= j
(push) ; 3
; [then-branch: 26 | 0 <= j@36@00 | live]
; [else-branch: 26 | !(0 <= j@36@00) | live]
(push) ; 4
; [then-branch: 26 | 0 <= j@36@00]
(assert (<= 0 j@36@00))
; [eval] j < |xs|
; [eval] |xs|
(push) ; 5
; [then-branch: 27 | j@36@00 < |xs@18@00| | live]
; [else-branch: 27 | !(j@36@00 < |xs@18@00|) | live]
(push) ; 6
; [then-branch: 27 | j@36@00 < |xs@18@00|]
(assert (< j@36@00 (Seq_length xs@18@00)))
; [eval] j != i
(pop) ; 6
(push) ; 6
; [else-branch: 27 | !(j@36@00 < |xs@18@00|)]
(assert (not (< j@36@00 (Seq_length xs@18@00))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 26 | !(0 <= j@36@00)]
(assert (not (<= 0 j@36@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 28 | j@36@00 != i@19@00 && j@36@00 < |xs@18@00| && 0 <= j@36@00 | live]
; [else-branch: 28 | !(j@36@00 != i@19@00 && j@36@00 < |xs@18@00| && 0 <= j@36@00) | live]
(push) ; 4
; [then-branch: 28 | j@36@00 != i@19@00 && j@36@00 < |xs@18@00| && 0 <= j@36@00]
(assert (and
  (and (not (= j@36@00 i@19@00)) (< j@36@00 (Seq_length xs@18@00)))
  (<= 0 j@36@00)))
; [eval] result[j] == xs[j]
; [eval] result[j]
(push) ; 5
(assert (not (>= j@36@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
(assert (not (< j@36@00 (Seq_length result@20@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 5
(assert (not (>= j@36@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 28 | !(j@36@00 != i@19@00 && j@36@00 < |xs@18@00| && 0 <= j@36@00)]
(assert (not
  (and
    (and (not (= j@36@00 i@19@00)) (< j@36@00 (Seq_length xs@18@00)))
    (<= 0 j@36@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and
    (and (not (= j@36@00 i@19@00)) (< j@36@00 (Seq_length xs@18@00)))
    (<= 0 j@36@00))
  (and
    (not (= j@36@00 i@19@00))
    (< j@36@00 (Seq_length xs@18@00))
    (<= 0 j@36@00))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((j@36@00 Int)) (!
  (implies
    (and
      (and (not (= j@36@00 i@19@00)) (< j@36@00 (Seq_length xs@18@00)))
      (<= 0 j@36@00))
    (and
      (not (= j@36@00 i@19@00))
      (< j@36@00 (Seq_length xs@18@00))
      (<= 0 j@36@00)))
  :pattern ((Seq_index result@20@00 j@36@00))
  :qid |prog.l240-aux|)))
(assert (forall ((j@36@00 Int)) (!
  (implies
    (and
      (and (not (= j@36@00 i@19@00)) (< j@36@00 (Seq_length xs@18@00)))
      (<= 0 j@36@00))
    (and
      (not (= j@36@00 i@19@00))
      (< j@36@00 (Seq_length xs@18@00))
      (<= 0 j@36@00)))
  :pattern ((Seq_index xs@18@00 j@36@00))
  :qid |prog.l240-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(assert (forall ((j@36@00 Int)) (!
  (implies
    (and
      (and (not (= j@36@00 i@19@00)) (< j@36@00 (Seq_length xs@18@00)))
      (<= 0 j@36@00))
    (Seq_equal (Seq_index result@20@00 j@36@00) (Seq_index xs@18@00 j@36@00)))
  :pattern ((Seq_index result@20@00 j@36@00))
  :pattern ((Seq_index xs@18@00 j@36@00))
  :qid |prog.l240|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (diz@17@00 $Ref) (xs@18@00 Seq<Seq<Int>>) (i@19@00 Int)) (!
  (Seq_equal
    (method_Program_pop__Sequence$Sequence$Integer$$__Integer%limited s@$ diz@17@00 xs@18@00 i@19@00)
    (method_Program_pop__Sequence$Sequence$Integer$$__Integer s@$ diz@17@00 xs@18@00 i@19@00))
  :pattern ((method_Program_pop__Sequence$Sequence$Integer$$__Integer s@$ diz@17@00 xs@18@00 i@19@00))
  )))
(assert (forall ((s@$ $Snap) (diz@17@00 $Ref) (xs@18@00 Seq<Seq<Int>>) (i@19@00 Int)) (!
  (method_Program_pop__Sequence$Sequence$Integer$$__Integer%stateless diz@17@00 xs@18@00 i@19@00)
  :pattern ((method_Program_pop__Sequence$Sequence$Integer$$__Integer%limited s@$ diz@17@00 xs@18@00 i@19@00))
  )))
(assert (forall ((s@$ $Snap) (diz@17@00 $Ref) (xs@18@00 Seq<Seq<Int>>) (i@19@00 Int)) (!
  (let ((result@20@00 (method_Program_pop__Sequence$Sequence$Integer$$__Integer%limited s@$ diz@17@00 xs@18@00 i@19@00))) (implies
    (and
      (not (= diz@17@00 $Ref.null))
      (and (<= 0 i@19@00) (< i@19@00 (Seq_length xs@18@00))))
    (and
      (= (Seq_length result@20@00) (Seq_length xs@18@00))
      (Seq_equal
        (Seq_index result@20@00 i@19@00)
        (Seq_drop (Seq_index xs@18@00 i@19@00) 1))
      (forall ((j Int)) (!
        (implies
          (and (<= 0 j) (and (< j (Seq_length xs@18@00)) (not (= j i@19@00))))
          (Seq_equal (Seq_index result@20@00 j) (Seq_index xs@18@00 j)))
        :pattern ((Seq_index result@20@00 j))
        :pattern ((Seq_index xs@18@00 j))
        )))))
  :pattern ((method_Program_pop__Sequence$Sequence$Integer$$__Integer%limited s@$ diz@17@00 xs@18@00 i@19@00))
  )))
; ----- Verification of function body and postcondition -----
(push) ; 1
(assert (= s@$ ($Snap.combine ($Snap.first s@$) ($Snap.second s@$))))
(assert (= ($Snap.first s@$) $Snap.unit))
(assert (not (= diz@17@00 $Ref.null)))
(assert (=
  ($Snap.second s@$)
  ($Snap.combine
    ($Snap.first ($Snap.second s@$))
    ($Snap.second ($Snap.second s@$)))))
(assert (= ($Snap.first ($Snap.second s@$)) $Snap.unit))
(assert (<= 0 i@19@00))
(assert (= ($Snap.second ($Snap.second s@$)) $Snap.unit))
(assert (< i@19@00 (Seq_length xs@18@00)))
; State saturation: after contract
(set-option :timeout 50)
(check-sat)
; unknown
; [eval] (0 < i ? Seq(xs[0]) ++ method_Program_pop__Sequence$Sequence$Integer$$__Integer(diz, xs[1..], i - 1) : Seq(xs[0][1..]) ++ xs[1..])
; [eval] 0 < i
(push) ; 2
(set-option :timeout 10)
(push) ; 3
(assert (not (not (< 0 i@19@00))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(push) ; 3
(assert (not (< 0 i@19@00)))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 29 | 0 < i@19@00 | live]
; [else-branch: 29 | !(0 < i@19@00) | live]
(push) ; 3
; [then-branch: 29 | 0 < i@19@00]
(assert (< 0 i@19@00))
; [eval] Seq(xs[0]) ++ method_Program_pop__Sequence$Sequence$Integer$$__Integer(diz, xs[1..], i - 1)
; [eval] Seq(xs[0])
; [eval] xs[0]
(set-option :timeout 0)
(push) ; 4
(assert (not (< 0 (Seq_length xs@18@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_length (Seq_singleton (Seq_index xs@18@00 0))) 1))
; [eval] method_Program_pop__Sequence$Sequence$Integer$$__Integer(diz, xs[1..], i - 1)
; [eval] xs[1..]
; [eval] i - 1
(push) ; 4
; [eval] diz != null
; [eval] 0 <= i
(push) ; 5
(assert (not (<= 0 (- i@19@00 1))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(assert (<= 0 (- i@19@00 1)))
; [eval] i < |xs|
; [eval] |xs|
(push) ; 5
(assert (not (< (- i@19@00 1) (Seq_length (Seq_drop xs@18@00 1)))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(assert (< (- i@19@00 1) (Seq_length (Seq_drop xs@18@00 1))))
(pop) ; 4
; Joined path conditions
(assert (and (<= 0 (- i@19@00 1)) (< (- i@19@00 1) (Seq_length (Seq_drop xs@18@00 1)))))
(pop) ; 3
(push) ; 3
; [else-branch: 29 | !(0 < i@19@00)]
(assert (not (< 0 i@19@00)))
; [eval] Seq(xs[0][1..]) ++ xs[1..]
; [eval] Seq(xs[0][1..])
; [eval] xs[0][1..]
; [eval] xs[0]
(push) ; 4
(assert (not (< 0 (Seq_length xs@18@00))))
(check-sat)
; unsat
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_length (Seq_singleton (Seq_drop (Seq_index xs@18@00 0) 1))) 1))
; [eval] xs[1..]
(pop) ; 3
(pop) ; 2
; Joined path conditions
(assert (implies
  (< 0 i@19@00)
  (and
    (< 0 i@19@00)
    (= (Seq_length (Seq_singleton (Seq_index xs@18@00 0))) 1)
    (<= 0 (- i@19@00 1))
    (< (- i@19@00 1) (Seq_length (Seq_drop xs@18@00 1))))))
; Joined path conditions
(assert (implies
  (not (< 0 i@19@00))
  (and
    (not (< 0 i@19@00))
    (= (Seq_length (Seq_singleton (Seq_drop (Seq_index xs@18@00 0) 1))) 1))))
(assert (Seq_equal
  result@20@00
  (ite
    (< 0 i@19@00)
    (Seq_append
      (Seq_singleton (Seq_index xs@18@00 0))
      (method_Program_pop__Sequence$Sequence$Integer$$__Integer ($Snap.combine
        $Snap.unit
        ($Snap.combine $Snap.unit $Snap.unit)) diz@17@00 (Seq_drop xs@18@00 1) (-
        i@19@00
        1)))
    (Seq_append
      (Seq_singleton (Seq_drop (Seq_index xs@18@00 0) 1))
      (Seq_drop xs@18@00 1)))))
; [eval] |result| == |xs|
; [eval] |result|
; [eval] |xs|
(push) ; 2
(assert (not (= (Seq_length result@20@00) (Seq_length xs@18@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (= (Seq_length result@20@00) (Seq_length xs@18@00)))
; [eval] result[i] == xs[i][1..]
; [eval] result[i]
(push) ; 2
(assert (not (>= i@19@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (< i@19@00 (Seq_length result@20@00))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [eval] xs[i][1..]
; [eval] xs[i]
(push) ; 2
(assert (not (>= i@19@00 0)))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not (Seq_equal
  (Seq_index result@20@00 i@19@00)
  (Seq_drop (Seq_index xs@18@00 i@19@00) 1))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (Seq_equal
  (Seq_index result@20@00 i@19@00)
  (Seq_drop (Seq_index xs@18@00 i@19@00) 1)))
; [eval] (forall j: Int :: { result[j] } { xs[j] } 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j])
(declare-const j@37@00 Int)
(push) ; 2
; [eval] 0 <= j && (j < |xs| && j != i) ==> result[j] == xs[j]
; [eval] 0 <= j && (j < |xs| && j != i)
; [eval] 0 <= j
(push) ; 3
; [then-branch: 30 | 0 <= j@37@00 | live]
; [else-branch: 30 | !(0 <= j@37@00) | live]
(push) ; 4
; [then-branch: 30 | 0 <= j@37@00]
(assert (<= 0 j@37@00))
; [eval] j < |xs|
; [eval] |xs|
(push) ; 5
; [then-branch: 31 | j@37@00 < |xs@18@00| | live]
; [else-branch: 31 | !(j@37@00 < |xs@18@00|) | live]
(push) ; 6
; [then-branch: 31 | j@37@00 < |xs@18@00|]
(assert (< j@37@00 (Seq_length xs@18@00)))
; [eval] j != i
(pop) ; 6
(push) ; 6
; [else-branch: 31 | !(j@37@00 < |xs@18@00|)]
(assert (not (< j@37@00 (Seq_length xs@18@00))))
(pop) ; 6
(pop) ; 5
; Joined path conditions
; Joined path conditions
(pop) ; 4
(push) ; 4
; [else-branch: 30 | !(0 <= j@37@00)]
(assert (not (<= 0 j@37@00)))
(pop) ; 4
(pop) ; 3
; Joined path conditions
; Joined path conditions
(push) ; 3
; [then-branch: 32 | j@37@00 != i@19@00 && j@37@00 < |xs@18@00| && 0 <= j@37@00 | live]
; [else-branch: 32 | !(j@37@00 != i@19@00 && j@37@00 < |xs@18@00| && 0 <= j@37@00) | live]
(push) ; 4
; [then-branch: 32 | j@37@00 != i@19@00 && j@37@00 < |xs@18@00| && 0 <= j@37@00]
(assert (and
  (and (not (= j@37@00 i@19@00)) (< j@37@00 (Seq_length xs@18@00)))
  (<= 0 j@37@00)))
; [eval] result[j] == xs[j]
; [eval] result[j]
(push) ; 5
(assert (not (>= j@37@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(push) ; 5
(assert (not (< j@37@00 (Seq_length result@20@00))))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
; [eval] xs[j]
(push) ; 5
(assert (not (>= j@37@00 0)))
(check-sat)
; unsat
(pop) ; 5
; 0.00s
; (get-info :all-statistics)
(pop) ; 4
(push) ; 4
; [else-branch: 32 | !(j@37@00 != i@19@00 && j@37@00 < |xs@18@00| && 0 <= j@37@00)]
(assert (not
  (and
    (and (not (= j@37@00 i@19@00)) (< j@37@00 (Seq_length xs@18@00)))
    (<= 0 j@37@00))))
(pop) ; 4
(pop) ; 3
; Joined path conditions
(assert (implies
  (and
    (and (not (= j@37@00 i@19@00)) (< j@37@00 (Seq_length xs@18@00)))
    (<= 0 j@37@00))
  (and
    (not (= j@37@00 i@19@00))
    (< j@37@00 (Seq_length xs@18@00))
    (<= 0 j@37@00))))
; Joined path conditions
(pop) ; 2
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((j@37@00 Int)) (!
  (implies
    (and
      (and (not (= j@37@00 i@19@00)) (< j@37@00 (Seq_length xs@18@00)))
      (<= 0 j@37@00))
    (and
      (not (= j@37@00 i@19@00))
      (< j@37@00 (Seq_length xs@18@00))
      (<= 0 j@37@00)))
  :pattern ((Seq_index result@20@00 j@37@00))
  :qid |prog.l240-aux|)))
(assert (forall ((j@37@00 Int)) (!
  (implies
    (and
      (and (not (= j@37@00 i@19@00)) (< j@37@00 (Seq_length xs@18@00)))
      (<= 0 j@37@00))
    (and
      (not (= j@37@00 i@19@00))
      (< j@37@00 (Seq_length xs@18@00))
      (<= 0 j@37@00)))
  :pattern ((Seq_index xs@18@00 j@37@00))
  :qid |prog.l240-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(push) ; 2
(assert (not (forall ((j@37@00 Int)) (!
  (implies
    (and
      (and (not (= j@37@00 i@19@00)) (< j@37@00 (Seq_length xs@18@00)))
      (<= 0 j@37@00))
    (Seq_equal (Seq_index result@20@00 j@37@00) (Seq_index xs@18@00 j@37@00)))
  :pattern ((Seq_index result@20@00 j@37@00))
  :pattern ((Seq_index xs@18@00 j@37@00))
  :qid |prog.l240|))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (forall ((j@37@00 Int)) (!
  (implies
    (and
      (and (not (= j@37@00 i@19@00)) (< j@37@00 (Seq_length xs@18@00)))
      (<= 0 j@37@00))
    (Seq_equal (Seq_index result@20@00 j@37@00) (Seq_index xs@18@00 j@37@00)))
  :pattern ((Seq_index result@20@00 j@37@00))
  :pattern ((Seq_index xs@18@00 j@37@00))
  :qid |prog.l240|)))
(pop) ; 1
(assert (forall ((s@$ $Snap) (diz@17@00 $Ref) (xs@18@00 Seq<Seq<Int>>) (i@19@00 Int)) (!
  (implies
    (and
      (not (= diz@17@00 $Ref.null))
      (and (<= 0 i@19@00) (< i@19@00 (Seq_length xs@18@00))))
    (Seq_equal
      (method_Program_pop__Sequence$Sequence$Integer$$__Integer s@$ diz@17@00 xs@18@00 i@19@00)
      (ite
        (< 0 i@19@00)
        (Seq_append
          (Seq_singleton (Seq_index xs@18@00 0))
          (method_Program_pop__Sequence$Sequence$Integer$$__Integer%limited ($Snap.combine
            $Snap.unit
            ($Snap.combine $Snap.unit $Snap.unit)) diz@17@00 (Seq_drop
            xs@18@00
            1) (- i@19@00 1)))
        (Seq_append
          (Seq_singleton (Seq_drop (Seq_index xs@18@00 0) 1))
          (Seq_drop xs@18@00 1)))))
  :pattern ((method_Program_pop__Sequence$Sequence$Integer$$__Integer s@$ diz@17@00 xs@18@00 i@19@00))
  )))
; ---------- hist_do_method_Future_Send__Integer__Integer ----------
(declare-const diz@38@00 $Ref)
(declare-const fr@39@00 frac)
(declare-const proc@40@00 Process)
; ---------- hist_do_method_Future_Recv__Integer__Integer ----------
(declare-const diz@41@00 $Ref)
(declare-const fr@42@00 frac)
(declare-const proc@43@00 Process)
; ---------- hist_do_method_Future_Done__Integer__Integer ----------
(declare-const diz@44@00 $Ref)
(declare-const fr@45@00 frac)
(declare-const proc@46@00 Process)
; ---------- hist_idle ----------
(declare-const diz@47@00 $Ref)
(declare-const fr@48@00 frac)
(declare-const proc@49@00 Process)
; ---------- method_Program_lock_held ----------
(declare-const diz@50@00 $Ref)
(declare-const globals@51@00 $Ref)
; ---------- method_Program_lock_invariant ----------
(declare-const diz@52@00 $Ref)
(declare-const globals@53@00 $Ref)
(push) ; 1
(declare-const $t@54@00 $Snap)
(assert (= $t@54@00 ($Snap.combine ($Snap.first $t@54@00) ($Snap.second $t@54@00))))
(assert (= ($Snap.first $t@54@00) $Snap.unit))
; [eval] diz != null
(assert (not (= diz@52@00 $Ref.null)))
(assert (=
  ($Snap.second $t@54@00)
  ($Snap.combine
    ($Snap.first ($Snap.second $t@54@00))
    ($Snap.second ($Snap.second $t@54@00)))))
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (=
  ($Snap.second ($Snap.second $t@54@00))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second $t@54@00)))
    ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second $t@54@00)))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@00))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
(push) ; 2
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))
  $Snap.unit))
; [eval] 0 < diz.field_Program_maxvalue
(assert (<
  0
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
(set-option :timeout 10)
(push) ; 2
(assert (not (not ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00))))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
(push) ; 2
(assert (not ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00)))))
(check-sat)
; unknown
(pop) ; 2
; 0.00s
; (get-info :all-statistics)
; [then-branch: 33 | First:(Second:($t@54@00)) | live]
; [else-branch: 33 | !(First:(Second:($t@54@00))) | live]
(push) ; 2
; [then-branch: 33 | First:(Second:($t@54@00))]
(assert ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))
  ($Snap.combine
    ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
    ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))))
(set-option :timeout 0)
(push) ; 3
(assert (not (not (= 2 0))))
(check-sat)
; unsat
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
(assert (=
  ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
  $Snap.unit))
; [eval] diz.field_Program_f != null
(assert (not
  (=
    ($SortWrappers.$SnapTo$Ref ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
    $Ref.null)))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))))
(set-option :timeout 10)
(push) ; 3
(assert (not (not ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00))))))
(check-sat)
; unknown
(pop) ; 3
; 0.00s
; (get-info :all-statistics)
; [then-branch: 34 | First:(Second:($t@54@00)) | live]
; [else-branch: 34 | !(First:(Second:($t@54@00))) | dead]
(push) ; 3
; [then-branch: 34 | First:(Second:($t@54@00))]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
  ($Snap.combine
    ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
    ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))))
(assert (=
  ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
    ($Snap.second ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
  $Snap.unit))
; [eval] diz.field_Program_size == |diz.field_Program_f.channel_hist_value|
; [eval] |diz.field_Program_f.channel_hist_value|
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))
  (Seq_length
    ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))))
(push) ; 4
(assert (not (not ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00))))))
(check-sat)
; unknown
(pop) ; 4
; 0.00s
; (get-info :all-statistics)
; [then-branch: 35 | First:(Second:($t@54@00)) | live]
; [else-branch: 35 | !(First:(Second:($t@54@00))) | dead]
(push) ; 4
; [then-branch: 35 | First:(Second:($t@54@00))]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
  ($Snap.combine
    ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
    ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))))))
(assert (=
  ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))))
    ($Snap.second ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))))
  $Snap.unit))
; [eval] diz.field_Program_size == |diz.field_Program_f.results_hist_value|
; [eval] |diz.field_Program_f.results_hist_value|
(assert (=
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))
  (Seq_length
    ($SortWrappers.$SnapToSeq<Int> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))))))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
  $Snap.unit))
; [eval] diz.field_Program_initialised ==> (forall i: Int, j: Int :: { diz.field_Program_f.channel_hist_value[i][j] } 0 <= i && (i < diz.field_Program_size && (0 <= j && j < |diz.field_Program_f.channel_hist_value[i]|)) ==> 0 <= diz.field_Program_f.channel_hist_value[i][j] && diz.field_Program_f.channel_hist_value[i][j] < diz.field_Program_maxvalue)
(push) ; 5
(push) ; 6
(assert (not (not ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00))))))
(check-sat)
; unknown
(pop) ; 6
; 0.00s
; (get-info :all-statistics)
; [then-branch: 36 | First:(Second:($t@54@00)) | live]
; [else-branch: 36 | !(First:(Second:($t@54@00))) | dead]
(push) ; 6
; [then-branch: 36 | First:(Second:($t@54@00))]
; [eval] (forall i: Int, j: Int :: { diz.field_Program_f.channel_hist_value[i][j] } 0 <= i && (i < diz.field_Program_size && (0 <= j && j < |diz.field_Program_f.channel_hist_value[i]|)) ==> 0 <= diz.field_Program_f.channel_hist_value[i][j] && diz.field_Program_f.channel_hist_value[i][j] < diz.field_Program_maxvalue)
(declare-const i@55@00 Int)
(declare-const j@56@00 Int)
(push) ; 7
; [eval] 0 <= i && (i < diz.field_Program_size && (0 <= j && j < |diz.field_Program_f.channel_hist_value[i]|)) ==> 0 <= diz.field_Program_f.channel_hist_value[i][j] && diz.field_Program_f.channel_hist_value[i][j] < diz.field_Program_maxvalue
; [eval] 0 <= i && (i < diz.field_Program_size && (0 <= j && j < |diz.field_Program_f.channel_hist_value[i]|))
; [eval] 0 <= i
(push) ; 8
; [then-branch: 37 | 0 <= i@55@00 | live]
; [else-branch: 37 | !(0 <= i@55@00) | live]
(push) ; 9
; [then-branch: 37 | 0 <= i@55@00]
(assert (<= 0 i@55@00))
; [eval] i < diz.field_Program_size
(push) ; 10
; [then-branch: 38 | i@55@00 < First:(Second:(Second:($t@54@00))) | live]
; [else-branch: 38 | !(i@55@00 < First:(Second:(Second:($t@54@00)))) | live]
(push) ; 11
; [then-branch: 38 | i@55@00 < First:(Second:(Second:($t@54@00)))]
(assert (<
  i@55@00
  ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))))
; [eval] 0 <= j
(push) ; 12
; [then-branch: 39 | 0 <= j@56@00 | live]
; [else-branch: 39 | !(0 <= j@56@00) | live]
(push) ; 13
; [then-branch: 39 | 0 <= j@56@00]
(assert (<= 0 j@56@00))
; [eval] j < |diz.field_Program_f.channel_hist_value[i]|
; [eval] |diz.field_Program_f.channel_hist_value[i]|
; [eval] diz.field_Program_f.channel_hist_value[i]
(set-option :timeout 0)
(push) ; 14
(assert (not (>= i@55@00 0)))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(push) ; 14
(assert (not (<
  i@55@00
  (Seq_length
    ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))))))
(check-sat)
; unsat
(pop) ; 14
; 0.00s
; (get-info :all-statistics)
(pop) ; 13
(push) ; 13
; [else-branch: 39 | !(0 <= j@56@00)]
(assert (not (<= 0 j@56@00)))
(pop) ; 13
(pop) ; 12
; Joined path conditions
; Joined path conditions
(pop) ; 11
(push) ; 11
; [else-branch: 38 | !(i@55@00 < First:(Second:(Second:($t@54@00))))]
(assert (not
  (<
    i@55@00
    ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00)))))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 37 | !(0 <= i@55@00)]
(assert (not (<= 0 i@55@00)))
(pop) ; 9
(pop) ; 8
; Joined path conditions
; Joined path conditions
(push) ; 8
; [then-branch: 40 | j@56@00 < |First:(First:(Second:(Second:(Second:(Second:(Second:(Second:($t@54@00))))))))[i@55@00]| && 0 <= j@56@00 && i@55@00 < First:(Second:(Second:($t@54@00))) && 0 <= i@55@00 | live]
; [else-branch: 40 | !(j@56@00 < |First:(First:(Second:(Second:(Second:(Second:(Second:(Second:($t@54@00))))))))[i@55@00]| && 0 <= j@56@00 && i@55@00 < First:(Second:(Second:($t@54@00))) && 0 <= i@55@00) | live]
(push) ; 9
; [then-branch: 40 | j@56@00 < |First:(First:(Second:(Second:(Second:(Second:(Second:(Second:($t@54@00))))))))[i@55@00]| && 0 <= j@56@00 && i@55@00 < First:(Second:(Second:($t@54@00))) && 0 <= i@55@00]
(assert (and
  (and
    (and
      (<
        j@56@00
        (Seq_length
          (Seq_index
            ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
            i@55@00)))
      (<= 0 j@56@00))
    (<
      i@55@00
      ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))))
  (<= 0 i@55@00)))
; [eval] 0 <= diz.field_Program_f.channel_hist_value[i][j] && diz.field_Program_f.channel_hist_value[i][j] < diz.field_Program_maxvalue
; [eval] 0 <= diz.field_Program_f.channel_hist_value[i][j]
; [eval] diz.field_Program_f.channel_hist_value[i][j]
; [eval] diz.field_Program_f.channel_hist_value[i]
(push) ; 10
(assert (not (>= i@55@00 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(push) ; 10
(assert (not (<
  i@55@00
  (Seq_length
    ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))))))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(push) ; 10
(assert (not (>= j@56@00 0)))
(check-sat)
; unsat
(pop) ; 10
; 0.00s
; (get-info :all-statistics)
(push) ; 10
; [then-branch: 41 | 0 <= First:(First:(Second:(Second:(Second:(Second:(Second:(Second:($t@54@00))))))))[i@55@00][j@56@00] | live]
; [else-branch: 41 | !(0 <= First:(First:(Second:(Second:(Second:(Second:(Second:(Second:($t@54@00))))))))[i@55@00][j@56@00]) | live]
(push) ; 11
; [then-branch: 41 | 0 <= First:(First:(Second:(Second:(Second:(Second:(Second:(Second:($t@54@00))))))))[i@55@00][j@56@00]]
(assert (<=
  0
  (Seq_index
    (Seq_index
      ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
      i@55@00)
    j@56@00)))
; [eval] diz.field_Program_f.channel_hist_value[i][j] < diz.field_Program_maxvalue
; [eval] diz.field_Program_f.channel_hist_value[i][j]
; [eval] diz.field_Program_f.channel_hist_value[i]
(push) ; 12
(assert (not (>= i@55@00 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(push) ; 12
(assert (not (<
  i@55@00
  (Seq_length
    ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))))))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(push) ; 12
(assert (not (>= j@56@00 0)))
(check-sat)
; unsat
(pop) ; 12
; 0.00s
; (get-info :all-statistics)
(pop) ; 11
(push) ; 11
; [else-branch: 41 | !(0 <= First:(First:(Second:(Second:(Second:(Second:(Second:(Second:($t@54@00))))))))[i@55@00][j@56@00])]
(assert (not
  (<=
    0
    (Seq_index
      (Seq_index
        ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
        i@55@00)
      j@56@00))))
(pop) ; 11
(pop) ; 10
; Joined path conditions
; Joined path conditions
(pop) ; 9
(push) ; 9
; [else-branch: 40 | !(j@56@00 < |First:(First:(Second:(Second:(Second:(Second:(Second:(Second:($t@54@00))))))))[i@55@00]| && 0 <= j@56@00 && i@55@00 < First:(Second:(Second:($t@54@00))) && 0 <= i@55@00)]
(assert (not
  (and
    (and
      (and
        (<
          j@56@00
          (Seq_length
            (Seq_index
              ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
              i@55@00)))
        (<= 0 j@56@00))
      (<
        i@55@00
        ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))))
    (<= 0 i@55@00))))
(pop) ; 9
(pop) ; 8
; Joined path conditions
(assert (implies
  (and
    (and
      (and
        (<
          j@56@00
          (Seq_length
            (Seq_index
              ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
              i@55@00)))
        (<= 0 j@56@00))
      (<
        i@55@00
        ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))))
    (<= 0 i@55@00))
  (and
    (<
      j@56@00
      (Seq_length
        (Seq_index
          ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
          i@55@00)))
    (<= 0 j@56@00)
    (<
      i@55@00
      ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00)))))
    (<= 0 i@55@00))))
; Joined path conditions
(pop) ; 7
; Nested auxiliary terms: globals (aux)
; Nested auxiliary terms: globals (tlq)
; Nested auxiliary terms: non-globals (aux)
(assert (forall ((i@55@00 Int) (j@56@00 Int)) (!
  (implies
    (and
      (and
        (and
          (<
            j@56@00
            (Seq_length
              (Seq_index
                ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
                i@55@00)))
          (<= 0 j@56@00))
        (<
          i@55@00
          ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))))
      (<= 0 i@55@00))
    (and
      (<
        j@56@00
        (Seq_length
          (Seq_index
            ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
            i@55@00)))
      (<= 0 j@56@00)
      (<
        i@55@00
        ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00)))))
      (<= 0 i@55@00)))
  :pattern ((Seq_index
    (Seq_index
      ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
      i@55@00)
    j@56@00))
  :qid |prog.l266-aux|)))
; Nested auxiliary terms: non-globals (tlq)
(pop) ; 6
(pop) ; 5
; Joined path conditions
(assert (implies
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00)))
  (forall ((i@55@00 Int) (j@56@00 Int)) (!
    (implies
      (and
        (and
          (and
            (<
              j@56@00
              (Seq_length
                (Seq_index
                  ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
                  i@55@00)))
            (<= 0 j@56@00))
          (<
            i@55@00
            ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))))
        (<= 0 i@55@00))
      (and
        (<
          j@56@00
          (Seq_length
            (Seq_index
              ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
              i@55@00)))
        (<= 0 j@56@00)
        (<
          i@55@00
          ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00)))))
        (<= 0 i@55@00)))
    :pattern ((Seq_index
      (Seq_index
        ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
        i@55@00)
      j@56@00))
    :qid |prog.l266-aux|))))
(assert (implies
  ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00)))
  (forall ((i@55@00 Int) (j@56@00 Int)) (!
    (implies
      (and
        (and
          (and
            (<
              j@56@00
              (Seq_length
                (Seq_index
                  ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
                  i@55@00)))
            (<= 0 j@56@00))
          (<
            i@55@00
            ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second $t@54@00))))))
        (<= 0 i@55@00))
      (and
        (<
          (Seq_index
            (Seq_index
              ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
              i@55@00)
            j@56@00)
          ($SortWrappers.$SnapToInt ($Snap.first ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))
        (<=
          0
          (Seq_index
            (Seq_index
              ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
              i@55@00)
            j@56@00))))
    :pattern ((Seq_index
      (Seq_index
        ($SortWrappers.$SnapToSeq<Seq<Int>> ($Snap.first ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))
        i@55@00)
      j@56@00))
    :qid |prog.l266|))))
(pop) ; 4
(pop) ; 3
(pop) ; 2
(push) ; 2
; [else-branch: 33 | !(First:(Second:($t@54@00)))]
(assert (not ($SortWrappers.$SnapToBool ($Snap.first ($Snap.second $t@54@00)))))
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))))
; [then-branch: 42 | First:(Second:($t@54@00)) | dead]
; [else-branch: 42 | !(First:(Second:($t@54@00))) | live]
(push) ; 3
; [else-branch: 42 | !(First:(Second:($t@54@00)))]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))
  ($Snap.combine
    ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
    ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00)))))))))))
; [then-branch: 43 | First:(Second:($t@54@00)) | dead]
; [else-branch: 43 | !(First:(Second:($t@54@00))) | live]
(push) ; 4
; [else-branch: 43 | !(First:(Second:($t@54@00)))]
(assert (=
  ($Snap.first ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
  $Snap.unit))
(assert (=
  ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second ($Snap.second $t@54@00))))))))
  $Snap.unit))
; [eval] diz.field_Program_initialised ==> (forall i: Int, j: Int :: { diz.field_Program_f.channel_hist_value[i][j] } 0 <= i && (i < diz.field_Program_size && (0 <= j && j < |diz.field_Program_f.channel_hist_value[i]|)) ==> 0 <= diz.field_Program_f.channel_hist_value[i][j] && diz.field_Program_f.channel_hist_value[i][j] < diz.field_Program_maxvalue)
(push) ; 5
; [then-branch: 44 | First:(Second:($t@54@00)) | dead]
; [else-branch: 44 | !(First:(Second:($t@54@00))) | live]
(push) ; 6
; [else-branch: 44 | !(First:(Second:($t@54@00)))]
(pop) ; 6
(pop) ; 5
; Joined path conditions
(pop) ; 4
(pop) ; 3
(pop) ; 2
(pop) ; 1
; ---------- method_Main_joinToken ----------
(declare-const diz@57@00 $Ref)
(declare-const globals@58@00 $Ref)
; ---------- method_Main_idleToken ----------
(declare-const diz@59@00 $Ref)
(declare-const globals@60@00 $Ref)
