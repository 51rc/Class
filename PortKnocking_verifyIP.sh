RESET="\e[0m"
VERMELHO="\e[1;31m"
VERDE="\e[1;32m"
AMARELO="\e[1;33m"
AZUL="\e[1;34m"
MAGENTA="\e[1;35m"
CINZA="\e[1;37m"

# Parâmetros: Faixa de IP (exemplo: 172.16.1) e lista de portas
FAIXA=$1
PORTAS=("${@:2}")  # Portas fornecidas após o primeiro argumento

# Verifica se os argumentos foram fornecidos
if [ "$#" -lt 2 ]; then
  echo "Uso: $0 <faixa_de_IP> <porta1> <porta2> ... <portaN>"
  exit 1
fi

# Array para armazenar IPs ativos
IPS_ATIVOS=()

# Passo 1: Verificar conectividade com os IPs da faixa
echo "Verificando IPs ativos na faixa $FAIXA..."
for i in {1..254}; do
  IP="$FAIXA.$i"
  # Testa se o IP responde
  if ping -c 1 -W 1 "$IP" &>/dev/null; then
    echo "IP ativo: $IP"
    IPS_ATIVOS+=("$IP")
  fi
done

# Passo 2: Testar portas nos IPs ativos
echo "Realizando port knocking nos IPs ativos..."
for IP in "${IPS_ATIVOS[@]}"; do
  echo "Verificando portas no IP $IP..."
  for PORTA in "${PORTAS[@]}"; do
    echo "Knockando na porta $PORTA..."
    hping3 -S -p "$PORTA" -c 1 "$IP" &>/dev/null
    sleep 1
  done

  # Verifica a porta 1337
  echo "Testando a porta 1337 em $IP..."
  if curl --connect-timeout 2 "$IP:1337" &>/dev/null; then
    echo "Porta 1337 aberta no IP $IP!"
    exit 0
  fi
done
