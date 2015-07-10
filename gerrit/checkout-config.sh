#!/tools/bin/bash
repo=$1
if [ -z "$repo" ]; then
  echo "Repo must be specified."
  exit 1
fi

if [ -e "$repo" ]; then
  echo "Directory already exists."
  exit 1
fi

user=`whoami`
MYGERRIT_HOST=gerrit-ccxsw.rtp.broadcom.com
MYGERRIT_PORT=29418
MYGERRIT_URL=ssh://$user@${MYGERRIT_HOST}:${MYGERRIT_PORT}

mkdir $repo
cd $repo
git init
git remote add origin ${MYGERRIT_URL}/$repo
git fetch origin refs/meta/config
git checkout FETCH_HEAD

rm project.config

git config -f project.config --add access.inheritFrom "All-Projects"
git config -f project.config --add access.refs/*.owner "group $repo Owners"
git config -f project.config --add access.refs/heads/*.label-Code-Review "-1..+2 group $repo Users"
git config -f project.config --add access.refs/*.read "group $repo Users"
git config -f project.config --add access.refs/*.submit "group $repo Users"
git config -f project.config --add access.refs/meta/config.read "group $repo Users"
git config -f project.config --add access.refs/for/refs/heads/*.push "group $repo Users"
git config -f project.config --add access.refs/for/refs/heads/*.pushMerge "group $repo Users"
git config -f project.config --add access.refs/tags/*.create "group $repo Users"
git config -f project.config --add access.refs/tags/*.push "group $repo Users"
git config -f project.config --add access.refs/tags/*.pushTag "group $repo Users"
git config -f project.config --add access.refs/tags/*.pushSignedTag "group $repo Users"

git commit -am "Updated config"
git push origin HEAD:refs/meta/config
