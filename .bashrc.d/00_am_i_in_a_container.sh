## Find out if I'm running inside a container and export a variable for that

## Variable of choice: IN_CONTAINER
##    Values: true/false

# Criterion: if $containers is set, IN_CONTAINER will be set to true. Otherwise, it will be set to false.

if [ "$container" = "oci" ]
then
	IN_CONTAINER="true"
else
	IN_CONTAINER="false"
fi

export IN_CONTAINER
