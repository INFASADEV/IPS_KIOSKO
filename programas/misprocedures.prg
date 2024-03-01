PROCEDURE llenardiario(mes)
MESSAGEBOX(mes)
ENDPROC

PROCEDURE filtrardatos(tabla,dato,vector,objeto)
STORE "" TO cadenafil
SELECT &tabla
IF EMPTY(dato)
	SET FILTER TO 
	GO top
	_SCREEN.repcostotiempogeneral.&objeto.Refresh 
ELSE
FOR ln = 1 TO ALEN(vector)
  cadenafil = cadenafil + vector(ln)+ ","
*  ? ln, la(ln)
ENDFOR
WAIT windows cadenafil
ENDIF
endproc

PROCEDURE llamarviewpicking(titulo,cunicox)
DO FORM viewpicking WITH titulo,cunicox
endproc

PROCEDURE crearpdf (rutadest,nombrearch,reportevfp)
&&&&&&&&&&&&&&&&&configuro BULLZIP
*SET STEP ON 
DIMENSION m.MATRICE(1)
m.NUMPRINTERS=APRINTERS(m.MATRICE)
STORE 0 TO OKBULLZIP
FOR m.counter=1 TO m.NUMPRINTERS
	IF "BULLZIP"$UPPER(m.MATRICE(m.counter,1)) AND !"REDIREC"$UPPER(m.MATRICE(m.counter,1))
		STORE 1 TO OKBULLZIP
		EXIT
	ENDIF
ENDFOR
IF OKBULLZIP=0
	MESSAGEBOX("NO EXISTE LA IMPRESORA BULLZIP PDF EN SU SISTEMA, FAVOR INFORMAR A SISTEMAS",64,"IMPRESORA")
	RETURN .F.
ENDIF

m.numprinter=m.counter
m.DEFAULTPRINTER=SET("Printer",2)
STORE m.DEFAULTPRINTER TO QQDEFAULT

IF !"BULLZIP"$UPPER(m.DEFAULTPRINTER)
	SET PRINTER TO NAME m.MATRICE(m.numprinter,1)
ENDIF
*!*		SELECT IESTADOCTA
*!*		STORE '&RUTAPDFS'+UCLIENTESINE+'.JPG' TO MRUTAPDF
*!*	STORE ALLTRIM(STR(NOORDEN)) TO CNORDEN
STORE ALLTRIM(nombrearch)+".PDF" TO NPDF
STORE ALLTRIM(rutadest) TO APATH
STORE APATH + NPDF TO MRUTAPDF

LCOBJ = CREATEOBJECT("BullZIP.PDFPrinterSettings")
WITH LCOBJ
	.SETVALUE("Output",MRUTAPDF)
	.SETVALUE("ShowSettings" ,"never")
	.SETVALUE("ShowPDF" ,"no")
	.SETVALUE("ShowProgressFinished" ,"no")
	.SETVALUE("ShowProgress" ,"no")
	.SETVALUE("Linearize" ,"no")
	.WRITESETTINGS(.T.)
ENDWITH

IF !"BULLZIP"$UPPER(m.DEFAULTPRINTER)
	STORE "Bullzip PDF Printer" TO m.DEFAULTPRINTER
	SET PRINTER TO NAME (m.DEFAULTPRINTER)
	IF ESREPLICA=.T.
		TRY
			oShell = CREATEOBJECT("WScript.Shell")
			oShell.RUN('rundll32 PRINTUI.dll,PrintUIEntry /y /n "Bullzip PDF Printer"',0,.T.)
		CATCH
		ENDTRY
	ENDIF
ENDIF

IF FILE('&MRUTAPDF')
	DELETE FILE '&MRUTAPDF'
ENDIF

SET ECHO OFF
SET TALK OFF
SET CONSOLE OFF
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
REPORT FORM &reportevfp TO PRINTER NOCONSOLE
IF ESREPLICA=.T. AND !"BULLZIP"$UPPER(QQDEFAULT)
	FOR m.counter=1 TO m.NUMPRINTERS
		IF UPPER("&QQDEFAULT")$UPPER(m.MATRICE(m.counter,1))
			TRY
				oShell = CREATEOBJECT("WScript.Shell")
				oShell.RUN('rundll32 PRINTUI.dll,PrintUIEntry /y /n "&QQDEFAULT"',0,.T.)
			CATCH
			ENDTRY
			EXIT
		ENDIF
	ENDFOR
