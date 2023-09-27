#!/bin/bash
set -euo pipefail


# Functie om mappen aan te maken wanneer deze niet bestaan
create_directory_if_not_exists() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
}

# Maak de mappen wanneer ze nog niet bestaan
create_directory_if_not_exists "tempdir"
create_directory_if_not_exists "tempdir/templates"
create_directory_if_not_exists "tempdir/static"


cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile << _EOF_
FROM python
RUN pip install flask
COPY  ./static /home/myapp/static/
COPY  ./templates /home/myapp/templates/
COPY  sample_app.py /home/myapp/
EXPOSE 5050
CMD python /home/myapp/sample_app.py
_EOF_

cd tempdir || exit
docker build -t sampleapp .
docker run -t -d -p 5050:5050 --name samplerunning sampleapp
docker ps -a 
