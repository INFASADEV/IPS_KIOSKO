&&&& RECONEXION A SQL
PUBLIC MENSAJERECO,ORDPOPUP
STORE -1 TO ORDPOPUP
_SCREEN.SCALEMODE = 0
STORE "" TO SECUEN
FOR I=1 TO 10
	STORE 0 TO NETCOMPLETA
	STORE SECUEN+"." TO SECUEN
	STORE "Verificando Su Conexi�n Al Servidor De Datos &SECUEN" TO MENSAJERECO
	ORDPOPUP=ORDPOPUP+1
*!*	WAIT WINDOW "&MENSAJERECO"+"&SECUEN" AT INT(_SCREEN.HEIGHT/2), INT(_SCREEN.WIDTH/2 - LEN("&MENSAJERECO"+"&SECUEN")/2) TIMEOUT 1
	_SCREEN.POPUP&MPROGRA..INIT
	_SCREEN.POPUP&MPROGRA..olecontrol1.SHOW
	WAIT WINDOW "" TIMEOUT 1
	IF FILE("&IDMAP:\EXE\&SISTCONFIG")
		VALCONEC=SQLEXEC(HCONN,'USE &DATASQL')
		IF VALCONEC>0
			VALCONEC=SQLEXEC(CMFCONN,'USE &DATACMF')
			IF VALCONEC>0
				STORE "Su Conexi�n Est� Activa Completamente" TO MENSAJERECO
*!*					WAIT WINDOW "&MENSAJERECO" AT INT(_SCREEN.HEIGHT/2), INT(_SCREEN.WIDTH/2 - LEN("&MENSAJERECO")/2) TIMEOUT 1
				ORDPOPUP=ORDPOPUP+1
				_SCREEN.POPUP&MPROGRA..INIT
				_SCREEN.POPUP&MPROGRA..olecontrol1.SHOW
				WAIT WINDOW "" TIMEOUT 1
				RELEASE MENSAJERECO
				EXIT
			ELSE
				NETCOMPLETA=RECUPERARCONEC(VALCONEC)
			ENDIF
		ELSE
			NETCOMPLETA=RECUPERARCONEC(VALCONEC)
		ENDIF
	ELSE
		NETCOMPLETA=RECUPERARCONEC(0)
	ENDIF
	DO CASE
	CASE NETCOMPLETA=0
	CASE NETCOMPLETA=1
		STORE "Se Ha Perdido La Conexi�n Al Servidor Principal, El Sistema Intentar� Recuperarla..." TO MENSAJERECO
		ORDPOPUP=ORDPOPUP+1
*!*			WAIT WINDOW "&MENSAJERECO" AT INT(_SCREEN.HEIGHT/2), INT(_SCREEN.WIDTH/2 - LEN("&MENSAJERECO")/2) TIMEOUT 1
		_SCREEN.POPUP&MPROGRA..INIT
		_SCREEN.POPUP&MPROGRA..olecontrol1.SHOW
		WAIT WINDOW "" TIMEOUT 1
	CASE NETCOMPLETA=2
		STORE "Se Ha Perdido La Conexi�n Al Servidor De CMF Pero Puede Seguir Trabajando, Presione (ALT+F12) Para Intentar Nuevamente" TO MENSAJERECO
		ORDPOPUP=ORDPOPUP+1
*!*			WAIT WINDOW "&MENSAJERECO" AT INT(_SCREEN.HEIGHT/2), INT(_SCREEN.WIDTH/2 - LEN("&MENSAJERECO")/2) TIMEOUT 1
		_SCREEN.POPUP&MPROGRA..INIT
		_SCREEN.POPUP&MPROGRA..olecontrol1.SHOW
		WAIT WINDOW "" TIMEOUT 1
	CASE NETCOMPLETA=3
		STORE "Su Conexi�n Se Ha Recuperado Completamente" TO MENSAJERECO
		ORDPOPUP=ORDPOPUP+1
*!*			WAIT WINDOW "&MENSAJERECO" AT INT(_SCREEN.HEIGHT/2), INT(_SCREEN.WIDTH/2 - LEN("&MENSAJERECO")/2) TIMEOUT 2
		_SCREEN.POPUP&MPROGRA..INIT
		_SCREEN.POPUP&MPROGRA..olecontrol1.SHOW
		WAIT WINDOW "" TIMEOUT 1
		RELEASE MENSAJERECO
		EXIT
	ENDCASE
