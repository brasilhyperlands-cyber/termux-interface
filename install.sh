#!/data/data/com.termux/files/usr/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
PURPLE=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
RESET=$(tput sgr0)

TERM_WIDTH=$(tput cols)
TERM_HEIGHT=$(tput lines)

center_text() {
    local text="$1"
    local clean_text=$(echo -e "$text" | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g')
    local text_length=${#clean_text}
    local padding=$(( (TERM_WIDTH - text_length) / 2 ))
    printf "%*s" $padding ""
    echo -e "$text"
}

center_line() {
    local char="$1"
    local color="$2"
    local line=""
    for ((i=0; i<TERM_WIDTH; i++)); do
        line="${line}${char}"
    done
    echo -e "${color}${line}${RESET}"
}

clear_screen() {
    clear
    local content_height=30
    local vertical_padding=$(( (TERM_HEIGHT - content_height) / 2 ))
    for ((i=0; i<vertical_padding; i++)); do
        echo ""
    done
}

show_banner() {
    clear_screen
    center_line "═" "${CYAN}"
    center_text "${CYAN}╔══════════════════════════════════════════════╗${RESET}"
    center_text "${CYAN}║                                              ║${RESET}"
    center_text "${CYAN}║  ${GREEN}████████╗███████╗██████╗ ███╗   ███╗${CYAN}  ║${RESET}"
    center_text "${CYAN}║  ${GREEN}╚══██╔══╝██╔════╝██╔══██╗████╗ ████║${CYAN}  ║${RESET}"
    center_text "${CYAN}║  ${GREEN}   ██║   █████╗  ██████╔╝██╔████╔██║${CYAN}  ║${RESET}"
    center_text "${CYAN}║  ${GREEN}   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║${CYAN}  ║${RESET}"
    center_text "${CYAN}║  ${GREEN}   ██║   ███████╗██║  ██║██║ ╚═╝ ██║${CYAN}  ║${RESET}"
    center_text "${CYAN}║  ${GREEN}   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝${CYAN}  ║${RESET}"
    center_text "${CYAN}║                                              ║${RESET}"
    center_text "${CYAN}║  ${WHITE}SCI-FI INTERFACE v4.0${CYAN}                 ║${RESET}"
    center_text "${CYAN}║  ${WHITE}TERMUX MODIFICATION${CYAN}                  ║${RESET}"
    center_text "${CYAN}║                                              ║${RESET}"
    center_text "${CYAN}╚══════════════════════════════════════════════╝${RESET}"
    center_line "═" "${CYAN}"
    echo ""
}

show_step() {
    local step_num="$1"
    local step_text="$2"
    echo ""
    center_text "${PURPLE}▶${RESET} ${CYAN}${BOLD}PASSO ${step_num}:${RESET} ${WHITE}${step_text}${RESET}"
    echo ""
}

show_progress() {
    center_text "${GREEN}[✓]${RESET} ${WHITE}$1${RESET}"
}

show_banner
sleep 2

show_step "01" "ATUALIZANDO SISTEMA"
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1
show_progress "Sistema atualizado"

show_step "02" "INSTALANDO PACOTES"
pkg install -y zsh git curl wget nano cmatrix neofetch figlet toilet > /dev/null 2>&1
show_progress "Pacotes instalados"

show_step "03" "CRIANDO ESTRUTURA"
mkdir -p ~/bin ~/.config
show_progress "Estrutura criada"

show_step "04" "CRIANDO SCRIPT sci-info"
cat > ~/bin/sci-info << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
COLS=$(tput cols)
C=$(tput setaf 6)
G=$(tput setaf 2)
Y=$(tput setaf 3)
W=$(tput setaf 7)
X=$(tput sgr0)

center() {
    local t="$1"
    local c=$(echo -e "$t" | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g')
    local l=${#c}
    local p=$(( (COLS - l) / 2 ))
    [ $p -lt 0 ] && p=0
    printf "%*s" $p ""
    echo -e "$t"
}

clear
center "${C}╔══════════════════════════════════════════════╗${X}"
center "${G}SYSTEM INFORMATION${X}"
center "${C}╠══════════════════════════════════════════════╣${X}"
center "${Y}User:${W} $(whoami)${X}"
center "${Y}Host:${W} $(hostname)${X}"
center "${Y}Shell:${W} $SHELL${X}"
center "${Y}OS:${W} $(uname -o)${X}"
center "${Y}Kernel:${W} $(uname -r)${X}"
center "${Y}Arch:${W} $(uname -m)${X}"
center "${Y}Uptime:${W} $(uptime -p | sed 's/up //')${X}"
center "${Y}Memory:${W} $(free -h | awk '/^Mem:/ {print $3\"/\"$2}')${X}"
center "${C}╚══════════════════════════════════════════════╝${X}"
EOF

chmod +x ~/bin/sci-info
show_progress "sci-info criado"

show_step "05" "CONFIGURANDO ZSH"
cat > ~/.zshrc << 'EOF'
export TERM="xterm-256color"
PROMPT='%F{cyan}[%F{green}%n%f@%F{yellow}%m%F{cyan}]%f:%F{magenta}%~%f
%F{cyan}❯%f '
alias sysinfo='~/bin/sci-info'
alias cls='clear'
alias matrix='cmatrix -C cyan'
clear
sysinfo
EOF
show_progress "Zsh configurado"

show_step "06" "CONFIGURANDO BASH"
cat > ~/.bashrc << 'EOF'
PS1='\[\033[96m\][\[\033[92m\]\u\[\033[0m\]@\[\033[93m\]\h\[\033[96m\]]\[\033[0m\]:\[\033[95m\]\w\[\033[0m\]\n\[\033[96m\]❯\[\033[0m\] '
alias sysinfo='~/bin/sci-info'
alias cls='clear'
clear
sysinfo
EOF
show_progress "Bash configurado"

clear_screen
center_line "═" "${GREEN}"
center_text "${WHITE}${BOLD}INSTALAÇÃO CONCLUÍDA${RESET}"
center_line "═" "${GREEN}"
echo ""
center_text "${YELLOW}Reabra o Termux ou execute:${RESET}"
center_text "source ~/.zshrc  |  source ~/.bashrc"
echo ""
center_text "${WHITE}Comando:${RESET} sysinfo"
echo ""
center_line "═" "${GREEN}"
read -n 1 -s
clear
