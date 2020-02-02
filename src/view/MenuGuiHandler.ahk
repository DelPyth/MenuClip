﻿;Handles changes to the menu
class MenuGuiHandler {
	__New(menuGui) {
		this.menuGui := menuGui
		hideGuiOnOutsideClickFn := ObjBindMethod(this, "watchMouseClickAndHideGuiOnOutsideClick")
		Hotkey, LButton, % hideGuiOnOutsideClickFn
		Hotkey, LButton, Off
		hideGuiOnEscOrWinFn := ObjBindMethod(this, "hideGuiOnEscOrWin")
		Hotkey, Escape, % hideGuiOnEscOrWinFn
		;Hotkey, Escape, Off
	}
	
	populateMenuFromArray(arr) {
		GuiControl, -Redraw, % this.menuGui.HANDLE_CLIPS_VIEW
		Loop, % loopIndex := arr.maxIndex()
			this.menuGui.insertItemAtTop(arr[loopIndex--])
		GuiControl, +Redraw, % this.menuGui.HANDLE_CLIPS_VIEW
	}
	
	watchMouseClickAndHideGuiOnOutsideClick() {
		MouseGetPos, , , windowClicked
		Click
		Gui ClipMenu:Hide
		if(windowClicked = this.GUI_WINDOW_ID) {
			this.menuGui.onItemClickFn.call(this.getControlValue(this.menuGui.HANDLE_CLIPS_VIEW))
		}
		Hotkey, LButton, Off
		Send, {Ctrl up} ;depresses Ctrl if you're using Ctrl in the showMenu shortcut
	}
	
	pasteSelectedOnEnter() {
		Gui ClipMenu:Hide
		this.menuGui.onItemClickFn.call(this.getControlValue(this.menuGui.HANDLE_CLIPS_VIEW))
		Hotkey, LButton, Off
		Send, {Ctrl up}
	}
	
	getControlValue(hWnd) {
		GuiControlGet, tmp,, %hWnd%
		return tmp
	}
	
	hideGuiOnEscOrWin() {
		MsgBox hi
		;Gui ClipMenu:Hide
		Hotkey, Escape, Off
	}
	
	showGui() {
		GuiControl, Choose, % this.menuGui.HANDLE_CLIPS_VIEW, 1
		Hotkey, LButton, On
		Hotkey, Escape, On
		MouseGetPos, mouseXPos, mouseYPos
		Gui ClipMenu:Show, x%mouseXPos% y%mouseYPos%
	}
}