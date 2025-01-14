###After Access inside the container##################
#### Create the file myrecord_schema.json################################
echo '{"schema": "{ \"type\": \"record\", \"name\": \"myrecord\", \"fields\": [ { \"name\": \"f1\", \"type\": \"string\" } ] }"}' > myrecord_schema.json

####Verify the file###############################
cat myrecord_schema.json
#Register the Schema Using curl
#############Register the Schema Using curl
curl -X POST http://localhost:8081/subjects/myrecord-value/versions \
-H "Content-Type: application/vnd.schemaregistry.v1+json" \
-d @myrecord_schema.json

#########Verify the schema registration
curl -X GET http://localhost:8081/subjects/myrecord-value/versions/latest

########Produce Messages
kafka-avro-console-producer \
  --bootstrap-server localhost:9092 \
  --topic myrecord \
  --property schema.registry.url=http://localhost:8081 \
  --property value.schema='{
    "type": "record",
    "name": "myrecord",
    "fields": [
      { "name": "f1", "type": "string" }
    ]
  }'
#testing Data
{"f1": "John"}

###Update Version
echo '{"schema": "{ \"type\": \"record\", \"name\": \"myrecord\", \"fields\": [ { \"name\": \"f1\", \"type\": \"string\" }, { \"name\": \"lastname\", \"type\": \"string\", \"default\": \"Unknown\" } ] }"}' > myrecord_schema.json



#############Register the Schema Using curl
curl -X POST http://localhost:8081/subjects/myrecord-value/versions \
-H "Content-Type: application/vnd.schemaregistry.v1+json" \
-d @myrecord_schema.json


kafka-avro-console-producer \
  --bootstrap-server localhost:9092 \
  --topic myrecord \
  --property schema.registry.url=http://localhost:8081 \
  --property value.schema='{
    "type": "record",
    "name": "myrecord",
    "fields": [
      { "name": "f1", "type": "string" },
      { "name": "lastname", "type": "string", "default": "Unknown" }
    ]
  }'

#Testing data

{"f1": "Leo", "lastname": "Sarmiento"}
{"f1": "John"}
{"f1": "Alice", "lastname": "Smith"}
{"f1": "Michael"}
{"f1": "Eve", "lastname": "Anderson"}