ENDFOR

PROCEDURE RECUPERARCONEC(VALCONEC)
IF VALCONEC<=0
	STORE 0 TO NETCOMPLETA
	STORE "Se Ha Perdido La Conexi�n Al Servidor, El Sistema Intentar� Recuperarla..." TO MENSAJERECO
*!*		WAIT WINDOW "&MENSAJERECO" AT INT(_SCREEN.HEIGHT/2), INT(_SCREEN.WIDTH/2 - LEN("&MENSAJERECO")/2) TIMEOUT 1
	STORE "Recuperando La Conexi�n..." TO MENSAJERECO
*!*		WAIT WINDOW "&MENSAJERECO" AT INT(_SCREEN.HEIGHT/2), INT(_SCREEN.WIDTH/2 - LEN("&MENSAJERECO")/2) NOWAIT
	PASSBD=INISISTEMA("DRIVERDB","PASSWORD",RUTAINI)
	USERBD=INISISTEMA("DRIVERDB","USER",RUTAINI)
	DSNNOMBRE=INISISTEMA("DRIVERDB","DSNNOMBRE",RUTAINI)
	DATASQL=INISISTEMA("DRIVERDB","DATA",RUTAINI)
	IDMAP=INISISTEMA("SISTEMA","MAPEOUNI",RUTAINI)  &&&&literal o unidad donde se crear� el mapeo
	RUTAUNIMAP=INISISTEMA("SISTEMA","SERVIDOR",RUTAINI)   &&&&&nombre del servidor de archivos del sistema
	USERUNIMAP=INISISTEMA("SISTEMA","USER",RUTAINI)   &&&&&usuario para la conexi�n con el servidor de archivos
	PASSUSERUNIMAP=INISISTEMA("SISTEMA","PASSWORD",RUTAINI)  &&&&&&password para la conexi�n con el servidor de archivos
&&&&&&&DATOS PARA CMF
	USERBDC=INISISTEMA("DRIVERCMF","USER",RUTAINI)
	PASSBDC=INISISTEMA("DRIVERCMF","PASSWORD",RUTAINI)
	DSNNOMBREC=INISISTEMA("DRIVERCMF","DSNNOMBRE",RUTAINI)
	DATACMF=INISISTEMA("DRIVERCMF","DATA",RUTAINI)
&&&&&&&&&&&&&&&&&&&&&&&&&
	PROC_CHECKREDES()
	IF FILE("&IDMAP:\EXE\&SISTCONFIG")
		STORE 1 TO NETCOMPLETA
		CONECTDATA(DSNNOMBRE,USERBD,PASSBD,"HCONN")  &&&&&&CONECTAR A LA BASE DE DATOS
		IF HCONN>0
			READY=SQLEXEC(HCONN,'USE &DATASQL')
			IF READY>0
				STORE 2 TO NETCOMPLETA
				CONECTDATA(DSNNOMBREC,USERBDC,PASSBDC,"CMFCONN")  &&&&&&CONECTAR A LA BASE DE DATOS
				IF CMFCONN>0
					READY=SQLEXEC(CMFCONN,'USE &DATACMF')
					IF READY>0
						STORE 3 TO NETCOMPLETA
*!*							Messagebox('Conexi�n Reestablecida Con �xito, Puede Seguir Trabajando',0+64+0,'Conexi�n A Base De Datos')
*!*							Store "Listo..." To MENSAJERECO
*!*							Wait Window "&MENSAJERECO" At Int(_Screen.Height/2), Int(_Screen.Width/2 - Len("&MENSAJERECO")/2) Timeout 1
					ELSE
*!*							Messagebox('Su Conexi�n Local Se Ha Reestablecido, Pero No Es Posible Conectar Con La Base De Datos De CMF, Notificar A Inform�tica',0+64+0,'Conexi�n base de Datos')
					ENDIF
				ELSE
*!*						Messagebox('Su Conexi�n Local Se Ha Reestablecido, Pero No Es Posible Conectar Con El Servidor De Datos De CMF, Notificar A Inform�tica',0+64+0,'Conexi�n base de Datos')
				ENDIF
			ELSE
