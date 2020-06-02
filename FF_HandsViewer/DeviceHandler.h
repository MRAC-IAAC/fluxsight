
#include <Windows.h>
#include <WindowsX.h>
#include "pxcsession.h"
#include "pxccapturemanager.h"

class DeviceHandler: public PXCCapture::Handler {

private:

public:

	HWND hwndDlg;
	void (*PopulateDevice)(HWND hwndDlg);

	virtual void PXCAPI OnDeviceListChanged(void) 
	{
		// Callback
		PopulateDevice(hwndDlg);

	}

};
