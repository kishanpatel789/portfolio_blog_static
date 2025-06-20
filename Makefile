S3_BUCKET=s3://static-site-kp
DISTRIBUTION_ID=E35CQ3V9FS8H8U

# Files to exclude during sync
EXCLUDES=--exclude notes.md --exclude '*git*' --exclude '*DS_Store*' --exclude 'node_modules*' --exclude '*swp' --exclude 'package*json' --exclude Makefile

# If DRYRUN=1 is passed, include --dryrun flag
ifdef DRYRUN
	DRY_FLAG=--dryrun
else
	DRY_FLAG=
endif

.PHONY: sync invalidate publish

sync:
	aws s3 sync . $(S3_BUCKET) \
		--delete \
		$(EXCLUDES) \
		$(DRY_FLAG)

invalidate:
ifndef DRYRUN
	aws cloudfront create-invalidation \
		--distribution-id $(DISTRIBUTION_ID) \
		--paths "/*"
else
	@echo "(dry run) skipping CloudFront invalidation"
endif

publish: sync invalidate
