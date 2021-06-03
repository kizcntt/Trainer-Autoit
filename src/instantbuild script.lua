[ENABLE]

aobscanmodule(12,game.exe,39 41 24 75 03 B0 01 C3 83) // should be unique
alloc(newmem,$1000)

label(code)
label(return)

newmem:
push ebx
mov ebx,[ecx+68]
cmp [ebx+30],0
pop ebx
jne code
cmp [ecx+24],(int)51
jg code
mov [ecx+24],(int)52
  jne game.exe+B9434
  jmp return

code:
  cmp [ecx+24],eax
  jne game.exe+B9434
  jmp return

12:
  jmp newmem
return:
registersymbol(12)

[DISABLE]

12:
  db 39 41 24 75 03

unregistersymbol(12)
dealloc(newmem)

{
// ORIGINAL CODE - INJECTION POINT: "game.exe"+B942C

"game.exe"+B941A: 90                 -  nop 
"game.exe"+B941B: 90                 -  nop 
"game.exe"+B941C: 90                 -  nop 
"game.exe"+B941D: 90                 -  nop 
"game.exe"+B941E: 90                 -  nop 
"game.exe"+B941F: 90                 -  nop 
"game.exe"+B9420: 8B 51 54           -  mov edx,[ecx+54]
"game.exe"+B9423: B8 36 00 00 00     -  mov eax,00000036
"game.exe"+B9428: 85 D2              -  test edx,edx
"game.exe"+B942A: 74 08              -  je game.exe+B9434
// ---------- INJECTING HERE ----------
"game.exe"+B942C: 39 41 24           -  cmp [ecx+24],eax
"game.exe"+B942F: 75 03              -  jne game.exe+B9434
// ---------- DONE INJECTING  ----------
"game.exe"+B9431: B0 01              -  mov al,01
"game.exe"+B9433: C3                 -  ret 
"game.exe"+B9434: 83 79 64 FF        -  cmp dword ptr [ecx+64],-01
"game.exe"+B9438: 74 08              -  je game.exe+B9442
"game.exe"+B943A: 39 41 24           -  cmp [ecx+24],eax
"game.exe"+B943D: 75 03              -  jne game.exe+B9442
"game.exe"+B943F: B0 01              -  mov al,01
"game.exe"+B9441: C3                 -  ret 
"game.exe"+B9442: 32 C0              -  xor al,al
"game.exe"+B9444: C3                 -  ret 
}
