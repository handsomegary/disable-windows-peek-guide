# Disable Windows Peek and Taskbar Preview Guide

This repository explains how to reduce or disable Windows hover previews such as
Peek, Aero Peek, and taskbar thumbnail previews.

The short version:

- Windows still has a supported setting for desktop Peek.
- Modern Windows 11 builds may not provide a supported built-in way to fully
  disable taskbar thumbnail previews.
- A practical workaround is to delay taskbar previews so they do not appear
  during normal mouse movement.

## What This Fixes

Windows has two similar hover behaviors:

1. **Desktop Peek**
   - Moving the mouse to the far-right taskbar edge can temporarily show the
     desktop.

2. **Taskbar thumbnail previews**
   - Hovering over an app icon on the taskbar can show preview windows.
   - This is the annoying one when previews cover the current app.

Depending on your Windows 11 version, these may be controlled separately.

## Method 1: Disable Peek From Windows Settings

Try the built-in setting first.

1. Right-click the taskbar.
2. Select **Taskbar settings**.
3. Open **Taskbar behaviors**.
4. Turn off **Use Peek to preview the desktop when you move your mouse to the
   Show desktop button at the end of the taskbar**.

This mainly affects desktop Peek, not always taskbar thumbnail previews.

## Method 2: Disable Peek From Performance Options

This older Windows setting may still help on some systems.

1. Press `Win + R`.
2. Type:

   ```text
   sysdm.cpl
   ```

3. Open the **Advanced** tab.
4. Under **Performance**, click **Settings**.
5. Open the **Visual Effects** tab.
6. Uncheck **Enable Peek**.
7. Click **Apply** and **OK**.
8. Restart Windows, or restart File Explorer.

## Method 3: Delay Taskbar Thumbnail Previews

If Windows 11 will not fully disable taskbar previews, delay them instead.

This makes previews appear only after a long hover time, such as 30 seconds.

### Registry Path

```text
HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced
```

### Value

```text
Name: ExtendedUIHoverTime
Type: DWORD (32-bit)
Value: 30000
Base: Decimal
```

`30000` means 30,000 milliseconds, or 30 seconds.

### PowerShell Option

You can run this from PowerShell:

```powershell
New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Force | Out-Null
New-ItemProperty `
  -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" `
  -Name "ExtendedUIHoverTime" `
  -PropertyType DWord `
  -Value 30000 `
  -Force
Stop-Process -Name explorer -Force
```

Explorer should restart automatically. If it does not, sign out and sign back
in, or restart Windows.

## Scripts

This repository includes two helper scripts.

Set the delay:

```powershell
.\scripts\set-taskbar-preview-delay.ps1 -DelayMilliseconds 30000 -RestartExplorer
```

Restore the default behavior:

```powershell
.\scripts\restore-taskbar-preview-delay.ps1 -RestartExplorer
```

## Important Windows 11 Note

Recent Windows 11 builds, especially 24H2 and newer, may ignore older methods
that used to disable taskbar thumbnails completely. Microsoft community answers
currently indicate that there may be no supported built-in switch to fully turn
off taskbar thumbnail previews on those builds.

Because of that, this guide recommends:

1. Try the supported Windows settings first.
2. If previews still appear, use `ExtendedUIHoverTime` to delay them.
3. Avoid editing system DLLs or using unsafe system patches.

## Sources

- [Microsoft Support: Customize the taskbar in Windows](https://support.microsoft.com/en-US/Windows/Experience/Personalization/customize-the-taskbar-in-windows)
- [Microsoft Q&A: Windows 11 taskbar preview cannot be disabled through standard settings](https://learn.microsoft.com/en-us/answers/questions/5706626/windows-11-how-to-disable-the-preview-on-the-task)
- [Microsoft Q&A: Windows 11 24H2 taskbar thumbnail behavior](https://learn.microsoft.com/en-us/answers/questions/5529569/disable-windows-11-aero-peek-%28windows-11-pro-versi)
- [Microsoft Q&A: Windows 11 25H2 thumbnail preview behavior](https://learn.microsoft.com/zh-cn/answers/questions/5903156/kb5089549)

