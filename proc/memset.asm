; memset implementation 
bits 64
default rel

extern _CRT_INIT
extern printf
global main

segment .data
  val dd 69420 

segment .rdata
  ans db "Before : %d , After : %d",0xA,0

segment .text
  
;memoryset(rcx=*dest,edx=value,r8=count)
memoryset:
  
  test r8,r8
  jz .done
  
 .loop:
    dec r8
    mov byte[rcx+r8],dl ; copy byte by byte 
    test r8,r8 
    jns .loop

 .done:
   ret

main:
  push rbp
  sub rsp,0x20
  
  mov ebp,[val]

  lea rcx,[val]
  xor edx,edx  
  mov r8 ,0x04
  call memoryset 

  lea rcx,[ans]
  mov edx,ebp 
  mov r8d,[val]
  call printf 

  xor eax,eax
  add rsp,0x20 
  pop rbp
  ret
