# Batch-Library-Manager
Simple batch tool to add and remove network shares or folders from Windows 7+ libraries. It is well suited for netlogon scripts or otherwise automating library tasks.

## Usage
To add a folder to a library, use the following command:

    library -a X:\path\to\folder LibraryName

To add a network share to a library, use the following command:

    library -a \\unc\path\to\folder LibraryName

<br />

To remove  a folder (both shared and local) from a library, use the following command:

    library -r folderName LibraryName


#### Command format
As I tend to work on multiple platforms, I often mix switch formats (`-a`, `/a` etc.). So for your enlightment, you can use the following schemes:

|   Switch   | Slash | Dash | Double-Dash |
|:----------:|:-----:|:----:|:-----------:|
|  **Add**   | `/a`  | `-a` |   `--add`   |
| **Remove** | `/r`  | `-r` | `--remove`  |
|  **Help**  | `/?`  | `-h` |  `--help`   |

#### Third-Party dependencies
To use the tool, you need a single executable from Microsoft, ShLib.exe, which is available as source code [here](http://msdn.microsoft.com/en-us/library/dd940379%28VS.85%29.aspx).  
**A compiled version is included in this package.**
