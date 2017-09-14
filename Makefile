# Must have `sentry-cli` installed globally
# Pass in SENTRY_PROJECT, SENTRY_ORG, SENTRY_AUTH_TOKEN, HEROKU_APP_ID, HEROKU_AUTH_TOKEN
#  or have it set as environment variable

VERSION=`sentry-cli releases propose-version`

setup_release: build_app create_release upload_sourcemaps

create_release:
	sentry-cli releases new -p $(SENTRY_PROJECT) $(VERSION)
	sentry-cli releases set-commits --auto $(VERSION)

build_app:
	REACT_APP_RELEASE=$(VERSION) npm run build

upload_sourcemaps:
	sentry-cli releases -p $(SENTRY_PROJECT) files \
		$(VERSION) upload-sourcemaps build/static/js

deploy: setup_release
	git push heroku master
