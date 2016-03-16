#!/bin/bash

# required:
#$WERCKER_MFS_UPLOAD_URL
#$WERCKER_MFS_UPLOAD_PATH
#$WERCKER_MFS_UPLOAD_FILE
#
# optional:
#$WERCKER_MFS_UPLOAD_USERNAME
#$WERCKER_MFS_UPLOAD_PASSWORD
#
# required, but defaulted:
#$WERCKER_MFS_UPLOAD_ACL
#$WERCKER_MFS_UPLOAD_EXPECTED_RESPONSE

set -e

test ! -z "$WERCKER_MFS_UPLOAD_URL"
test ! -z "$WERCKER_MFS_UPLOAD_PATH"
test ! -z "$WERCKER_MFS_UPLOAD_FILE"
test ! -z "$WERCKER_MFS_UPLOAD_ACL"
test ! -z "$WERCKER_MFS_UPLOAD_EXPECTED_RESPONSE"

if [ ! -f "$WERCKER_MFS_UPLOAD_FILE" ]; then
  fail "Attribute 'file' must point to an existing file, got: ${WERCKER_MFS_UPLOAD_FILE}"
fi

## Show some user infos about the file to be uploaded
info "Local file: $(ls -lah $file)"
info "ACL: ${acl}"
info "Remote path: ${path}"
# setMessage is shown below the console output in the webui as oneline
setMessage "Artifact: $(ls -lah $file)"


# do the upload
command="curl -sS -XPUT"
if [ ! -z "$WERCKER_MFS_UPLOAD_USERNAME" ]; then
  command="$command -u${WERCKER_MFS_UPLOAD_USERNAME}:${WERCKER_MFS_UPLOAD_PASSWORD}"
fi
command="$command ${WERCKER_MFS_UPLOAD_URL}/${WERCKER_MFS_UPLOAD_PATH}"

upload=$(${command} --data-binary "@$WERCKER_MFS_UPLOAD_FILE" -H"X-ACL: ${WERCKER_MFS_UPLOAD_ACL}" -H'Content-Type: application/octet-stream' --output "$WERCKER_REPORT_ARTIFACTS_DIR/mfs_upload_step_response.out" -w '%{http_code}')
if [ "$upload" -eq "$WERCKER_MFS_UPLOAD_EXPECTED_RESPONSE" ]; then
  success "Upload completed."
else
  fail "upload: $(cat "$WERCKER_REPORT_ARTIFACTS_DIR/mfs_upload_step_response.out")"
fi
