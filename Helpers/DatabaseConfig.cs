using System;
using System.IO;
using System.Windows.Forms;
using System.Text.Json;

namespace InventorySystem
{
    /// <summary>
    /// Centralized database and file path configuration (SQLite)
    /// </summary>
    public static class DatabaseConfig
    {
        /// <summary>
        /// The SQLite database file is stored next to the .exe in a /Data subfolder.
        /// This works on any Windows PC without any SQL Server installation.
        /// </summary>
        public static string ConnectionString
        {
            get
            {
                string dbPath = DatabasePath;
                // Ensure directory exists
                string dir = Path.GetDirectoryName(dbPath);
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);

                return $"Data Source={dbPath};";
            }
        }

        /// <summary>
        /// Full path to the SQLite .db file.
        /// Stored under LocalAppData so it works when installed to Program Files.
        /// </summary>
        public static string DatabasePath
        {
            get
            {
                string dir = Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                    "OtargiInventory", "Data");
                if (!Directory.Exists(dir))
                    Directory.CreateDirectory(dir);

                string path = Path.Combine(dir, "inventory.db");

                // One-time migrate from old Program Files / exe-side Data folder
                try
                {
                    if (!File.Exists(path))
                    {
                        string legacy = Path.Combine(Application.StartupPath, "Data", "inventory.db");
                        if (File.Exists(legacy))
                            File.Copy(legacy, path, false);
                    }
                }
                catch { }

                return path;
            }
        }

        /// <summary>
        /// Gets the parts images directory path (writable user data location).
        /// </summary>
        public static string PartsImagesDirectory
        {
            get
            {
                string imagesPath = Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                    "OtargiInventory", "Parts_Images");
                if (!Directory.Exists(imagesPath))
                    Directory.CreateDirectory(imagesPath);
                return imagesPath;
            }
        }
    }
}
