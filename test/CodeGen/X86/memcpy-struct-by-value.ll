; RUN: llc -mtriple=x86_64-linux-gnu -mattr=-fast-string < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=NOFAST
; RUN: llc -mtriple=x86_64-linux-gnu -mattr=+fast-string < %s -o - | FileCheck %s --check-prefix=ALL --check-prefix=FAST

%struct.large = type { [4096 x i8] }

declare void @foo(%struct.large* align 8 byval) nounwind

define void @test1(%struct.large* nocapture %x) nounwind {
  call void @foo(%struct.large* align 8 byval %x)
  ret void

; ALL-LABEL: test1:
; NOFAST: rep;movsq
; FAST: rep;movsb
}
