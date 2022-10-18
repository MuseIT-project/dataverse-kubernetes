export PGPASSWORD=`cat /secrets/db/password`; psql -U dataverse dataverse -h postgres -c "select * from dvobject;"
