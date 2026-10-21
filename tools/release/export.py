"""Offline candidate export. Never execute the selected source or change adopters."""
import argparse
import datetime
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys

MAX=262144
TOTAL=2097152
PROTECTED={'status.md','founder.md','decisions.md','agents.md','claude.md','gemini.md','codex.md','.cursorrules'}
class Refused(ValueError):pass

def need(ok,message):
    if not ok:raise Refused(message)

def sha(data):return hashlib.sha256(data).hexdigest()
def encoded(value):return (json.dumps(value,ensure_ascii=False,sort_keys=True,indent=2)+'\n').encode()

def git(root,*args):
    try:r=subprocess.run(['git','--no-replace-objects','-c','core.fsmonitor=false','-c','core.hooksPath=/dev/null','-C',str(root),*args],env={'PATH':os.defpath,'GIT_CONFIG_NOSYSTEM':'1','GIT_CONFIG_GLOBAL':os.devnull,'LC_ALL':'C'},capture_output=True,timeout=20)
    except subprocess.TimeoutExpired as e:raise Refused('Git read timed out') from e
    need(r.returncode==0,'Git snapshot unavailable');need(len(r.stdout)<=TOTAL*8,'Git output limit');return r.stdout

def path(value):
    need(isinstance(value,str) and len(value)<=180 and re.fullmatch(r'[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*',value),'unsafe path')
    need(all(p not in {'.','..'} and p.casefold()!='.git' and not p.endswith('.') and p.split('.')[0].upper() not in {'CON','PRN','AUX','NUL',*(f'COM{i}' for i in range(10)),*(f'LPT{i}' for i in range(10))} for p in value.split('/')),'unsafe platform path')
    need(not any(p.lower().startswith('.env') or p.lower() in {'.npmrc','.netrc','credentials','secrets'} or p.lower().endswith(('.pem','.key','.p12','.pfx')) for p in value.split('/')),'credential path refused')
    return value

def blob(root,revision,name):
    name=path(name)
    info=git(root,'ls-tree',revision,'--',name).decode().split()
    need(len(info)==4 and info[0] in {'100644','100755'} and info[1]=='blob' and info[3]==name,'nonregular or missing source')
    need(int(git(root,'cat-file','-s',info[2]))<=MAX,'source byte limit')
    raw=git(root,'cat-file','blob',info[2]);need(b'\0' not in raw,'binary source')
    try:raw.decode('utf-8')
    except UnicodeDecodeError as e:raise Refused('invalid source text') from e
    return raw,info[0]

