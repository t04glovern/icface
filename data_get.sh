#!/bin/sh

BUCKET=devopstar
PREFIX=resources/icface


case "$1" in
    "put")
        # make bucket
        aws s3 mb s3://$BUCKET

        # push pre-trained
        aws s3 sync src/checkpoints/gpubatch_resnet/ \
            s3://$BUCKET/$PREFIX/gpubatch_resnet/ \
                --exclude "*.txt"
        ;;

    "get")
        # push pre-trained
        aws s3 sync s3://$BUCKET/$PREFIX/gpubatch_resnet/ \
            ./src/checkpoints/gpubatch_resnet
        ;;
esac