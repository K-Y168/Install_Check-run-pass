@echo off
::UACの通知を回避するため、通常実行

::ソフトのインストール、正しいバージョンがインストールされているかの確認

if not exist "<<Program FilesまたはProgram Files (x86)内の対象ソフトの.exe>>" (goto :inst)

for /f "usebackq tokens=*" %%A in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Assemblies\<<展開先パス|バージョンの値が格納されているキー名>>" /v "<<キー内のバージョン情報までの名前>>"*"`) do set REG1=%%A

if "%REG1%" == "検索の完了: 該当 1 件" (goto :NEXT)


::インストールが必要であれば「:inst」にジャンプ

:inst

::管理者権限に昇格

whoami /priv | find "SeDebugPrivilege" > nul
if %errorlevel% neq 0 (
@powershell start-process %~0 -verb runas
exit
)

::5回インストールを繰り返し、成功で次回確認用レジストリ追加後終了

set I=0
set P=1

:loop1

MsiExec.exe /I "<<任意のパス\ソフト名>>" /quiet /norestart

::インストールに５回失敗したらエラーメッセージを出力して終了

if %I% == 5 (call "<<任意のパス>>\Error_messege-I.vbs")
if %I% == 5 (goto :EXIT)
set /a I=%I%+%P%

::インストールされているかを.exe有無で確認、されていなければ「loop1」へジャンプ
if exist "<<Program FilesまたはProgram Files (x86)内の対象ソフトの.exe>>" (set I=6)

if %I% leq 5 (goto :loop1)
if %I% geq 6 (set I=)

set P=
set REG=

::※※レジストリーの値を追加
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\<<ソフト名など_Name1>>" /v <<ソフト名など_Name2>> /t REG_SZ /d <<任意の文字列A>> /f

:NEXT

::※※で追加したレジストリーの値を照合
for /f "usebackq tokens=*" %%A in (`reg query "HKEY_LOCAL_MACHINE\SOFTWARE\<<ソフト名など_Name1>>" /v <<ソフト名など_Name2>>`) do set REG2=%%A

if "%REG2%" == "<<ソフト名など_Name2>>    REG_SZ    <<任意の文字列A>>" (goto :EXIT) else (goto :inst)

:EXIT

