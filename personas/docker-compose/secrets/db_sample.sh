export PGPASSWORD=`cat /secrets/db/password`; psql -U dataverse dataverse -h postgres -c "insert into setting (content, name) values (True, ':OAIServerEnabled')"
export PGPASSWORD=`cat /secrets/db/password`; psql -U dataverse dataverse -h postgres -c "update apitoken set tokenstring='5cbd0d29-6174-4c44-9285-f865c9820eba' where id=1"
export PGPASSWORD=`cat /secrets/db/password`; psql -U dataverse dataverse -h postgres -c "update authenticateduser set superuser=True where id=1"
export PGPASSWORD=`cat /secrets/db/password`; psql -U dataverse dataverse -h postgres -c "select * from apitoken"
