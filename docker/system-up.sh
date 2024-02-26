
BASEDIR=${PWD}/$(dirname "$0")

echo "--------- CRIANDO NETWORK ----------"
sudo docker network rm erp_net
sudo docker network create --subnet 174.30.0.0/16 erp_net

sudo docker rm -f erp.api
sudo docker rm -f erp.db

echo "--------- BUILDANDO A IMAGEM ----------"
sudo docker build -t erp.api ${BASEDIR}


echo "--------- CRIANDO CONTAINER ----------"
sudo docker run --restart=always --name erp.api -idt --net erp_net --ip=174.30.0.2 -v ${BASEDIR}/..:/var/www/html -v ${BASEDIR}../../.local:/.local --privileged erp.api
sudo docker run --restart=always --name erp.db -idt --net erp_net --ip=174.30.0.3 -e POSTGRES_PASSWORD=toor -e PGDATA=/var/lib/postgresql/data/pgdata -v ${BASEDIR}/../../db:/var/lib/postgresql/data postgres
echo "--------- CRIANDO HOSTS ----------"
if grep "174.30.0.2" /etc/hosts> /dev/null
then
    echo "--------- HOST JÁ EXISTE ----------"
    echo "--------- ATUALIZANDO PROJETO ----------"
    sudo docker exec erp.api composer install
    sudo docker exec erp.api php artisan migrate
    echo "LINK:  http://erp.api"
    exit
fi
echo "--------- HOST CRIADA ----------"
sudo echo "174.30.0.2 erp.api" | sudo tee -a /etc/hosts
echo "--------- ATUALIZANDO PROJETO ----------"
sudo docker exec erp.api composer install
sudo docker exec erp.api php artisan migrate
echo "LINK:  http://erp.api"
