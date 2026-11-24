#!/usr/bin/env python3
"""Build the standalone overnight runner with the same sources as libsoccer."""
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor
import hashlib,json,os,platform,subprocess,sys
root=Path(__file__).resolve().parents[1]
out=Path(sys.argv[1]) if len(sys.argv)>1 else root/'build-security'
runner=(root/sys.argv[2]).resolve() if len(sys.argv)>2 else root/'Tools/strong_security_sweep.cpp'
if not runner.is_file() or runner.suffix!='.cpp':raise SystemExit('Expected a C++ runner source inside this repository')
runner.relative_to(root)
out.mkdir(parents=True,exist_ok=True)
sources=[root/p for p in ['Scramble/Public/Soccer3.cpp','Scramble/Composer/Soccer3.cpp','Scramble/Composer/Soccer3Cryptex.cpp','Scramble/Composer/SoccerFolding.cpp','Scramble/Encrypter/Kernels/FourToadKernel.cpp','Scramble/Encrypter/CryptexLayer.cpp','Scramble/Encrypter/Cryptex.cpp']]
sources += [root/'Scramble/Encrypter/Kernels/FourCrowKernel.cpp', root/'Scramble/Encrypter/Kernels/FourRavenKernel.cpp']
sources+=sorted((root/'Scramble/Expander/Core').glob('*.cpp'))+sorted((root/'Scramble/Expander/Family').glob('*.cpp'))+[runner]
sources += [root/'Scramble/Composer/BitPlane.cpp', root/'Scramble/Composer/BitPlaneFarm.cpp']
headers=sorted((root/'Scramble').rglob('*.hpp'))+sorted((root/'Scramble').rglob('*.inc'))+[root/'StatisticalTests/StatisticalRecoveryHarness.hpp',root/'ScrambleTests/CryptexTestSupport.hpp',root/'Tools/SweepCipherNames.hpp']
compiler=subprocess.check_output(['xcrun','--find','clang++'],text=True).strip()
compiler_version=subprocess.check_output([compiler,'--version'],text=True)
digest=hashlib.sha256()
digest.update(Path(__file__).read_bytes());digest.update(compiler_version.encode());digest.update(platform.machine().encode())
for p in sources+headers:digest.update(str(p.relative_to(root)).encode());digest.update(p.read_bytes())
fingerprint=digest.hexdigest();exe=out/runner.stem;stamp=out/'build_id.txt'
if exe.exists() and stamp.exists() and stamp.read_text()==fingerprint:print(exe);sys.exit(0)
flags=['-O3','-std=c++20','-DNDEBUG',f'-DSOCCER_SWEEP_BUILD="{fingerprint}"']
for path in ['Scramble/Composer','Scramble/Expander/Core','Scramble/Expander/Family','Scramble/Encrypter','Scramble/Encrypter/Kernels']:flags+=['-I',str(root/path)]
objects=[]
for p in sources:objects.append(out/(str(p.relative_to(root)).replace('/','_')+'.o'))
def compile_one(pair):
 source,obj=pair;subprocess.run([compiler,*flags,'-c',str(source),'-o',str(obj)],check=True,stdout=subprocess.DEVNULL)
with ThreadPoolExecutor(max_workers=4) as pool:list(pool.map(compile_one,zip(sources,objects)))
subprocess.run([compiler,*map(str,objects),'-o',str(exe)],check=True)
stamp.write_text(fingerprint)
(out/'build_manifest.json').write_text(json.dumps(dict(build=fingerprint,compiler=compiler,compiler_version=compiler_version,architecture=platform.machine(),flags=flags,sources=[str(p.relative_to(root)) for p in sources]),indent=2)+'\n')
print(exe)
