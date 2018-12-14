
HOSTNAME=http://localhost:4000
MIO_TOKEN=`curl -H "Content-Type: application/json" -d '{"session": {"email": "admin@media-io.com", "password": "admin123"} }' $HOSTNAME/api/sessions | jq -r ".access_token"`
curl -H "Authorization: $MIO_TOKEN" -H "Content-Type: application/json" -d '{"reference": "488d0f5a-6b06-4bf6-a9be-aa024edf4d1b", "mp4_path": "/streaming-adaptatif_france-dom-tom/2018/S49/J7/195355542-5c0cf635d0b53-standard1.mp4", "ttml_path": "https://staticftv-a.akamaihd.net/sous-titres/2018/12/09/195355542-5c0cf635d0b53-1544353508.ttml"}' $HOSTNAME/api/workflow/acs
