LOCAL printerx
printerx = GETPRINTER()
SET PRINTER TO NAME ALLTRIM(printerx)
REPORT FORM recordatoriopago TO PRINTER noconsole
