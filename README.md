[![wercker status](https://app.wercker.com/status/a05fb56108bca761cebe0b2cd310d05f/m "wercker status")](https://app.wercker.com/project/bykey/a05fb56108bca761cebe0b2cd310d05f)

# mfs-upload-step

A wercker.com step to upload a file via HTTP PUT to an endpoint. This is intended to be used with [fs-php](http://github.com/zeisss/fs-php), but probably
works with other HTTP services too - it's just a PUT.

## Attributes

Name              | Req | Default | Description
------------------|-----|---------|----------------------
url               | Yes |         | The URL for the API endpoint
file              | Yes |         | The file to upload
path              | Yes |         | The absolute path to locate the uploaded file at
username          | No  |         | An optional htbasic username for authentication
password          | No  |         | An optional htbasic password for authentication
expected_response | No  | 201     | The expected HTTP status code in the response. The step will fail if this is not returned
acl               | No  | private | The ACL for the new file. Will be uploaded via the header `X-ACL`