*!*					Messagebox('No Es Posible Conectar Con La Base De Datos, Intenar De Nuevo Presionando (Alt+F12)',0+64+0,'Conexi�n A Base De Datos')
			ENDIF
		ELSE
*!*				Messagebox('No Es Posible Reconectar Con El Servidor De Datos, Intenar De Nuevo Presionando (Alt+F12),0+64+0,'CONEXI�N A Base DE DATOS')
		ENDIF
	ELSE
*!*			Messagebox("No Se Ha Podido Reconectar Al Servidor De Archivos Con La Unidad Mapeada &IDMAP, Intenar De Nuevo Presionando (Alt+F12)",64+0+0,"RECONEXION DEL SISTEMA &MPROGRA")
	ENDIF
ENDIF
RELEASE PASSBD,USERBD,DSNNOMBRE,USERUNIMAP,RUTAFOTOSEMP,PASSUSERUNIMAP
RETURN NETCOMPLETA
ENDPROC

PROCEDURE PROC_CHECKREDES  &&&&&&&&&&&&&&&VERIFICA EL ESTADO DE LAS REDES EN USO, MAPEA LA UNIDAD SI ES NECESARIO Y CONECTA, ELIMINA MAPEOS ANTIGUOS Y CONTROLA ACCESOS A REDES POR EL EXPLORADOR DE WINDOWS
STORE "C:\&MPROGRA"+"TMP\NMAPS.TXT" TO VARIMAP
IF FILE ('&VARIMAP')
	ERASE &VARIMAP
ENDIF
*!*	RUN NET USE >&VARIMAP
CMDRUN ("NET USE >&VARIMAP")
IF FILE("&VARIMAP")
	IF USED ('REDESMAP')
		USE IN REDESMAP
	ENDIF
	STORE "C:\&MPROGRA"+"TMP" TO PATHTEMP
	CREATE TABLE &PATHTEMP\REDESMAP.DBF FREE (CAMPO1 V(150))
	SELECT REDESMAP
	APPEND FROM '&VARIMAP' SDF
	SELECT REDESMAP
	GO TOP
	STORE .F. TO CONECTADO
	STORE '' TO XCV2
	STORE ATC('\',ALLTRIM(RUTAUNIMAP),1) TO POSX1
	STORE ATC('\',ALLTRIM(RUTAUNIMAP),3) TO POSX2
	STORE SUBSTR(RUTAUNIMAP,POSX1,POSX2-POSX1+1) TO RUTAUNIMAPTMP
	SCAN
		IF UPPER("&RUTAUNIMAPTMP")$ALLTRIM(UPPER(REDESMAP.CAMPO1)) OR  UPPER("&IDMAP:")$ALLTRIM(UPPER(REDESMAP.CAMPO1))
			IF UPPER(":")$ALLTRIM(UPPER(REDESMAP.CAMPO1))  &&&&&SI EXISTE UNA UNIDAD DE RED EN EL LISTADO, LA VERIFICA
				IF UPPER("&IDMAP:")$ALLTRIM(UPPER(REDESMAP.CAMPO1))  &&&&&&SI ESA UNIDAD DE RED ES LA QUE YO NECESITO Y ESTA DIRIJIDA AL MISMO SERVIDOR VERIFICA EL ESTADO
					IF UPPER("CONECTADO")$ALLTRIM(UPPER(REDESMAP.CAMPO1)) AND UPPER("&RUTAUNIMAPTMP")$ALLTRIM(UPPER(REDESMAP.CAMPO1))
						STORE .T. TO CONECTADO
						EXIT
					ELSE
*!*						RUN NET USE /DELETE &IDMAP: >NULL
						CMDRUN("NET USE /DELETE &IDMAP: >NULL")
					ENDIF
				ELSE
					STORE ATC(':',ALLTRIM(UPPER(REDESMAP.CAMPO1)),1) TO POS
					STORE SUBSTR(ALLTRIM(UPPER(REDESMAP.CAMPO1)),POS-1,1) TO MAPACTUAL
*!*					RUN NET USE /DELETE &MAPACTUAL: >NULL  &&&&ESTA MAPEADO PERO NO CON LA UNIDAD DE RED QUE SE NECESITA ACTUALMENTE
					CMDRUN("NET USE /DELETE &MAPACTUAL: >NULL")
				ENDIF
			ELSE
				STORE ATC('\',ALLTRIM(UPPER(REDESMAP.CAMPO1)),1) TO POS
				FOR I=POS TO LEN(ALLTRIM(REDESMAP.CAMPO1))-POS
					STORE SUBSTR(ALLTRIM(REDESMAP.CAMPO1),I,1) TO XCV
					IF XCV=' '
						EXIT
					ELSE
						XCV2=XCV2+XCV
					ENDIF
				ENDFOR
*!*				RUN NET USE /DELETE &XCV2 >NULL  &&&SI APARECE LA DIRECCION DE RED, SIN UNIDAD DE MAPEO, HAY QUE ELIMINARLA POR NOMBRE DE SERVIDOR
				CMDRUN("NET USE /DELETE &XCV2 >NULL")
			ENDIF
		ENDIF
	ENDSCAN
	IF CONECTADO=.T.
	ELSE
*!*		RUN NET USE &IDMAP: &RUTAUNIMAP /USER:&USERUNIMAP &PASSUSERUNIMAP&&&&&&MAPEAR LA UNIDAD
		CMDRUN("NET USE &IDMAP: &RUTAUNIMAP /USER:&USERUNIMAP &PASSUSERUNIMAP")
	ENDIF
	USE IN REDESMAP
	ERASE &PATHTEMP\REDESMAP.DBF

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&RECONECTAR TABLAS DE FOXPRO&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

	STORE 0 TO MAXTABLAS
	FOR R=1 TO 1000
		STORE ALLTRIM(STR(R)) TO OTAB
		SELECT &OTAB
		STORE ALIAS() TO NNOMTAB
		IF LEN(ALLTRIM(NNOMTAB))=0
			STORE 1000 TO R
		ELSE
			DIMENSION ARRAYTABLE[R,1]
			ARRAYTABLE[R,1]=NNOMTAB
			STORE R TO MAXTABLAS
		ENDIF
	ENDFOR

	OPEN DATABASE &IPSRUTAFINAL SHARED
	FOR V=1 TO MAXTABLAS
		STORE ALLTRIM(ARRAYTABLE[V,1]) TO TABLAREACTIV
		TRY
			IF USED ('&TABLAREACTIV')
			ELSE
				SELECT 0
				IF FILE('C:\&PIFOLDER\&TABLAREACTIV..DBF')
					USE C:\&PIFOLDER\&TABLAREACTIV..DBF
					SELECT &TABLAREACTIV
				ELSE
					USE &TABLAREACTIV
					SELECT &TABLAREACTIV
				ENDIF
			ENDIF
		CATCH
			PUBLIC MENSAJERECO
			STORE "Error Intentanto Reconectar Algunos Archivos" TO MENSAJERECO
			ORDPOPUP=ORDPOPUP+1
			_SCREEN.POPUP&MPROGRA..INIT
			_SCREEN.POPUP&MPROGRA..olecontrol1.SHOW
			WAIT WINDOW "" TIMEOUT 1
			RELEASE MENSAJERECO
*!*				MESSAGEBOX("Error Intentanto Reconectar Algunos Archivos",64+0+0,"RECONECTAR DATA")
		ENDTRY
	ENDFOR
ELSE
	PUBLIC MENSAJERECO
	STORE "Error Intentanto Reconectar Algunos Archivos" TO MENSAJERECO
	ORDPOPUP=ORDPOPUP+1
	_SCREEN.POPUP&MPROGRA..INIT
	_SCREEN.POPUP&MPROGRA..olecontrol1.SHOW
	WAIT WINDOW "" TIMEOUT 1
	RELEASE MENSAJERECO
*!*		MESSAGEBOX("No Se Pudieron Detectar Las Unidades De Red Activas")
ENDIF
ENDPROC
*****************************************************************************************************************************************

****************************************************************************************
PROCEDURE CMDRUN (CMDCOMANDO)
LOCAL OWSH
OWSH = CREATEOBJECT("WScript.Shell")
STORE "CMD /C "+"&cmdComando" TO CMDINSTRUC
OWSH.RUN("&cmdinstruc",0,.T.)
ENDPROC


