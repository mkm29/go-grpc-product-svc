# Product gRPC service

## Register

```bash
curl -X POST \
  http://localhost:3000/auth/register \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "mitch@murphy.com",
  "password": "password"
}'
```

### Login

```bash
RES=`curl -X POST \
  http://localhost:3000/auth/login \
  -H 'Content-Type: application/json' \
  -d '{
  "email": "mitch@murphy.com",
  "password": "password"
}'`
```

Get and save the token: 

```bash
TOKEN=`echo $RES | jq -r .token`
```
