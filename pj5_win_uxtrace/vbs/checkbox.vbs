Option Explicit
Dim gsForm
Set gsForm = WScript.CreateObject(?GooeyScript.Form?, ?gsForm_?)
gsForm.Load ,,,,?This is a form with a simple button?,,,FALSE
gsForm.Button.Load ?ButtonExit?,175,75,180,125,?Exit the form?, TRUE
gsForm.OnTop = TRUE
gsForm.Visible = TRUE
gsForm.Pause

BEGIN COMMENT LINE
'Execution pauses now and recommences here once Form:
:UnPause has been ?called.
END COMMENT LINE
gsForm.Unload
Set gsForm = Nothing

BEGIN COMMENT LINE
'This subprocedure handles the button-click event
 by unpausing the ?script.
END COMMENT LINE
Sub gsForm_ButtonClick(strButtonName)
	gsForm.UnPause
End Sub

BEGIN CALLOUT A
Sub gsForm_FormClose()
	gsForm.OnTop = TRUE
	gsForm.Visible = TRUE
End Sub
END CALLOUT A

