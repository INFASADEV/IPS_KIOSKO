&&&&&&&&PROGRAMA PARA LEER LA CONFIGURACI�N INICIAL DEL SISTEMA

PARAMETERS CLASE,DATO,RUTA
STORE 126 TO CHARCOMO
STORE 'A1B2C3D4E5F6G7H8I9J0' TO CLAVENCRI
VALTEMP= ALLTRIM(STRTRAN(ALLTRIM(LEERINI(CLASE,DATO,RUTA)),CHR(0),'')) &&&&&QUITAMOS EL FIN DE LINEA PARA DEJAR SOLO EL VALOR A UTILIZAR
STORE ASC(RIGHT(VALTEMP,1)) TO CHARENCRIP

IF CHARENCRIP==CHARCOMO&&&&YA ESTA ENCRIPTADO
	VALOR= LEFT(VALTEMP,LEN(VALTEMP)-1) &&&&&QUITAMOS EL CHAR(1) PARA DEJAR SOLO EL VALOR A UTILIZAR
	DENCRIP=SISENCRIPTA(VALOR,CLAVENCRI,0)  &&&&&DESENCRIPTAMOS EL VALOR
	RETURN DENCRIP
ELSE
	STORE '&MPROGRA'+'TMP' TO XTMP
	IF FILE("C:\&XTMP\USERTEMP.DBF")
&&&&&ESTA ABRIENDO OTRA EMPRESA Y NO PUEDE MODIFICAR LAS CREDENCIALES DE LA PRIMER EMPRESA (TIENE QUE CERRAR TODAS )
	ELSE
		SIENCRIP=SISENCRIPTA(VALTEMP,CLAVENCRI,1) &&&&&ENCRIPTA EL VALOR
		STORE "&SIENCRIP"+CHR(CHARCOMO) TO VALORENC
		SIENC=WRITEFILEINI(CLASE,DATO,RUTA,VALORENC) &&&&&&&MODIFICA EL INI CON EL VALOR ENCRIPTADO
		IF SIENC=.T.
			RETURN VALTEMP &&&DEVUELVE EL VALOR QUE HAB�A LEIDO Y QUE AUN NO ESTABA ENCRIPTADO
		ELSE
			MESSAGEBOX("Error Al Configurar El Archivo INI",64+0+0,"ABRIR &MPROGRA")
			RETURN .F.
		ENDIF

	ENDIF
FUNCTION LEERINI(CSECTION, CENTRY, CINIFILE)
LOCAL CDEFAULT, CRETVAL, NRETLEN
CDEFAULT = ""
CRETVAL = SPACE(255)
NRETLEN = LEN(CRETVAL)
DECLARE INTEGER GetPrivateProfileString IN WIN32API ;
	STRING cSection, STRING cEntry, ;
	STRING cDefault, STRING @cRetVal, ;
	INTEGER nRetLen, STRING cINIFile
NRET = GETPRIVATEPROFILESTRING(CSECTION, CENTRY, CDEFAULT, ;
	@CRETVAL, NRETLEN, CINIFILE)
RETURN LEFT(CRETVAL, NRETLEN)
ENDFUNC

*----------------------------------------------------
FUNCTION WRITEFILEINI(TCSECTION,TCENTRY,TCFILENAME,TCVALUE)
*----------------------------------------------------
* Escribe un valor de un archivo INI.
* Si no existe el archivo, la secci�n o la entrada, la crea.
* Retorna .T. si tuvo �xito
* PARAMETROS:
* tcFileName = Nombre y ruta completa del archivo.INI
* tcSection = Secci�n del archivo.INI
* tcEntry = Entrada del archivo.INI
* tcValue = Valor de la entrada
* USO: WriteFileIni("C:MiArchivo.ini","Default","Port","2")
* RETORNO: Logico
*----------------------------------------------------
DECLARE INTEGER WritePrivateProfileString ;
	IN WIN32API ;
	STRING cSection,STRING cEntry,STRING cEntry,;
	STRING cFileName
RETURN IIF(WRITEPRIVATEPROFILESTRING(TCSECTION,TCENTRY,TCVALUE,TCFILENAME)=1, .T., .F.)
ENDFUNC