ENDIF


*!*	IF DIRECTORY('&APATH')
*!*		THISFORM.OLEcontrol1.NAvigate2('&APATH')
*!*		THISFORM.OLEcontrol1.VISIBLE= .T.
*!*	ELSE
*!*		THISFORM.OLEcontrol1.NAvigate2('')
*!*		THISFORM.OLEcontrol1.VISIBLE= .F.
*!*	ENDIF
ENDPROC
PROCEDURE crearpdf2 (rutadest,nombrearch,reportevfp)
	SET STEP ON 
	DIMENSION m.MATRICE(1)
	m.NUMPRINTERS=APRINTERS(m.MATRICE)
	FOR m.COUNTER=1 TO m.NUMPRINTERS
		IF ATC("BULLZIP",m.MATRICE(m.COUNTER,1))>0
			EXIT
		ENDIF
	ENDFOR
	m.NUMPRINTER=m.COUNTER
	m.DEFAULTPRINTER=SET("Printer",2)
	IF ATC("BULLZIP",m.DEFAULTPRINTER)=0
		SET PRINTER TO NAME m.MATRICE(m.NUMPRINTER,1)
	ENDIF
	*SELECT FACTURAS
	STORE ALLTRIM(nombrearch)+".PDF" TO NPDF
	STORE ALLTRIM(rutadest) TO APATH
	STORE APATH + NPDF TO MRUTAPDF
	
*	STORE '&RUTAPDFS'+FACTURAS.FACTURA+'.PDF' TO MRUTAPDF
	LCOBJ = CREATEOBJECT("BullZIP.PDFPrinterSettings")
	WITH LCOBJ
		.SETVALUE("Output",MRUTAPDF)
		.SETVALUE("ShowSettings" ,"never")
		.SETVALUE("ShowPDF" ,"no")
		.SETVALUE("ShowProgressFinished" ,"no")
		.SETVALUE("ShowProgress" ,"no")
		.SETVALUE("Linearize" ,"yes")
		.WRITESETTINGS(.T.)
	ENDWITH
	IF ATC("BULLZIP",m.DEFAULTPRINTER)=0
		STORE 'Bullzip PDF Printer' TO m.DEFAULTPRINTER
		SET PRINTER TO NAME (m.DEFAULTPRINTER)
	ENDIF
*!*		SET ECHO OFF
*!*		SET TALK OFF
*!*		SET CONSOLE OFF
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*	SELECT FACTUREPO
*	REPORT FORM facturalasertextopickegresos TO PRINTER NOCONSOLE
	LABEL FORM &reportevfp TO PRINTER NOCONSOLE 
	*REPORT FORM FACTURALASERTEXTOr TO PRINTER NOCONSOLE
	WAIT WINDOW 'Exportacion de Factura '+facturas.factura+' en '+mrutapdf TIMEOUT 1
ENDPROC

PROCEDURE estabPredPrinter(nombreimpr)
	STORE ALLTRIM(nombreimpr) TO respx
	IF .not. EMPTY(respx)
		ws = Createobject("WScript.Network")
		ws.SetDefaultPrinter(Alltrim(respx))
		RELEASE ws && lo libero de memoria.
		SET PRINTER TO NAME ((SET("PRINTER",2)))
	ENDIF
ENDPRO

PROCEDURE impresoraDeterminada()
	STORE "" TO predex
	For lnI = 1 To Aprinters(aPrintArray)
		aPrintArray[lnI,1] = Space(1) + aPrintArray[lnI,1]
	Endfor
	For i = 1 To Alen(aPrintArray)
		lnPos = i
		If Upper(Set('PRINTER',2))$Upper(aPrintArray[i])
			predex = Upper(Set('PRINTER',2))
			Exit
		Endif
	ENDFOR
	RETURN predex
ENDPROC

PROCEDURE verEstadoImpresora(nomimp)
	STORE ALLTRIM(nomimp) TO NOMBREIMPRESORA
	STORE .T. TO PRINTERON
	strComputer = "."
	objWMIService = Getobject("winmgmts:"+ "{impersonationLevel=impersonate}!\\" + strComputer + "\root\cimv2")
	colInstalledPrinters = objWMIService.ExecQuery("SELECT * FROM Win32_Printer")
	For Each objPrinter In colInstalledPrinters
		IF ALLTRIM(objPrinter.Name) ==  ALLTRIM(NOMBREIMPRESORA)
