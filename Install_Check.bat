@echo off
::UAC�̒ʒm��������邽�߁A�ʏ���s

::�\�t�g�̃C���X�g�[���A�������o�[�W�������C���X�g�[������Ă��邩�̊m�F

if not exist "<<Program Files�܂���Program Files (x86)���̑Ώۃ\�t�g��.exe>>" (goto :inst)

for /f "usebackq tokens=*" %%A in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\<<�W�J��p�X|�o�[�W�����̒l���i�[����Ă���L�[��>>" /v "<<�L�[���̃o�[�W�������܂ł̖��O>>"*"`) do set REG1=%%A

if "%REG1%" == "�����̊���: �Y�� 1 ��" (goto :NEXT)


::�C���X�g�[�����K�v�ł���΁u:inst�v�ɃW�����v

:inst

::�Ǘ��Ҍ����ɏ��i

whoami /priv | find "SeDebugPrivilege" > nul
if %errorlevel% neq 0 (
@powershell start-process %~0 -verb runas
exit
)

::5��C���X�g�[�����J��Ԃ��A�����Ŏ���m�F�p���W�X�g���ǉ���I��

set I=0
set P=1

:loop1

MsiExec.exe /I "<<�C�ӂ̃p�X\�\�t�g��>>" /quiet /norestart

::�C���X�g�[���ɂT�񎸔s������G���[���b�Z�[�W���o�͂��ďI��

if %I% == 5 (call "<<�C�ӂ̃p�X>>\Error_messege-I.vbs")
if %I% == 5 (goto :EXIT)
set /a I=%I%+%P%

::�C���X�g�[������Ă��邩��.exe�L���Ŋm�F�A����Ă��Ȃ���΁uloop1�v�փW�����v
if exist "<<Program Files�܂���Program Files (x86)���̑Ώۃ\�t�g��.exe>>" (set I=6)

if %I% leq 5 (goto :loop1)
if %I% geq 6 (set I=)

set P=
set REG=

::�������W�X�g���[�̒l��ǉ�
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\<<�\�t�g���Ȃ�_Name1>>" /v <<�\�t�g���Ȃ�_Name2>> /t REG_SZ /d <<�C�ӂ̕�����A>> /f

:NEXT

::�����Œǉ��������W�X�g���[�̒l���ƍ�
for /f "usebackq tokens=*" %%A in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\<<�\�t�g���Ȃ�_Name1>>" /v <<�\�t�g���Ȃ�_Name2>>`) do set REG2=%%A

if "%REG2%" == "<<�\�t�g���Ȃ�_Name2>>    REG_SZ    <<�C�ӂ̕�����A>>" (goto :EXIT) else (goto :inst)

:EXIT

