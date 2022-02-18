# circleci-realitycheck-prep
Script to set up env vars needed for realitycheck repo on Server 3.x installs.

### Prerequisites

1. Deployed an instance of CircleCI Server
2. Created a personal API token on your Server instance
3. Created a namespace using `circleci namespace create`

### Flags


|Flag|Description|Example|
|-----|-----|-----|
|-h|Server hostname including scheme|https://mycciserver.example.com|
|-t|Server Personal API Token|abcde12345abcde12345abcde12345|
|-v| VCS type|github, bitbucket|
|-n|Namespace|mycirclecinamespace|
|-o|VCS Org Name|acmecorp|



### Example usage

```
./server_setup.sh \
-h https://circleci.example.com \
-t abcde12345abcde12345abcde12345 \
-v github \
-n myawesomenamespace \
-o acmecorp
