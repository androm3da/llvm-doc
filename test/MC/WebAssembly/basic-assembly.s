# RUN: llvm-mc -triple=wasm32-unknown-unknown < %s | FileCheck %s

    .text
    .type    test0,@function
test0:
    # Test all types:
    .param      i32, i64
    .local      f32, f64  #, i8x16, i16x8, i32x4, f32x4
    # Explicit getlocal/setlocal:
    get_local   2
    set_local   2
    # Immediates:
    i32.const   -1
    f64.const   0x1.999999999999ap1
    # Indirect addressing:
    get_local   0
    f64.store   0
    # Loops, conditionals, binary ops, calls etc:
    block
    i32.const   1
    get_local   0
    i32.ge_s
    br_if       0        # 0: down to label0
.LBB0_1:
    loop             # label1:
    call        something1@FUNCTION
    i64.const   1234
    i32.call    something2@FUNCTION
    i32.const   0
    call_indirect
    i32.const   1
    i32.add
    tee_local   0
    get_local   0
    i32.lt_s
    br_if       0        # 0: up to label1
.LBB0_2:
    end_loop
    end_block                       # label0:
    end_function


# CHECK:           .text
# CHECK-LABEL: test0:
# CHECK-NEXT:      .param      i32, i64
# CHECK-NEXT:      .local      f32, f64
# CHECK-NEXT:      get_local   2
# CHECK-NEXT:      set_local   2
# CHECK-NEXT:      i32.const   -1
# CHECK-NEXT:      f64.const   0x1.999999999999ap1
# CHECK-NEXT:      get_local   0
# CHECK-NEXT:      f64.store   0:p2align=0
# CHECK-NEXT:      block
# CHECK-NEXT:      i32.const   1
# CHECK-NEXT:      get_local   0
# CHECK-NEXT:      i32.ge_s
# CHECK-NEXT:      br_if 0            # 0: down to label0
# CHECK-NEXT:  .LBB0_1:
# CHECK-NEXT:      loop                    # label1:
# CHECK-NEXT:      call        something1@FUNCTION
# CHECK-NEXT:      i64.const   1234
# CHECK-NEXT:      i32.call    something2@FUNCTION
# CHECK-NEXT:      i32.const   0
# CHECK-NEXT:      call_indirect
# CHECK-NEXT:      i32.const   1
# CHECK-NEXT:      i32.add
# CHECK-NEXT:      tee_local   0
# CHECK-NEXT:      get_local   0
# CHECK-NEXT:      i32.lt_s
# CHECK-NEXT:      br_if 0            # 0: up to label1
# CHECK-NEXT:  .LBB0_2:
# CHECK-NEXT:      end_loop
# CHECK-NEXT:      end_block                       # label0:
# CHECK-NEXT:      end_function
