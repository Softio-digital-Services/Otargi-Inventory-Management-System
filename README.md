# Otargi Inventory — Web-Based

Web-hosted Otargi only (WebView2 + embedded API + `wwwroot`). No legacy WinForms POS screens.

## Run (no build)

```text
dist\app\OtargiInventorySystem.exe
```

Or install with:

```text
dist\OtargiSetup.exe
```

## Develop

Requires [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) and WebView2 Runtime.

```powershell
dotnet restore
dotnet build -c Release
dotnet run -c Release --project OtargiInventorySystem.csproj
```

Edit UI under `wwwroot/`. Edit host/API under `Program.cs`, `Forms/`, `Services/`, `Helpers/`.

## Refresh the runnable build

After source changes, republish exe + setup:

```powershell
powershell -ExecutionPolicy Bypass -File .\installer\build.ps1
```

## Layout

| Path | Purpose |
|------|---------|
| `wwwroot/` | Web UI source |
| `Program.cs` / `Forms/` / `Services/` / `Helpers/` | Host + API |
| `dist/app/` | Published app (open the exe) |
| `dist/OtargiSetup.exe` | Windows installer |
| `installer/` | Publish + Inno Setup scripts |
