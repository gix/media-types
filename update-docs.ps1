git diff --exit-code > $null
if (-not $?) {
  echo "Uncommitted changes. Aborting."
  exit
}

$commit = git rev-parse --short HEAD

D:\xslt.exe .\MediaTypes.xml .\MediaTypesStyle.xsl _MediaTypes.html
git checkout gh-pages
mv -force _MediaTypes.html index.html
git add index.html
git commit -m "Regenerate docs for $commit"
git checkout master
