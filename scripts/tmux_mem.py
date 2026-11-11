#!/usr/bin/python3
"""Report memory use per tmux window.

tmux only knows the PID of the shell it started in each pane. Everything you
actually run (editors, servers, Claude, builds) is a descendant of that shell.
So this script:

  1. Snapshots every process on the box once: its PID, parent PID and RSS.
  2. Rebuilds the parent -> children tree from that snapshot.
  3. Asks tmux for every pane's root PID and sums RSS over that pane's subtree.
  4. Rolls panes up into their window and prints windows, biggest first.

Caveats worth knowing when reading the numbers:
  - RSS counts shared pages (libraries, shared memory) once per process, so
    summing it overstates real usage. Treat totals as an upper bound and use
    them for relative comparison between windows, not as "free this much".
  - A process that daemonizes (double-forks and gets reparented to launchd,
    PID 1) leaves its pane's subtree and is no longer counted anywhere.
"""
import subprocess, collections

# One ps call for the whole system. The trailing "=" on each column suppresses
# the header row. Only numeric columns are requested (no command name), so
# whitespace splitting yields a flat list of exactly 3 tokens per process:
# [pid, ppid, rss, pid, ppid, rss, ...]. RSS is in KiB.
ps = subprocess.run(["ps","-axo","pid=,ppid=,rss="],capture_output=True,text=True).stdout.split()

# rss:  pid -> resident memory in KiB
# kids: ppid -> [child pids]; a defaultdict so leaf processes return [] safely
rss, kids = {}, collections.defaultdict(list)
for i in range(0,len(ps),3):
    p,pp,r = map(int,ps[i:i+3]); rss[p]=r; kids[pp].append(p)

def tree(p):
    """Return (total RSS in KiB, process count) for p and all its descendants.

    rss.get(..., 0) covers a pane whose root process exited between the ps
    snapshot and the tmux query: it contributes nothing rather than crashing.
    """
    t, n = rss.get(p,0), 1
    for c in kids[p]:
        a,b = tree(c); t+=a; n+=b
    return t,n

# One line per pane across all sessions (-a), tab-separated so window names
# containing spaces survive the split:
#   "<session>:<window_index>\t<window_name>\t<pane_pid>"
out = subprocess.run(["tmux","list-panes","-a","-F","#{session_name}:#{window_index}\t#{window_name}\t#{pane_pid}"],capture_output=True,text=True).stdout

# Per-window accumulator keyed by "session:index":
#   [rss_kib, process_count, pane_count, window_name]
win = collections.defaultdict(lambda:[0,0,0,""])
for line in out.strip().splitlines():
    k,name,pid = line.split("\t"); m,n = tree(int(pid))
    # Every pane in a window reports the same window_name, so overwriting
    # w[3] on each pane is harmless.
    w = win[k]; w[0]+=m; w[1]+=n; w[2]+=1; w[3]=name

total = sum(w[0] for w in win.values())

# Table sorted by RSS descending. 1048576 KiB = 1 GiB.
print(f"{'window':<20}{'name':<25}{'panes':>6}{'procs':>7}{'RSS':>10}")
for k,(m,n,p,name) in sorted(win.items(), key=lambda x:-x[1][0]):
    print(f"{k:<20}{name[:24]:<25}{p:>6}{n:>7}{m/1048576:>9.2f}G")
print(f"{'TOTAL':<45}{'':>13}{total/1048576:>9.2f}G")

# The tmux server is the parent of every pane's shell, not a descendant, so it
# is not in any window's total above; report it separately. pgrep -x matches
# the exact name "tmux", which also catches attached tmux *client* processes,
# so expect one entry per attached terminal plus the server. KiB / 1024 = MiB.
srv = subprocess.run(["pgrep","-x","tmux"],capture_output=True,text=True).stdout.split()
print("tmux server RSS:", ", ".join(f"{pid}={rss.get(int(pid),0)/1024:.0f}M" for pid in srv))
