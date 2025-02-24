; RUN: opt -aa-pipeline=basic-aa -passes=aa-eval -print-all-alias-modref-info -disable-output < %s 2>&1 | FileCheck %s

; Check that BasicAA falls back to MayAlias (instead of PartialAlias) when none
; of its little tricks are applicable.

; CHECK: NoAlias: float* %arrayidxA, float* %arrayidxB

define void @fallback_mayalias(ptr noalias nocapture %C, i64 %i, i64 %j) local_unnamed_addr {
entry:
  %cmp = icmp ne i64 %i, %j
  call void @llvm.assume(i1 %cmp)

  %arrayidxA = getelementptr inbounds float, ptr %C, i64 %i
  store float undef, ptr %arrayidxA, align 4

  %arrayidxB = getelementptr inbounds float, ptr %C, i64 %j
  store float undef, ptr %arrayidxB, align 4

  ret void
}

declare void @llvm.assume(i1)
