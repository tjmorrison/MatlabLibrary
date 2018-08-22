program TestIRBACS64;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ldirbacs2, dtestirbacs;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTestLib, frmTestLib);
  Application.Run;
end.

