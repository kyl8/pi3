param()
$ErrorActionPreference = 'Stop'
Push-Location -LiteralPath $PSScriptRoot
try {
    $rCommand = Get-Command Rscript.exe -ErrorAction SilentlyContinue
    if (-not $rCommand) { throw 'Rscript nao encontrado. Instale R e inclua sua pasta bin no PATH.' }
    & $rCommand.Source 'estrutura/codigos/executar_atualizacao.R'
    if ($LASTEXITCODE -ne 0) { throw "A execucao R falhou com codigo $LASTEXITCODE." }
}
finally { Pop-Location }
