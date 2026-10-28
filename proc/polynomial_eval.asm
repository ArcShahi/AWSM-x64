; Program to evaluate Polynomials  using Horner's formula 
; Todo : Remove heap allocation and deal on stack
default rel

extern _CRT_INIT, printf,scanf,malloc
global main

segment .data
  msg0 db "Terms: ",0 
  msg1 db "Coefficients (In Standard form) : ",0 
  msg2 db "x: ",0 
  fmt  db "%d",0 
  fmt2 db "%f",0 
  ans  db " y= f(%g) = %g",0xA,0XA,0 

segment .text 

; rcx=&arr,rdx=N,xmm2=x  ->xmm0 
horner_eval:
  
  vmovd xmm0,[rcx] ; xmm0 = arr[0]=Highest Degree coeff 
  mov eax, 1 
; Iterating from back 
 .loop:
  cmp eax,edx 
  jge .done 
  vfmadd213ss xmm0,xmm2,[rcx+rax*4] 
  inc eax 
  jmp .loop 

 .done:
  ret 
   
main:
  push rdi
  push rsi 
  sub rsp,0x38               ; rule of tumb : must be odd multiple of 8 
  call _CRT_INIT

  lea rcx,[msg0]
  call printf 
  
  lea rcx,[fmt]
  lea rdx,[rsp+0x20] 
  call scanf

  ; Allocate buffer 
  mov rcx,[rsp+0x20]
  shl rcx,0x02              ; terms * sizeof(int) 
  call malloc               ; Assuming malloc succedded 

  mov qword[rsp+0x2C],rax   ; buffer* at rsp+44 
  
  lea rcx,[msg1]
  call printf 

  xor esi,esi 
  mov rdi,qword[rsp+0x2C]

.fetch_input:
  cmp esi,[rsp+0x20]
  jge .done

  lea rcx,[fmt2]
  lea rdx,[rdi+rsi*4]
  call scanf 

  inc esi 
  jmp .fetch_input

.done:
  
  lea rcx,[msg2]
  call printf 

  lea rcx,[fmt2]
  lea rdx,[rsp+0x24]        ; x 
  call scanf

  mov rcx,[rsp+0x2C]        ; passing pointer to heap allocated buffer
  mov rdx,[rsp+0x20]        ; size N
  vmovd xmm2,[rsp+0x24]     ; x at 
  call horner_eval
  
  lea rcx,[ans]
  vxorps xmm1,xmm1,xmm1 
  vcvtss2sd xmm1,xmm1,[rsp+0x24]
  vmovq rdx,xmm1 

  vcvtss2sd xmm2,xmm0,xmm0  ; printf needs double so we've to convert it 
  vmovq r8,xmm2             ; and mirror it into int reg. Welcome to C -_- 
  call printf              

  add rsp,0x38
  pop rsi 
  pop rdi 

  xor eax,eax 
  ret 
