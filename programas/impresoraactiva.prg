PARAMETERS nombreImpresora,tipoTrabajo
DO case
CASE ALLTRIM(UPPER(tipotrabajo)) == 'E'
	&& Enumera impresoras y estado
	strComputer = "."
	objWMIService = Getobject("winmgmts:"+ "{impersonationLevel=impersonate}!\\" + strComputer + "\root\cimv2")
	colInstalledPrinters = objWMIService.ExecQuery("SELECT * FROM Win32_Printer")
	For Each objPrinter In colInstalledPrinters
		?"Name: " + objPrinter.Name
		Do Case
			Case objPrinter.PrinterStatus = 1
				strPrinterStatus = "Other"
			Case objPrinter.PrinterStatus = 2
				strPrinterStatus = "Unknown"
			Case objPrinter.PrinterStatus = 3
				strPrinterStatus = "Idle"
			Case objPrinter.PrinterStatus = 4
				strPrinterStatus = "Printing"
			Case objPrinter.PrinterStatus = 5
				strPrinterStatus = "Warmup"
		Endcase
		? "Printer Status: " + strPrinterStatus
	NEXT
	pendientes = 0
CASE ALLTRIM(UPPER(tipotrabajo)) == 'B'
	STORE 0 TO pendientes
	&& Enumera los trajos de impresion de cada impresora

	lcComputer = "."
	loWMIService = Getobject("winmgmts:{impersonationLevel=impersonate}!\\" + lcComputer + "\root\cimv2")
	colPrintQueues =  loWMIService.ExecQuery ("Select * from Win32_PerfFormattedData_Spooler_PrintQueue Where Name <> '_Total'")
	For Each loPrintQueue In colPrintQueues
		IF ALLTRIM(UPPER(loPrintQueue.name)) == ALLTRIM(UPPER(nombreImpresora))
	      *?"Name: " + loPrintQueue.Name
	      *?"Current jobs: " + transform(loPrintQueue.Jobs)
	      pendientes = loPrintQueue.Jobs
	    ENDIF	    
	NEXT
OTHERWISE
	pendientes = 0
ENDCASE
RETURN pendientes