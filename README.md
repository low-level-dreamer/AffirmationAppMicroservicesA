# AffirmationAppMicroservicesA

# How to run the microservice
Simply run command "python3 db_manager.py" to start the service. No additional packages need to be installed.

# How to send data to storage
The program is on stand by and reads the pipeline.json file periodically (Interval 1 second)
## Storage request
The program can receive the following data in two formats:
- a list of json key value pairs 
- a single key value pairs 
Example:
[
    {
        "id":"Affirmation-adore-morning-routine",
        "text":"I adore doing my morning routine and how it feels",
        "tags":["Morning routine"],
        "ratings":[]
    },
    ... More key value pairs
]
OR
{
    "id":"Affirmation-adore-morning-routine",
    "text":"I adore doing my morning routine and how it feels",
    "tags":["Morning routine"],
    "ratings":[]
}

## Duplication detection
If the database has the exact same id of affirmation, then the program will NOT insert the data, instead it returns an Error message, see more below.

## Storage result
The program will return a json key value pair to pipeline.json
json format:
{
    "success":True/False,
    "errors":[
        {
            "error":"Entry ID: {entry id here} exist in database"
            "id":"Affirmation-adore-morning-routine",
            "text":"I adore doing my morning routine and how it feels",
            "tags":["Morning routine"],
            "ratings":[]
        },
        More failed storage...
    ]
}

# UML Diagram
