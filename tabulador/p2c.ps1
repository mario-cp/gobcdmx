.\pdftotext.exe -l 242 -margint 150 -marginb 70 -nopgbrk -simple .\202004.pdf 202004.txt
$segundas="^\s{2,}(.*)$"
$rxclave="^(?<clave>[A-Z0-9]+)\b";
$final=$regex="\b(?<unidad>(cala adi|diseño|fosa|Ha|hora|juego|junta|litro|lote|lto|muestra|p.t|pieza|prueba|pza-km|semana|serie|toma|visita|an\wlisis|estudi\w{1,2}|kg(/uso)?|(m([23])?|pza|ton)([/-](d\wa|est(ac)?|km))?))(\W|\b)\s+(?<precio>(\d{1,3}([,\.]\d{3})*|(\d+))(\.\d{2})?)$";
$espacios="\s+";
$rawtext=Get-Content -Path ./202004.txt
del .\catalogo.csv;
$clave="";
$unidad="";
$precio="";
$concepto="";
$segunda="";$cod="";
Add-Content -Path .\catalogo.csv -Value ("clave`tconcepto`tunidad`tprecio")
foreach ($l in $rawtext){
$l | Select-String -Pattern $rxclave | Foreach-Object {$clave= $_.Matches[0].Groups["clave"].Value}
if($clave -ne ""){
    if($concepto -ne ""){Add-Content -Path .\catalogo.csv -Value ("$cod`t$concepto`t$unidad`t$precio");Write-Host $clave}
$cod=$clave;
$clave="";
$unidad="";
$precio="";
$concepto="";
$segunda="";
    $l | Select-String -Pattern $final | Foreach-Object {$unidad, $precio= $_.Matches[0].Groups["unidad","precio"].Value}
    $concepto=($l -replace $rxclave,"" -replace $final,"" -replace $espacios," ").trim(" ");
}
else { $l | Select-String -Pattern $segundas | Foreach-Object {$concepto = $concepto +" "+ ($_.Matches[0].Groups[1].Value).trim(" ") -replace $espacios," "}
}
}
Add-Content -Path .\catalogo.csv -Value ("$cod`t$concepto`t$unidad`t$precio")
