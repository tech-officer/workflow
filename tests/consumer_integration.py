"""Explicit production-consumer compatibility; missing dependencies fail, never skip."""
import argparse
import json
from pathlib import Path
import shutil
import sys
import tempfile
from test_release import ROOT,VALUES,git,commit,install,exporter

parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--consumer',required=True);parser.add_argument('--output',required=True);args=parser.parse_args()
consumer=Path(args.consumer).resolve();module=consumer/'tools/workflow_upgrade/planner.py'
if not module.is_file():raise SystemExit('UNAVAILABLE: production B511 planner missing')
sys.path.insert(0,str(module.parent));from planner import manifest,prepare
out=Path(args.output).absolute()
if out.exists() or any(p.is_symlink() for p in [out,*out.parents]) or any(root==out.resolve() or root in out.resolve().parents for root in [ROOT,consumer]):raise SystemExit('Refused: separate new report path required')
with tempfile.TemporaryDirectory(prefix='p008-consumer-') as temp:
    base=Path(temp);source=base/'source';shutil.copytree(ROOT,source,ignore=shutil.ignore_patterns('.git','__pycache__'));git(source,'init','-q');oldref=commit(source)
    old,_,_=exporter.candidate(source,oldref,VALUES,'synthetic-baseline')
    manifest(old,source)
    adopter=base/'adopter';adopter.mkdir();result=install(source,adopter)
    assert result.returncode==0,result.stderr.decode();git(adopter,'init','-q');adopter_ref=commit(adopter);before=git(adopter,'write-tree')
    changed=source/'templates/boot-prompts.md';changed.write_bytes(changed.read_bytes()+b'\nSynthetic changed-source fixture, not a published instruction.\n');newref=commit(source)
    new,_,_=exporter.candidate(source,newref,VALUES,'synthetic-target');manifest(new,source)
    plan,forward,reverse=prepare(adopter,adopter_ref,source,new,old,adopter_ref,'pinned',VALUES['renderTime'])
    assert plan['state']=='prepared candidate' and forward and reverse
    for name,data in [('forward.patch',forward),('reverse.patch',reverse)]: (base/name).write_bytes(data)
    git(adopter,'apply','--check',str(base/'forward.patch'));git(adopter,'apply',str(base/'forward.patch'))
    assert (adopter/'docs/ops/boot-prompts.md').read_bytes().endswith(b'Synthetic changed-source fixture, not a published instruction.\n')
    git(adopter,'apply','--check',str(base/'reverse.patch'));git(adopter,'apply',str(base/'reverse.patch'));git(adopter,'add','--all');assert git(adopter,'write-tree')==before
    actual=git(consumer,'rev-parse','HEAD').decode().strip();status=git(consumer,'status','--porcelain');observed={name:(consumer/name).read_bytes() for name in ['STATUS.md','AGENTS.md','FOUNDER.md','DECISIONS.md']}
    real,f,r=prepare(consumer,actual,source,new,observed_at=VALUES['renderTime'])
    assert real['installedVersion']=='unknown' and not f and not r
    assert git(consumer,'status','--porcelain')==status and all((consumer/name).read_bytes()==data for name,data in observed.items())
    report={'result':'PASS','workflowWorkingSourceBase':git(ROOT,'rev-parse','HEAD').decode().strip(),'syntheticSourceCommits':[oldref,newref],'syntheticAdopterCommit':adopter_ref,'consumerCommit':actual,'consumerUnknownPlan':real,'roundtrip':'actual installer baseline, changed candidate, forward and reverse exact Git tree PASS','limitations':'Synthetic source commits are not upstream releases. Protected owner bytes unchanged; no historical version or live rollout certified.'}
    with out.open('x') as handle:json.dump(report,handle,indent=2);handle.write('\n')
print('PASS production B511 manifest, actual installer baseline, forward/reverse exact tree and real consumer unknown-baseline preservation')
