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
  
  xor eax,eax 
 .loop:
  cmp rax,r8 
  jge .done 
  mov [rcx+rax],dl ; copy byte by byte
  inc rax 
  jmp .loop 

 .done:
   ret

main:
  
  sub rsp,0x20
  
  call _CRT_INIT
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
  ret
