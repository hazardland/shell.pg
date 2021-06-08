pg-branch

    ახალი ბრენჩის შექმნა
    -------------------------
    git checkout -b promo1
        create promo1 db
        pgquarrel [master>>pg-branch.promo1].sql
        psql [master>>pg-branch.promo1].sql promo1

    ბრენჩის დამერჯვა
    --------------------------
    git merge pg-branch-1



pg-dev
    ბრენჩზე გადასვლა
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

    ცვლილებების ჩამოტანა
    --------------
    git pull
        pgquarrel [pg-branch.promo1>>pg-dev.promo1].sql
        psql [pg-branch.promo1>>pg-dev.promo1].sql

git config core.hooksPath შემიძლია გამოვიყენო დოკერში ჰუკების დირექტორიის დასაყენებლად

კიდევ უნდა გავაკეთო
---------------------------
branch db-ს კონტეინერი სატესტოდ სადაც იქნება სერვერის ჰუკები ალბათ





touch .git/hooks/post-checkout
chmod u+x .git/hooks/post-checkout


