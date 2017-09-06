# Must have `sentry-cli` installed globally
# Pass in SENTRY_PROJECT, SENTRY_ORG, HEROKU_APP_ID, HEROKU_AUTH_TOKEN
#  or have it set as environment variable

VERSION=`sentry-cli releases propose-version`

release: create_release set_release_context upload_sourcemaps

create_release:
	sentry-cli releases new -p $(SENTRY_PROJECT) $(VERSION)
	sentry-cli releases set-commits --auto $(VERSION)

upload_sourcemaps:
	npm run build
	sentry-cli releases -p $(SENTRY_PROJECT) files \
		$(VERSION) upload-sourcemaps build/static/js

set_release_context:
	curl -n -X PATCH https://api.heroku.com/apps/$(HEROKU_APP_ID)/config-vars \
		-d "{ \"REACT_APP_RELEASE\":\"$(VERSION)\"}" \
		-H "Content-Type: application/json" \
		-H "Accept: application/vnd.heroku+json; version=3" \
		-H "Authorization: Bearer $(HEROKU_AUTH_TOKEN)"
