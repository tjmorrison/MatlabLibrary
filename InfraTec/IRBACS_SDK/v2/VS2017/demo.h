// demo.h : Haupt-Header-Datei für die Anwendung DEMO
//

#if !defined(AFX_DEMO_H__2DDD2ED6_E2C1_44B4_AB6F_E8CE0E33319C__INCLUDED_)
#define AFX_DEMO_H__2DDD2ED6_E2C1_44B4_AB6F_E8CE0E33319C__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// Hauptsymbole

/////////////////////////////////////////////////////////////////////////////
// CDemoApp:
// Siehe demo.cpp für die Implementierung dieser Klasse
//

class CDemoApp : public CWinApp
{
public:
	CDemoApp();

// Überladungen
	// Vom Klassenassistenten generierte Überladungen virtueller Funktionen
	//{{AFX_VIRTUAL(CDemoApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementierung

	//{{AFX_MSG(CDemoApp)
		// HINWEIS - An dieser Stelle werden Member-Funktionen vom Klassen-Assistenten eingefügt und entfernt.
		//    Innerhalb dieser generierten Quelltextabschnitte NICHTS VERÄNDERN!
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ fügt unmittelbar vor der vorhergehenden Zeile zusätzliche Deklarationen ein.

#endif // !defined(AFX_DEMO_H__2DDD2ED6_E2C1_44B4_AB6F_E8CE0E33319C__INCLUDED_)
