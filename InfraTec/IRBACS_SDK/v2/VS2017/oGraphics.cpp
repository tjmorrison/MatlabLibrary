#include "StdAfx.h"
#include "hGraphics.h"
#include "hGlobal.h"


void oGraphicControl::Init(CWnd *Wnd, CWnd *ParenWnd)
{
	GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
	myControl = Wnd;
	pMyGraphic = new Graphics(*myControl);
	ClearGraphic();
	
}

void oGraphicControl::DeInit(void)
{
	ClearGraphic();
	myControl = NULL;
	delete(pMyGraphic);
	pMyGraphic = NULL;
	GdiplusShutdown(gdiplusToken);
}

void oGraphicControl::Reset(void)
{
	if (pMyGraphic == NULL) { return; }
	delete pMyGraphic;
	GdiplusShutdown(gdiplusToken);

	GdiplusStartup(&gdiplusToken, &gdiplusStartupInput, NULL);
	pMyGraphic = new Graphics(*myControl);
}


void oGraphicControl::DrawingBitmap(Bitmap *MyBitmap)
{
	if (MyBitmap == NULL) { return; }

	ClearGraphic();
	pMyGraphic->DrawImage(MyBitmap, 0, 0);
}

void oGraphicControl::ClearGraphic(void)
{
	if (pMyGraphic == NULL) { return; }
	pMyGraphic->Clear(Color(255, 255, 255));
}
