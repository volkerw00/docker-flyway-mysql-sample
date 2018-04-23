function getContainerHealth {
    docker inspect --format='{{json .State.Health}}' $1
}

function waitContainer {
    while STATUS=$(getContainerHealth $1); [[ $STATUS != *"\"healthy\""* ]]; do
        if [[ "$STATUS" == *"\"unhealthy\""* ]]; then
            echo "Failed!"
            exit -1
        fi
        printf .
        lf=$'\n'
        sleep 1
    done
    printf "$lf"
}
