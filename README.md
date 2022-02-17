# circleci-realitycheck-prep
Script to set up env vars needed for realitycheck repo on Server 3.x installs.

### Flags


|Flag|Description|
|-----|-----|
|-h|Server hostname including scheme|
|-t|Server Personal API Token|
|-v| VCS type|
|-n|Namespace|



### Example usage

```
./server_setup.sh \
-h https://circleci.example.com \
-t abcde12345abcde12345abcde12345 \
-v github \
-n myawesomenamespace
