unit Devtools.Utils;

interface

uses
  System.SysUtils, FMX.Forms, FMX.Dialogs, Winapi.Windows, Winapi.TlHelp32,
  Winapi.ShellAPI;

type
  TWinVersion = record
    WinPlatForm: Byte; // VER_PLATFORM_WIN32_NT, VER_PLATFORM_WIN32_WINDOWS
    WinVersion: string;
    Major: Cardinal;
    Minor: Cardinal;
  end;

function AppExec(const CmdLine, CmdParams: string; const CmdShow: Integer): Boolean;

procedure ExecAndWait(const FileName, Params: string; const CmdShow: Integer);

procedure ProcessMessages;

function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;

function RunAsAdmin(const iExeName, iParam: string): Boolean;

function Exec(const iCommand, iParam: string): string;

function GetCmdFullPath: string;

var
  WinVersion: TWinVersion;

implementation

function AppExec(const CmdLine, CmdParams: string; const CmdShow: Integer): Boolean;
begin
  result := (ShellExecute(GetCurrentProcess, 'open', PChar(CmdLine), PChar(CmdParams), '', CmdShow) > 32);
end;

procedure ExecAndWait(const FileName, Params: string; const CmdShow: Integer);
var
  exInfo: TShellExecuteInfo;
  Ph: DWORD;
begin
  FillChar(exInfo, SizeOf(exInfo), 0);
  with exInfo do
  begin
    cbSize := SizeOf(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    ExInfo.lpVerb := 'open';
    ExInfo.lpParameters := PChar(Params);
    lpFile := PChar(FileName);
    nShow := CmdShow;
  end;
  if ShellExecuteEx(@exInfo) then
    Ph := exInfo.HProcess
  else
  begin
    ShowMessage(SysErrorMessage(GetLastError));
    Exit;
  end;
  while WaitForSingleObject(ExInfo.hProcess, 50) <> WAIT_OBJECT_0 do
    ProcessMessages;
  CloseHandle(Ph);
end;

procedure ProcessMessages;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, GetCurrentProcess, 0, 0, PM_REMOVE) do
    //if not IsDialogMessage(Dlg, Msg) then
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SA do
  begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SA, 0);
  try
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /c ' + CommandLine), nil, nil, True, 0, nil, PChar(WorkDir), SI, PI);
    CloseHandle(StdOutPipeWrite);
    if Handle then
    try
      repeat
        WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
        if BytesRead > 0 then
        begin
          Buffer[BytesRead] := #0;
          Result := Result + Buffer;
        end;
      until not WasOK or (BytesRead = 0);
      WaitForSingleObject(PI.hProcess, INFINITE);
    finally
      CloseHandle(PI.hThread);
      CloseHandle(PI.hProcess);
    end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;

function RunAsAdmin(const iExeName, iParam: string): Boolean;
var
  SEI: TShellExecuteInfo;
begin
  Result := False;

  // runas �ϡ�Vista �Խ��Τ߄�������
  if (CheckWin32Version(6)) then
  begin
    ZeroMemory(@SEI, SizeOf(SEI));

    with SEI do
    begin
      cbSize := SizeOf(SEI);
      Wnd := 0;
      fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
      lpVerb := 'runas';
      lpFile := PChar(iExeName);
      lpParameters := PChar(iParam);
      nShow := SW_SHOW;
    end;

    Result := ShellExecuteEx(@SEI);
  end;
end;

function Exec(const iCommand, iParam: string): string;
var
  ReadHandle, WriteHandle: THandle;
  SA: TSecurityAttributes;
  SI: TStartUpInfo;
  PI: TProcessInformation;
  Buffer: RawByteString;
  Len: Cardinal;

  // �ѥ��פ��邎���i�߳���
  procedure ReadResult;
  var
    Count: DWORD;
    ReadableByte: DWORD;
    Data: RawByteString;
  begin
    // �i�߳����Хåե��򥯥ꥢ
    ZeroMemory(PRawByteString(Buffer), Len);

    // �ѥ��פ��i�߳�����Х������������Ĥ���Τ��{�٤�
    PeekNamedPipe(ReadHandle, PRawByteString(Buffer), Len, nil, nil, nil);
    ReadableByte := Length(Trim(string(Buffer)));

    // �i���z��������Ф�����ʤ�
    if (ReadableByte > 0) then
    begin
      while (ReadFile(ReadHandle, PRawByteString(Buffer)^, Len, Count, nil)) do
      begin
        Data := Data + RawByteString(Copy(Buffer, 1, Count));

        if (Count >= ReadableByte) then
          Break;
      end;

      Result := Result + Data;
    end;
  end;

begin
  Result := '';

  ZeroMemory(@SA, SizeOf(SA));
  SA.nLength := SizeOf(SA);
  SA.bInheritHandle := True;

  // �ѥ��פ�����
  CreatePipe(ReadHandle, WriteHandle, @SA, 0);
  try
    // StartInfo ����ڻ�
    ZeroMemory(@SI, SizeOf(SI));
    with SI do
    begin
      cb := SizeOf(SI);
      dwFlags := STARTF_USESTDHANDLES; // �˜�������ϥ�ɥ��ʹ���ޤ�������
      hStdOutput := WriteHandle;       // �˜ʳ���������ѥ��פˉ��
      hStdError := WriteHandle;        // �˜ʥ���`����������ѥ��פˉ��
    end;

    // �ץ���������
    if (not CreateProcess(PChar(iCommand), PChar(iParam), nil, nil, True, 0, nil, nil, SI, PI)) then
      Exit;

    // �i�߳����Хåե��� 4096[byte] �_��
    SetLength(Buffer, 4096);
    Len := Length(Buffer);

    with PI do
    begin
      // �ץ������K�ˤ���ޤǡ��ѥ��פ��i�߳���
      while (WaitForSingleObject(hProcess, 100) = WAIT_TIMEOUT) do
        ReadResult;

      ReadResult;

      // �ץ������]����
      CloseHandle(hProcess);
      CloseHandle(hThread);
    end;
  finally
    // �ѥ��פ��]����
    CloseHandle(WriteHandle);
    CloseHandle(ReadHandle);
  end;
end;

function GetCmdFullPath: string;
var
  CmdPath: string;
begin
  CmdPath := StringOfChar(#0, MAX_PATH);
  ExpandEnvironmentStrings(PChar('%ComSpec%'), PChar(CmdPath), Length(CmdPath));

  CmdPath := Trim(CmdPath);
  Result := CmdPath;
end;

end.

