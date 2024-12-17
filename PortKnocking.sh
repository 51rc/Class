  GNU nano 8.1                                       PortKnocking.sh                                                
#!/bin/bash
RESET="\e[0m"
VERMELHO="\e[1;31m"
VERDE="\e[1;32m"
AMARELO="\e[1;33m"
AZUL="\e[1;34m"
MAGENTA="\e[1;35m"
CINZA="\e[1;37m"


# Verifica se o usuário forneceu pelo menos um servidor e uma porta
if [ "$#" -lt 2 ]; then
  echo "Uso: $0 <servidor> <porta1> <porta2> ... <portaN>"
  exit 1
fi

# Obtém o servidor do primeiro argumento
SERVER=$1
shift # Remove o primeiro argumento (servidor), deixando apenas as portas

# Itera sobre as portas fornecidas
for PORT in "$@"; do
  echo -e "${VERDE}Knockando na porta $PORT do servidor $SERVER...${RESET}"
  hping3 -S -p "$PORT" -c 1 "$SERVER"
  sleep 1
done

echo -e "========================================================================== \n"
echo -e "${VERDE} fazendo CURL $SERVER:1337\n"

curl "$SERVER:1337"
