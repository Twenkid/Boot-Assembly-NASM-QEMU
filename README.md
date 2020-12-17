# Boot-Sector-Assembly-NASM-QEMU

## 0. BAT
## 1. NASM_Mingw_ld_linker_asm_22-4-2016.txt
## 2. VirtualBox_NASM_cmd_16-5-2016.txt

## 0. BAT

0.1. Call __nasmpath.bat__, temporary set PATH environment variable:

```
nasmpath.bat
@set path=B:\NASM;%path%
@%comspec%
```

0.2. Call __link.bat__

Call the assembler with the source - produces .obj file.

```
nasm -fwin32 a1.asm
```

0.3. Call __link.bat__

Then link with the __Linker__ command.
Set the appropriate paths to the VS linker (or another one) and to the SDK header files.

link.bat <br>
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" a1.obj /subsystem:windows /entry:WinMain /libpath:"S:\Program Files\Microsoft SDKs\Windows\v7.0\Lib\"  kernel32.lib user32.lib  /largeaddressaware: no



### 1.  \NASM\NASM_Mingw_ld_linker_asm_22-4-2016.txt

NASM, Mingw, ld, Linker, Assembler ... x86, x64 ... 

22-4-2016

Инсталирай NASM

Инсталирай B:\bin\libiconv-1.9.2-1-bin

Копирай .dll файла  libiconv-2.dll ... в папката на NASM

mingw - компилатор, асемблер, съединител, ... linker - ld

В папката bin на инсталацията на mingw.

Преименувай файла libiconv2.dll в libiconv-2.dll 

//Защото при пускане на ld, ld дава съобщение за грешка, че този файл липсва. Имена сходни, разлика във версии, ... . Библиотека за преобразуване Уникод и т.н.


LINKER

Уиндоуски, Visual Studio ...

Файл с код, асемблер, x86, за NASM:

B:\nasm\a1.asm

```
global _WinMain@16
extern _MessageBoxA@16
extern _ExitProcess@4

section code use32 class=code
;_main:
_WinMain@16:
	push	dword 0      ; UINT uType = MB_OK
	push	dword title  ; LPCSTR lpCaption
	push	dword banner ; LPCSTR lpText
	push	dword 0      ; HWND hWnd = NULL
	call	_MessageBoxA@16

	push	dword 0      ; UINT uExitCode
	call	_ExitProcess@4

section data use32 class=data
	banner:	db 'Hello, world!', 0
	title:	db 'Hello', 0
	
section .drectve info
db "/defaultlib:user32.lib /defaultlib:kernel32.lib /defaultlib:msvcrt.lib"

; nasm -f win32
```

nasm -fwin32 a1.asm 

---> a1.obj

cd ... - в папката, където са библиотеките на Уиндоус, иначе не работи

c:\Program Files\Microsoft Visual Studio 10.0\VC\lib>


c:\Program Files\Microsoft Visual Studio 10.0\VC\lib>

```
"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" b:\nasm\a1.obj /OUT:b:/nasm/a1x.exe /subsystem:windows /libpath:"S:\Program Files\Microsoft SDKs\Windows\v7.0\Lib\"  /entry:WinMainCRTStartup 

c:\Program Files\Microsoft Visual Studio 10.0\VC\lib>"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" b:\nasm\a1.obj /OUT:b:/nasm/a1.exe /subsystem:windows /libpath:"S:\Program Files\Microsoft SDKs\Windows\v7.0\Lib\"  /entry: WinMainCRTStartup
```

Microsoft (R) Incremental Linker Version 10.00.30319.01
Copyright (C) Microsoft Corporation.  All rights reserved.


```
c:\Program Files\Microsoft Visual Studio 10.0\VC\lib>b:\nasm\a1x.exe
```

Важно: иска WinMainCRTStartup

Въпреки че е зададено друго. Искаше и msvcrt. Защото няма цикъл за обработка на съобщения? Едва ли.

Съобщения за обходените библиотеки: /VERBOSE:LIB
```
c:\Program Files\Microsoft Visual Studio 10.0\VC\lib>"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" b:\nasm\a1.obj /OUT:b:/nasm/a1x.exe /VERBOSE:LIB  /subsystem:windows /libpath:"S:\Program Files\Microsoft SDKs\Windows\v7.0\Lib\"  /entry:WinMainCRTStartup

/VERBOSE: LIB ...
```
Но взе да показва "Access Denied" и не ще да свърже наново?!


