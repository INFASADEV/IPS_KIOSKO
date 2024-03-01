PARAMETERS archivost,tipost,copiasst,revalidar
DO misprocedures.prg
LOCAL valemp,arcimpresora,cantcopies
 DECLARE INTEGER ShellExecute IN shell32.dll ; 
  INTEGER hndWin, ; 
  STRING cAction, ; 
  STRING cFileName, ; 
  STRING cParams, ;  
  STRING cDir, ; 
  INTEGER nShowWin 
  
  arcimpresora = "C:\Program Files\SumatraPDF\SumatraPDF.exe"
  valemp = 0
  cantcopies=""
IF revalidar = 1
	IF FILE(ALLTRIM(archivost)) = .f.
		MESSAGEBOX("El Archivo No Se Logro Encontrar",64,"Archivo No Existe")
		RETURN .f.
	ENDIF
endif
DO case
	CASE FILE(arcimpresora) = .t. .and. ALLTRIM(UPPER(tipost))=='PDF'		
		cantcopies = IIF(copiasst>0,','+ALLTRIM(STR(copiasst))+'x','')
		cAction = "open"
		cFileName = arcimpresora
		cParams = '-print-to-default -print-settings "paper=8 1/2x11'+cantcopies+'"  &archivost'					
OTHERWISE
	cAction = "print"
	cFileName = archivost
	cParams = ''			
ENDCASE
FOR opimp = 1 TO IIF(EMPTY(cantcopies)=.t.,copiasst,1)
	valemp = 0
	DO while valemp < 33
		valemp =ShellExecute(0, cAction, cFileName, cParams, "", 1) 
*!*			IF !EMPTY(cantcopies)
*!*				esperarTiempo(2,"Enviando Grupo Copia # "+cantcopies)	
*!*			endif
		IF valemp <= 32
			IF !EMPTY(cantcopies)
				FOR xop = 1 TO copiasst
					valemp =ShellExecute(0, 'print', archivost, '', "", 1)
*!*						esperarTiempo(2,"Utilizando Metodo Tradicional De Impresion Copia # "+allt(STR(xop)))
				next
			endif						
			IF revalidar = 1
				IF MESSAGEBOX("Problemas Al Intentar Imprimir, Desea Volverlo a Intentar",4+32+256,"Error Al Imprimir") = 7
					valemp = 33
				ENDIF
			ELSE
				valemp = 33
			endif
		ENDIF
	ENDDO
*!*		IF EMPTY(cantcopies)=.t. .and. copiasst > 1
*!*			esperarTiempo(2,"Enviando Copia # "+allt(STR(opimp)))
*!*		endif
next		  
RETURN IIF(valemp = 33,.f.,.t.)