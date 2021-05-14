push:
	git add .
	git commit -m '$(m)'
	git push

rm:
	git rm $(doc) --cached

email:
	git config --global user.email $(email)
	git config --local user.email $(email)
