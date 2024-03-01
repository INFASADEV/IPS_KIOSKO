PROCEDURE decl
	DECLARE INTEGER EnumJobs IN winspool.drv;
		INTEGER hPrinter, INTEGER FirstJob, INTEGER NoJobs,;
		INTEGER Lvl, INTEGER pJob, INTEGER cbBuf,;
		INTEGER @pcbNeeded, INTEGER @pcReturned

	DECLARE INTEGER GetDefaultPrinter IN winspool.drv;
		STRING @pszBuffer, INTEGER @pcchBuffer

	DECLARE INTEGER OpenPrinter IN winspool.drv;
		STRING pPrinterName, INTEGER @phPrinter, INTEGER pDefault

	DECLARE INTEGER ClosePrinter IN winspool.drv INTEGER hPrinter
	DECLARE INTEGER GetLastError IN kernel32
	DECLARE INTEGER GlobalAlloc IN kernel32 INTEGER wFlags, INTEGER dwBytes
	DECLARE INTEGER GlobalFree IN kernel32 INTEGER hMem

	DECLARE INTEGER GetProfileString IN kernel32;
		STRING lpApp, STRING lpKey, STRING lpDefault,;
		STRING @lpReturnedString, INTEGER nSize

	DECLARE RtlMoveMemory IN kernel32 As Mem2Str;
		STRING @Dest, INTEGER Src, INTEGER nLength  


PROCEDURE ParseJobInfo
	IF Not USED("csResult")
	* mirrors the JOB_INFO_1 structure except the SYSTEMTIME member
	* adjust field sizes if they are too small
		CREATE CURSOR csResult (;
		jobid I, prnname C(30), compname C(20), usrname C(20),;
		document C(150), datatype C(20), jstat C(10), jstat1 I,;
		priority I, position I, totalpg I, printpg I )
	ENDIF

	INSERT INTO csResult VALUES (mw(1), ms(5), ms(9), ms(13),;
		JUSTSTEM(ALLTRIM(ms(17))), ms(21), ms(25), mw(29), mw(33), mw(37), mw(41), mw(45))
RETURN

FUNCTION mw(lnOffs)
RETURN buf2dword(SUBSTR(cInfo, lnOffs,4))

FUNCTION ms(lnOffs)
RETURN GetMemStr(buf2dword(SUBSTR(cInfo, lnOffs,4)))

FUNCTION GetMemStr(lnAddr)
	IF lnAddr = 0
		RETURN ""
	ENDIF

	LOCAL lnOffs, lcResult, ch
	lnOffs = lnAddr - hBuffer + 1
	lcResult = ""

	DO WHILE lnOffs < nBufsize
		ch = SUBSTR(cBuffer, lnOffs,1)
		IF ch = Chr(0)
			EXIT
		ELSE
			lcResult = lcResult + ch
		ENDIF
		lnOffs = lnOffs + 1
	ENDDO
RETURN lcResult

FUNCTION GetPrnNameNT
* returns default printer name (WinNT)
	LOCAL lcPrinter, lnBufsize
	lnBufsize = 250
	lcPrinter = Repli(Chr(0), lnBufsize)
RETURN Iif(GetDefaultPrinter(@lcPrinter, @lnBufsize)=0, "",;
	SUBSTR(lcPrinter, 1, AT(Chr(0),lcPrinter)-1))

FUNCTION GetPrnName
* returns default printer name from registry
	LOCAL lcBuffer, lnPos
	lcBuffer = Repli(Chr(0), 120)

	= GetProfileString("Windows", "Device", ",,,",;
		@lcBuffer, Len(lcBuffer))

	lcBuffer = STRTRAN(lcBuffer, Chr(0), "")
	lnPos = AT(",", lcBuffer, 1)
RETURN SUBSTR(lcBuffer, 1, lnPos-1)

FUNCTION  buf2dword (lcBuffer)
RETURN Asc(SUBSTR(lcBuffer, 1,1)) + ;
	BitLShift(Asc(SUBSTR(lcBuffer, 2,1)),  8) +;
	BitLShift(Asc(SUBSTR(lcBuffer, 3,1)), 16) +;
	BitLShift(Asc(SUBSTR(lcBuffer, 4,1)), 24)		