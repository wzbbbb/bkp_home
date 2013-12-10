Set objExplorer = CreateObject("InternetExplorer.Application")
objExplorer.Navigate "about:blank"
objExplorer.ToolBar = 0
objExplorer.StatusBar = 0
objExplorer.Width = 800
objExplorer.Height = 570
objExplorer.Left = 0
objExplorer.Top = 0
objExplorer.Visible = 1

Do While (objExplorer.Busy)
Loop

Set objDocument = objExplorer.Document
objDocument.Open

objDocument.Writeln "<html><head><title>Service Status</title></head>"
objDocument.Writeln "<body bgcolor='white'>"
objDocument.Writeln "<table width='100%'>"
objDocument.Writeln "<tr>"
objDocument.Writeln "<td width='50%'><b>Service</b></td>"
objDocument.Writeln "<td width='50%'><b>State</b></td>"
objDocument.Writeln "</tr>"

strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer& "\root\cimv2")
Set colServices = objWMIService.ExecQuery _
 ("SELECT * FROM Win32_Service")
 
For Each objService in colServices
 objDocument.Writeln "<tr>"
 objDocument.Writeln "<td width='50%'>" & objService.DisplayName & "</td>"
 objDocument.writeln "<td width='50%'>" & objService.State & "</td>"
 objDocument.Writeln "</tr>"
Next

objDocument.Writeln "</table>"
objDocument.Writeln "</body></html>"
objDocument.Write()
objDocument.Close 

