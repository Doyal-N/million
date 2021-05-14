push:
	git add .
	git commit -m '$(m)'
	git push

rm:
	git rm $(doc) --cached

git-email:
	git config --global user.email $(email)
	git config --local user.email $(email)