def inputs(value):
    names={'project','founder','domain','devUrl','weekday','renderTime'}
    need(isinstance(value,dict) and set(value)==names,'exact render fields required')
    for key,item in value.items():
        need(isinstance(item,str) and 0<len(item)<=500 and not any(ord(c)<32 or ord(c)==127 or c in '{}' for c in item),'invalid or ambiguous render value')
    need('"' not in value['project'] and '\\' not in value['project'],'project cannot contain quote or backslash')
    timestamp=value['renderTime'];need(bool(re.fullmatch(r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z',timestamp)),'UTC render time required')
    try:datetime.datetime.strptime(timestamp,'%Y-%m-%dT%H:%M:%SZ')
    except ValueError as e:raise Refused('invalid render time') from e
    initial=value['founder'][0].translate(str.maketrans('abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'))
    return {'{PROJECT}':value['project'],'{FOUNDER}':value['founder'],'{FOUNDER_INITIAL}':initial,'{DOMAIN}':value['domain'],'{DEV_URL}':value['devUrl'],'{WEEKDAY}':value['weekday'],'{DATE}':timestamp[:10],'{ISO-8601-WITH-TIMEZONE}':timestamp}

def candidate(root,revision,values,label):
    root=Path(root).resolve();need(bool(re.fullmatch('[0-9a-f]{40}',revision)),'full immutable commit required')
    need(git(root,'rev-parse','--verify',revision+'^{commit}').decode().strip()==revision,'commit mismatch')
    need(Path(git(root,'rev-parse','--show-toplevel').decode().strip()).resolve()==root,'repository root required')
    need(isinstance(label,str) and bool(re.fullmatch(r'[A-Za-z0-9_.-]{1,80}',label)),'invalid candidate label')
    substitutions=inputs(values);raw_map,_=blob(root,revision,'managed-files.tsv')
    rows=[];seen=set();size=0;rendered_size=0;rendered={};files=[];protected=[]
    for line in raw_map.decode().splitlines():
        if not line or line.startswith('#'):continue
        fields=line.split('|');need(len(fields)==4,'malformed mapping');src,dst,policy,action=fields;path(src);path(dst)
        need(dst.casefold() not in seen,'case or duplicate collision');seen.add(dst.casefold())
        need(policy in {'managed','protected'} and action in {'file','agents','adapter'},'invalid mapping policy')
        if policy=='managed':need(action=='file' and dst.casefold().split('/')[-1] not in PROTECTED and not dst.lower().startswith('docs/plans/'),'protected destination cannot be managed')
        raw,mode=blob(root,revision,src);need(mode=='100644','documentation mode must be 100644');size+=len(raw);need(size<=TOTAL and len(rows)<64,'mapping budget exceeded')
        rows.append(dst)
        if policy=='protected':protected.append({'path':dst,'sourcePath':src,'sourceSha256':sha(raw),'reason':'Owner state, custom plans, adapters or combined instructions; no automatic upgrade ownership.'});continue
        data=re.sub(r'\{[A-Z0-9_-]+\}',lambda m:substitutions.get(m[0],m[0]),raw.decode()).encode()
        rendered_size+=len(data);need(len(data)<=MAX and rendered_size<=TOTAL,'rendered byte limit');rendered[dst]=(data,mode)
        files.append({'path':dst,'sourcePath':src,'sourceSha256':sha(raw),'sha256':sha(data),'mode':mode})
    need(rows and not any(b.lower().startswith(a.lower()+'/') for a in rows for b in rows if a!=b),'nested file collision')
    manifest={'schema':'techofficer.workflow-rendered/v1','source':{'repository':'tech-officer/workflow','commit':revision,'releaseLabel':label},'contract':'2.2','substitutions':substitutions,'files':files}
    metadata={'schema':'techofficer.workflow-candidate/v1','state':'exported candidate; not published or installed','sourceCommit':revision,'candidateLabel':label,'renderTime':values['renderTime'],'manifestSha256':sha(encoded(manifest)),'mappingSha256':sha(raw_map),'managedSubsetCount':len(files),'protected':protected,'compatibility':'Contract2.2; queue producers unchanged; historical adopter baseline remains unknown.'}
    return manifest,metadata,rendered

def write(output,root,manifest,metadata,rendered):
    out=Path(output).absolute();need(not any(p.is_symlink() for p in [out,*out.parents]),'output symlink refused')
    resolved=out.resolve();root=Path(root).resolve();need(resolved!=root and root not in resolved.parents and resolved not in root.parents,'output overlaps source')
    need(not out.exists() or out.is_dir() and not any(out.iterdir()),'output must be new or empty')
    documents={name:blob(root,metadata['sourceCommit'],source)[0] for name,source in [('MIGRATION.md','docs/releases/upgrade-candidates.md'),('CHANGELOG.md','docs/releases/candidate-changelog.md')]}
    out.mkdir(parents=True,exist_ok=True)
    package={'manifest.json':encoded(manifest),'candidate.json':encoded(metadata),'REVIEW.md':b'# Candidate only\n\nInspect manifest and protected report. No historical baseline is inferred. Use the B511 planner with an explicitly pinned/deferred target and proven baseline, or obtain unknown/manual findings. Check exact hashes in a disposable clean checkout, obtain authority for project checks, then open a reviewed PR. Founder merges; record only the accepted subset with evidence. Before merge reverse the exact patch; after merge use a reviewed revert PR. No tag, release, adopter access or installation is certified. See source docs/releases/upgrade-candidates.md for migration and publication gates.\n'}
    package.update(documents)
    for name,data in package.items():
        with (out/name).open('xb') as f:f.write(data)
    for name,(data,mode) in rendered.items():
        p=out/'rendered'/name;p.parent.mkdir(parents=True,exist_ok=True)
        with p.open('xb') as f:f.write(data)
        p.chmod(int(mode[-3:],8))

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    for flag in ['source','commit','inputs','label','output']:parser.add_argument('--'+flag,required=True)
    args=parser.parse_args()
    try:
        p=Path(args.inputs);need(p.is_file() and not p.is_symlink() and p.stat().st_size<=8192,'invalid input file')
        def unique(pairs):
            result={}
            for k,v in pairs:need(k not in result,'duplicate input field');result[k]=v
            return result
        values=json.loads(p.read_bytes(),object_pairs_hook=unique)
        manifest,metadata,rendered=candidate(args.source,args.commit,values,args.label)
        write(args.output,args.source,manifest,metadata,rendered)
    except (ValueError,OSError) as e:print('Refused: '+str(e),file=sys.stderr);return 2
    print('Candidate exported; no release or adopter changed');return 0
if __name__=='__main__':sys.exit(main())
