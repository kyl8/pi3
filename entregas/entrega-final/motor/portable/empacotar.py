"""Cria um executável Windows x64 com o motor, R e todas as dependências."""
import argparse
import os
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory
from zipfile import ZIP_DEFLATED, ZipFile

PORTABLE = Path(__file__).resolve().parent
REPO = PORTABLE.parents[3]
files = [
    "estrutura/codigos/motor-appa.R", "estrutura/codigos/motor-professor/motor08.R",
    "estrutura/codigos/aula07_funcoes.R", "estrutura/codigos/mmr.R",
    "estrutura/codigos/config.R", "estrutura/corpus/banco-de-dados/docs.rds",
    "estrutura/corpus/banco-de-dados/origem.rds", "entregas/entrega-final/motor/busca.R",
    "entregas/entrega-final/motor/app.R", "entregas/entrega-final/motor/iniciar.R",
]

def add_tree(bundle, source, target):
    for path in sorted(source.rglob("*")):
        if path.is_file():
            bundle.write(path, (target / path.relative_to(source)).as_posix())

def build(runtime, target):
    csc = Path(os.environ["WINDIR"]) / "Microsoft.NET/Framework64/v4.0.30319/csc.exe"
    dependencies = subprocess.check_output(
        [str(runtime/"bin/Rscript.exe"), "--vanilla", str(PORTABLE/"bibliotecas.R")],
        text=True, encoding="utf-8",
    ).splitlines()
    target.parent.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(prefix="appa-build-", dir=target.parent) as local:
        local = Path(local)
        archive = local / "appa.zip"
        with ZipFile(archive, "w", ZIP_DEFLATED, compresslevel=6) as bundle:
            for directory in ["bin", "etc", "modules", "share"]:
                add_tree(bundle, runtime/directory, Path("R")/directory)
            for license_file in ["COPYING", "README.R-4.6.1"]:
                if (runtime/license_file).is_file():
                    bundle.write(runtime/license_file, f"R/{license_file}")
            for dep in map(Path, dependencies):
                add_tree(bundle, dep, Path("R/library")/dep.name)
            for name in files:
                bundle.write(REPO/name, "pi3/"+name)
            add_tree(bundle, PORTABLE.parent/"www", Path("pi3/entregas/entrega-final/motor/www"))
        executable = local / "Busca-APPA.exe"
        subprocess.run([str(csc), "/nologo", "/target:winexe", "/platform:x64", "/codepage:65001",
            "/optimize+", f"/out:{executable}", f"/resource:{archive},appa.zip",
            "/reference:System.Windows.Forms.dll", "/reference:System.Drawing.dll",
            "/reference:System.IO.Compression.dll", "/reference:System.IO.Compression.FileSystem.dll",
            str(PORTABLE/"Launcher.cs")], check=True)
        executable.replace(target)
    print(f"{target} ({target.stat().st_size / 1024**2:.1f} MiB)")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--r", required=True, type=Path, help="Pasta do R com shiny e SnowballC")
    parser.add_argument("--saida", required=True, type=Path)
    args = parser.parse_args()
    build(args.r.resolve(), args.saida.resolve())
