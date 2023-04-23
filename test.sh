CHANGED_FILE=./test1
#NUM=23370202
NUM=
echo $CHANGED_FILE
#URI_LIST=`ag "https://((user-images\.githubusercontent.*?\/$NUM\/)|(pbs.twimg.com/media/)|(video.twimg.com/.+_video/)).*?(png|jpg|gif|mp4)" -o $CHANGED_FILE`
#https://user-images.githubusercontent.com/23370202/233828006-f7031b60-4c08-45f6-98a0-efc5d993b123.png
#URI_LIST=`ag "https://((user-images\.githubuser.*?\/[0-9]+\/)).*?(png|jpg|gif|mp4)" -o $CHANGED_FILE`
URI_LIST=`ag "https://((user-images\.githubuser.*?\/[0-9]+\/)|(pbs.twimg.com/media/)|(video.twimg.com/.+_video/)).*?(png|jpg|gif|mp4)" -o $CHANGED_FILE`
echo "URI_LIST : $URI_LIST"



SUCCESS_COUNT=0
FAIL_COUNT=0
    echo "이미지경로를 교정할 문서 파일: [$CHANGED_FILE]"

    RESOURCE_DIR=`head $CHANGED_FILE | egrep -o '[A-F0-9-]{2}/[A-F0-9-]{34}$'`
    echo "RESOURCE_DIR : $RESOURCE_DIR"
    TARGET_PATH="./resource/$RESOURCE_DIR"

    echo "생성할 디렉토리 경로: [$TARGET_PATH]"
    mkdir -p $TARGET_PATH

    # 작업 대상 파일에서 참조하고 있는 github에 등록된 리소스 파일들의 URI 목록
    # URI_LIST=`ag "https://user-images\.githubuser.*?\/$NUM\/.*?(png|jpg|gif|mp4)" -o $CHANGED_FILE`
    # URI_LIST=`ag "https://pbs.twimg.com/media/.*?(png|jpg|gif|mp4)" -o $CHANGED_FILE`

    #URI_LIST=`ag "https://((user-images\.githubuser.*?\/[0-9]+\/)|(pbs.twimg.com/media/)|(video.twimg.com/.+_video/)).*?(png|jpg|gif|mp4)" -o $CHANGED_FILE`
    URI_LIST=`ag "https://((user-images\.githubuser.*?\/[0-9]+\/)|(pbs.twimg.com/media/)|(video.twimg.com/.+_video/)).*?(png|jpg|gif|mp4)" -o $CHANGED_FILE`
    echo "URI_LIST : $URI_LIST"
