#!/usr/bin/env bash
# Renders tuxedo task list for the Neovim dashboard, styled to match the
# tuxedo TUI palette (truecolor ANSI).

[ -f todo.txt ] || exit 0

python3 - <<'EOF'
import subprocess, re, sys
from datetime import date, timedelta

today      = date.today()
week_end   = today + timedelta(days=7)
nweek_end  = today + timedelta(days=14)

def fg(r, g, b): return f'\033[38;2;{r};{g};{b}m'

RESET  = '\033[0m'
BOLD   = '\033[1m'
DIM    = '\033[2m'

# Tuxedo palette
FG     = fg(223, 225, 230)   # --fg     #dfe1e6
MUTED  = fg(139, 145, 156)   # --muted  #8b919c
ACCENT = fg(196, 181, 106)   # --accent #c4b56a  (priority)
DANGER = fg(217, 122, 122)   # --danger #d97a7a  (overdue / due dates)
TEAL   = fg( 90, 180, 140)   # this-week header
PROJ   = fg(100, 160, 220)   # +projects
CTX    = fg(140, 200, 140)   # @contexts

SECTION_COLORS = {
    'OVERDUE':     DANGER + BOLD,
    'TODAY':       ACCENT + BOLD,
    'THIS WEEK':   TEAL   + BOLD,
    'NEXT WEEK':   FG     + BOLD,
    'LATER':       MUTED,
    'NO DUE DATE': MUTED,
}

def colorize(task):
    task = re.sub(r'\(([A-Z])\)', lambda m: f'{ACCENT}{BOLD}({m.group(1)}){RESET}', task)
    task = re.sub(r'\+\S+',       lambda m: f'{PROJ}{m.group()}{RESET}',             task)
    task = re.sub(r'@\S+',        lambda m: f'{CTX}{m.group()}{RESET}',              task)
    task = re.sub(r'due:\S+',     lambda m: f'{DANGER}{m.group()}{RESET}',           task)
    return task

result = subprocess.run(['tuxedo', 'list'], capture_output=True, text=True)
lines  = result.stdout.strip().split('\n')

groups = {k: [] for k in ['OVERDUE', 'TODAY', 'THIS WEEK', 'NEXT WEEK', 'LATER', 'NO DUE DATE']}

for line in lines:
    if re.match(r'^\d+ x ', line): continue  # done task
    if re.match(r'^--|^TODO:',line): continue  # summary
    m = re.match(r'^(\d+) (.+)$', line)
    if not m: continue
    num, task = m.group(1), m.group(2)

    due = re.search(r'due:(\d{4}-\d{2}-\d{2})', task)
    if due:
        try:
            d = date.fromisoformat(due.group(1))
            if   d < today:      key = 'OVERDUE'
            elif d == today:     key = 'TODAY'
            elif d <= week_end:  key = 'THIS WEEK'
            elif d <= nweek_end: key = 'NEXT WEEK'
            else:                key = 'LATER'
        except ValueError:
            key = 'NO DUE DATE'
    else:
        key = 'NO DUE DATE'

    groups[key].append((num, task))

shown = False
for name, tasks in groups.items():
    if not tasks: continue
    shown = True
    print(f'{SECTION_COLORS[name]}  ── {name} ──{RESET}')
    for num, task in tasks:
        print(f'  {MUTED}{num}{RESET} {FG}{colorize(task)}{RESET}')

if not shown:
    print(f'{MUTED}  no open tasks{RESET}')
EOF
