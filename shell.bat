@echo off

rem ფაილის ამოცანა არის ერთი ბრძანების საშუალებით
rem ჩამოპულოს და დააყენოს დეველიპერის გარემოს უახლესი ვერსია
rem ისე რომ შეინარჩუნოს დეველოპერის ნამუშევარი
rem მაგრამ გააჩეროს და წაშალოს ყველა ძველი კონტეინერი და იმიჯი
rem და ბოლოს დეველოპერი მოახვედროს ci/cd ის შელში

rem ჩამოგვაქვს ბოლო ვერსია ყველაფრის
git pull

set image=pg-dev
set tag=0.0.20
set name=%image%

rem აქ ხდება .config ფაილის კონტენტის ცვლადებად გამოცხადება
for /f "delims== tokens=1,2" %%G in (.config) do set %%G=%%H

docker build -t %image%:%tag% --build-arg IMAGE_VERSION=%tag% --build-arg GIT_USER_NAME=%GIT_USER_NAME% --build-arg GIT_USER_EMAIL=%GIT_USER_EMAIL% -f Dockerfile .

rem ყველა ამ იმიჯის კონტეინერს ვაჩერებთ
for /f "tokens=* delims=" %%a in (
  '"docker container ls -q --filter name=%name%*"'
) do (
    docker container stop "%%a"
)

set volume=%localappdata%\%name%
echo "Data will be stored at "%volume%

rem შევუქმნათ ფოლდერი თუ არ არსებობს
if not exist %volume% mkdir %volume%

docker network create pg

rem ვქმნით ბოლოს დაბილდულ კონტეინერს
docker run -d --name %name%-%tag%^
    -e POSTGRES_PASSWORD=1234^
    -e PGDATA=/var/lib/postresql/data^
    -e PG_BRANCH_HOSTNAME=%PG_BRANCH_HOSTNAME%^
    -e PG_BRANCH_USERNAME=%PG_BRANCH_USERNAME%^
    -e PG_BRANCH_PASSWORD=%PG_BRANCH_PASSWORD%^
    -e PG_BRANCH_PORT=%PG_BRANCH_PORT%^
    -e PG_DEV_HOSTNAME=%PG_DEV_HOSTNAME%^
    -e PG_DEV_USERNAME=%PG_DEV_USERNAME%^
    -e PG_DEV_PASSWORD=%PG_DEV_PASSWORD%^
    -e PG_DEV_PORT=%PG_DEV_PORT%^
    -v %volume%:/var/lib/postresql/data^
    -p %PG_DEV_EXPOSE%:5432^
    --net pg^
    %image%:%tag%

rem ან თუ არ შეიქმნა ესეიგი შექმნილი იყო და კომპიუტერი დარესტარტდა
rem ამიტომ უკვე შექმნილს ვსტარტავთ
docker start %name%-%tag%


rem დანარჩენი ყველა კონტეინერი იგივე ტეგით ზედმეტია
for /f "tokens=* delims=" %%a in (
  '"docker ps -q --all --filter name=%name%* --filter status=exited"'
) do (
    rem რადგან მხოლოდ ბოლო კონტეინიერია გაშვებული ვშლით ზედმეტს
    docker container rm -f "%%a"
)

rem და ბოლოს ვშლით ისეთ იმიჯებს რომლებიც არ გვჭირდება
docker image prune -f -a

rem შევდივართ დოკერის კონტეინერში შელზე
docker exec -ti %name%-%tag% /bin/bash

rem docker exec -ti pg-branch /bin/bash
rem cd ../hooks && git pull && cd ../project && git commit --allow-empty -a -m "hello world"
