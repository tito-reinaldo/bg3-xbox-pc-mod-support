Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$script:TaskWork=Split-Path -Parent $PSScriptRoot
$script:TaskLibraryDir=Join-Path $script:TaskWork 'Manager\_Lib'
foreach($taskDll in @('LZ4pn.dll','LZ4.dll','ZstdSharp.dll','LSLib.dll')){[Reflection.Assembly]::LoadFrom((Join-Path $script:TaskLibraryDir $taskDll))|Out-Null}
function Read-BoundedPakText {
  param($Entry,[int]$MaxCharacters=2097152)
  $reader=[IO.StreamReader]::new($Entry.CreateContentReader())
  try {
    $text=[Text.StringBuilder]::new();$buffer=[char[]]::new(8192)
    while(($n=$reader.Read($buffer,0,$buffer.Length))-gt 0){
      if($text.Length+$n-gt $MaxCharacters){throw 'Package metadata exceeds the size limit.'}
      [void]$text.Append($buffer,0,$n)
    }
    return $text.ToString()
  }finally{$reader.Dispose()}
}
function Read-BG3PakMetadata {
  [CmdletBinding()]param([Parameter(Mandatory)][string]$Path)
  $taskPak=[LSLib.LS.PackageReader]::new().Read([IO.Path]::GetFullPath($Path),$false)
  try {
    $taskMetas=@($taskPak.Files|Where-Object{$_.Name -match '^Mods/[^/]+/meta\.lsx$'})
    foreach($taskMeta in $taskMetas){
      $taskXml=[xml]::new();$taskXml.XmlResolver=$null
      $xmlSettings=[Xml.XmlReaderSettings]::new();$xmlSettings.DtdProcessing=[Xml.DtdProcessing]::Prohibit;$xmlSettings.XmlResolver=$null;$xmlSettings.MaxCharactersInDocument=2097152
      $taskReader=[Xml.XmlReader]::Create([IO.StringReader]::new((Read-BoundedPakText $taskMeta)),$xmlSettings)
      try{$taskXml.Load($taskReader)}finally{$taskReader.Dispose()}
      $taskNode=$taskXml.SelectSingleNode('//node[@id="ModuleInfo"]')
      if(!$taskNode){continue}
      $taskAttributes=@{}
      foreach($taskAtt in $taskNode.SelectNodes('./attribute')){$taskAttributes[$taskAtt.id]=$taskAtt.value}
      $taskDependencies=@(foreach($taskDep in $taskXml.SelectNodes('//node[@id="Dependencies"]/children/node[@id="ModuleShortDesc"]')){
        $taskValues=@{};foreach($taskAtt in $taskDep.SelectNodes('./attribute')){$taskValues[$taskAtt.id]=$taskAtt.value};$taskValues
      })
      $taskExtenderConfig=$null
      $taskConfigPath='Mods/'+$taskAttributes['Folder']+'/ScriptExtender/Config.json'
      $taskConfig=@($taskPak.Files|Where-Object{$_.Name -eq $taskConfigPath})
      if($taskConfig.Count -eq 1){$taskExtenderConfig=(Read-BoundedPakText $taskConfig[0] -MaxCharacters 262144)|ConvertFrom-Json}
      [pscustomobject]@{PackagePath=[IO.Path]::GetFullPath($Path);PackageVersion=[int]$taskPak.Version;MetadataPath=$taskMeta.Name;Attributes=$taskAttributes;Dependencies=$taskDependencies;ScriptExtender=$taskExtenderConfig;EmbeddedNativeFiles=@($taskPak.Files|Where-Object{$_.Name -match '\.(dll|exe)$'}|ForEach-Object{$_.Name})}
    }
  }finally{$taskPak.Dispose()}
}
function New-BG3Pak {
  [CmdletBinding()]param([Parameter(Mandatory)][string]$Source,[Parameter(Mandatory)][string]$Destination,[byte]$Priority=0)
  if(Test-Path -LiteralPath $Destination){throw "Refusing to overwrite an existing package: $Destination"}
  $taskRoot=[IO.Path]::GetFullPath($Source)
  $taskBuild=[LSLib.LS.PackageBuildData]::new()
  $taskBuild.Version=[LSLib.LS.Enums.PackageVersion]18
  $taskBuild.Compression=[LSLib.LS.CompressionMethod]::LZ4
  $taskBuild.CompressionLevel=[LSLib.LS.LSCompressionLevel]::Default
  $taskBuild.Priority=$Priority
  foreach($taskFile in Get-ChildItem -LiteralPath $taskRoot -File -Recurse){
    $taskRelative=[IO.Path]::GetRelativePath($taskRoot,$taskFile.FullName).Replace('\','/')
    $taskBuild.Files.Add([LSLib.LS.PackageBuildInputFile]::CreateFromFilesystem($taskFile.FullName,$taskRelative))
  }
  [IO.Directory]::CreateDirectory((Split-Path -Parent ([IO.Path]::GetFullPath($Destination))))|Out-Null
  $taskWriter=[LSLib.LS.PackageWriterFactory]::Create($taskBuild,$Destination)
  try{$taskWriter.Write()}finally{$taskWriter.Dispose()}
  Get-FileHash -LiteralPath $Destination -Algorithm SHA256
}
Export-ModuleMember -Function Read-BG3PakMetadata,New-BG3Pak
