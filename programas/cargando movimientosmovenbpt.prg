STORE "" TO QUEVERPEDM1
SCAN 
	SET STEP ON 
	WAIT WINDOW lote TIMEOUT 1
	TEXT TO QUEVERPEDM TEXTMERGE NOSHOW
		INSERT INTO MoviEnBodegaBpt (numeroref,lote,codigo,cantidad,fecha,iduser,habilitado,tipomov,estadoPres,Bodega,tipoPrecio) values
		('0002FF002200166613456','<<ALLTRIM(lote)>>','<<ALLTRIM(codigo)>>',<<cantidad>>,CURRENT_TIMESTAMP,121,1,1,1,'<<ALLTRIM(codbo)>>','<<ALLTRIM(tipoprecio)>>')
	ENDTEXT
	QUEVERPEDM1 = QUEVERPEDM1 + CHR(13) + QUEVERPEDM 
	_cliptext = QUEVERPEDM 	
endscan