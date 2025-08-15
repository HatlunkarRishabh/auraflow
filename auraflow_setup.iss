; Inno Setup Script for AuraFlow
; This script defines the structure and behavior of the Windows installer.

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
AppId={{YOUR-UNIQUE-GUID}}
AppName=AuraFlow
AppVersion=1.0.0
AppPublisher=Your Name or Company
AppPublisherURL=https://your-website.com
AppSupportURL=https://your-website.com/support
AppUpdatesURL=https://your-website.com/updates
DefaultDirName={autopf}\AuraFlow
DefaultGroupName=AuraFlow
AllowNoIcons=yes
LicenseFile=
InfoBeforeFile=
InfoAfterFile=
OutputDir=installer
OutputBaseFilename=AuraFlow_Setup_v1.0.0
SetupIconFile=windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
; These tasks will appear as checkboxes during the installation process.
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; This section tells the installer which files to package.
; It copies everything from your Flutter release build output folder.
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Do not use "Flags: ignoreversion" on any shared system files

[Icons]
; This section creates the shortcuts for the Start Menu and optionally the Desktop.
Name: "{group}\AuraFlow"; Filename: "{app}\auraflow.exe"
Name: "{group}\{cm:UninstallProgram,AuraFlow}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\AuraFlow"; Filename: "{app}\auraflow.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\AuraFlow"; Filename: "{app}\auraflow.exe"; Tasks: quicklaunchicon

[Run]
; This section defines what happens after the installation is complete.
Filename: "{app}\auraflow.exe"; Description: "{cm:LaunchProgram,AuraFlow}"; Flags: nowait postinstall skipifsilent