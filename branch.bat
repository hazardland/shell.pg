@echo off

set image=postgres
set tag=12.3
set name=pg-branch

rem ეს იმიჯი უბრალოდ პოსტგრეს უშვებს ბრენჩინიგისთვის

rem აქ ხდება .config ფაილის კონტენტის ცვლადებად გამოცხადება
for /f "delims== tokens=1,2" %%G in (.config) do set %%G=%%H

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
docker run -d --name %name%^
    -e POSTGRES_PASSWORD=%PG_BRANCH_PASSWORD%^
    -e PGDATA=/var/lib/postresql/data^
    -v %volume%:/var/lib/postresql/data^
    -p %PG_BRANCH_EXPOSE%:5432^
    --net pg^
    %image%:%tag%

rem ან თუ არ შეიქმნა ესეიგი შექმნილი იყო და კომპიუტერი დარესტარტდა
rem ამიტომ უკვე შექმნილს ვსტარტავთ
docker start %name%


rem დანარჩენი ყველა კონტეინერი იგივე ტეგით ზედმეტია
for /f "tokens=* delims=" %%a in (
  '"docker ps -q --all --filter name=%name%* --filter status=exited"'
) do (
    rem რადგან მხოლოდ ბოლო კონტეინიერია გაშვებული ვშლით ზედმეტს
    docker container rm -f "%%a"
)
