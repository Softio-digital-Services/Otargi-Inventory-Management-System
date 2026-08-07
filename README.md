# Otargi Inventory — Web-Based

Desktop host (WinForms + WebView2) that serves the Otargi web SPA from `wwwroot/` and an embedded ASP.NET Core API on port 5000. Data is stored in SQLite.

## Requirements

- Windows 10/11
- [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- WebView2 Runtime (usually preinstalled on Windows 11)

## Run

```powershell
dotnet restore
dotnet build -c Release
dotnet run -c Release --project OtargiInventorySystem.csproj
```

Or launch the built exe from `bin\Release\net8.0-windows\win-x64\`.

## Layout

| Path | Purpose |
|------|---------|
| `wwwroot/` | Web UI (HTML/CSS/JS) |
| `Program.cs` | App entry, license gate, embedded API |
| `Forms/WebServerHostForm.cs` | WebView2 host shell |
| `Forms/LicenseActivationForm.cs` | License activation UI |
| `Services/` | Business / data services used by the API |
| `Helpers/` | DB, license, print, theme, i18n helpers |
| `Assets/` | Icons and branding assets |
| `appsettings.json` | Branding and config |

## Notes

- This repo contains **only** the web-hosted app (not the legacy WinForms POS screens).
- After changing `wwwroot` files, rebuild or copy them next to the exe so `Content` copy picks them up.
- Thermal receipt/barcode printing goes through the host (`printReceipt` / `printBarcodes` WebView messages).
