Set objEmail = CreateObject("CDO.Message")
objEmail.From = "zwa@orsyp.com"
objEmail.To = "zwa@orsyp.com"
objEmail.Subject = "test from vbs"
objEmail.Textbody = "ohoh"
objEmail.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
objEmail.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = _
"mail.netzero.net"
objEmail.Configuration.Fields.Item _
 ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
objEmail.Configuration.Fields.Update
objEmail.Send