Пътят грешно написан, с обратни черти?? Трябва b:\nasm\a1x.exe ... !!! (а не b:/nasm/...)
```
c:\Program Files\Microsoft Visual Studio 10.0\VC\lib>"C:\Program Files\Microsoft
 Visual Studio 10.0\VC\bin\link.exe" b:\nasm\a1.obj /OUT:"b:\nasm\a1x.exe" /subs
ystem:windows /libpath:"S:\Program Files\Microsoft SDKs\Windows\v7.0\Lib\"  /ent
ry:WinMainCRTStartup  /VERBOSE:
Microsoft (R) Incremental Linker Version 10.00.30319.01
Copyright (C) Microsoft Corporation.  All rights reserved.

c:\Program Files\Microsoft Visual Studio 10.0\VC\lib>"C:\Program Files\Microsoft
 Visual Studio 10.0\VC\bin\link.exe" b:\nasm\a1.obj /OUT:"b:\nasm\a1x.exe" /VERB
OSE:LIB /subsystem:windows /libpath:"S:\Program Files\Microsoft SDKs\Windows\v7.
0\Lib\"  /entry:WinMainCRTStartup
Microsoft (R) Incremental Linker Version 10.00.30319.01
Copyright (C) Microsoft Corporation.  All rights reserved.


Searching libraries
    Searching C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib\user32.lib:
    Searching C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib\kernel32.lib:
    Searching msvcrt.lib:
    Searching C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib\user32.lib:
    Searching C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib\kernel32.lib:

Finished searching libraries

Searching libraries
    Searching C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib\user32.lib:
    Searching C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib\kernel32.lib:
    Searching msvcrt.lib:
    Searching C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib\user32.lib:
    Searching C:\Program Files\Microsoft SDKs\Windows\v7.0A\lib\kernel32.lib:

Finished searching libraries
```

7.0A ?!!! Ansi?

```
c:\Program Files\Microsoft Visual Studio 10.0\VC\lib>"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" b:\nasm\a1.obj /OUT:b:\nasm\a1x.exe /VERBOSE:LIB  /subsystem:windows /libpath:"S:\Program Files\Microsoft SDKs\Windows\v7.0A\Lib\"  /entry:WinMainCRTStartup


"C:\Program Files\Microsoft Visual Studio 10.0\VC\bin\link.exe" b:\nasm\a1.obj /OUT:b:\nasm\a1x.exe /VERBOSE:LIB  /subsystem:windows /libpath:"S:\Program Files\Microsoft SDKs\Windows\v7.0A\Lib\"  /entry:WinMainCRTStartup
```


# 2. \NASM\VirtualBox_NASM_cmd_16-5-2016.txt
```
Operating System ... Boot sector ... VirtualBox Boot sequence and operation ... Init ... 
//16-5-2016

! install VirtualBox

path to VirtualBox = R:\VirtualBox\

! install NASM
path to NASM = B:\NASM\

! asm file = boot2.asm
! bin format = "no offset, raw ..."

//B:\NASM> nasm boot2.asm -o boot2.bin

path to input = "boot2.asm" or "B:\NASM\boot2.asm"
path to output = "boot2.bin" //"local directory"

call nasm: nasm boot2.asm -o boot2.bin

nasm boot2.asm -o boot2.bin

! create VirtualBox virtual machine ... (example: 4 MB RAM, ... IDE ... - empty, ...)

machine = "boot2"

cd "path to VBoxManage" or call with the path ...


R:\VirtualBox>VBoxManage storageattach  boot2 --storagectl IDE --port 1 --device 1 --medium none
 
! delete attached devices:

VBoxManage storageattach  boot2 --storagectl IDE --port 1 --device 1 --medium none

! convert bin to virtual disk:

R:\VirtualBox>VBoxManage.exe convertfromraw  B:\nasm\boot2.bin  b:\nasm\boot2f.dsk --format VMDK

VBoxManage.exe convertfromraw  B:\nasm\boot2.bin  b:\nasm\boot2f.dsk --format VMDK

//Converting from raw image file="B:\nasm\boot2.bin" to file="b:\nasm\boot2f.dsk".
//..
//Creating dynamic image with size 512 bytes (1MB)...

! Attach to the machine

R:\VirtualBox>VBoxManage storageattach  boot2 --storagectl IDE --port 1 --device 1 --type hdd --medium B:\nasm\boot4f.dsk

VBoxManage storageattach  boot2 --storagectl IDE --port 1 --device 1 --type hdd --medium B:\nasm\boot2f.dsk

! Start instance of the machine with gui

R:\VirtualBox>VBoxManage  startvm  boot2 --type gui

VBoxManage  startvm  boot2 --type gui

//Waiting for VM "boot2" to power on...
//VM "boot2" has been successfully started.

! Turn off the machine:

VBoxManage controlvm boot2 poweroff

R:\VirtualBox>VBoxManage  controlvm boot2 poweroff

"0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%"

! Debug - read the registers:

VBoxManage   debugvm boot2 getregisters all human-readable > regs2.txt

R:\VirtualBox> VBoxManage  debugvm boot2 getregisters all human-readable > regs2.txt


```
