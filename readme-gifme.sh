#!/usr/bin/env bash
api_key="$GIPHY_API_KEY_DEV"
tag="$GIPHY_TAG"

if [ $api_key == "" ]
then
    echo "GIPHY API Key is required."
    exit 1;
fi

if [ $tag == "" ]
then
    echo "Tag is empty. GIPHY will pull a random GIF."
fi

rating="g"
giphyEndpoint="api.giphy.com/v1/gifs/random?api_key=$api_key&tag=$tag&rating=$rating" 

# Local 
responseFile="temp"
readmeFile="README.md"

touch $responseFile

# Hit enpoint
curl $giphyEndpoint | python -c "import sys, json; f = open('$responseFile', 'w'); f.write(json.load(sys.stdin)['data']['id']); f.close()"

if [ ! -f "$readmeFile" ] 
then
    # Create Readme file
    touch $readmeFile
fi

gifId=$(head -n 1 $responseFile)
gitURL="![READme//GIFme](https://media.giphy.com/media/$gifId/giphy.gif)"
firstLineOfReadme=$(head -n 1 $readmeFile)

if [ $gifId == "" ]
then
    echo "The GIPHY ID is missing. Confirm that your GIPHY API Key is correct."
    exit 1;
fi

if echo " $firstLineOfReadme" | grep -q "giphy"
then
    grep -v "media.giphy.com" $readmeFile > tmpfile && mv tmpfile $readmeFile
    echo $gitURL | cat - $readmeFile > temp && mv temp $readmeFile
    cat $readmeFile
else
    echo $gitURL | cat - $readmeFile > temp && mv temp $readmeFile
    cat $readmeFile
fi