$QemuEXE = (Get-ChildItem -Path "$env:USERPROFILE\Software" `
          | ?{ $_.PSIsContainer } `
          | Where-Object {$_.Name -match ([regex]::Escape("qemu"))} `
          | Sort-Object FullName `
          | Select-Object -Last 1 `
          | Get-ChildItem `
          | Where-Object {$_.Name -match ([regex]::Escape("qemu-img.exe"))} `
          | Select-Object -Last 1).Fullname

$SourceFile = (Get-ChildItem `
             | ?{ ! $_.PSIsContainer } `
             | Where-Object {$_.Name -match ([regex]::Escape(".vmdk"))} `
             | Select-Object -Last 1).Fullname

$DestinationFile = [System.IO.Path]::GetDirectoryName($SourceFile) `
                 + "\" `
                 + [System.IO.Path]::GetFileNameWithoutExtension($SourceFile) `
                 + ".vhdx"

& $QemuEXE convert $SourceFile -O vhdx -o subformat=dynamic -o block_size=1 $DestinationFile
