4 რაღაც
-----------------------
. გიტლაბზე ბრენჩის შექმნა სხვა ბრენჩიდან
. გიტლაბზე ბრენჩის დამერჯვა
. პროცედურები ფაილურ სტრუქტურაში


. მასტერის და სტეიჯინგში ენვში? აღარ გვჭირდება, საჭიროა მხოლოდ გიტლაბზე

gitlab
------------------------
1. გიტლაბზე უნდა გამოვიკვლიოთ როგორ შეიძლება [ბრენჩის შექმნის] დროს ჩვენი სკრიფტების გაშვება
    webhook (?)
2. ასევე უნდა გამოვიკვლიოთ როგორ შეიძლება [ბრენჩის დამერჯვის] დროს ჩვენი სკრიფტების ჩასმა:
    webhook
    ci/cd pipline (jankins) https://docs.gitlab.com/ee/ci/quick_start/

pg-branch - ბრენჩის გარემო
----------------------

    1. ახალი ბრენჩის შექმნა (+)
    -----------------------------
    რომელ ბრენჩიდანაც ვქმნით ახალ ბრენჩს,
    იმ ბრენჩის შესაბამის დატაბეიზი უნდა დაკოპირდეს
    ახალი ბრენჩის შესაბამის დატაბეიზში (რომელიც ჯერ უნდა შეიქმნას)
    (branc_name = database_name)

    2. ბრენჩის დამერჯვა (-)
    --------------------------
    იმ ბრენჩის შესაბამის დატაბეიზში რომელშიც ვმერჯავთ სხვა ბრენჩის შესაბამის დატაბეიზს
    უნდა აისახოს მეორე დატაბაიზის ცვლილებები.

    master> git checkout -b wallet (wallet ბრენჩის შექმნა)
    wallet> (აქ დატაბეიზში შეგვაქვს ცვლილებები)
    wallet> git checkout master
    master> git merge wallet (მასტერის დატაბეიზში იმერჯება wallet ში შესული ცვლილებები)

    ახალი ბრენჩის შექმნა
    -------------------------
    git checkout -b promo1
        create promo1 db
        pgquarrel [master>>pg-branch.promo1].sql
        psql [master>>pg-branch.promo1].sql promo1

    ბრენჩის დამერჯვა
    --------------------------
    git merge pg-branch-1



pg-dev - დეველოპერის გარემო
--------------------------------

    + ბრენჩზე გადასვლა
    --------------------
    git checkout promo1
        create promo1  db
        pgquarrel [pg-branch.promo1>>pg-dev.promo1].sql
        psql [pg-branch.promo1>>pg-dev.promo1].sql

    + დაკომიტება
    --------------------
    git commit -a -m "changes"
        ამოცანა არის ლოკალური ბაზის შედარება ბრენჩ ბაზასთან და diff.sql-ის გენერირება
        pgquarrel pg-local.[branch_name] pg-branch.[branch_name]
        სავარაუდოდ ეს მონაცემემები .config ში უნდა გვედოს
        PG_LOCAL_HOSTNAME
        PG_LOCAL_USERNAME
        PG_LOCAL_PASSWORD
        db = branch_name

        PG_BRANCH_HOSTNAME
        PG_BRANCH_USERNAME
        PG_BRANCH_PASSWORD

        აქ ვიყენებ post-commit ჰუკს რადგან pre-commit-ში commit-ის ჰეში არ მაქვს
        თუ sql ფაილის დაგენერირების დროს მოხდა შეცდომა
        git reset HEAD~1 --soft ით ვაბრუნებთ კომიტამდე მოცემულობას

    + დაპუშვა
    --------------
    git push
        apply commited changes to pg-branch.promo1
        . დაპუშვაში მაქვს ჩასამატებელი ENV

    + ცვლილებების ჩამოტანა
    --------------
    git pull
        pgquarrel [pg-branch.promo1>>pg-dev.promo1].sql
        psql [pg-branch.promo1>>pg-dev.promo1].sql

    + პირველადი ჩამოტანა
    -------------------
    git fetch (მუშაობს ჩექაუთის დროს ან პულით)

git config core.hooksPath შემიძლია გამოვიყენო დოკერში ჰუკების დირექტორიის დასაყენებლად

კიდევ უნდა გავაკეთო
---------------------------
branch db-ს კონტეინერი სატესტოდ სადაც იქნება სერვერის ჰუკები ალბათ





touch .git/hooks/post-checkout
chmod u+x .git/hooks/post-checkout


. როგორ დავარესეტე ბრენჩ სერვერი და შელი
--------------------------
1. წავშალე ვოლუმი C:\Users\BIOHAZARD\AppData\Local\pg-branch
2. shell ში ვერსია ავწიე ერთით


პირველი master ბაზა როგორ იქმნება?
ეს მომენტი გვკიდია იმიტომ რომ არსბეულ ბაზებზე მიებმევა თაივდანვე

გასაკეთებელია
---------------------
. master და staging ბაზების კონფიგურაციები და მოხმარება ჰუკებში
. master დან პირველად როცა ვქმნი ბრენჩს parent_branch ცარიელია
+ როდესაც გადავედი branch1 დან master-ზე master.sql მაინც დააგენერირა
    [ანუ ბაზის შესაქმნელი სკრიფტი]
. საბოლოო ჯამში პროექტის ფოლდერი ვოლუმს უნდა მიებას

გასარკვევია
---------------------
. გიტლაბში როგორ მივაბათ გლობალ ჰუკები (server-hooks)
. რომელი ჰუკი იმუშავებს ბრენჩის შექმნის დროს

gitlab.bat:
ln -s /opt/gitlab/embedded/bin/python3.7 /usr/bin/python3
git clone https://github.com/hazardland/hook.pg.git /home/hook
ln -s /home/hook/gitlab/ /opt/gitlab/embedded/service/gitlab-shell/hooks

gitlab: weebhook for fetching branch create
gitlab: ci/cd pipline for merging


გიტლაბში
---------------------
. მასტერ ბრენჩზე და სტეიჯინგზე მომხმარებლის კომპიუტერიდან დაპუშვის შეზღუდვა
