# Batch-Library-Manager
Simple batch tool to add and remove network shares or folders from Windows 7+ libraries.

## Usage
To add a folder to a library, use the following command:

    library -a X:\path\to\folder LibraryName

To add a network share to a library, use the following command:

    library -a \\unc\path\to\folder LibraryName

<br />

To remove  a folder (both shared and local) from a library, use the following command:

    library -r folderName LibraryName



## Third-Party dependencies
To use the tool, you need a single executable from Microsoft, ShLib.exe, which is available as source code [here](http://msdn.microsoft.com/en-us/library/dd940379%28VS.85%29.aspx). **A compiled version is included in this package.**
