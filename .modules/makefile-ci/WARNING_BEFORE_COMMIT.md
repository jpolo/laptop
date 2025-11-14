# Warning

If this repository is present .modules/ of a project read this first !

This project was added using `git subtree add`

**Committing in this folder is discouraged, unless you know exactly what you are doing.**

If a modification is needed, prefer this method :

1. Clone [makefile-ci](https://github.com/w5s/makefile-ci)
   1. Modify code
   2. Commit & Push
2. Reopen the project containing `.modules/makefile-ci`
3. In a terminal, execute `make self-update`
   1. (Optional) If makefile-core was updated review the commit
   2. Then this will create a Squash commit and an Update commit
   3. Review and push
