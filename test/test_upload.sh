export API_TOKEN=5cbd0d29-6174-4c44-9285-f865c9820eba
export SERVER_URL=http://dataverse:8080
export DATAVERSE_ID=root
export PERSISTENT_IDENTIFIER=doi:10.34622/datarepositorium/SGXCQO
export FILE=example.json

curl -H X-Dataverse-key:$API_TOKEN -X POST "$SERVER_URL/api/dataverses/$DATAVERSE_ID/datasets/:import?pid=$PERSISTENT_IDENTIFIER&release=yes" --upload-file $FILE
