project_dir=$(realpath .)

crop() {
    local filename=$1
    magick "$filename" -gravity South \
        -background white -splice 0x1  -background black -splice 0x1 \
        -trim  +repage -chop 0x1 "$filename"
    magick "$filename" -gravity North \
        -background white -splice 0x1  -background black -splice 0x1 \
        -trim  +repage -chop 0x1 "$filename"
    magick "$filename" -gravity South -chop 0x101 "$filename"

}

screencapture() {
    local project_name=$1
    echo '#$ expect \$'>> $project_dir/commands.sh
#     echo '
# exit
# '>> $project_dir/commands.sh
    mkdir -p $project_dir/build && asciinema-automation -dt 1 -wt 1 $project_dir/commands.sh $project_dir/build/"$project_name".cast; agg --font-size 25 --cols 120 --rows 40 --theme asciinema $project_dir/build/"$project_name".cast $project_dir/build/"$project_name".gif
    convert -coalesce $project_dir/build/"$project_name".gif $project_dir/build/out.png \
    && mv $project_dir/build/out-$(identify -format "%n\n" $project_dir/build/"$project_name".gif | head -n 1 | awk '{print $1-1}').png $project_dir/build/"$project_name".png
    crop $project_dir/build/"$project_name".png
    mkdir -p $project_dir/public/assets
    mv $project_dir/build/"$project_name".png $project_dir/public/assets/
    mv $project_dir/build/"$project_name".cast $project_dir/public/assets/
}

asciinema_init() {
    # echo '#$ wait 1000' > $project_dir/commands.sh
    echo '#$ delay 1' > $project_dir/commands.sh
}


record() {
    local project_name=$1
    local code=$2
    echo "$project_name"
    asciinema_init
    echo "$code" >> $project_dir/commands.sh
    screencapture "$project_name"
}
execute() {
    local project_name=$1
    local code=$2
    echo "$project_name"
    sh -c "$code"
}

export GIT_PAGER=cat

cp ./src_assets/man.png ./public/assets/man.png

command rm -rf $project_dir/build
record git_init "
command rm -rf example_project
command rm -rf remote-example_project
mkdir example_project
cd example_project
clear
git init
ls -a"

record git_init_tree "
tree -L 1 .git
"

cd example_project

record git_config "
cd example_project
clear
git config --local pull.rebase false
git config --local --list"
record adding_files_1 "
git status
echo \"some code\" > our_first_file.txt
echo \"some other code\" > this_file_wont_be_commited.txt
git status"

record adding_files_2 "
git add our_first_file.txt
ls
git status"

record git_commit "
git commit -m \"this is our commit message\"
ls
git status
git log"

record git_log_1 "
echo \"somethin\" >> newfile.sh
git add newfile.sh
git commit -m \"another commit\"
git log
echo \"something else\" >> newfile.sh
git add newfile.sh
git commit -m \"yet another commit\"
git log
git log --oneline"

# record git_remote "
# git remote add origin git@github.com:jonboh/git-basics-remote-example.git
# git push -uf origin main
# git log --graph --oneline --all
# "

# execute fake_git_remote "
cd ..
mkdir remote-example_project
cd remote-example_project
git clone ../example_project .
cd ../example_project
git remote remove origin
git remote add origin ../remote-example_project
git push --set-upstream origin main
cd ../remote-example_project
git config --local user.name olga
git config --local user.email olga@lib.re
git checkout main
echo "this line was added by olga and produces a conflict. remove it!" >> newfile.sh
git add newfile.sh
git commit -m "added a line that will get you into a conflict!"
go run ../gitbrute.go --prefix 01123
echo test > "olgas_file"
git add olgas_file
git commit -m "a new file added by olga"
go run ../gitbrute.go --prefix 31415
git checkout -b another_olga_feature
cd ../example_project
# "

record git_branch_1 "
git branch my_new_branch
git log --oneline
git switch my_new_branch
git log --oneline
"
record git_branch_shortcuts "
git checkout -b different_feature
git switch -c foo
git log --oneline
"

record git_branch_commit "
git switch my_new_branch
echo \"another line\" >> newfile.sh
git add newfile.sh
git commit -m \"add a line to newfile.sh\"
git log --oneline
"

record git_branch_diverge "
git switch main
echo \"another line\" >> our_first_file.txt
git add our_first_file.txt
git commit -m \"add a line to our_first_file.txt\"
git log --oneline
"

record git_log_graph "
git log --oneline
git log --oneline --graph --all
"

record git_branch_merge "
git log --oneline --graph --all
git merge my_new_branch -m \"merging my_new_branch into main\"
git log --oneline --graph --all
"

record fast_forward_merge_partial "
git switch foo
git log --oneline --graph --all
"

record fast_forward_merge "
git switch foo
git log --oneline --graph --all
git merge main
git log --oneline --graph --all
"

record moving_branches "
git switch my_new_branch
git log --oneline --graph --all
git checkout different_feature
git log --oneline --graph --all
"

record git_fetch "
git log --oneline --graph --all
git fetch --all
git log --oneline --graph --all
"

record checkout_commit_1 "
git checkout 01123
"

record checkout_commit_2 "
git status
git log --oneline --graph --all
ls
"

record checkout_commit_3 "
git checkout 31415
git log --oneline --graph --all
ls
"

record git_merge_conflict_0 "
git checkout main
git log --oneline --graph --all
git merge origin/main
"

record git_merge_conflict_1 "
git status
cat newfile.sh
"

record git_merge_conflict_2 "
git log --graph --oneline --all
vim newfile.sh
#$ wait 500
#$ delay 500
ggjjddjdddddd:wq
#$ delay 1
git add newfile.sh
#$ wait 500
git commit -m \"merge origin/main into main solving conflict\"
git log --oneline --graph --all
git push
git log --oneline --graph --all
"

cd ../

rm -rf _example_project
cp  -r example_project _example_project

#

rm -rf example_project
cp -r _example_project example_project

cd example_project
# git reset
record git_reset_1 "
git checkout main
echo \"very important but incorrect changes\" > new_functionality.py
git add new_functionality.py
git commit -m \"very important but incorrect changes\"
go run ../gitbrute.go --prefix 0bad
clear
git log --oneline --graph --all -3
git reset HEAD~1
git log --oneline --graph --all -5
"

record git_reflog "
git reflog
"

record git_tag "
git config --local advice.detachedHead false
clear
git checkout 31415
git tag v0.1.0
git checkout main
git tag v0.2.0
git push --tags
git log --oneline --graph
"

record git_revert_1 "
echo \"more bad changes\" > new_functionality.py
git add new_functionality.py
git commit -m \"more bad changes\"
go run ../gitbrute.go --prefix 9bad
clear
git revert 9bad
:wq
#$ wait 1000
clear
git log --oneline --graph --all -4"

record git_revert_2 "
git diff 9bad~1 9bad
git diff 9bad HEAD
"

record tldr "
tldr git log
"


command rm $project_dir/commands.sh
command rm $project_dir/build/out-*.png
