install: deps assets build

build: compile release

compile:
	mix compile

release:
	mix release

assets: assets-fetch assets-compile assets-digest

assets-fetch:
	npm install

assets-compile:
	node_modules/brunch/bin/brunch build

assets-digest:
	mix phoenix.digest

deps: deps-fetch deps-compile

deps-fetch:
	mix deps.get

deps-compile:
	mix deps.compile

clean: clean-release

clean-release:
	mix release.clean --implode --force
