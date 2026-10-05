default rel


extern _CRT_INIT,__acrt_iob_func,printf,fgets,malloc
global main


segment .data
  prompt db "Gimme str: ",0xA,0
  omsg db "COPIED !!",0xA,"SRC @: %p ",0xA,"DEST @: %p ",0xA,"Data >",0xA,"%s"

segment .text 


; strcpy(dest*,src*)
strcpy:

  .LOOP:
    mov r9b,[rdx]
    mov [rcx],r9b
    inc rcx
    inc rdx 
    test r9b,r9b 
    jnz .LOOP

    ret 
   
main:
  sub rsp,0x28  ; Allocate stack space : 40B : Shadow 32 + local bufferAddress 8B , returnAdd was pushed : 48%16==0 Stack aligned 
  call _CRT_INIT

  lea rcx,[prompt]
  call printf

  ; Heap allocating buffer 

  mov rcx,0xC8       ; 200 B for both buffers : Buff1 0-99 and Buff2 : 100-199 
  call malloc
  mov qword[rsp+0x20],rax ; rsp@48 = *buff

; get STDIN
  mov ecx,0 ; for STDIN 
  call __acrt_iob_func ; it returns the address of fucking STDIN 
 
  ; call fgets(buff,size,*FILE)
  mov rcx,[rsp+0x20]   ; buff 
  mov rdx,0x64         ; 100 B for src input 
  mov r8,rax           ; r8=*STDIN 
  call fgets

  mov rcx,[rsp+0x20] 
  lea rcx,[rcx+0x64]   ; Destination is after 100 B 
  mov rdx,[rsp+0x20]   ; src 
  mov r8, 0x64         ; size 
  call strcpy 

  mov rax,[rsp+0x20]   ; rax = addr(buff) 
  lea rcx,[omsg]
  mov rdx,rax          ; rdx = addr(buff)
  lea r8,[rax+0x64]    ; r8= dest addr 
  mov r9,r8            ; data 
  call printf 


  ; free not necessary
  add rsp,0x28
  xor eax,eax
  ret
