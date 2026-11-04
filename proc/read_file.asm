default rel

extern printf
extern fopen,fseek,ftell,fread,fclose 
extern malloc,free

global main 

segment .rdata
  fmt_s db "%s",0xA,0 
  file_mode db "rb",0 

segment .text

; (rcx=const char* filename)
read_file:
  push rsi
  push rdi
  push rbp
  sub rsp,0x20
 
 ;fopen : takes file name and mode returns *FILE
  lea rdx,[file_mode]
  call fopen
  test rax,rax
  jz .done
  mov rbp,rax  ; rbp= &file 

; fseek(&stream,offset,origin)
  mov rcx,rbp
  xor edx,edx
  mov r8d,2          ; SEEK_END
  call fseek

 ; ftell(&steam)
  mov rcx,rbp
  call ftell
  movsxd rsi,eax     ; rsi=size

  mov rcx,rbp
  xor edx,edx
  mov r8d,0x00       ; SEEK_SET
  call fseek         

  lea rcx,[rsi+0x01]
  call malloc
  test rax,rax
  jz .done 
  mov rdi,rax        ; rdi= &buffer 

;fread(&buffer,size,count,&stream)
  mov rcx,rdi
  mov edx,0x01
  mov r8,rsi
  mov r9,rbp
  call fread

  mov byte [rdi+rax],0x00

  mov rcx,rbp
  call fclose

  lea rcx,[fmt_s]
  mov rdx,rdi
  call printf

  mov rcx,rdi
  call free

.done:
  add rsp,0x20
  pop rbp
  pop rdi
  pop rsi
  ret

main:
  ; We're not calling any ABI compliant function so no need for Shadow space here
  ; Just align the stack to 16B Boundary 
  push rbp 
  mov rcx,[rdx+0x08] ; argv is pointer to pointer so 8B jump
  call read_file

  xor eax,eax 
  pop rbp
  ret 
  
