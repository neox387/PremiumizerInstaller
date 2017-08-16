#include <.\idp\idp.iss>

#define PremiumizerInstallerVersion "v0.4"

#define AppId "{{9D9946EA-5EDE-462C-A42A-9A511E26CE7B}"
#define AppName "Premiumizer"
#define AppVersion "master"
#define AppPublisher "Premiumizer"
#define AppURL "https://github.com/piejanssens/premiumizer"
#define AppServiceName AppName
#define AppServiceDescription "Cloud Downloader Premiumize.me"
#define ServiceStartIcon "{group}\Start " + AppName + " Service"
#define ServiceStopIcon "{group}\Stop " + AppName + " Service"

#define InstallerVersion 1004
#define InstallerSeedUrl "https://raw.github.com/neox387/PremiumizerInstaller/master/seed.ini"
#define AppRepoUrl "https://github.com/piejanssens/premiumizer.git"
#define nzbtomediaRepoUrl "https://github.com/clinton-hall/nzbToMedia.git"

[Setup]
AppId={#AppId}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} ({#AppVersion})
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={sd}\{#AppName}
DefaultGroupName={#AppName}
AllowNoIcons=yes
ArchitecturesInstallIn64BitMode=x64
UninstallDisplayIcon={app}\Installer\prem.ico
OutputBaseFilename={#AppName}Installer
UninstallFilesDir={app}\Installer
ExtraDiskSpaceRequired=350000000
SetupIconFile=assets\prem.ico
InternalCompressLevel=max
SolidCompression=True
SetupLogging=yes

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "utils\unzip.exe"; Flags: dontcopy
Source: "utils\get-pip.py"; Flags: dontcopy
Source: "utils\pywin32-221.win-amd64-py2.7.exe"; Flags: dontcopy
Source: "utils\VCForPython27.msi"; Flags: dontcopy
Source: "assets\github.ico"; DestDir: "{app}\Installer"
Source: "assets\prem.ico"; DestDir: "{app}\Installer"
Source: "utils\nssm32.exe"; DestDir: "{app}\Installer"; DestName: "nssm.exe"; Check: not Is64BitInstallMode
Source: "utils\nssm64.exe"; DestDir: "{app}\Installer"; DestName: "nssm.exe"; Check: Is64BitInstallMode

[Icons]
Name: "{group}\{#AppName}"; Filename: "http://127.0.0.1:5000/"; IconFilename: "{app}\Installer\prem.ico"
Name: "{commondesktop}\{#AppName}"; Filename: "http://127.0.0.1:5000/"; IconFilename: "{app}\Installer\prem.ico"; Tasks: desktopicon
Name: "{group}\{#AppName} on GitHub"; Filename: "{#AppRepoUrl}"; IconFilename: "{app}\Installer\github.ico"; Flags: excludefromshowinnewinstall
Name: "{#ServiceStartIcon}"; Filename: "{app}\Installer\nssm.exe"; Parameters: "start ""{#AppServiceName}"""; Flags: excludefromshowinnewinstall
Name: "{#ServiceStopIcon}"; Filename: "{app}\Installer\nssm.exe"; Parameters: "stop ""{#AppServiceName}"""; Flags: excludefromshowinnewinstall
Name: "{group}\Edit {#AppName} Service"; Filename: "{app}\Installer\nssm.exe"; Parameters: "edit ""{#AppServiceName}"""; AfterInstall: ModifyServiceLinks; Flags: excludefromshowinnewinstall

[Run]
Filename: "msiexec.exe"; Parameters: "/i ""{tmp}\VCForPython27.msi"" /q"; StatusMsg: "Installing Microsoft Visual C++ Compiler..."
Filename: "{app}\Git\cmd\git.exe"; Parameters: "clone {#AppRepoUrl} {app}\{#AppName}"; StatusMsg: "Installing {#AppName}..."
Filename: "{app}\Git\cmd\git.exe"; Parameters: "clone {#NzbToMediaRepoUrl} {app}\{#AppName}\nzbtomedia"; StatusMsg: "Installing NzbTomedia..."
Filename: "{app}\Python\Python.exe"; Parameters: "{tmp}\get-pip.py"; StatusMsg: "Installing pip..."
Filename: "{app}\Python\Scripts\easy_install.exe"; Parameters: "{tmp}\pywin32-221.win-amd64-py2.7.exe"; StatusMsg: "Installing Pywin32..."
Filename: "{app}\Python\Scripts\pip2.7.exe"; Parameters: "install -r {app}\{#AppName}\requirements.txt"; StatusMsg: "Installing Premiumizer dependencies"
Filename: "{app}\Installer\nssm.exe"; Parameters: "start ""{#AppServiceName}"""; Flags: runhidden; BeforeInstall: CreateService; StatusMsg: "Starting {#AppName} service..."
Filename: "{sys}\services.msc"; WorkingDir: {sys}; Flags: shellexec postinstall; Description: "Open Services.msc to change user log on for Premiumizer to your account"
Filename: "notepad"; Parameters: "{app}\{#AppName}\nzbtomedia\autoProcessMedia.cfg.spec"; Flags: postinstall shellexec; Description: "Open NzbToMedia config file SAVE IT AS autoProcessMedia.cfg"
Filename: "http://127.0.0.1:5000/"; Flags: postinstall shellexec unchecked; Description: "Open {#AppName} in browser"

[UninstallRun]
Filename: "{app}\Installer\nssm.exe"; Parameters: "remove ""{#AppServiceName}"" confirm"; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}\Python"
Type: filesandordirs; Name: "{app}\Git"
Type: filesandordirs; Name: "{app}\{#AppName}"
Type: filesandordirs; Name: "{app}\Installer"
Type: dirifempty; Name: "{app}"

[Messages]
WelcomeLabel2=This will install [name/ver] on your computer.%n%nYou will need Internet connectivity in order to download the required packages.%n%nNOTE: This installer intentionally ignores any existing installations of Git or Python you might already have installed on your system. If you would prefer to use those versions, we recommend installing [name] manually.
AboutSetupNote=PremiumizerInstaller {#PremiumizerInstallerVersion}
BeveledLabel=PremiumizerInstaller {#PremiumizerInstallerVersion}

[Code]
type
  TDependency = record
    Name:     String;
    URL:      String;
    Filename: String;
    Size:     Integer;
    SHA1:     String;
  end;

  IShellLinkW = interface(IUnknown)
    '{000214F9-0000-0000-C000-000000000046}'
    procedure Dummy;
    procedure Dummy2;
    procedure Dummy3;
    function GetDescription(pszName: String; cchMaxName: Integer): HResult;
    function SetDescription(pszName: String): HResult;
    function GetWorkingDirectory(pszDir: String; cchMaxPath: Integer): HResult;
    function SetWorkingDirectory(pszDir: String): HResult;
    function GetArguments(pszArgs: String; cchMaxPath: Integer): HResult;
    function SetArguments(pszArgs: String): HResult;
    function GetHotkey(var pwHotkey: Word): HResult;
    function SetHotkey(wHotkey: Word): HResult;
    function GetShowCmd(out piShowCmd: Integer): HResult;
    function SetShowCmd(iShowCmd: Integer): HResult;
    function GetIconLocation(pszIconPath: String; cchIconPath: Integer;
      out piIcon: Integer): HResult;
    function SetIconLocation(pszIconPath: String; iIcon: Integer): HResult;
    function SetRelativePath(pszPathRel: String; dwReserved: DWORD): HResult;
    function Resolve(Wnd: HWND; fFlags: DWORD): HResult;
    function SetPath(pszFile: String): HResult;
  end;

  IPersist = interface(IUnknown)
    '{0000010C-0000-0000-C000-000000000046}'
    function GetClassID(var classID: TGUID): HResult;
  end;

  IPersistFile = interface(IPersist)
    '{0000010B-0000-0000-C000-000000000046}'
    function IsDirty: HResult;
    function Load(pszFileName: String; dwMode: Longint): HResult;
    function Save(pszFileName: String; fRemember: BOOL): HResult;
    function SaveCompleted(pszFileName: String): HResult;
    function GetCurFile(out pszFileName: String): HResult;
  end;

  IShellLinkDataList = interface(IUnknown)
    '{45E2B4AE-B1C3-11D0-B92F-00A0C90312E1}'
    procedure Dummy;
    procedure Dummy2;
    procedure Dummy3;
    function GetFlags(out dwFlags: DWORD): HResult;
    function SetFlags(dwFlags: DWORD): HResult;
  end;

const
  WM_CLOSE             = $0010;
  GENERIC_WRITE        = $40000000;
  GENERIC_READ         = $80000000;
  OPEN_EXISTING        = 3;
  INVALID_HANDLE_VALUE = $FFFFFFFF;
  SLDF_RUNAS_USER      = $00002000;
  CLSID_ShellLink = '{00021401-0000-0000-C000-000000000046}';

var
  // This lets AbortInstallation() terminate setup without prompting the user
  CancelWithoutPrompt: Boolean;
  ErrorMessage, LocalFilesDir: String;
  SeedDownloadPageId, DependencyDownloadPageId: Integer;
  PythonDep, GitDep: TDependency;
  InstallDepPage: TOutputProgressWizardPage;

// Import some Win32 functions
function CreateFile(
  lpFileName: String;
  dwDesiredAccess: LongWord;
  dwSharedMode: LongWord;
  lpSecurityAttributes: LongWord;
  dwCreationDisposition: LongWord;
  dwFlagsAndAttributes: LongWord;
  hTemplateFile: LongWord): LongWord;
external 'CreateFileW@kernel32.dll stdcall';

function CloseHandle(hObject: LongWord): Boolean;
external 'CloseHandle@kernel32.dll stdcall';

procedure AbortInstallation(ErrorMessage: String);
begin
  MsgBox(ErrorMessage + #13#10#13#10 'Setup will now terminate.', mbError, 0)
  CancelWithoutPrompt := True
  PostMessage(WizardForm.Handle, WM_CLOSE, 0, 0);
end;

procedure CheckInstallerVersion(SeedFile: String);
var
  InstallerVersion, CurrentVersion: Integer;
  DownloadUrl: String;
begin
  InstallerVersion := StrToInt(ExpandConstant('{#InstallerVersion}'))

  CurrentVersion := GetIniInt('Installer', 'Version', 0, 0, MaxInt, SeedFile)

  if CurrentVersion = 0 then begin
    AbortInstallation('Unable to parse configuration.')
  end;

  if CurrentVersion > InstallerVersion then begin
    DownloadUrl := GetIniString('Installer', 'DownloadUrl', ExpandConstant('{#AppURL}'), SeedFile)
    AbortInstallation(ExpandConstant('This is an old version of the {#AppName} installer. Please get the latest version at:') + #13#10#13#10 + DownloadUrl)
  end;
end;

procedure ParseDependency(var Dependency: TDependency; Name, SeedFile: String);
var
  LocalFile: String;
begin
  Dependency.Name     := Name;
  Dependency.URL      := GetIniString(Name, 'url', '', SeedFile)
  Dependency.Filename := Dependency.URL
  Dependency.Size     := GetIniInt(Name, 'size', 0, 0, MaxInt, SeedFile)
  Dependency.SHA1     := GetIniString(Name, 'sha1', '', SeedFile)

  if (Dependency.URL = '') or (Dependency.Size = 0) or (Dependency.SHA1 = '') then begin
    AbortInstallation('Error parsing dependency information for ' + Name + '.')
  end;

  while Pos('/', Dependency.Filename) <> 0 do begin
    Delete(Dependency.Filename, 1, Pos('/', Dependency.Filename))
  end;

  if LocalFilesDir <> '' then begin
    LocalFile := LocalFilesDir + '\' + Dependency.Filename
  end;
  if (LocalFile <> '') and (FileExists(LocalFile)) then begin
    FileCopy(LocalFile, ExpandConstant('{tmp}\') + Dependency.Filename, True)
  end else begin
    idpAddFileSize(Dependency.URL, ExpandConstant('{tmp}\') + Dependency.Filename, Dependency.Size)
  end
end;

procedure ParseSeedFile();
var
  SeedFile: String;
  DownloadPage: TWizardPage;
begin
  SeedFile := ExpandConstant('{tmp}\installer.ini')

  // Make sure we're running the latest version of the installer
  CheckInstallerVersion(SeedFile)

  ParseDependency(PythonDep,    'Python.x64'    , SeedFile)
  ParseDependency(GitDep,       'Git.x64'       , SeedFile)

  DependencyDownloadPageId := idpCreateDownloadForm(wpPreparing)
  DownloadPage := PageFromID(DependencyDownloadPageId)
  DownloadPage.Caption := 'Downloading Dependencies'
  DownloadPage.Description := ExpandConstant('Setup is downloading {#AppName} dependencies...')

  idpSetOption('DetailedMode', '1')
  idpSetOption('DetailsButton', '0')

  idpConnectControls()
end;

procedure InitializeSeedDownload();
var
  DownloadPage: TWizardPage;
  Seed: String;
  IsRemote: Boolean;
begin
  IsRemote := True

  Seed := ExpandConstant('{param:SEED}')
  if (Lowercase(Copy(Seed, 1, 7)) <> 'http://') and (Lowercase(Copy(Seed, 1, 8)) <> 'https://') then begin
    if Seed = '' then begin
      Seed := ExpandConstant('{#InstallerSeedUrl}')
    end else begin
      if FileExists(Seed) then begin
        IsRemote := False
      end else begin
        MsgBox('Invalid SEED specified: ' + Seed, mbError, 0)
        Seed := ExpandConstant('{#InstallerSeedUrl}')
      end;
    end;
  end;

  if not IsRemote then begin
    FileCopy(Seed, ExpandConstant('{tmp}\installer.ini'), False)
    ParseSeedFile()
  end else begin
    // Download the installer seed INI file
    // I'm adding a dummy size here otherwise the installer crashes (divide by 0)
    // when runnning in silent mode, a bug in IDP maybe?
    idpAddFileSize(Seed, ExpandConstant('{tmp}\installer.ini'), 1024)

    SeedDownloadPageId := idpCreateDownloadForm(wpWelcome)
    DownloadPage := PageFromID(SeedDownloadPageId)
    DownloadPage.Caption := 'Downloading Installer Configuration'
    DownloadPage.Description := 'Setup is downloading it''s configuration file...'

    idpConnectControls()
  end;
end;

function CheckFileInUse(Filename: String): Boolean;
var
  FileHandle: LongWord;
begin
  if not FileExists(Filename) then begin
    Result := False
    exit
  end;

  FileHandle := CreateFile(Filename, GENERIC_READ or GENERIC_WRITE, 0, 0, OPEN_EXISTING, 0, 0)
  if (FileHandle <> 0) and (FileHandle <> INVALID_HANDLE_VALUE) then begin
    CloseHandle(FileHandle)
    Result := False
  end else begin
    Result := True
  end;
end;

procedure CreateService();
var
  Nssm: String;
  ResultCode: Integer;
  OldProgressString: String;
begin
  Nssm := ExpandConstant('{app}\Installer\nssm.exe')

  OldProgressString := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := ExpandConstant('Installing {#AppName} service...')

  Exec(Nssm, ExpandConstant('install "{#AppServiceName}" "{app}\Python\python.exe" """{app}\{#AppName}\Premiumizer.py""" --windows'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppDirectory "{app}\{#AppName}"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" Description "{#AppServiceDescription}"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppStopMethodSkip 6'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppStopMethodConsole 20000'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppRestartDelay 2000'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  Exec(Nssm, ExpandConstant('set "{#AppServiceName}" AppEnvironmentExtra "PATH={app}\Git\cmd;%PATH%" "PATH={app}\Python;%PATH%"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)

  WizardForm.StatusLabel.Caption := OldProgressString;
end;

procedure StopService();
var
  Nssm: String;
  ResultCode: Integer;
  Retries: Integer;
  OldProgressString: String;
begin
  Retries := 30

  OldProgressString := UninstallProgressForm.StatusLabel.Caption;
  UninstallProgressForm.StatusLabel.Caption := ExpandConstant('Stopping {#AppName} service...')

  Nssm := ExpandConstant('{app}\Installer\nssm.exe')
  Exec(Nssm, ExpandConstant('stop "{#AppServiceName}"'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode)

  while (Retries > 0) and (CheckFileInUse(Nssm)) do begin
    UninstallProgressForm.StatusLabel.Caption := ExpandConstant('Waiting for {#AppName} service to stop (') + IntToStr(Retries) + ')...'
    Sleep(1000)
    Retries := Retries - 1
  end;

  UninstallProgressForm.StatusLabel.Caption := OldProgressString;
end;

procedure CleanPython();
var
  PythonPath: String;
begin
  PythonPath := ExpandConstant('{app}\Python')

  DelTree(PythonPath + '\*.msi',        False, True, False)
  DelTree(PythonPath + '\Doc',          True,  True, True)
  DelTree(PythonPath + '\Lib\test\*.*', False, True, True)
  DelTree(PythonPath + '\tcl',          True,  True, True)
  DelTree(PythonPath + '\Tools',        True,  True, True)
end;

procedure InstallPython();
var
  ResultCode: Integer;
begin
  InstallDepPage.SetText('Installing Python...', '')
  Exec('msiexec.exe', ExpandConstantEx('/A "{tmp}\{filename}" /QN TARGETDIR="{app}\Python"', 'filename', PythonDep.Filename), '', SW_SHOW, ewWaitUntilTerminated, ResultCode)
  CleanPython();
  ExtractTemporaryFile('get-pip.py');
  ExtractTemporaryFile('pywin32-221.win-amd64-py2.7.exe');
  ExtractTemporaryFile('VCForPython27.msi');
  InstallDepPage.SetProgress(InstallDepPage.ProgressBar.Position+1, InstallDepPage.ProgressBar.Max)
end;

procedure InstallGit();
var
  ResultCode: Integer;
begin
  InstallDepPage.SetText('Installing Git...', '')
  Exec(ExpandConstantEx('{tmp}\{filename}', 'filename', GitDep.Filename), ExpandConstant('/DIR="{app}\Git" /VERYSILENT'), '', SW_SHOW, ewWaitUntilTerminated, ResultCode)
  InstallDepPage.SetProgress(InstallDepPage.ProgressBar.Position+1, InstallDepPage.ProgressBar.Max)
end;

function VerifyDependency(Dependency: TDependency): Boolean;
begin
  Result := True

  InstallDepPage.SetText('Verifying dependency files...', Dependency.Filename)
  if GetSHA1OfFile(ExpandConstant('{tmp}\') + Dependency.Filename) <> Dependency.SHA1 then begin
    MsgBox('SHA1 hash of ' + Dependency.Filename + ' does not match.', mbError, 0)
    Result := False
  end;
  InstallDepPage.SetProgress(InstallDepPage.ProgressBar.Position+1, InstallDepPage.ProgressBar.Max)
end;

function VerifyDependencies(): Boolean;
begin
  Result := True

  Result := Result and VerifyDependency(PythonDep)
  Result := Result and VerifyDependency(GitDep)
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  if ErrorMessage <> '' then begin
    Result := ErrorMessage
  end;
end;

procedure InstallDependencies();
begin
  try
    InstallDepPage.Show
    InstallDepPage.SetProgress(0, 6)
     InstallPython()
     InstallGit()
  finally
    InstallDepPage.Hide
  end;
end;

procedure InitializeWizard();
begin
  InitializeSeedDownload()

  idpInitMessages()

  InstallDepPage := CreateOutputProgressPage('Installing Dependencies', ExpandConstant('Setup is installing {#AppName} dependencies...'));
end;

function ShellLinkRunAsAdmin(LinkFilename: String): Boolean;
var
  Obj: IUnknown;
  SL: IShellLinkW;
  PF: IPersistFile;
  DL: IShellLinkDataList;
  Flags: DWORD;
begin
  try
    Obj := CreateComObject(StringToGuid(CLSID_ShellLink));

    SL := IShellLinkW(Obj);
    PF := IPersistFile(Obj);

    // Load the ShellLink
    OleCheck(PF.Load(LinkFilename, 0));

    // Set the SLDF_RUNAS_USER flag
    DL := IShellLinkDataList(Obj);
    OleCheck(DL.GetFlags(Flags))
    OleCheck(DL.SetFlags(Flags or SLDF_RUNAS_USER))

    // Save the ShellLink
    OleCheck(PF.Save(LinkFilename, True));

    Result := True
  except
    Result := False
  end;
end;

procedure ModifyServiceLinks();
begin
  ShellLinkRunAsAdmin(ExpandConstant('{#ServiceStartIcon}.lnk'))
  ShellLinkRunAsAdmin(ExpandConstant('{#ServiceStopIcon}.lnk'))
end;

function InitializeSetup(): Boolean;
begin
  CancelWithoutPrompt := False

  LocalFilesDir := ExpandConstant('{param:LOCALFILES}')
  if (LocalFilesDir <> '') and (not DirExists(LocalFilesDir)) then begin
    MsgBox('Invalid LOCALFILES specified: ' + LocalFilesDir, mbError, 0)
    LocalFilesDir := ''
  end;

  // Don't allow installations over top
  if RegKeyExists(HKEY_LOCAL_MACHINE, ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#AppId}_is1')) then begin
    MsgBox(ExpandConstant('{#AppName} is already installed. If you''re reinstalling or upgrading, please uninstall the current version first.'), mbError, 0)
    Result := False
  end else begin
    Result := True
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True

  if CurPageID = SeedDownloadPageId then begin
    ParseSeedFile()
  end;
end;


procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  Confirm := not CancelWithoutPrompt;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then begin
    // Stop service
    StopService()
  end;
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo,
  MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
begin
  Result := MemoDirInfo + NewLine + NewLine + \
            MemoGroupInfo + NewLine + NewLine + \
            'Download and install dependencies:' + NewLine + \
            Space + 'Git' + NewLine + \
            Space + 'Python'

  if MemoTasksInfo <> '' then begin
    Result := Result + NewLine + NewLine + MemoTasksInfo
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then begin
    InstallDependencies()
  end;
end;

function GetAppID():string;
begin
  result := ExpandConstant('{#SetupSetting("AppID")}');     
end;

function GetAppUninstallRegKey():string;
begin
  result := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\' + GetAppID + '_is1'); //Get the Uninstall search path from the Registry
end;

function IsAppInstalled():boolean;
var Key : string;          //Registry path to details about the current installation (uninstall info)
begin                            
  Key := GetAppUninstallRegKey;
  result := RegValueExists(HKEY_LOCAL_MACHINE, Key, 'UninstallString');
end;

//Return the install path used by the existing installation.
function GetInstalledPath():string;
var Key : string;
begin
  Key := GetAppUninstallRegKey;
  RegQueryStringValue(HKEY_LOCAL_MACHINE, Key, 'InstallLocation', result);
end;

function MoveLogfileToLogDir():boolean;
var
  logfilepathname, logfilename, newfilepathname: string;
begin
  logfilepathname := expandconstant('{log}');

  //If logfile is disabled then logfilepathname is empty
  if logfilepathname = '' then begin
     result := false;
     exit;
  end;

  logfilename := ExtractFileName(logfilepathname);
  try
    //Get the install path by first checking for existing installation thereafter by GUI settings
    if IsAppInstalled then
       newfilepathname := GetInstalledPath + '\Installer\'
    else
       newfilepathname := expandconstant('{app}\Installer\');
  except
    //This exception is raised if {app} is invalid i.e. if canceled is pressed on the Welcome page
        try
          newfilepathname := WizardDirValue + '\Installer\'; 
        except
          //This exception is raised if WizardDirValue i s invalid i.e. if canceled is pressed on the Mutex check message dialog.
          result := false;
        end;
  end;  
  result := ForceDirectories(newfilepathname); //Make sure the destination path exists.
  newfilepathname := newfilepathname + logfilename; //Add filename

  //if copy successful then delete logfilepathname 
  result := filecopy(logfilepathname, newfilepathname, false);

  if result then
     result := DeleteFile(logfilepathname);
end;

//Called just before Setup terminates. Note that this function is called even if the user exits Setup before anything is installed.
procedure DeinitializeSetup();
begin
  MoveLogfileToLogDir;
end;