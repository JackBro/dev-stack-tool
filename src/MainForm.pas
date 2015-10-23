unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUtils, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, Winapi.ShellAPI,
  Winapi.Windows, FMX.platform.Win, FMX.Edit;

type
  TMainForm = class(TForm)
    TabControl1: TTabControl;
    ��������: TTabItem;
    ���ݿ�: TTabItem;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    ������: TTabItem;
    btn6: TButton;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    TabItem4: TTabItem;
    btn10: TButton;
    GroupBox1: TGroupBox;
    lbl1: TLabel;
    edt1: TEdit;
    btn11: TButton;
    btn12: TButton;
    btn13: TButton;
    TabItem1: TTabItem;
    Button1: TButton;
    lbl2: TLabel;
    edt2: TEdit;
    edt3: TEdit;
    lbl3: TLabel;
    btn14: TButton;
    lbl4: TLabel;
    lbl5: TLabel;
    edt4: TEdit;
    edt5: TEdit;
    btn15: TButton;
    btn16: TButton;
    btn17: TButton;
    btn18: TButton;
    btn19: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn12Click(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure btn14Click(Sender: TObject);
    procedure btn15Click(Sender: TObject);
    procedure btn16Click(Sender: TObject);
    procedure btn17Click(Sender: TObject);
    procedure btn18Click(Sender: TObject);
    procedure btn19Click(Sender: TObject);
  private
    function get_laravel_project_path: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TMainForm;

implementation

{$R *.fmx}

uses
  Devtools.Utils;

procedure TMainForm.btn10Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_freemind', SW_HIDE);
end;

procedure TMainForm.btn11Click(Sender: TObject);
var
  laravel_project_path: string;
  laravel_project_name: string;
begin
  if (edt1.Text.Length > 0) and (edt2.Text.Length > 0) then
  begin
    laravel_project_path := edt1.Text;
    laravel_project_name := edt2.Text;

    AppExec('run_laravel.bat', '--laravel create ' + laravel_project_path + ' ' + laravel_project_name, SW_SHOWNORMAL);
  end;
end;

procedure TMainForm.btn12Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_sftp_net_drive', SW_HIDE);
end;

procedure TMainForm.btn13Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_node_shell', SW_HIDE)
end;

procedure TMainForm.btn14Click(Sender: TObject);
var
  laravel_project_path: string;
  controller_name: string;
begin
  if (edt3.Text.Length > 0) then
  begin
    laravel_project_path := Self.get_laravel_project_path();
    controller_name := edt3.Text;
    AppExec('run_laravel.bat', '--laravel make:controller ' + laravel_project_path + ' ' + controller_name, SW_SHOWNORMAL);
  end;
end;

procedure TMainForm.btn15Click(Sender: TObject);
var
  laravel_project_path: string;
  model_name: string;
begin
  if (edt4.Text.Length > 0) then
  begin
    laravel_project_path := Self.get_laravel_project_path();
    model_name := edt4.Text;
    AppExec('run_laravel.bat', '--laravel make:model ' + laravel_project_path + ' ' + model_name, SW_SHOWNORMAL);
  end;

end;

procedure TMainForm.btn16Click(Sender: TObject);
var
  laravel_project_path: string;
  table_name: string;
begin
  if (edt5.Text.Length > 0) then
  begin
    laravel_project_path := Self.get_laravel_project_path();
    table_name := edt5.Text;
    AppExec('run_laravel.bat', '--laravel make:migration ' + laravel_project_path + ' ' + table_name, SW_SHOWNORMAL);
  end;

end;

procedure TMainForm.btn17Click(Sender: TObject);
var
  laravel_project_path: string;
begin
  laravel_project_path := Self.get_laravel_project_path();
  AppExec('run_laravel.bat', '--laravel migrate ' + laravel_project_path, SW_SHOWNORMAL);
end;

procedure TMainForm.btn18Click(Sender: TObject);
var
  laravel_project_path: string;
begin

  laravel_project_path := Self.get_laravel_project_path();
  AppExec('run_laravel.bat', '--laravel db:seed ' + laravel_project_path, SW_SHOWNORMAL);

end;

procedure TMainForm.btn19Click(Sender: TObject);
var
  laravel_project_path: string;
begin

  laravel_project_path := Self.get_laravel_project_path();
  AppExec('run_laravel.bat', '--laravel run_server ' + laravel_project_path, SW_SHOWNORMAL);

end;

procedure TMainForm.btn1Click(Sender: TObject);
begin
  AppExec('run.cmd', 'services', SW_HIDE);

end;

procedure TMainForm.btn2Click(Sender: TObject);
begin
  AppExec('run.cmd', 'install_nginx_service', SW_HIDE);
end;

procedure TMainForm.btn3Click(Sender: TObject);
begin
  AppExec('run.cmd', 'uninstall_nginx_service', SW_HIDE);
end;

procedure TMainForm.btn4Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_sqlmanager', SW_HIDE);
end;

procedure TMainForm.btn5Click(Sender: TObject);
begin
  WinExec('cmd /k run.cmd login_mysql', SW_SHOWNORMAL);
end;

procedure TMainForm.btn6Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_autohotkey_spy', SW_HIDE);
end;

procedure TMainForm.btn7Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_procexp', SW_HIDE);
end;

procedure TMainForm.btn8Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_phpMyAdmin', SW_HIDE);
end;

procedure TMainForm.btn9Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_putty', SW_HIDE);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  AppExec('run.cmd', 'run_phpstorm', SW_HIDE);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  current_dir: string;
  filepath: string;
begin
  current_dir := TPath.GetLibraryPath;
  filepath := TPath.Combine(current_dir, 'delphiXE.png');
  //ShowMessage(filepath);
  //SetCurrentDir(current_dir);


  //Exec('C:\Windows\System32\CMD.exe', '/k run.cmd services');
  //ShowMessage(CmdPath);
  // �����ߘ��ޤǌg��
  //RunAsAdmin(CmdPath, '');
end;

function TMainForm.get_laravel_project_path: string;
var
  laravel_project_path: string;
  laravel_project_name: string;
  artisan_filename: string;
begin
  if (edt1.Text.Length > 0) then
  begin
    laravel_project_path := edt1.Text;
    laravel_project_name := edt2.Text;
    artisan_filename := TPath.Combine(laravel_project_path, 'artisan');

    if not TFile.Exists(artisan_filename) then
    begin
      if (edt2.Text.Length > 0) then
      begin
        laravel_project_path := TPath.Combine(laravel_project_path, laravel_project_name);
      end;
    end;
  end;

  Result := laravel_project_path;
end;

end.

