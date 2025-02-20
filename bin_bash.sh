#!/bin/bash 

#1
echo -e "\033[0;34m TraceHunter-Forensic Collector \033[0m"

if [[ $EUID -ne 0 ]]; then
   echo -e "\033[0;31m Este script precisa ser executado como root. \033[0m"
   exit 1
fi

#2
COLLECTED_DIR="Collected_files"
mkdir -p "$COLLECTED_DIR"

#3
echo -e "\033[1;35m Coletando arquivos do sistema... \033[0m"

#4
echo -e "\033[0;95m Listando informações sobre discos e partições...\033[0m"
lsblk > "$COLLECTED_DIR/disk_info.txt"

#5
echo -e "\033[1;95m Coletando informações da rede...\033[0m"
ss -tunapl > "$COLLECTED_DIR/active_connections.txt"
netstat -tunapl > "$COLLECTED_DIR/open_ports.txt"

#6
echo -e "\033[1;95m Coletando lista de processos...\033[0m"
ps aux > "$COLLECTED_DIR/process_list.txt"

#7
echo -e "\033[1;95m Coletando log  do sistema...\033[0m"
cp /var/log/syslog "$COLLECTED_DIR/syslog.log"
cp /var/log/auth.log "$COLLECTED_DIR/auth.log"
cp /var/log/dmesg "$COLLECTED_DIR/dmesg.log"

#8
echo -e "\033[1;95m Coletando arquivos de configuração...\033[0m"
mkdir -p /backup/etc_backup && cp -r /etc/* /backup/etc_backup

#9
echo -e "\033[1;95m Listando o diretório raiz...\033[0m"
ls -lh / > "$COLLECTED_DIR/root_dir_list.txt"

#10
HOSTNAME=$(hostname)
DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_FILE="TraceHunter_${HOSTNAME}_${DATETIME}.tar.gz"
tar -czf "$OUTPUT_FILE" -C "$COLLECTED_DIR" .

echo -e "\033[1;5;31m FINISH HIM...\033[0m"
