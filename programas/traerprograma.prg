**************traer un programa enfrende**************
*!*	#DEFINE SW_RESTORE 9
*!*	#DEFINE WINNAME [Picking List]
*!*	#DEFINE wclass 0
*!*	************
*!*	DECLARE INTEGER GetActiveWindow IN Win32API
*!*	DECLARE INTEGER GetWindowText IN Win32API ;
*!*	***********
*!*	DECLARE INTEGER BringWindowToTop IN WIN32API ;
*!*	    LONG HWND
*!*	DECLARE INTEGER ShowWindow IN WIN32API AS APIShowWin  ;
*!*	    LONG HWND, LONG nCmdShow
*!*	DECLARE INTEGER FindWindow IN WIN32API AS GetWind STRING,STRING

*!*	apphand = GetWind(wclass, WINNAME)
*!*	nHandle = GetActiveWindow()
*!*	nHandlet = GetWindowText ()
*!*	MESSAGEBOX(nHandlet)
*!*	IF apphand <> 0
*!*	    = APIShowWin(apphand, SW_RESTORE)
*!*	    = BringWindowToTop(apphand)
*!*	    = GetActiveWindow() 
*!*	*ELSE
*!*	 *   RUN /N notepad.exe
*!*	*    RUN /N kioscopickinglist.exe
*!*	ENDIF

*!*	CLEAR DLLS
*!*	MOUSE DRAG TO 5,5
*!*	MOUSE CLICK 

*!*	#Define MOUSEEVENTF_RESET 1
*!*	#Define MOUSEEVENTF_LEFTDOWN 2
*!*	#Define MOUSEEVENTF_LEFTUP 4
*!*	#Define MOUSEEVENTF_RIGHTDOWN 8
*!*	#Define MOUSEEVENTF_RIGHTUP 16
*!*	#Define MOUSEEVENTF_MIDDLEDOWN 32
*!*	#Define MOUSEEVENTF_MIDDLEUP 64
*!*	#Define MOUSEEVENTF_MIDDLEUP_WHEEL_MOVED 128
*!*	Declare mouse_event In user32.Dll Long,Long,Long,Long,Long
*!*	=mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,0)


*-- Declare two API functions
*!*	DECLARE INTEGER GetActiveWindow IN Win32API
*!*	DECLARE INTEGER GetWindowText IN Win32API ;
*!*	 INTEGER, STRING @, INTEGER
*!*	*-- Get the handle to the main VFP window
*!*	nHandle = GetActiveWindow()
*!*	*-- Initialize variables
*!*	lcText = SPACE(100)
*!*	lnSize = LEN(lcText)
*!*	*-- Call the API function
*!*	lnSize = GetWindowText(nHandle, @lcText, lnSize)
*!*	*-- Use the resulting value
*!*	IF lnSize > 0
*!*	 MESSAGEBOX(LEFT(lcText, lnSize))
*!*	ENDIF

LOCAL hWindow,lcText,lnLength,lcTitle 

DECLARE INTEGER GetForegroundWindow IN user32
DECLARE INTEGER GetWindowText IN Win32API ;
    INTEGER hWnd ,;
    STRING @cText ,;
    INTEGER nType
STORE '' TO nombrex
hWindow = GetForegroundWindow()
lcText     = SPACE(250)
lnLength = GetWindowText(hWindow,@lcText,LEN(lcText))
lcTitle = LEFT(lcText,lnLength)
nombrex = lcTitle 
*!*	IF 'Picking'$nombrex = .f.
*!*		#DEFINE SW_RESTORE 9
*!*		#DEFINE WINNAME [Picking List]
*!*		#DEFINE wclass 0
*!*		************
*!*		DECLARE INTEGER GetActiveWindow IN Win32API
*!*		DECLARE INTEGER GetWindowText IN Win32API ;
*!*		***********
*!*		DECLARE INTEGER BringWindowToTop IN WIN32API ;
*!*		    LONG HWND
*!*		DECLARE INTEGER ShowWindow IN WIN32API AS APIShowWin  ;
*!*		    LONG HWND, LONG nCmdShow
*!*		DECLARE INTEGER FindWindow IN WIN32API AS GetWind STRING,STRING

*!*		apphand = GetWind(wclass, WINNAME)
*!*		nHandle = GetActiveWindow()
*!*		nHandlet = GetWindowText ()
*!*		IF apphand <> 0
*!*		    = APIShowWin(apphand, SW_RESTORE)
*!*		    = BringWindowToTop(apphand)
*!*		    = GetActiveWindow() 
*!*		ENDIF
*!*	*!*		#Define MOUSEEVENTF_RESET 1
*!*	*!*		#Define MOUSEEVENTF_LEFTDOWN 2
*!*	*!*		#Define MOUSEEVENTF_LEFTUP 4
*!*	*!*		#Define MOUSEEVENTF_RIGHTDOWN 8
*!*	*!*		#Define MOUSEEVENTF_RIGHTUP 16
*!*	*!*		#Define MOUSEEVENTF_MIDDLEDOWN 32
*!*	*!*		#Define MOUSEEVENTF_MIDDLEUP 64
*!*	*!*		#Define MOUSEEVENTF_MIDDLEUP_WHEEL_MOVED 128
*!*	*!*		Declare mouse_event In user32.Dll Long,Long,Long,Long,Long
*!*	*!*		=mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,0)
*!*	ENDIF
RETURN nombrex