*!*				?"Name: " + objPrinter.Name
*!*				?objPrinter.PrinterStatus
*!*				?objPrinter.Availability
*!*				?objPrinter.PrinterState
*!*				?objPrinter.SpoolEnabled
*!*				?objPrinter.WorkOffline
*!*				?objPrinter.Status
*!*				?objPrinter.StatusInfo
*!*				?objPrinter.PrinterStatus
*!*				?objPrinter.PortName
*!*				?objPrinter.Network
*!*				?objPrinter.Location
*!*				?objPrinter.Local
*!*				?objPrinter.EnableBIDI
*!*				?objPrinter.EnableDevQueryPrint
*!*				?objPrinter.Default
		PRINTERON = objPrinter.WorkOffline
		ENDIF
	NEXT
	RETURN PRINTERON
ENDPROC

PROCEDURE ping(iHost)
	Declare Integer GetRTTAndHopCount In Iphlpapi;
		Integer DestIpAddress, Long @HopCount,;
		Integer MaxHops, Long @RTT
	Declare Integer inet_addr In ws2_32 String cp
	Local nDst, nHop, nRTT
	nDst = inet_addr(iHost)
	Store 0 To nHop, nRTT
	If GetRTTAndHopCount(nDst, @nHop, 1, @nRTT) <> 0
		Return 1
	Else
		Return 2
	Endif
ENDPROC 

PROCEDURE BatteryStat
	DECLARE INTEGER GetSystemPowerStatus IN kernel32;
	STRING @lpSystemPowerStatus
	PUBLIC vPorcenBat,vAcLine
	*!*	En FoxPro
	*|typedef struct _SYSTEM_POWER_STATUS {
	*|  BYTE ACLineStatus;         1:1
	*|  BYTE BatteryFlag;          2:1
	*|  BYTE BatteryLifePercent;   3:1
	*|  BYTE Reserved1;            4:1
	*|  DWORD BatteryLifeTime;     5:4
	*|  DWORD BatteryFullLifeTime; 9:4
	*|} SYSTEM_POWER_STATUS, *LPSYSTEM_POWER_STATUS; total 12 bytes

	LOCAL cBuffer
	cBuffer = REPLI(CHR(0), 12)
	IF GetSystemPowerStatus(@cBuffer) = 0
		RETURN
	ENDIF
	LOCAL nStatus
	vAcLine = ASC(SUBSTR(cBuffer,1,1))
	vPorcenBat = ASC(SUBSTR(cBuffer,3,1))
ENDPROC

PROCEDURE imprimirArchivoExt(archivo,promptact,impreactx)
*STORE 0 TO resultesp
	IF FILE(archivo)
	ELSE
		MESSAGEBOX("Archivo No Encontrado",0+64,"Archivo No Existe")
		RETURN 0
	endif
	IF promptact = 1
		respx= ALLTRIM(impreactx)
		IF .not. EMPTY(respx)
			ws = Createobject("WScript.Network")
			ws.SetDefaultPrinter(Alltrim(respx))
			RELEASE ws && lo libero de memoria.
			SET PRINTER TO NAME ((SET("PRINTER",2)))
		ELSE
			RETURN 0		
		endif
	ENDIF
		loShell = CREATEOBJECT("Shell.Application")
		loShell.ShellExecute(ALLTRIM(archivo), SET('PRINTER',1), '', 'printto', 0 )
ENDPROC

PROCEDURE estpreprinterx(impnomx)
	respx= ALLTRIM(impnomx)
	IF .not. EMPTY(respx)
		ws = Createobject("WScript.Network")
		ws.SetDefaultPrinter(Alltrim(respx))
		RELEASE ws && lo libero de memoria.
		SET PRINTER TO NAME ((SET("PRINTER",2)))
	ELSE
		RETURN 0		
	ENDIF
ENDPROC

PROCEDURE esperarTiempo(timex,menwait)
	LOCAL ltMessageTimeOut
	m.ltMessageTimeOut = DATETIME() + timex
	DO WHILE DATETIME() < m.ltMessageTimeOut
	    WAIT WINDOW menwait NOCLEAR TIMEOUT 1
	ENDDO
	WAIT clear
ENDPROC

