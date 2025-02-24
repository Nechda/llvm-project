; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv6m-none-eabi | FileCheck %s --check-prefix=CHECK-T1
; RUN: llc < %s -mtriple=thumbv7m-none-eabi | FileCheck %s --check-prefix=CHECK-T2 --check-prefix=CHECK-T2NODSP
; RUN: llc < %s -mtriple=thumbv7em-none-eabi | FileCheck %s --check-prefix=CHECK-T2 --check-prefix=CHECK-T2DSP
; RUN: llc < %s -mtriple=armv8a-none-eabi | FileCheck %s --check-prefix=CHECK-ARM

declare i4 @llvm.uadd.sat.i4(i4, i4)
declare i8 @llvm.uadd.sat.i8(i8, i8)
declare i16 @llvm.uadd.sat.i16(i16, i16)
declare i32 @llvm.uadd.sat.i32(i32, i32)
declare i64 @llvm.uadd.sat.i64(i64, i64)

define i32 @func(i32 %x, i32 %y) nounwind {
; CHECK-T1-LABEL: func:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    adds r0, r0, r1
; CHECK-T1-NEXT:    blo .LBB0_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r0, #0
; CHECK-T1-NEXT:    mvns r0, r0
; CHECK-T1-NEXT:  .LBB0_2:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: func:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    adds r0, r0, r1
; CHECK-T2-NEXT:    it hs
; CHECK-T2-NEXT:    movhs.w r0, #-1
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    adds r0, r0, r1
; CHECK-ARM-NEXT:    mvnhs r0, #0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i32 @llvm.uadd.sat.i32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i64 @func2(i64 %x, i64 %y) nounwind {
; CHECK-T1-LABEL: func2:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    .save {r4, r5, r7, lr}
; CHECK-T1-NEXT:    push {r4, r5, r7, lr}
; CHECK-T1-NEXT:    movs r5, #0
; CHECK-T1-NEXT:    adds r4, r0, r2
; CHECK-T1-NEXT:    adcs r1, r3
; CHECK-T1-NEXT:    mov r0, r5
; CHECK-T1-NEXT:    adcs r0, r5
; CHECK-T1-NEXT:    mvns r2, r5
; CHECK-T1-NEXT:    cmp r0, #0
; CHECK-T1-NEXT:    mov r0, r2
; CHECK-T1-NEXT:    beq .LBB1_3
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    beq .LBB1_4
; CHECK-T1-NEXT:  .LBB1_2:
; CHECK-T1-NEXT:    mov r1, r2
; CHECK-T1-NEXT:    pop {r4, r5, r7, pc}
; CHECK-T1-NEXT:  .LBB1_3:
; CHECK-T1-NEXT:    mov r0, r4
; CHECK-T1-NEXT:    bne .LBB1_2
; CHECK-T1-NEXT:  .LBB1_4:
; CHECK-T1-NEXT:    mov r2, r1
; CHECK-T1-NEXT:    mov r1, r2
; CHECK-T1-NEXT:    pop {r4, r5, r7, pc}
;
; CHECK-T2-LABEL: func2:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    adds r0, r0, r2
; CHECK-T2-NEXT:    mov.w r12, #0
; CHECK-T2-NEXT:    adcs r1, r3
; CHECK-T2-NEXT:    adcs r2, r12, #0
; CHECK-T2-NEXT:    itt ne
; CHECK-T2-NEXT:    movne.w r0, #-1
; CHECK-T2-NEXT:    movne.w r1, #-1
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func2:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    adds r0, r0, r2
; CHECK-ARM-NEXT:    mov r12, #0
; CHECK-ARM-NEXT:    adcs r1, r1, r3
; CHECK-ARM-NEXT:    adcs r2, r12, #0
; CHECK-ARM-NEXT:    mvnne r0, #0
; CHECK-ARM-NEXT:    mvnne r1, #0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i64 @llvm.uadd.sat.i64(i64 %x, i64 %y)
  ret i64 %tmp
}

