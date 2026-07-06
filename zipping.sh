rm -f effective-bench,zip
rm -fr effective-bench
zip -r effective-bench.zip . -x 'dist-newstyle/*' '.git/*' .gitignore .DS_Store
