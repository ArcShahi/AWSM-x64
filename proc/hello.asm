; ... And the journey starts
default rel

extern printf
global main

segment .rdata
  msg db 0xA,"Hello ASM x86-64 ;)",0xA,0XA,0 ; 0XA = \n; 0 = NULL

segment .text

main:
  sub rsp,0x28

  lea rcx,[msg]
  call printf

  xor eax,eax
  add rsp,0x28
  ret 