define zeroext i16 @func16(i16 zeroext %x, i16 zeroext %y) nounwind {
; CHECK-T1-LABEL: func16:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    adds r0, r0, r1
; CHECK-T1-NEXT:    ldr r1, .LCPI2_0
; CHECK-T1-NEXT:    cmp r0, r1
; CHECK-T1-NEXT:    blo .LBB2_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    mov r0, r1
; CHECK-T1-NEXT:  .LBB2_2:
; CHECK-T1-NEXT:    bx lr
; CHECK-T1-NEXT:    .p2align 2
; CHECK-T1-NEXT:  @ %bb.3:
; CHECK-T1-NEXT:  .LCPI2_0:
; CHECK-T1-NEXT:    .long 65535 @ 0xffff
;
; CHECK-T2NODSP-LABEL: func16:
; CHECK-T2NODSP:       @ %bb.0:
; CHECK-T2NODSP-NEXT:    add r1, r0
; CHECK-T2NODSP-NEXT:    movw r0, #65535
; CHECK-T2NODSP-NEXT:    cmp r1, r0
; CHECK-T2NODSP-NEXT:    it lo
; CHECK-T2NODSP-NEXT:    movlo r0, r1
; CHECK-T2NODSP-NEXT:    bx lr
;
; CHECK-T2DSP-LABEL: func16:
; CHECK-T2DSP:       @ %bb.0:
; CHECK-T2DSP-NEXT:    uqadd16 r0, r0, r1
; CHECK-T2DSP-NEXT:    uxth r0, r0
; CHECK-T2DSP-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func16:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    uqadd16 r0, r0, r1
; CHECK-ARM-NEXT:    uxth r0, r0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i16 @llvm.uadd.sat.i16(i16 %x, i16 %y)
  ret i16 %tmp
}

define zeroext i8 @func8(i8 zeroext %x, i8 zeroext %y) nounwind {
; CHECK-T1-LABEL: func8:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    adds r0, r0, r1
; CHECK-T1-NEXT:    cmp r0, #255
; CHECK-T1-NEXT:    blo .LBB3_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r0, #255
; CHECK-T1-NEXT:  .LBB3_2:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2NODSP-LABEL: func8:
; CHECK-T2NODSP:       @ %bb.0:
; CHECK-T2NODSP-NEXT:    add r0, r1
; CHECK-T2NODSP-NEXT:    cmp r0, #255
; CHECK-T2NODSP-NEXT:    it hs
; CHECK-T2NODSP-NEXT:    movhs r0, #255
; CHECK-T2NODSP-NEXT:    bx lr
;
; CHECK-T2DSP-LABEL: func8:
; CHECK-T2DSP:       @ %bb.0:
; CHECK-T2DSP-NEXT:    uqadd8 r0, r0, r1
; CHECK-T2DSP-NEXT:    uxtb r0, r0
; CHECK-T2DSP-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func8:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    uqadd8 r0, r0, r1
; CHECK-ARM-NEXT:    uxtb r0, r0
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i8 @llvm.uadd.sat.i8(i8 %x, i8 %y)
  ret i8 %tmp
}

define zeroext i4 @func3(i4 zeroext %x, i4 zeroext %y) nounwind {
; CHECK-T1-LABEL: func3:
; CHECK-T1:       @ %bb.0:
; CHECK-T1-NEXT:    adds r0, r0, r1
; CHECK-T1-NEXT:    cmp r0, #15
; CHECK-T1-NEXT:    blo .LBB4_2
; CHECK-T1-NEXT:  @ %bb.1:
; CHECK-T1-NEXT:    movs r0, #15
; CHECK-T1-NEXT:  .LBB4_2:
; CHECK-T1-NEXT:    bx lr
;
; CHECK-T2-LABEL: func3:
; CHECK-T2:       @ %bb.0:
; CHECK-T2-NEXT:    add r0, r1
; CHECK-T2-NEXT:    cmp r0, #15
; CHECK-T2-NEXT:    it hs
; CHECK-T2-NEXT:    movhs r0, #15
; CHECK-T2-NEXT:    bx lr
;
; CHECK-ARM-LABEL: func3:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    add r0, r0, r1
; CHECK-ARM-NEXT:    cmp r0, #15
; CHECK-ARM-NEXT:    movhs r0, #15
; CHECK-ARM-NEXT:    bx lr
  %tmp = call i4 @llvm.uadd.sat.i4(i4 %x, i4 %y)
  ret i4 %tmp
}
