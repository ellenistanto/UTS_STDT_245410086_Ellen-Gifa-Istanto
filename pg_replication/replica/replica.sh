set -e

echo "Menyiapkan replica..."

rm -rf /var/lib/postgresql/data/*

PGPASSWORD=replicapass pg_basebackup -h primary -D /var/lib/postgresql/data -U replicator -Fp -Xs -P

echo "primary_conninfo = 'host=primary port=5432 user=replicator password=replicapass'" >> /var/lib/postgresql/data/postgresql.auto.conf
echo "standby_mode = 'on'" >> /var/lib/postgresql/data/postgresql.auto.conf

touch /var/lib/postgresql/data/standby.signal

echo "Replica siap!"
