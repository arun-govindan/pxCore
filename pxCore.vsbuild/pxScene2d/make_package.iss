; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{525C71A9-61E5-463E-ADBB-C8AF15C824CC}
AppName=pxScene
AppVersion=0.0.1
AppPublisher=pxScene
AppPublisherURL=http://www.example.com/
AppSupportURL=http://www.example.com/
AppUpdatesURL=http://www.example.com/
DefaultDirName={pf}\pxScene
DisableProgramGroupPage=yes
OutputBaseFilename=pxscene-setup
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Visual C++ 2010 SP1 Redist(x86) installer
Source: "C:\projects\pxCore\vcredist_x86.exe"; DestDir: {tmp}; Flags: deleteafterinstall
; Visual C++ 2015 SP3 Redist(x86)installer
Source: "C:\projects\pxCore\vc_redist.x86.exe"; DestDir: {tmp}; Flags: deleteafterinstall
Source: "C:\projects\pxcore\pxCore.vsbuild\pxScene2d\exe\pxScene.exe"; DestDir: "{app}"; Flags: ignoreversion;
Source: "C:\projects\pxCore\pxCore.vsbuild\pxScene2d\exe\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Run]
; the conditional installation Check
; install  Visual C++ 2010 SP1 Redist(x86) if not exist
Filename: "{tmp}\vcredist_x86.exe"; Parameters: "/q /norestart"; StatusMsg: "Installing Microsoft Visual C++ 2010 SP1 Runtime ..."; Check: VC2010SP1RedistNeedsInstall
; install  Visual C++ 2015 SP3 Redist(x86) if not exist
Filename: "{tmp}\vc_redist.x86.exe"; Parameters: "/q /norestart"; StatusMsg: "Installing Microsoft Visual C++ 2015 SP3 Runtime ..."; Check: VC2015SP3RedistNeedsInstall

[Registry]
Root: HKCU; Subkey: "Software\pxScene.org"; Flags: uninsdeletekey

[Code]
#IFDEF UNICODE
  #DEFINE AW "W"
#ELSE
  #DEFINE AW "A"
#ENDIF
type
  INSTALLSTATE = Longint;
const
  INSTALLSTATE_INVALIDARG = -2;  { An invalid parameter was passed to the function. }
  INSTALLSTATE_UNKNOWN = -1;     { The product is neither advertised or installed. }
  INSTALLSTATE_ADVERTISED = 1;   { The product is advertised but not installed. }
  INSTALLSTATE_ABSENT = 2;       { The product is installed for a different user. }
  INSTALLSTATE_DEFAULT = 5;      { The product is installed for the current user. }

  {Visual C++ 2010 SP1 Redist(x86) 10.0.40219}
  VC_2010_SP1_REDIST_X86 = '{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5}';

  {Visual C++ 2015 SP3 Redist(x86) 14.0.24215}
  VC_2015_SP3_REDIST_X86 = '{BBF2AC74-720C-3CB3-8291-5E34039232FA}';

function MsiQueryProductState(szProduct: string): INSTALLSTATE;
  external 'MsiQueryProductState{#AW}@msi.dll stdcall';

function VCVersionInstalled(const ProductID: string): Boolean;
begin
  Result := not (MsiQueryProductState(ProductID) = INSTALLSTATE_DEFAULT);
end;

function VC2010SP1RedistNeedsInstall: Boolean;
begin
  Result := VCVersionInstalled(VC_2010_SP1_REDIST_X86);
end;

function VC2015SP3RedistNeedsInstall: Boolean;
begin
  Result := VCVersionInstalled(VC_2015_SP3_REDIST_X86);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if (CurPageID = wpSelectDir) and (MsgBox('Do you really want to install pxScene into ''' + WizardDirValue + '''?', mbConfirmation, MB_YESNO) = IDNO) then begin
         Result := False
  end;
end;

[Icons]
Name: "{commonprograms}\pxScene"; Filename: "{app}\pxScene.exe"; Parameters:"-hide-console";
Name: "{commondesktop}\pxScene"; Filename: "{app}\pxScene.exe"; Parameters:"-hide-console"; Tasks: desktopicon