FUNCTION CHECKIMPRESION(lcpri,documento)
	DO decl
	#DEFINE GMEM_FIXED  0

	*|typedef struct _JOB_INFO_1 {
	*|  DWORD  JobId;          0:4
	*|  LPTSTR pPrinterName;   4:4
	*|  LPTSTR pMachineName;   8:4
	*|  LPTSTR pUserName;     12:4
	*|  LPTSTR pDocument;     16:4
	*|  LPTSTR pDatatype;     20:4
	*|  LPTSTR pStatus;       24:4
	*|  DWORD  Status;        28:4
	*|  DWORD  Priority;      32:4
	*|  DWORD  Position;      36:4
	*|  DWORD  TotalPages;    40:4
	*|  DWORD  PagesPrinted;  44:4
	*|  SYSTEMTIME Submitted; 48:16
	*|} JOB_INFO_1, *PJOB_INFO_1; 64 bytes
	#DEFINE JOB_INFO_SIZE  64

	PRIVATE hBuffer, cBuffer, nBufsize, nMinsize, nCount, cInfo
	LOCAL hPrinter, lcPrinter, lnIndex, lnResult

	* use default printer name or any other valid printer name
	*lcPrinter = GetPrnNameNT()  && WinNT users
	*lcPrinter = GetPrnName()  && more common way
	lcPrinter = lcpri  && more common way

	hPrinter = 0
	IF OpenPrinter(lcPrinter, @hPrinter, 0) = 0
		**? "Unable to retrieve printer handle for printer [" +;
			lcPrinter + "]"
		RETURN 3
	ENDIF

	* Allocate a sufficient buffer from the very beginning.
	* Calling the EnumJobs with a nil buffer to define a buffer size
	* -- it does not work with VFP, sometimes causing
	* the well-known C0000005 Exception Error
	* http://fox.wikis.com/wc.dll?Wiki~C0000005ExError

	nBufsize = 16384  && dont be too modest
	hBuffer = GlobalAlloc(GMEM_FIXED, nBufsize)
	*SET STEP ON
	STORE 0 TO nCount, nMinsize

	* calling with level 1 -- JOB_INFO_1
	lnResult = EnumJobs(hPrinter, 0, 15, 1, hBuffer, nBufsize,;
		@nMinsize, @nCount)

	= ClosePrinter(hPrinter)

	IF lnResult = 0
	* 122 = ERROR_INSUFFICIENT_BUFFER
		= GlobalFree(hBuffer)
		WAIT wind GetLastError() nowait
		*? "Expected bufsize:", nBufsize
		RETURN
	ENDIF

	**? "Jobs for printer [" + lcPrinter + "]", nCount

	IF nCount = 0
		= GlobalFree(hBuffer)
		*RETURN
	ENDIF
	cBuffer = Repli(Chr(0), nBufsize)
	= Mem2Str(@cBuffer, hBuffer, nBufsize)
	IF USED('csresult') 
		USE IN csresult
	endif
	*FOR lnIndex=0 TO nCount-1
*	MESSAGEBOX(nCount)
	*FOR lnIndex = nCount-1 to 0 STEP - 1
	FOR lnIndex=0 TO nCount-1		
		*cInfo = SUBSTR(cBuffer, (nCount-1)*JOB_INFO_SIZE+1, JOB_INFO_SIZE)
		cInfo = SUBSTR(cBuffer, lnIndex *JOB_INFO_SIZE+1, JOB_INFO_SIZE)
	*	SET STEP ON
		*MESSAGEBOX(lnIndex)
		DO ParseJobInfo
	ENDFOR

	*!*	IF USED("csResult")
	*!*		GO TOP
	*!*		BROWSE NORMAL NOWAIT
	*!*	ENDIF
	= GlobalFree(hBuffer)

	SELECT csResult
	LOCATE FOR UPPER(ALLTRIM(document)) == UPPER(ALLTRIM(documento))
	IF FOUND()
		RETURN 1
		*MESSAGEBOX(1)
	ELSE
		*MESSAGEBOX(2)
		RETURN 0
	endif
ENDFUNC

PROCEDURE CMDRUN (CMDCOMANDO)
	LOCAL OWSH	
	OWSH = CREATEOBJECT("WScript.Shell")
	STORE "CMD /C "+"&cmdComando" TO CMDINSTRUC	
	OWSH.RUN("&cmdinstruc",0,.T.)
ENDPROC