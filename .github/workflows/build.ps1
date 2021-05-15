param (
    [Parameter(Mandatory)] $vs,
    [Parameter(Mandatory)] $arch
)

$ErrorActionPreference = "Stop"

if ($vs -eq "vc15") {
    $slndir = "MSVC15"
} else {
    $slndir = "MSVC16"
}

if ($arch -eq "x86") {
    $platform = "Win32"
} else {
    $platform = "x64"
}

Set-Location $slndir
msbuild /t:Rebuild /p:Configuration=Release /p:Platform=$platform /p:WindowsTargetPlatformVersion=10.0.19041.0 libiconv.sln
msbuild /t:Rebuild /p:Configuration=Debug /p:Platform=$platform /p:WindowsTargetPlatformVersion=10.0.19041.0 libiconv.sln

Set-Location ..
New-Item winlib_build\bin -ItemType directory
Copy-Item $slndir\$platform\bin\*.dll -Destination winlib_build\bin
Copy-Item $slndir\$platform\bin\*.pdb -Destination winlib_build\bin
New-Item winlib_build\include -ItemType directory
Copy-Item source\include\iconv.h -Destination winlib_build\include
New-Item winlib_build\lib -ItemType directory
Copy-Item $slndir\$platform\lib\*.lib -Destination winlib_build\lib
Copy-Item $slndir\$platform\lib\*.pdb -Destination winlib_build\lib
