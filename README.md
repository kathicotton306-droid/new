# NEBULA OMEGA — Professional Desktop Edition

A dedicated Windows desktop application using Tauri 2 and Microsoft Edge WebView2. Includes a NEBULA custom ICO icon, four interactive cinematic WebGL scenes, and an NSIS Windows installer configuration.

## What is protected?

The release build minifies and obfuscates its JavaScript using Terser and javascript-obfuscator. This discourages casual inspection but **does not encrypt the code or prevent reverse engineering**. It does not hide the fact that WebView2 uses web technology.

## Build on Windows 10/11

Install Node.js LTS, Rust (MSVC toolchain), Microsoft C++ Build Tools, and WebView2 Runtime. Then in PowerShell:

```powershell
.\scripts\Build-Windows.ps1
```

Or run:

```powershell
npm install
npm run build:nsis
```

Find the unsigned installer in `src-tauri\target\release\bundle\nsis\`.

## Code signing

For verified publisher identity, sign the compiled EXE and installer using a legitimate trusted code-signing certificate. The existing `scripts/Sign-Installer.ps1` provides a starting point for signing the installer. Signing alone does not guarantee that SmartScreen reputation warnings will disappear immediately. Do not disable SmartScreen to work around warnings.

## Important limitations

- This ZIP contains a **buildable source project**, not a prebuilt Windows installer or signed executable. Windows compilation and launch have not been tested here.
- A first build needs internet to download npm and Rust dependencies.
- This is an offline-rendering app after installation; WebView2 is required.
- The rendering is the stable ray-marching/WebGL version, **not** a physically accurate production path tracer.
- Keep the source code private if you do not want others to inspect the unobfuscated original. Only distribute the compiled installer.

## Build an installer without installing developer tools on your PC

A GitHub Actions workflow is included at `.github/workflows/windows-installer.yml`.

1. Create a **private** GitHub repository and upload the contents of this project (the `package.json` file must be at repository root). Make sure hidden `.github` is included.
2. In GitHub, open **Actions** and select **Build NEBULA OMEGA Windows Installer**.
3. Click **Run workflow** and wait for the Windows build to finish.
4. Open the completed workflow and download the `NEBULA-OMEGA-Windows-Installer-unsigned` artifact.
5. Extract the downloaded artifact ZIP, then run the installer on Windows 10/11.

The installer is **unsigned** and may show a Microsoft Defender SmartScreen warning. For trusted public distribution, use a genuine code-signing certificate and establish application reputation. The GitHub workflow requires network access to download dependencies and may need adjustment if upstream packages change.
