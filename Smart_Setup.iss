; Script criado pela Tiziiu para o H. Olhos Bahia.
; Autor: Maurício Sampaio
; Em caso de dúvida favor entrar em contato: contato@tiziiu.com

#define MyAppName "Smart"
#define MyAppVersion "1.0"
#define MyAppPublisher "Tiziiu"
#define MyAppURL "http://tiziiu.com"
#define MyAppExeName "Aplic125\SMART125.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={8FAAE71F-D195-415A-9E96-B2970A687EE6}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:/Smart
DisableDirPage=yes
DefaultGroupName=Smart
AllowNoIcons=yes
; The [Icons] "quicklaunchicon" entry uses {userappdata} but its [Tasks] entry has a proper IsAdminInstallMode Check.
UsedUserAreasWarning=no
; Uncomment the following line to run in non administrative install mode (install for current user only.)
PrivilegesRequired=admin
OutputDir=C:\Users\mauricios\OneDrive - Opty\Smart_Setup
OutputBaseFilename=Setup_Smart_5.0
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ChangesEnvironment=yes

[Languages]
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "Adicionar atalho na Área de Trabalho"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode
Name: modifypath; Description: "Adicionar o diretório da aplicação nas variáveis de ambiente"

[Files]
Source: "{code:GetSmartIniPath}"; DestDir: "{app}"; Flags: external
Source: "C:\Users\mauricios\OneDrive - Opty\Smart_Setup\Imagem\foxfont.ttf"; DestDir: "{fonts}"; FontInstall: "FoxFont"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "C:\Users\mauricios\OneDrive - Opty\Smart_Setup\Imagem\*"; DestDir: "{app}\Imagem"; Flags: ignoreversion
Source: "\\S70-FS-001\Smart\03 - Smart Estrutura Padrao\Smart125\*"; DestDir: "{app}"; Components: principal\ssa; Flags: ignoreversion recursesubdirs createallsubdirs external
Source: "\\s72-fs-001\smart\03 - Smart Estrutura padrao\Smart125\*"; DestDir: "{app}"; Components: principal\itb; Flags: ignoreversion recursesubdirs createallsubdirs external
Source: "\\s73-ad-001\smart\03 - Smart Estrutura Padrao\Smart125\*"; DestDir: "{app}"; Components: principal\enp; Flags: ignoreversion recursesubdirs createallsubdirs external
Source: "\\S70-FS-001\Smart\03 - Smart Estrutura Padrao\Smart60\*"; DestDir: "{app}"; Components: modulos\ssa; Flags: ignoreversion recursesubdirs createallsubdirs external
Source: "\\s72-fs-001\Smart\03 - Smart Estrutura Padrao\Smart60\*"; DestDir: "{app}"; Components: modulos\itb; Flags: ignoreversion recursesubdirs createallsubdirs external
Source: "\\s73-ad-001\Smart\03 - Smart Estrutura Padrao\Smart60\*"; DestDir: "{app}"; Components: modulos\enp; Flags: ignoreversion recursesubdirs createallsubdirs external
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Code]
const
	ModPathName = 'modifypath';
	ModPathType = 'system';

function ModPathDir(): TArrayOfString;
begin
	setArrayLength(Result, 2)
	Result[0] := ExpandConstant('{app}\Pb6dk');
	Result[1] := ExpandConstant('{app}\Pb12dk');
end;
#include "modpath.iss"

var
  SmartIniFilePage: TInputFileWizardPage;

procedure InitializeWizard();
begin
  SmartIniFilePage :=
    CreateInputFilePage(
      wpSelectComponents,
      'Selecione a localização do Smart.ini',
      'Onde o Smart.ini está localizado?',
      'Selecione onde o arquivo Smart.ini está localizado, depois clique em Seguinte.');

  SmartIniFilePage.Add(
    'Localização do Smart.ini:',         
    'Smart.ini|*.ini|All files|*.*', 
    '.ini');                             
end;

function GetSmartIniPath(Param: string): string;
begin
  Result := SmartIniFilePage.Values[0];
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = SmartIniFilePage.ID then
  begin
    if SmartIniFilePage.Values[0] = '' then
    begin
      MsgBox('É necessário informar um Smart.ini para continuar com a instalação!', mbInformation, MB_OK);
      Result := False;
    end
    else
      Result := True;
  end
  else
    Result := True;
end;
  
[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon
Name: "{commonstartup}\Atualizador SMART"; Filename: "{app}\Sync\sync.exe"; Parameters: "C:\Smart\Sync\smart.syc"

[Run]
Filename: "{cmd}"; Parameters: "/C set MYVAR=C:\Smart\Pb6dk & ""{app}\{#MyAppExeName}"""; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: postinstall runhidden
Filename: "{app}\Imagem\imagem.bat"; StatusMsg: "Registrando DLL's e instalando as fontes necessárias."; Description: "Registrar variáveis para a aba de imagem"; Flags: shellexec nowait
Filename: "{app}\Pb12dk\32\sqlncli.msi"; Parameters: "/passive"; StatusMsg: "Instalando o Client do SQL Server."; Description: "Instalação do Client do SQL Server"; Check: "not IsWin64"; Flags: shellexec 
Filename: "{app}\Pb12dk\64\sqlncli.msi"; Parameters: "/passive"; StatusMsg: "Instalando o Client do SQL Server."; Description: "Instalação do Client do SQL Server"; Check: "IsWin64"; Flags: shellexec 
Filename: "{app}\Imagem\ImageViewerFull2005Setup.exe"; Parameters: "/VERYSILENT"; Description: "Instalar o ImageViewer"; Flags: shellexec postinstall skipifsilent nowait

[Components]
Name: "principal"; Description: "Arquivos de programa essenciais"; Types: "salvador itabuna eunapolis custom"; Flags: fixed 
Name: "principal\ssa"; Description: "Arquivos para DH Salvador"; Types: "salvador"; Flags: exclusive 
Name: "principal\itb"; Description: "Arquivos para DH Itabuna"; Types: "itabuna"; Flags: exclusive 
Name: "principal\enp"; Description: "Arquivos para DH Eunapolis"; Types: "eunapolis"; Flags: exclusive
;Name: "principal\iof"; Description: "Arquivos para IOF"; Types: "iof"; 
Name: "modulos"; Description: "Modulos legados"; Types: "custom"
Name: "modulos\ssa"; Description: "Modulos do Smart60 para Salvador"; Types: "custom"; Flags: exclusive 
Name: "modulos\itb"; Description: "Modulos do Smart60 para Itabuna"; Types: "custom"; Flags: exclusive 
Name: "modulos\enp"; Description: "Modulos do Smart60 para Eunapolis"; Types: "custom"; Flags: exclusive

[Types]
Name: "itabuna"; Description: "Smart Itabuna"
Name: "salvador"; Description: "Smart Salvador"
Name: "eunapolis"; Description: "Smart Eunápolis"
Name: "custom"; Description: "Personalizado"; Flags: iscustom