#!/bin/sh
echo ">>>>>>>>>>>>>   uploading artifact to build server"
API_URL="https://ci.appveyor.com/api"
export projStr="$(curl -sS --header "Content-type: application/json" "https://ci.appveyor.com/api/projects/pxscene/pxcore/history?recordsNumber=20")"
counter=0
echo ">>>>>>>>>>>>>>>>>before while loop"
while [  $counter -lt 20 ]; do
  buildList=".builds[$counter].version"
  jobId=$(echo $projStr | jq -r  $buildList)
  counter=$((counter+1))
  echo ">>>>>>>>>>>>>>>>> trace 1 : $jobId"; 
  if [ "$jobId" != null ] ; then
  build="$(curl -sS --header "Content-type: application/json" "https://ci.appveyor.com/api/projects/pxscene/pxcore/build/"$jobId)" 
  artifactStr=".build.jobs[0].artifactsCount"
  buildStr=".build.jobs[0].jobId" 
  artifactCounts=$(echo $build | jq -r  $artifactStr)
  buildVer=$(echo $build | jq -r  $buildStr)
    if [ $artifactCounts -gt 0 ] ; then
    downloadArtifact="wget -q https://ci.appveyor.com/api/buildjobs/"$buildVer"/artifacts/pxscene-setup.exe"
    echo "Artifact count : $artifactCounts, Build version :  $buildVer, JobId : $(echo $build | jq -r .build.jobs[0].buildNumber)"
    echo "$downloadArtifact"
    $downloadArtifact
    if [ "$?" -ne 0 ] ; then
      echo ">>>>>>>>>>>>>>> failed to upload the artifact."
    fi
    #DOWNLOAD_ARTIFACT="$(curl -sS --header "Content-type: application/json" "https://ci.appveyor.com/api/buildjobs/"$buildVer"/artifacts/pxscene-setup.exe")" 
    break;
    fi
  fi
done

filename="pxscene-setup.exe"
DEPLOY_USER="${DEPLOY_USER:-ubuntu}"
REMOTE_HOST="96.116.56.119"
REMOTE_DIR="/var/www/html/edge/windows"

scp -P 2220 ${filename} ${DEPLOY_USER}@${REMOTE_HOST}:${REMOTE_DIR}

if [ "$?" -ne 0 ] ; then
  echo ">>>>>>>>>>>>>>> failed to upload the artifact."
fi
