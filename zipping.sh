rm -f benchmark,zip
rm -fr benchmark
zip -r benchmark.zip . -x 'dist-newstyle/*' '.git/*' .gitignore .DS_Store
