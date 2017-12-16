git status
echo 'Commit message:'
read commitmessage

git add -A
git commit -am "$commitmessage"
git pull origin master
git push origin master