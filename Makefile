.PHONY: help
help:; @echo '$(help)'
help = Available targets:

BRANCH = stable
release = sorcery-$(BRANCH).tar.bz2

ts-scm = .git/refs/heads/master

$(release): $(ts-scm)
	tmp="$$(mktemp -p .)" \
	&& git archive --prefix=sorcery/ | bzip2 > "$$tmp" \
	&& mv "$$tmp" $(release) \
	|| rm -f "$$tmp"

help += $(.newline)	release - Make a release
.PHONY: release
release: $(release)

help += $(.newline)	bump - Bump version
.PHONY: bump bump-stable bump-devel
bump-stable:
	git describe --tags | >etc/sorcery/version \
	awk -F'[^0-9]' -vOFS=. '{++$$NF;for(i=1;i<NF;i++)$$i=$$(i+1)}NF--'

bump-devel:
	date -u +%Y%m%d > etc/sorcery/version

bump: bump-$(BRANCH)

script-targets = install uninstall convert
.PHONY: $(script-targets)
$(script-targets):; ./$@
