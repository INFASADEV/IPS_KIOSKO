
PARAMETERS LCEXENAME
*SET STEP ON
oWMI = GETOBJECT('winmgmts://')
cQuery = "select * from win32_process where name='"+LCEXENAME+"'"
oResult = oWMI.ExecQuery(cQuery)
? oResult.Count
FOR EACH oProcess IN oResult
*    ? oProcess.Name
    TRY
   		oProcess.Terminate(0)
	CATCH
  		WAIT WINDOW "" TIMEOUT 0.1
	ENDTRY
NEXT

