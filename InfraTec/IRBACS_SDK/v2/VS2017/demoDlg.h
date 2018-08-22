// demoDlg.h : Header-Datei
//

#if !defined(AFX_DEMODLG_H__2F020E8D_F184_4515_A9DC_3E26FBDF00F0__INCLUDED_)
#define AFX_DEMODLG_H__2F020E8D_F184_4515_A9DC_3E26FBDF00F0__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "afxwin.h"
#include "afxcmn.h"
#include "hIRBACS.h"
#include "hGlobal.h"



/////////////////////////////////////////////////////////////////////////////
// CDemoDlg Dialogfeld

class CDemoDlg : public CDialog
{
// Konstruktion
public:
	CDemoDlg(CWnd* pParent = NULL);	// Standard-Konstruktor

// Dialogfelddaten
	//{{AFX_DATA(CDemoDlg)
	enum { IDD = IDD_DEMO_DIALOG };
	CButton	m_ButtonGrab;
	CButton	m_ButtonConnect;
	CButton m_CheckBox1;
	CMFCDynamicLayout m_PropertyList;
	
	//}}AFX_DATA

	// Vom Klassenassistenten generierte Überladungen virtueller Funktionen
	//{{AFX_VIRTUAL(CDemoDlg)
	public:
	virtual BOOL DestroyWindow();
	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV-Unterstützung
	//}}AFX_VIRTUAL

// Implementierung
protected:
	HICON m_hIcon;

	// Generierte Message-Map-Funktionen
	//{{AFX_MSG(CDemoDlg)
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();

	//}}AFX_MSG

	DECLARE_MESSAGE_MAP()

private:

public:

private:

public:

private:
	CButton btnLoadLib;
public:
	afx_msg void OnBnClickedBtnloadlib();
	CEdit edtCoordX;
	CEdit edtCoordY;
	CSpinButtonCtrl spnCoordX;
	CSpinButtonCtrl spnCoordY;
	afx_msg void OnDeltaposSpinCordx(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnDeltaposSpinCoordy(NMHDR *pNMHDR, LRESULT *pResult);
	CSpinButtonCtrl spnFrameIndex;
	CEdit edtFrameIndex;
	afx_msg void OnEnChangeEditFrameindex();
	afx_msg void OnDeltaposSpinFrameindex(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnEnChangeEditCoordx();
	afx_msg void OnEnChangeEditCoordy();
	CEdit edtFrameCount;
	afx_msg void OnEnUpdateEditFramecounts();
	CEdit edtFilename;
	CEdit edtParam0;
	CEdit edtParam1;
	CEdit edtParam2;
	CEdit edtParam3;
	CEdit edtParam4;
	CEdit edtParam5;
	CEdit edtParam6;
	CEdit edtParam7;
	CEdit edtParam8;
	CEdit edtParam9;
	CEdit edtParam10;
	CEdit edtParam11;
	CEdit edtParam12;
	CEdit edtParam13;
	CEdit edtParam14;
	CStatic imgIRBpicture;
	CStatic lblImage2;
	afx_msg void OnBnClickedButton4();
	CStatic lblParam0;
	CStatic lblParam1;
	CStatic lblParam2;
	CStatic lblParam3;
	CStatic lblParam4;
	CStatic lblParam5;
	CStatic lblParam6;
	CStatic lblParam7;
	CStatic lblParam8;
	CStatic lblParam9;
	CStatic lblParam10;
	CStatic lblParam11;
	CStatic lblParam12;
	CStatic lblParam13;
	CStatic lblParam14;
	CStatic lblFrameCounts;
	CStatic lblFrameIndex;
	CStatic lblCoordX;
	CStatic lblCoordY;
	CEdit edtTempBlackbody;
	CEdit edtTemp;
	afx_msg void OnEnChangeEdtblackbody();
	CStatic lblBlackbody;
	CStatic lblTemp;
	CStatic lblPath;
	CButton btnRepaint;
};



//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ fügt unmittelbar vor der vorhergehenden Zeile zusätzliche Deklarationen ein.

#endif // !defined(AFX_DEMODLG_H__2F020E8D_F184_4515_A9DC_3E26FBDF00F0__INCLUDED_)
