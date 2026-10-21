import importlib.util
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('release_export',ROOT/'tools/release/export.py');exporter=importlib.util.module_from_spec(spec);spec.loader.exec_module(exporter)
VALUES={'project':'Café project','founder':'Éva & Co\\team','domain':'research & development / Europe','devUrl':'https://example.invalid/a?x=1&y=2','weekday':'Monday','renderTime':'2026-10-21T12:34:56Z'}

def git(root,*args):
    return subprocess.check_output(['git','-C',str(root),*args],stderr=subprocess.DEVNULL)
def commit(root):
    git(root,'add','--all');git(root,'-c','user.name=Fixture','-c','user.email=fixture@example.invalid','commit','-qm','disposable fixture');return git(root,'rev-parse','HEAD').decode().strip()

def install(source,destination,values=VALUES,mode='ask',extra=None):
    args=['bash',str(source/'install.sh'),str(destination),'--project',values['project'],'--founder',values['founder'],'--domain',values['domain'],'--dev-url',values['devUrl'],'--weekday',values['weekday'],'--render-time',values['renderTime'],'--overwrite',mode]
    return subprocess.run(args+(extra or []),input=b'',capture_output=True,env={**os.environ,'LC_ALL':'C.UTF-8'})

class ReleaseTests(unittest.TestCase):
    def setUp(self):
        self.tmp=tempfile.TemporaryDirectory();self.addCleanup(self.tmp.cleanup);self.base=Path(self.tmp.name);self.source=self.base/'source'
        shutil.copytree(ROOT,self.source,ignore=shutil.ignore_patterns('.git','__pycache__'));git(self.source,'init','-q');self.rev=commit(self.source);self.adopter=self.base/'adopter';self.adopter.mkdir()
    def candidate(self,values=VALUES):return exporter.candidate(self.source,self.rev,values,'candidate-test')
    def test_real_installer_parity_and_reproducible_export(self):
        manifest,meta,rendered=self.candidate();result=install(self.source,self.adopter);self.assertEqual(result.returncode,0,result.stderr.decode())
        self.assertEqual(len(manifest['files']),6)
        for name,(data,mode) in rendered.items():
            self.assertEqual((self.adopter/name).read_bytes(),data,name);self.assertEqual((self.adopter/name).stat().st_mode & 0o777,int(mode[-3:],8))
        self.assertIn(b'{ROLE}',rendered['docs/ops/boot-prompts.md'][0]);self.assertIn(b'NO feature',rendered['docs/ops/boot-prompts.md'][0])
        inputs=self.base/'inputs.json';inputs.write_text(json.dumps(VALUES))
        for name in ['out1','out2']:
            result=subprocess.run([sys.executable,str(ROOT/'tools/release/export.py'),'--source',str(self.source),'--commit',self.rev,'--inputs',str(inputs),'--label','candidate-test','--output',str(self.base/name)],capture_output=True)
            self.assertEqual(result.returncode,0,result.stderr.decode())
        self.assertEqual({str(p.relative_to(self.base/'out1')):p.read_bytes() for p in (self.base/'out1').rglob('*') if p.is_file()},{str(p.relative_to(self.base/'out2')):p.read_bytes() for p in (self.base/'out2').rglob('*') if p.is_file()})
        (self.source/'templates/boot-prompts.md').write_text('DIRTY SOURCE')
        self.assertEqual(self.candidate(),(manifest,meta,rendered))
    def test_custom_owners_adapters_append_once_and_reruns(self):
        for name in ['STATUS.md','FOUNDER.md','DECISIONS.md','CLAUDE.md','GEMINI.md']:(self.adopter/name).write_text('custom '+name)
        (self.adopter/'AGENTS.md').write_text('custom instructions\n')
        result=install(self.source,self.adopter);self.assertEqual(result.returncode,0,result.stderr)
        agents=(self.adopter/'AGENTS.md').read_bytes();self.assertTrue(agents.startswith(b'custom instructions'));self.assertEqual(agents.count(b'## Team & status protocol'),1)
        before={str(p.relative_to(self.adopter)):p.read_bytes() for p in self.adopter.rglob('*') if p.is_file()}
        for mode in ['ask','skip']:
            result=install(self.source,self.adopter,mode=mode);self.assertEqual(result.returncode,0,result.stderr);self.assertIn(b'no installed release is certified',result.stdout)
            self.assertEqual({str(p.relative_to(self.adopter)):p.read_bytes() for p in self.adopter.rglob('*') if p.is_file()},before)
    def test_unicode_initial_and_escaping(self):
        for founder in ['İpek','Éva','Omar & Co\\team']:
            values={**VALUES,'founder':founder};dest=self.base/f'adopter{len(founder)}';dest.mkdir(exist_ok=True)
            result=install(self.source,dest,values);self.assertEqual(result.returncode,0,result.stderr)
            _,_,rendered=self.candidate(values)
            expected=exporter.inputs(values)['{FOUNDER_INITIAL}']
            self.assertIn('Owners: **'+expected+'** = '+founder,(dest/'STATUS.md').read_text())
            for name,(data,_) in rendered.items():self.assertEqual((dest/name).read_bytes(),data)
    def test_invalid_values_and_calendar(self):
        for key,value in [('project','a\\b'),('project','a"b'),('founder','{PROJECT}'),('domain','line\nbreak'),('domain','a\x01b'),('weekday','a'*501),('renderTime','2026-02-29T12:00:00Z'),('renderTime','2026-10-21T24:00:00Z'),('renderTime','2026-10-21T12:00:00+00:00')]:
            values={**VALUES,key:value}
            with self.assertRaises(exporter.Refused):self.candidate(values)
            result=install(self.source,self.adopter,values);self.assertNotEqual(result.returncode,0,(key,value));self.assertEqual(list(self.adopter.iterdir()),[])
        with self.assertRaises(exporter.Refused):self.candidate({})
        result=subprocess.run(['bash',str(self.source/'install.sh'),str(self.adopter)],input=b'',capture_output=True);self.assertNotEqual(result.returncode,0)
    def test_installer_links_refused_before_any_write(self):
        sentinel=self.base/'sentinel';sentinel.write_text('outside')
        (self.adopter/'STATUS.md').symlink_to(sentinel)
        result=install(self.source,self.adopter);self.assertNotEqual(result.returncode,0);self.assertEqual(sentinel.read_text(),'outside');self.assertEqual(len(list(self.adopter.iterdir())),1)
        (self.adopter/'STATUS.md').unlink();(self.adopter/'docs').symlink_to(self.base,target_is_directory=True)
        result=install(self.source,self.adopter);self.assertNotEqual(result.returncode,0);self.assertFalse((self.adopter/'STATUS.md').exists())
    def test_export_boundaries_and_bad_mapping(self):
        manifest,meta,rendered=self.candidate()
        for output in [self.source,self.source/'out',self.base]:
            with self.assertRaises(exporter.Refused):exporter.write(output,self.source,manifest,meta,rendered)
        link=self.base/'link';link.symlink_to(self.adopter,target_is_directory=True)
        with self.assertRaises(exporter.Refused):exporter.write(link/'out',self.source,manifest,meta,rendered)
        with self.assertRaises(exporter.Refused):exporter.candidate(self.source,'HEAD',VALUES,'candidate')
        original=(self.source/'managed-files.tsv').read_text()
        for line in ['templates/STATUS.md|../outside|managed|file','templates/STATUS.md|STATUS.md|managed|file','templates/STATUS.md|docs/OPS/boot-prompts.md|managed|file','templates/STATUS.md|docs|managed|file','templates/STATUS.md|status.md|managed|file','templates/STATUS.md|nested/AGENTS.md|managed|file','templates/STATUS.md|CODEX.md|managed|file','.env.local|safe.md|managed|file']:
            (self.source/'managed-files.tsv').write_text(original+'\n'+line+'\n');self.rev=commit(self.source)
            with self.assertRaises(exporter.Refused):self.candidate()
        self.assertEqual(list(self.adopter.iterdir()),[])
    def test_cli_malformed_inputs_and_rendered_aggregate(self):
        for payload in ['{"project":1,"project":2}', '{}', 'x'*8193]:
            p=self.base/'bad.json';p.write_text(payload)
            result=subprocess.run([sys.executable,str(ROOT/'tools/release/export.py'),'--source',str(self.source),'--commit',self.rev,'--inputs',str(p),'--label','test','--output',str(self.base/'bad-out')],capture_output=True)
            self.assertEqual(result.returncode,2);self.assertFalse((self.base/'bad-out').exists())
        mapping=[]
        for i in range(9):
            (self.source/f'templates/expand{i}.md').write_text('{DOMAIN}'*500)
            mapping.append(f'templates/expand{i}.md|docs/expand{i}.md|managed|file')
        (self.source/'managed-files.tsv').write_text('\n'.join(mapping)+'\n');self.rev=commit(self.source)
        with self.assertRaises(exporter.Refused):self.candidate({**VALUES,'domain':'x'*500})
    def test_nonregular_and_oversized_sources(self):
        target=self.source/'templates/boot-prompts.md';target.unlink();target.symlink_to('/etc/passwd');self.rev=commit(self.source)
        with self.assertRaises(exporter.Refused):self.candidate()
        target.unlink();target.write_bytes(b'x'*262145);self.rev=commit(self.source)
        with self.assertRaises(exporter.Refused):self.candidate()

if __name__=='__main__':unittest.main(verbosity=2)
