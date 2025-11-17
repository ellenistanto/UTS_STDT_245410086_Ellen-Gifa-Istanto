ALTER SYSTEM SET wal_level = 'replica';
ALTER SYSTEM SET max_wal_senders = 5;
ALTER SYSTEM SET wal_keep_size = 64;

CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicapass';
