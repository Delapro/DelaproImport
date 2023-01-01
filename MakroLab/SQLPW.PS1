# Datext SQL Passwort - nur als Gedankenstütze

$ToDecrypt = "c9qhBWuy8I41c75o25CACzvkEN1HjWye14LqNqacylU="   # User
$CryptCode = "#2fI+0x"
$str1 = "#2fI+0x"

$md5SP = New-Object System.Security.Cryptography.MD5CryptoServiceProvider
$key = $md5SP.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($str1))
$md5SP.Clear()

$rijndael = New-Object System.Security.Cryptography.RijndaelManaged
$size = 16

$bytes = [System.Convert]::FromBase64String($ToDecrypt)
$ms = New-Object System.IO.MemoryStream -ArgumentList (,$bytes)  # , ist wichtig!
$byteArray = [Byte[]]0x0 * $size
$ms.Read($byteArray, 0, $size)

$rijndael.IV = $byteArray
$rijndael.Key = $key

$b2 = New-Object System.Security.Cryptography.CryptoStream($ms,$rijndael.CreateDecryptor(),[System.Security.Cryptography.CryptoStreamMode]::Read)
#$numArray2 = [Byte[]](([int]$ms.Length - [long]$size)+1)
$numArray2 = [Byte[]]0x0 * 17
$num1 = [int]$b2.Read($numArray2,0,$numArray2.Length-1)

# Die Fehlermeldung "Zeichenabstände sind ungültig und können nicht entfernt werden."
# bezieht sich auf das Padding der Bytes!!!!! Leider funktioniert es in C# korrekt aber in Powershell irgendwie nicht!


$str2 = [System.Text.Encoding]::UTF8.GetString($numArray2,0,$num1)
$b2.Close()
$rijndael.Clear()


$str2
